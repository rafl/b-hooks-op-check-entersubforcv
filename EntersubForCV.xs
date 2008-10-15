#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "hook_op_check.h"
#include "hook_op_check_entersubforcv.h"

typedef struct userdata_St {
	CV *cv;
	hook_op_check_entersubforcv_cb cb;
	void *ud;
} userdata_t;

STATIC OP *
entersub_cb (pTHX_ OP *op, void *user_data) {
	OP *kid, *last;
	CV *cv;
	userdata_t *ud = (userdata_t *)user_data;

	kid = cUNOPx (op)->op_first;

	/* pushmark for method call */
	if (kid->op_type != OP_NULL) {
		return op;
	}

	last = cLISTOPx (kid)->op_last;

	/* not what we expected */
	if (last->op_type != OP_NULL) {
		return op;
	}

	kid = cUNOPx (last)->op_first;

	/* not a GV */
	if (kid->op_type != OP_GV) {
		return op;
	}

	cv = GvCV (cGVOPx_gv (kid));

	if (ud->cv == cv) {
		ud->cb (aTHX_ op, cv, ud->ud);
	}

	return op;
}

void
hook_op_check_entersubforcv (CV *cv, hook_op_check_entersubforcv_cb cb, void *user_data) {
	userdata_t *ud;

	Newx (ud, 1, userdata_t);
	ud->cv = cv;
	ud->cb = cb;
	ud->ud = user_data;

	hook_op_check (OP_ENTERSUB, entersub_cb, ud);
}

STATIC OP *
perl_cb (pTHX_ OP *op, CV *cv, void *ud) {
	dSP;

	ENTER;
	SAVETMPS;

	PUSHMARK (sp);
	XPUSHs (sv_2mortal (newRV ((SV *)cv)));
	PUTBACK;

	call_sv ((SV *)ud, G_VOID|G_DISCARD);

	SPAGAIN;

	PUTBACK;
	FREETMPS;
	LEAVE;

	return op;
}

MODULE = B::Hooks::OP::Check::EntersubForCV  PACKAGE = B::Hooks::OP::Check::EntersubForCV

PROTOTYPES: DISABLE

void
hook (cv, cb)
		CV *cv
		SV *cb
	CODE:
		hook_op_check_entersubforcv (cv, perl_cb, newSVsv (cb));

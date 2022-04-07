SBCL_BIN ?= /usr/bin/sbcl
SBCL_HOME ?= /usr/lib/sbcl
SBCL_COMPRESSION ?= nil
export SBCL_HOME

ipickme:
	$(SBCL_BIN) --non-interactive --no-sysinit --no-userinit \
             --load ~/quicklisp/setup.lisp \
             --load ../ipickme.asd \
             --eval '(ql:quickload :ipickme)' \
             --eval "(sb-ext:save-lisp-and-die \"ipickme\" :toplevel #'ipickme:main :executable t :compression $(SBCL_COMPRESSION) :purify t)"

.PHONY: install
install: ipickme
	install ipickme $(HOME)/bin/

.PHONY: clean
clean: ; rm -f ipickme

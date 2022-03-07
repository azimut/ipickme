SBCL_BIN ?= /usr/bin/sbcl
SBCL_HOME ?= /usr/lib/sbcl
SBCL_COMPRESSION ?= nil
export SBCL_HOME

ipickme:
	$(SBCL_BIN) --non-interactive --no-sysinit --no-userinit \
             --load ~/quicklisp/setup.lisp \
             --load ../ipickme.asd \
             --eval '(ql:quickload :ipickme)' \
             --eval "(sb-ext:save-lisp-and-die \"ipickme\" :toplevel #'ipickme:start :executable t :compression $(SBCL_COMPRESSION) :purify t)"

.PHONY: install
install: ipickme
	install ipickme $(HOME)/bin/

.PHONY: clean
clean:
	rm -f ipickme

.PHONY: appimage
appimage: ipickme-latest-x86_64.AppImage
ipickme-latest-x86_64.AppImage: ipickme AppImageBuilder.yml iconfile.svg
	appimage-builder --skip-appimage --skip-tests
	install ipickme AppDir/usr/bin/
	appimage-builder --skip-build --skip-tests --skip-script

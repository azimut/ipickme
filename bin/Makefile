SBCL_BIN ?= /usr/bin/sbcl
SBCL_HOME ?= /usr/lib/sbcl
SBCL_COMPRESSION ?= nil
export SBCL_HOME
APPIMAGETOOL_URL := https://github.com/AppImage/AppImageKit/releases/download/12/appimagetool-x86_64.AppImage

ipickme:
	$(SBCL_BIN) --non-interactive --no-sysinit --no-userinit \
             --load ~/quicklisp/setup.lisp \
             --load ../ipickme.asd \
             --eval '(ql:quickload :ipickme)' \
             --eval "(sb-ext:save-lisp-and-die \"ipickme\" :toplevel #'ipickme:start :executable t :compression $(SBCL_COMPRESSION) :purify t)"

ipickme-deploy/ipickme:
	$(SBCL_BIN) --non-interactive --no-sysinit --no-userinit \
             --load ~/quicklisp/setup.lisp \
             --eval '(ql:quickload :deploy)' \
             --load '../ipickme.asd' \
             --load '../ipickme-deploy.asd' \
             --eval '(ql:quickload :ipickme-deploy)' \
             --eval '(asdf:make :ipickme-deploy :verbose t :force t)'
	-install /usr/*/gdk-pixbuf*/*/loaders/libpixbufloader-*   ipickme-deploy/
	-install /usr/*/*/gdk-pixbuf*/*/loaders/libpixbufloader-* ipickme-deploy/

ipickme-x86_64.AppImage: ipickme-deploy/ipickme
	cp ipickme.desktop ipickme-deploy/ipickme.desktop
	cp iconfile.svg    ipickme-deploy/iconfile.svg
	cp AppRun          ipickme-deploy/AppRun
	wget -c -O ~/Downloads/appimagetool $(APPIMAGETOOL_URL)
	chmod +x ~/Downloads/appimagetool
	ARCH=x86_64 ~/Downloads/appimagetool ipickme-deploy ipickme-x86_64.AppImage

.PHONY: install
install: ipickme
	install ipickme $(HOME)/bin/

.PHONY: clean
clean:
	rm -f ipickme

all: build ; groff -Wall -mtty-char -Tascii -mandoc -c makl.1

build: clean ; xml2man makl.1.xml makl.1

clean: ; rm -f makl.1

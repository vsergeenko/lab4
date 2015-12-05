BINS=isutf8 ifdata ifne pee sponge mispipe lckdo parallel errno
PERLSCRIPTS=vidir vipe ts combine zrun chronic
MANS=sponge.1 vidir.1 vipe.1 isutf8.1 ts.1 combine.1 ifdata.1 ifne.1 pee.1 zrun.1 chronic.1 mispipe.1 lckdo.1 parallel.1 errno.1
CFLAGS?=-O2 -g -Wall
INSTALL_BIN?=install -s
PREFIX?=/usr
LIBDIR=/usr/local/lib

DOCBOOK2XMAN=xsltproc --param man.authors.section.enabled 0 /usr/share/xml/docbook/stylesheet/docbook-xsl/manpages/docbook.xsl

all: libpe-svn.so envx-svn $(BINS) $(MANS)

# compile libs
libpe-svn.o: libpe-svn.c
	gcc -fPIC -c -o libpe-svn.o libpe-svn.c
libpe-svn.so: libpe-svn.o
	gcc -shared -o libpe-svn.so -Wall libpe-svn.o

# compile programm
envx-svn: envx-svn.o libpe-svn.so
	gcc -Wall -o envx-svn envx-svn.o libpe-svn.so

clean:
	rm -f $(BINS) $(MANS) dump.c errnos.h errno.o *.o *.so

install:
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	$(INSTALL_BIN) $(BINS) $(DESTDIR)$(PREFIX)/bin
	install $(PERLSCRIPTS) $(DESTDIR)$(PREFIX)/bin
	
	mkdir -p $(DESTDIR)$(PREFIX)/share/man/man1
	install $(MANS) $(DESTDIR)$(PREFIX)/share/man/man1

	install libpe-svn.so $(LIBDIR)/libpe-svn.so
	ldconfig

check: isutf8
	./check-isutf8

%.1: %.docbook
	xmllint --noout --valid $<
	$(DOCBOOK2XMAN) $<

errno.o: errnos.h
errnos.h:
	echo '#include <errno.h>' > dump.c
	$(CC) -E -dD dump.c | awk '/^#define E/ { printf "{\"%s\",%s},\n", $$2, $$2 }' > errnos.h
	rm -f dump.c
	
errno.1: errno.docbook
	$(DOCBOOK2XMAN) $<

%.1: %
	pod2man --center=" " --release="moreutils" $< > $@;

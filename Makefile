LIBNAME = lpeg
LUADIR = ../lua/

COPT = -O2
# COPT = -DLPEG_DEBUG -g

CWARNS = -Wall -Wextra -pedantic \
	-Waggregate-return \
	-Wcast-align \
	-Wcast-qual \
	-Wdisabled-optimization \
	-Wpointer-arith \
	-Wshadow \
	-Wsign-compare \
	-Wundef \
	-Wwrite-strings \
	-Wbad-function-cast \
	-Wdeclaration-after-statement \
	-Wmissing-prototypes \
	-Wnested-externs \
	-Wstrict-prototypes \
# -Wunreachable-code \


CFLAGS = $(CWARNS) $(COPT) -std=c99 -I$(LUADIR) 
CC = ../toolbox/dependency/install/bin/musl-gcc

FILES = lpvm.o lpcap.o lptree.o lpcode.o lpprint.o

# For Linux
linux:
	make lpeg.a "DLLFLAGS = -static -no-pie -nostartfiles"

# For Mac OS
macosx:
	make lpeg.so "DLLFLAGS = -bundle -undefined dynamic_lookup"

lpeg.a: $(FILES)
	env $(CC) $(DLLFLAGS) $(FILES) -llua -o lpeg.a

$(FILES): Makefile

test: test.lua re.lua lpeg.a
	./test.lua

clean:
	rm -f $(FILES) lpeg.a


lpcap.o: lpcap.c lpcap.h lptypes.h
lpcode.o: lpcode.c lptypes.h lpcode.h lptree.h lpvm.h lpcap.h
lpprint.o: lpprint.c lptypes.h lpprint.h lptree.h lpvm.h lpcap.h
lptree.o: lptree.c lptypes.h lpcap.h lpcode.h lptree.h lpvm.h lpprint.h
lpvm.o: lpvm.c lpcap.h lptypes.h lpvm.h lpprint.h lptree.h


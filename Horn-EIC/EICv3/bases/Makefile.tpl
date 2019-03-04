#
# Makefile for library BASES ver 5.1 for  HP 9000
# 
#                             CP group at Minami-Tateya
#                             1994/06/13 
#                             1995/06/30 (revised)
#
# (1) In subroutines, bstime and bsdate, we use CERNLIB.
# (2) bsbhok, spbhok are used for HBOOK in addition to
#     original BASES library.
# (3) subroutines bsgetw,bsputw are added.
#
#
LIBBASES      = libbases.a
#
SRCS	= bases.f bhinit.f bhplot.f bhrset.f bhsave.f bschck.f \
bsdate.f bsetgu.f bsetgv.f bsinfo.f bsinit.f bsdims.f bsgrid.f \
bsparm.f bsintg.f bslist.f bsordr.f bsprnt.f bsread.f bstcnv.f \
bstime.f bsutim.f bswrit.f dhfill.f dhinit.f dhplot.f drn.f    \
drnset.f shcler.f shfill.f shinit.f shplot.f shrset.f shupdt.f \
spchck.f sphist.f spinfo.f sprgen.f spring.f xhchck.f xhfill.f \
xhinit.f xhordr.f xhplot.f xhrnge.f xhscle.f bshbok.f sphbok.f \
bsgetw.f bsputw.f uxtime_.c uxdate_.c

OBJS	= bases.o bhinit.o bhplot.o bhrset.o bhsave.o bschck.o \
bsdate.o bsetgu.o bsetgv.o bsinfo.o bsinit.o bsdims.o bsgrid.o \
bsparm.o bsintg.o bslist.o bsordr.o bsprnt.o bsread.o bstcnv.o \
bstime.o bsutim.o bswrit.o dhfill.o dhinit.o dhplot.o drn.o    \
drnset.o shcler.o shfill.o shinit.o shplot.o shrset.o shupdt.o \
spchck.o sphist.o spinfo.o sprgen.o spring.o xhchck.o xhfill.o \
xhinit.o xhordr.o xhplot.o xhrnge.o xhscle.o bshbok.o sphbok.o \
bsgetw.o bsputw.o uxtime_.o uxdate_.o

all:	${LIBBASES}

${LIBBASES}:	${OBJS}
	${AR} rc ${LIBBASES} $?
	${RANLIB} ${LIBBASES}

tags:${SRCS}
	${FTAGS} ${SRCS}

install: all
	cp ${LIBBASES} ${LIBDIR}

clean:
		rm -f ${LIBBASES} ${OBJS} core

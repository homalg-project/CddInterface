#
# CddInterface: Gap interface to Cdd package
#
# This file is part of the build system of a GAP kernel extension.
# Requires automake.
#
ACLOCAL_AMFLAGS = -I m4

AM_CFLAGS = -Wall

BINARCHDIR = bin/$(GAPARCH)
GAPINSTALLLIB = $(abs_top_srcdir)/$(BINARCHDIR)/CddInterface.so

lib_LTLIBRARIES = CddInterface.la

CddInterface_la_SOURCES = src/CddInterface.c
CddInterface_la_CPPFLAGS = $(GAP_CPPFLAGS) -DCONFIG_H -DGMPRATIONAL $(CDD_CPPFLAGS)
# Note that the latter is only for GAP 4.4.12
CddInterface_la_LDFLAGS = -module -avoid-version $(CDD_LDFLAGS) -lgmp
if SYS_IS_CYGWIN
CddInterface_la_LDFLAGS += -no-undefined -version-info 0:0:0 -Wl,$(GAPROOT)/bin/$(GAPARCH)/gap.dll
endif

all-local: CddInterface.la
	$(mkdir_p) $(top_srcdir)/$(BINARCHDIR)
if SYS_IS_CYGWIN
	cp .libs/CddInterface.dll $(GAPINSTALLLIB)
else
	cp .libs/CddInterface.so $(GAPINSTALLLIB)
endif
	@echo "SUCCESS!"

distclean-local:
	rm -rf bin/*
	(cd doc ; ./clean)

doc: doc/manual.six

doc/manual.six: doc/*.xml PackageInfo.g
	($(GAPROOT)/bin/gap.sh -A makedoc.g)

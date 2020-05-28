#
# CddInterface: Gap interface to Cdd package
#
# This file is part of the build system of a GAP kernel extension.
# Requires GNU autoconf, GNU automake and GNU libtool.
#

dnl ##
dnl ## Setup autoconf
dnl ##
AC_PREREQ([2.68])
AC_INIT([CddInterface], [package])
AC_CONFIG_SRCDIR([src/CddInterface.c])
AC_CONFIG_MACRO_DIR([m4])
m4_include([m4/find_gap.m4])

dnl ##
dnl ## Set the language
dnl ##
AC_PROG_CC
AC_LANG([C])

dnl ##
dnl ## Locate the GAP root dir
dnl ##
FIND_GAP

dnl ##
dnl ## Set cdd root dir
dnl ##
AC_ARG_WITH([cddlib],
    [AS_HELP_STRING([--with-cddlib=<path>], [specify the path of cdd installation])],
    [], [with_cddlib=yes])
AS_IF([test "x$with_cddlib" = "xno"], [AC_MSG_ERROR([cddlib is required and cannot be disabled])])
AS_IF([test "x$with_cddlib" != "xyes"],[
  # Debian and Ubuntu put the headers into PREFIX/include/cdd, while on other
  # systems, the headers are directly in PREFIX/include/ -- so we just add
  # both to the CPPFLAGS
  AS_IF([test -d "$with_cddlib"],[],[AC_MSG_ERROR([the cddlib path is not a directory])])
  CDD_CPPFLAGS="-I$with_cddlib/include/cdd -I$with_cddlib/include/cddlib -I$with_cddlib/include"
  CDD_LDFLAGS="-L$with_cddlib/lib -lcddgmp"
],[
  CDD_CPPFLAGS="-I/usr/include/cdd"
  CDD_LDFLAGS="-lcddgmp"
])
AC_SUBST(CDD_CPPFLAGS)
AC_SUBST(CDD_LDFLAGS)

dnl check that cddlib actually is usable
old_CPPFLAGS="$CPPFLAGS"
old_LDFLAGS="$LDFLAGS"
CPPFLAGS="$CPPFLAGS $CDD_CPPFLAGS"
LDFLAGS="$LDFLAGS $CDD_LDFLAGS"
AC_CHECK_HEADER([setoper.h], [], [AC_MSG_ERROR([could not use setoper.h])], [])
AC_CHECK_LIB([cddgmp],[dd_SetLinearity])
CPPFLAGS="$old_CPPFLAGS"
LDFLAGS="$old_LDFLAGS"


dnl ##
dnl ## Output everything
dnl ##
AC_CONFIG_FILES([Makefile])
AC_OUTPUT

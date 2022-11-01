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

# if no path was given. as a special consideration, detect if the user has cddlib
# installed via Homebrew (on macOS), and if so, use that
AS_IF([test "x$with_cddlib" = "xyes"],[
  AS_IF([command -v brew >/dev/null 2>&1],[
    AC_MSG_NOTICE([BREW detected])
    with_cddlib=$(brew --prefix)
  ])
])

AS_IF([test "x$with_cddlib" != "xyes"],[
  # Debian and Ubuntu put the headers into PREFIX/include/cdd, while on
  # e.g. homebrew the headers are in PREFIX/include/cddlib. Finally in
  # some cases, the headers are directly in PREFIX/include/ -- so we
  # just add all three to the CPPFLAGS
  AS_IF([test -d "$with_cddlib"],[],[AC_MSG_ERROR([the cddlib path is not a directory])])
  CDD_CPPFLAGS="-I$with_cddlib/include/cdd -I$with_cddlib/include/cddlib -I$with_cddlib/include"
  CDD_LDFLAGS="-L$with_cddlib/lib -lcddgmp -lgmp"
],[
  CDD_CPPFLAGS="-I/usr/include/cdd -I/usr/include/cddlib"
  CDD_LDFLAGS="-lcddgmp -lgmp"
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

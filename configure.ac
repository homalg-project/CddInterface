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
AC_CONFIG_HEADER([src/pkgconfig.h:cnf/pkgconfig.h.in])
AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_AUX_DIR([cnf])

dnl ##
dnl ## Get canonical host info
dnl ##
AC_CANONICAL_HOST

dnl ##
dnl ## Setup automake
dnl ##
AM_INIT_AUTOMAKE([1.11 -Wall foreign subdir-objects])
AM_SILENT_RULES([yes])
AM_PROG_AR

dnl ##
dnl ## Set the language
dnl ##
AC_PROG_CC
AC_LANG([C])

dnl ##
dnl ## Setup libtool (for building the GAP kernel extension)
dnl ##
LT_PREREQ([2.4.2])
LT_INIT([disable-static dlopen win32-dll])

dnl ##
dnl ## Locate the GAP root dir
dnl ##
AC_FIND_GAP

dnl ##
dnl ## Set cdd root dir
dnl ##
AC_ARG_WITH([cddlib],
    [AC_HELP_STRING([--with-cddlib=<path>], [specify the path of cdd installation])],
    [], [with_cddlib=yes])
AS_IF([test "x$with_cddlib" = "xno"], [AC_MSG_ERROR([cddlib is required and cannot be disabled])])
AS_IF([test "x$with_cddlib" != "xyes"],[
  # Debian and Ubuntu put the headers into PREFIX/include/cdd, while on other
  # systems, the headers are directly in PREFIX/include/ -- so we just add
  # both to the CPPFLAGS
  AS_IF([test -d "$with_cddlib"],[],[AC_MSG_ERROR([the cddlib path is not a directory])])
  CDD_CPPFLAGS="-I$with_cddlib/include/cdd -I$with_cddlib/include"
  CDD_LDFLAGS="-L$with_cddlib/lib -lcddgmp"
],[
  CDD_CPPFLAGS="-I/usr/include/cdd"
  CDD_LDFLAGS="-lcddgmp"
])
AC_SUBST(CDD_CPPFLAGS)
AC_SUBST(CDD_LDFLAGS)

# TODO: check that cddlib actually is usable
#AC_CHECK_LIB([cddgmp],[dd_SetLinearity])

dnl ##
dnl ## Detect Windows resp. Cygwin
dnl ##
case $host_os in
  *cygwin* ) CYGWIN=yes;;
         * ) CYGWIN=no;;
esac
AM_CONDITIONAL([SYS_IS_CYGWIN], [test "$CYGWIN" = "yes"])
if test "$CYGWIN" = "yes"; then
  AC_DEFINE(SYS_IS_CYGWIN32, 1, are we on CYGWIN?)
else
  AC_DEFINE(SYS_IS_CYGWIN32, 0, are we on CYGWIN?)
fi

dnl ##
dnl ## Output everything
dnl ##
AC_CONFIG_FILES([Makefile])
AC_OUTPUT

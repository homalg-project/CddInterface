#
# CddInterface: Gap interface to Cdd package
#
# This file is a script which compiles the package manual.
#
if fail = LoadPackage("AutoDoc", ">= 2014.03.27") then
    Error("AutoDoc version 2014.03.27 is required.");
fi;

AutoDoc( "CddInterface" : scaffold := true, autodoc := rec( files:=[ "doc/intro.autodoc" ] ) );

PrintTo("VERSION", PackageInfo("CddInterface")[1].Version);

QUIT;

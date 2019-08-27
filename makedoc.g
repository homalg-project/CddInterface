#
# CddInterface: interface to cdd library
#
# This file is a script which compiles the package manual.
#

if fail = LoadPackage("AutoDoc", "2016.02.16") then
    Error("AutoDoc version 2016.02.16 or newer is required.");
fi;

AutoDoc( 
        rec(
            maketest := rec( commands := [ "LoadPackage(\"CddInterface\");" ] ),
            scaffold := rec( entities := [ "GAP4", "homalg" ] ),
            autodoc := rec( files := [ "doc/intro.autodoc" ] ),
            extract_examples := rec( units := "Single" )
            ) 
        );

QUIT;

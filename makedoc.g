#
# CddInterface: interface to cdd library
#
# This file is a script which compiles the package manual.
#

if fail = LoadPackage("AutoDoc", ">= 2019.04.10") then
    Error("AutoDoc 2019.04.10 or newer is required");
fi;

AutoDoc( 
        rec(
            scaffold := rec( entities := [ "GAP4", "homalg" ] ),
            autodoc := rec( files := [ "doc/intro.autodoc" ] ),
            #extract_examples := rec( units := "Single" )
            ) 
        );

QUIT;

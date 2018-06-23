#
# CddInterface: interface to cdd library
#
# This file is a script which compiles the package manual.
#

#PrintTo( "VERSION", PackageInfo( "CddInterface" )[1].Version );

if fail = LoadPackage("AutoDoc", "2016.02.16") then
    Error("AutoDoc version 2016.02.16 or newer is required.");
fi;

AutoDoc( 
        rec(
            scaffold := rec( entities := [ "GAP4", "homalg", "CAP" ],
                             ),
            
            autodoc := rec( files := [ "doc/intro.autodoc" ] ),

            maketest := rec( folder := ".",
                             commands :=
                             [ "LoadPackage( \"CddInterface\" );",
                             ],
                           ),
            )
);


QUIT;

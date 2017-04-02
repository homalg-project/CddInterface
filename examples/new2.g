LoadPackage( "Cdd" );
f := function( m, n )
local L, C;

L := List( [ 1 .. m ], i -> List( [ 1.. n ], j -> i*j ) );

return Cdd_PolyhedronByInequalities( L );
end;

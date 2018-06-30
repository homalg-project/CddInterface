LoadPackage( "CddInterface" );

L := List( [ 1 .. 30 ], i -> List( [ 1 .. 30 ], j-> Random( [ 1 .. 10 ] ) ) );
C := Cdd_PolyhedronByInequalities( L );
#V := Cdd_V_Rep( C );

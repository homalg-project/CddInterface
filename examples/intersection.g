LoadPackage( "CddInterface" );

#! @BeginChunk intersection
#! @BeginExample
A := Cdd_PolyhedronByInequalities( [ [ 3, 4, 5 ] ], [ 1 ] );;
B := Cdd_PolyhedronByInequalities( [ [ 9, 7, 2 ] ], [ 1 ] );;
C := Cdd_Intersection( A, B );;
Display( Cdd_V_Rep( A ) );
#! V-representation
#! linearity 1, [ 2 ]
#! begin
#!    2 X 3  rational
#!
#!    1  -3/4     0
#!    0    -5     4
#! end
Display( Cdd_V_Rep( B ) );
#! V-representation
#! linearity 1, [ 2 ]
#! begin
#!    2 X 3  rational
#!
#!    1  -9/7     0
#!    0    -2     7
#! end
Display( Cdd_V_Rep( C ) );
#! V-representation
#! begin
#!    1 X 3  rational
#!
#!    1  -13/9    5/9
#! end
#! @EndExample
#! @EndChunk


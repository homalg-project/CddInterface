
LoadPackage( "CddInterface" );

#! @BeginChunk comparing_polyhedrons
#! @BeginExample
A := Cdd_PolyhedronByInequalities( [ [ 10, -1, 1, 0 ],
[ -24, 9, 2, 0 ], [ 1, 1, -1, 0 ], [ -23, -12, 1, 11 ] ], [ 4 ] );
#! <Polyhedron given by its H-representation>
B := Cdd_PolyhedronByInequalities( [ [ 1, 0, 0, 0 ],
[ -4, 1, 0, 0 ], [ 10, -1, 1, 0 ], [ -3, -1, 0, 1 ] ], [ 3, 4 ] );
#! <Polyhedron given by its H-representation>
Cdd_IsContained( B, A );
#! true
Display( Cdd_V_Rep( A ) );
#! V-representation
#! begin
#!    3 X 4  rational
#!
#!    1   2   3   4
#!    1   4  -6   7
#!    0   1   1   1
#! end
Display( Cdd_V_Rep( B ) );
#! V-representation
#! begin
#!    2 X 4  rational
#!
#!    1   4  -6   7
#!    0   1   1   1
#! end
#! @EndExample
#! @EndChunk

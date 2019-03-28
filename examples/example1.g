LoadPackage("CddInterface");

#! @Chunk Example1
#! @Example
A:= Cdd_PolyhedronByInequalities( [ [ 0, 1, 0 ], [ 0, 1, -1 ] ] );
#! <Polyhedron given by its H-representation>
Display( A );
#! H-representation
#! begin
#!    2 X 3  rational
#!
#!    0   1   0
#!    0   1  -1
#! end
B:= Cdd_PolyhedronByInequalities( [ [ 0, 1, 0 ], [ 0, 1, -1 ] ], [ 2 ] );
#! <Polyhedron given by its H-representation>
Display( B );
#! H-representation
#! linearity 1, [ 2 ]
#! begin
#!    2 X 3  rational
#!
#!    0   1   0
#!    0   1  -1
#! end
#! @EndExample
#! @EndChunk


#! @Chunk Example2
#! @Example
A:= Cdd_PolyhedronByGenerators( [ [ 0, 1, 3 ], [ 1, 4, 5 ] ] );
#! <Polyhedron given by its V-representation>
Display( A );
#! V-representation
#! begin
#!    2 X 3  rational
#!
#!    0  1  3
#!    1  4  5
#! end
B:= Cdd_PolyhedronByGenerators( [ [ 0, 1, 3 ] ], [ 1 ] );
#! <Polyhedron given by its V-representation>
Display( B );
#! V-representation
#! linearity 1, [ 1 ]
#! begin
#!    1 X 3  rational
#!
#!    0  1  3
#! end
#! @EndExample
#! @EndChunk

#! @Chunk Example3
#! @Example
A:= Cdd_PolyhedronByInequalities( [ [ 0, 2, 6 ], [ 0, 1, 3 ], [1, 4, 10 ] ] );
#! <Polyhedron given by its H-representation>
B:= Cdd_Canonicalize( A );
#! <Polyhedron given by its H-representation>
Display( B );
#! H-representation
#! begin
#!    2 X 3  rational
#!
#!    0   1   3
#!    1   4  10
#! end
#! @EndExample
#! @EndChunk

#! @Chunk Example4
#! @Example
A:= Cdd_PolyhedronByInequalities( [ [ 0, 1, 1 ], [ 0, 5, 5 ] ] );
#! <Polyhedron given by its H-representation>
B:= Cdd_V_Rep( A );
#! <Polyhedron given by its V-representation>
Display( B );
#! V-representation
#! linearity 1, [ 2 ]
#! begin
#!    2 X 3  rational
#!
#!    0   1   0
#!    0  -1   1
#! end
C:= Cdd_H_Rep( B );
#! <Polyhedron given by its H-representation>
Display( C );
#! H-representation
#! begin
#!    1 X 3  rational
#!
#!    0  1  1
#! end
D:= Cdd_PolyhedronByInequalities( [ [ 0, 1, 1, 34, 22, 43 ],
[ 11, 2, 2, 54, 53, 221 ], [33, 23, 45, 2, 40, 11 ] ] );
#! <Polyhedron given by its H-representation>
Cdd_V_Rep( D );
#! <Polyhedron given by its V-representation>
Display( last );
#! V-representation
#! linearity 2, [ 5, 6 ]
#! begin
#!    6 X 6  rational
#!
#!    1  -743/14   369/14    11/14        0        0
#!    0    -1213      619       22        0        0
#!    0       -1        1        0        0        0
#!    0      764     -390      -11        0        0
#!    0   -13526     6772       99      154        0
#!    0  -116608    59496     1485        0      154
#! end
#! @EndExample
#! @EndChunk

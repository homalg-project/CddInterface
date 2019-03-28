#! @Chunk minkuwski
#! @Example
P := Cdd_PolyhedronByGenerators( [ [ 1, 2, 5 ], [ 0, 1, 2 ] ] );
#! < Polyhedron given by its V-representation >
Q := Cdd_PolyhedronByGenerators( [ [ 1, 4, 6 ], [ 1, 3, 7 ], [ 0, 3, 1 ] ] );
#! < Polyhedron given by its V-representation >
S := P+Q;
#! < Polyhedron given by its H-representation >
V := Cdd_V_Rep( S );
#! < Polyhedron given by its V-representation >
Display( V );
#! V-representation 
#! begin
#!    4 X 3  rational
#!
#!    0   3   1 
#!    1   6  11 
#!    1   5  12 
#!    0   1   2 
#! end
Cdd_GeneratingVertices( P ); 
#! [ [ 2, 5 ] ]
Cdd_GeneratingVertices( Q );
#! [ [ 3, 7 ], [ 4, 6 ] ]
Cdd_GeneratingVertices( S );
#! [ [ 5, 12 ], [ 6, 11 ] ]
Cdd_GeneratingRays( P );
#! [ [ 1, 2 ] ]
Cdd_GeneratingRays( Q );
#! [ [ 3, 1 ] ]
Cdd_GeneratingRays( S );
#! [ [ 1, 2 ], [ 3, 1 ] ]
#! @EndExample
#! @EndChunk


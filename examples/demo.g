

LoadPackage( "CddInterface" );

#! @Chunk demo
#! @Example
poly:= Cdd_PolyhedronByInequalities( [ [ 1, 3, 4, 5, 7 ], [ 1, 3, 5, 12, 34 ],
[ 9, 3, 0, 2, 13 ]  ], [ 1 ] );
#! <Polyhedron given by its H-representation>
Cdd_InteriorPoint( poly );
#! [ -194/75, 46/25, -3/25, 0 ]

Cdd_FacesWithInteriorPoints( poly );
#! [ [ 3, [ 1 ], [ -194/75, 46/25, -3/25, 0 ] ], [ 2, [ 1, 2 ],
#! [ -62/25, 49/25, -7/25, 0 ] ], [ 1, [ 1, 2, 3 ],
#! [ -209/75, 56/25, -8/25, 0 ] ], [ 2, [ 1, 3 ], [ -217/75, 53/25, -4/25, 0 ] ] ]

Cdd_Dimension( poly );
#! 3
Cdd_IsPointed( poly );
#! false
Cdd_IsEmpty( poly );
#! false
Cdd_Faces( poly );
#! [ [ 3, [ 1 ] ], [ 2, [ 1, 2 ] ], [ 1, [ 1, 2, 3 ] ], [ 2, [ 1, 3  ] ] ]
poly1 := Cdd_ExtendLinearity( poly, [ 1, 2, 3 ] );
#! <Polyhedron given by its H-representation>
Display( poly1 );
#! H-representation 
#! linearity 3, [ 1, 2, 3 ]
#! begin
#!    3 X 5  rational
#!
#!    1   3   4   5   7 
#!    1   3   5  12  34 
#!    9   3   0   2  13 
#! end
Cdd_Dimension( poly1 );
#! 1
Cdd_Facets( poly );
#! [ [ 1, 2 ], [ 1, 3 ] ]
Cdd_GeneratingVertices( poly );
#! [ [ -209/75, 56/25, -8/25, 0 ] ]
Cdd_GeneratingRays( poly );
#! [ [ -97, 369, -342, 75 ], [ -8, -9, 12, 0 ],
#! [ 23, -21, 3, 0 ], [ 97, -369, 342, -75 ] ]
Cdd_Inequalities( poly );
#! [ [ 1, 3, 5, 12, 34 ], [ 9, 3, 0, 2, 13 ] ]
Cdd_Equalities( poly );
#! [ [ 1, 3, 4, 5, 7 ] ]
P := Cdd_FourierProjection( poly, 2);
#! <Polyhedron given by its H-representation>
Display( P );
#! H-representation 
#! linearity 1, [ 3 ]
#! begin 
#!    3 X 5  rational
#!
#!     9    3    0    2   13 
#!    -1   -3    0   23  101 
#!     0    0    1    0    0 
#! end
#! @EndExample
#! @EndChunk


LoadPackage( "CddInterface" );

#! @Chunk Fourier
#! To illustrate this projection, Let  $P= \mathrm{conv}( (1,2), (4,5) )$ in $\mathbb{Q}^2$.
#! $\newline$
#! To find its projection on the subspace $(O, x_1)$, we apply the Fourier elemination to get rid of $x_2$
#! @Example
P := Cdd_PolyhedronByGenerators( [ [ 1, 1, 2 ], [ 1, 4, 5 ] ] );
#! <Polyhedron given by its V-representation>
H := Cdd_H_Rep( P );
#! <Polyhedron given by its H-representation>
Display( H );
#! H-representation
#! linearity 1, [ 3 ]
#! begin
#!    3 X 3  rational
#!
#!     4  -1   0 
#!    -1   1   0 
#!    -1  -1   1 
#! end
P_x1 := Cdd_FourierProjection( H, 2);
#! <Polyhedron given by its H-representation>
Display( P_x1 );
#! H-representation
#! linearity 1, [ 3 ]
#! begin
#!    3 X 3  rational
#!
#!     4  -1   0
#!    -1   1   0
#!     0   0   1
#! end
Display( Cdd_V_Rep( P_x1 ) );
#! V-representation
#! begin
#!    2 X 3  rational
#!
#!    1  1  0
#!    1  4  0
#! end

#! @EndExample
#! Let again $Q= Conv( (2,3,4), (2,4,5) )+ nonneg( (1,1,1) )$, and let us compute its projection on $(O,x_2,x_3)$
#! @Example
Q := Cdd_PolyhedronByGenerators( [ [ 1, 2, 3, 4 ],[ 1, 2, 4, 5 ], [ 0, 1, 1, 1 ] ] );
#! <Polyhedron given by its V-representation>
R := Cdd_H_Rep( Q );
#! <Polyhedron given by its H-representation>
Display( R );
#! H-representation
#! linearity 1, [ 4 ]
#! begin
#!    4 X 4  rational
#!
#!     2   1  -1   0 
#!    -2   1   0   0 
#!    -1  -1   1   0 
#!    -1   0  -1   1 
#! end
P_x2_x3 := Cdd_FourierProjection( R, 1);
#! <Polyhedron given by its H-representation>
Display( P_x2_x3 );
#! H-representation
#! linearity 2, [ 1, 3 ]
#! begin
#!    3 X 4  rational
#!
#!    -1   0  -1   1 
#!    -3   0   1   0 
#!     0   1   0   0 
#! end
Display( Cdd_V_Rep( last ) ) ;
#! V-representation 
#! begin
#!    2 X 4  rational
#!                
#!    0  0  1  1 
#!    1  0  3  4 
#! end
#! @EndExample
#! @EndChunk


##
## Some corner cases for a polyhedron that is defined by generators.
##
gap> C := Cdd_PolyhedronByGenerators( [ [ 0, 2 ], [ 0, -2 ] ] );;
gap> Display( Cdd_H_Rep( C ) );
H-representation 
begin 
   1 X 2  rational
         
   1  0 
end
gap> C := Cdd_PolyhedronByGenerators( [ [ 1, 2 ], [ 1, -2 ] ] );;
gap> Display( Cdd_H_Rep( C ) );
H-representation 
begin 
   2 X 2  rational
           
   2  -1 
   2   1 
end
gap> C := Cdd_PolyhedronByGenerators( [ [ 1, 0 ] ] );;
gap> Display( Cdd_H_Rep( C ) );
H-representation 
linearity 1, [ 2 ]
begin 
   2 X 2  rational
         
   1  0 
   0  1 
end
gap> C := Cdd_PolyhedronByInequalities( [ [ -2 , 1 ], [ 1, -1 ] ] );;
gap> Display( Cdd_V_Rep( C ) );
The empty polyhedron

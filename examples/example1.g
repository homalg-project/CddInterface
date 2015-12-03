

#! @Chunk Example1
#! @Example
A:= Cdd_PolyhedraByInequalities( [ [ 0, 1, 0 ], [ 0, 1, -1 ] ] );
#! < Polyhedra given by its H-representation >   
Display( A );
#! H-representation 
#! Begin 
#!    2 X 3  rational
#!               
#!    0   1   0 
#!    0   1  -1 
#! End
B:= Cdd_PolyhedraByInequalities( [ [ 0, 1, 0 ], [ 0, 1, -1 ] ], [ 2 ] );
#! < Polyhedra given by its H-representation >
Display( B );
#! H-representation 
#! Linearity 1, [ 2 ]
#! Begin 
#!    2 X 3  rational
#!               
#!    0   1   0 
#!    0   1  -1 
#! End   
#! @EndExample
#! @EndChunk


#! @Chunk Example2
#! @Example
A:= Cdd_PolyhedraByGenerators( [ [ 0, 1, 3 ], [ 1, 4, 5 ] ] );
#! < Polyhedra given by its V-representation >
Display( A );
#! V-representation 
#! Begin 
#!    2 X 3  rational
#!             
#!    0  1  3 
#!    1  4  5 
#! End
B:= Cdd_PolyhedraByGenerators( [ [ 0, 1, 3 ] ], [ 1 ] );      
#! < Polyhedra given by its V-representation >
Display( B );
#! V-representation 
#! Linearity 1, [ 1 ]
#! Begin 
#!    1 X 3  rational
#!             
#!    0  1  3 
#! End
#! @EndExample
#! @EndChunk

#! @Chunk Example3
#! @Example
A:= Cdd_PolyhedraByInequalities( [ [ 0, 2, 6 ], [ 0, 1, 3 ], [1, 4, 10 ] ] );
#! < Polyhedra given by its H-representation >
B:= Cdd_Canonicalize( A );                                                       
#! < Polyhedra given by its H-representation >
Display( B );                                                             
#! H-representation 
#! Begin 
#!    2 X 3  rational
#!               
#!    0   1   3 
#!    1   4  10 
#! End
#! @EndExample
#! @EndChunk

#! @Chunk Example4
#! @Example
A:= Cdd_PolyhedraByInequalities( [ [ 0, 1, 1 ], [0, 5, 5 ] ] );                          
#!< Polyhedra given by its H-representation >
B:= Cdd_V_Rep( A );                                    
#! < Polyhedra given by its V-representation >
Display( B );                                   
#! V-representation 
#! Linearity 1, [ 2 ]
#! Begin 
#!    2 X 3  rational
#!               
#!    0   1   0 
#!    0  -1   1 
#! End
C:= Cdd_H_Rep( B );
#! < Polyhedra given by its H-representation >
Display( C );
#! H-representation 
#! Begin 
#!    1 X 3  rational
#!             
#!    0  1  1 
#! End
D:= Cdd_PolyhedraByInequalities( [ [ 0, 1, 1, 34, 22, 43 ], 
[ 11, 2, 2, 54, 53, 221 ], [33, 23, 45, 2, 40, 11 ] ] );
#! < Polyhedra given by its H-representation >
Cdd_V_Rep( C );                                                                                                     
#! < Polyhedra given by its V-representation >
Display( last );                                                                                                    
#! V-representation 
#! Linearity 2, [ 5, 6 ]
#! Begin 
#!    6 X 6  rational
#!                                                         
#!    1  -743/14   369/14    11/14        0        0 
#!    0    -1213      619       22        0        0 
#!    0       -1        1        0        0        0 
#!    0      764     -390      -11        0        0 
#!    0   -13526     6772       99      154        0 
#!    0  -116608    59496     1485        0      154 
#! End
#! @EndExample
#! @EndChunk


#! @Chunk Example5
#! @Example
A:= Cdd_PolyhedraByInequalities( [ [ 1, 1, 1 ], [ 3, 5, 5 ],
[ 4, 2, -3/4 ] ] );
#! < Polyhedra given by its H-representation >
L:= Cdd_LinearProgram( A, "max", [0, 2, 4 ] );
#! < Linear program >
Display( L );
#! Linear program given by H-represented polyhedra  
#! Begin 
#!    3 X 3  rational
#!                     
#!    1     1     1 
#!    3     5     5 
#!    4     2  -3/4 
#! End
#! max  [ 0, 2, 4 ]
#! @EndExample
#! @EndChunk
LoadPackage( "CddInterface" );

#! @Chunk Example5
#! To illustrate the using of these functions, let us solve the linear program given by:
#! $$\textbf{Maximize}\;\;P(x,y)= 1-2x+5y,\;\mathrm{with}$$
#! $$100\leq x \leq 200,80\leq y\leq 170,y \geq -x+200.$$
#! We bring the inequalities to the form $b+AX\geq 0$ and get:
#! $$-100+x\geq 0, 200-x \geq 0, -80+y \geq 0, 170 -y \geq 0,-200 +x+y \geq 0.$$
#! @Example
A:= Cdd_PolyhedronByInequalities( [ [ -100, 1, 0 ], [ 200, -1, 0 ],
[ -80, 0, 1 ], [ 170, 0, -1 ], [ -200, 1, 1 ] ] );
#! <Polyhedron given by its H-representation>
lp1:= Cdd_LinearProgram( A, "max", [1, -2, 5 ] );
#! <Linear program>
Display( lp1 );
#! Linear program given by:
#! H-representation
#! begin
#!    5 X 3  rational
#!
#!    -100     1     0
#!     200    -1     0
#!     -80     0     1
#!     170     0    -1
#!    -200     1     1
#! end
#! max  [ 1, -2, 5 ]
Cdd_SolveLinearProgram( lp1 );
#! [ [ 100, 170 ], 651 ]
lp2:= Cdd_LinearProgram( A, "min", [ 1, -2, 5 ] );
#! <Linear program>
Display( lp2 );
#! Linear program given by:
#! H-representation
#! begin
#!    5 X 3  rational
#!
#!    -100     1     0
#!     200    -1     0
#!     -80     0     1
#!     170     0    -1
#!    -200     1     1
#! end
#! min  [ 1, -2, 5 ]
Cdd_SolveLinearProgram( lp2 );
#! [ [ 200, 80 ], 1 ]
B:= Cdd_V_Rep( A );
#! <Polyhedron given by its V-representation>
Display( B );
#! V-representation
#! begin
#!    5 X 3  rational
#!
#!    1  100  170
#!    1  100  100
#!    1  120   80
#!    1  200   80
#!    1  200  170
#! end
#! @EndExample
#! So the optimal solution for $\texttt{lp1}$ is $(x=100,y=170)$ with optimal value $p=1-2(100)+5(170)=651$ and for $\texttt{lp2}$ is
#! $(x=200,y=80)$ with optimal value $p=1-2(200)+5(80)=1$.
#! @EndChunk


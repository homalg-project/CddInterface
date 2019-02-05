#############################################################################
##
##  polyhedra.gd         CddInterface package                Kamal Saleh
##
##  Copyright 2019 Mathematics Faculty, Siegen University, Germany
##
##  Fans for NConvex package.
##
#############################################################################

# Interface to Cdd package
#
# Declarations
#

#################################
##
## Family 
##
#################################

DeclareGlobalVariable( "CddPolyhedronCalculations" );

#################################
##
##  Categories
##
#################################

DeclareCategory( "IsCddPolyhedron", IsObject );

DeclareCategory( "IsCddLinearProgram", IsObject );



##################################
##
## Operations and Global functions
##
##################################
# to activate the documentation press gap makedoc.g


#! @Chapter Creating polyhedra and their Operations
#! @Section Creating a polyhedron


#! @Arguments ineq [, linearities_list ]
#! @Returns a CddPolyhedron
#! @Description  
#! The function takes a list in which every entry represents an inequality (or equality).
#! In case we want some entries to represent equalities we should refer  
#! in a second list to their indices.
DeclareGlobalFunction( "Cdd_PolyhedronByInequalities" );
#! @InsertChunk Example1

#! @Arguments genes[, linearities_list ] 
#! @Returns a CddPolyhedron
#! @Description  
#! The function takes a list in which every entry represents a vertex in the ambient vector space.
#! In case we want some vertices to be free (the vertex and its negative belong to the polyhedron) we should refer 
#! in a second list to their indices . 
DeclareGlobalFunction( "Cdd_PolyhedronByGenerators" );
#! @InsertChunk Example2

#! @Section Some operations on a polyhedron

#! @Arguments P, i
#! @Returns a CddPolyhedron
#! @Description 
#! The function returns the Fourier projection of the polyhedron in the subspace $(O,x_1,\dots,x_{i-1},x_{i+1},\dots,x_n)$ after applying the Fourier elemination algorithm to get rid of the variable $x_{i}$.
DeclareOperation( "Cdd_FourierProjection" , [ IsCddPolyhedron, IsInt ] );
#! @InsertChunk Fourier


DeclareOperation( "Cdd_ExtendLinearity" , [ IsCddPolyhedron, IsList ] );

#! @Section Some operations on two polyhedrons

#! @Arguments P1, P2
#! @Returns <C>true</C> or <C>false</C>
#! @Description 
#! The function returns <C>true</C> if $P_1$ is contained in $P_2$, otherwise returns <C>false</C>.
DeclareOperation( "Cdd_IsContained", [ IsCddPolyhedron, IsCddPolyhedron ] );
#! @InsertChunk comparing_polyhedrons

#! @Arguments P1, P2
#! @Returns a CddPolyhedron
#! @Description 
#! The function returns the intersection of $P_1$ and $P_2$
DeclareOperation( "Cdd_Intersection", [ IsCddPolyhedron, IsCddPolyhedron ] );
#! @InsertChunk intersection

#! @Arguments P1, P2
#! @Returns a CddPolyhedron
#! @Description 
#! The function returns the Minkuwski sum of $P_1$ and $P_2$.
DeclareOperation( "\+", [ IsCddPolyhedron, IsCddPolyhedron ] );
#! @InsertChunk minkuwski



#! @Chapter Linear Programs
#! @Section Creating and solving linear programs

#! @Arguments P, str, obj
#! @Returns a **CddLinearProgram** Object
#! @Description 
#! The function takes three variables. The first is a polyhedron **poly**, the second **str** should 
#! be "max" or "min" and the third **obj** is the objective function. 
DeclareOperation( "Cdd_LinearProgram", [ IsCddPolyhedron, IsString, IsList ] );

#! @Arguments lp
#! @Returns a list if the program is optimal, otherwise returns the value 0
#! @Description 
#! The function takes a linear program. If the program is optimal, the function returns a list of two
#! entries, the solution vector and the optimal value of the objective, otherwise it returns <A>fail</A>.
DeclareOperation( "Cdd_SolveLinearProgram", [ IsCddLinearProgram ] );
#! @InsertChunk Example5


##################################
##
##  Attributes
##
##################################

#! @Chapter Attributes and properties
#! @Section Attributes and properties of polyhedron

#! @Arguments P
#! @Returns a CddPolyhedron
#! @Description 
#! The function takes a polyhedron and reduces its defining inequalities (generators set) by deleting all redundant inequalities (generators). 
DeclareAttribute( "Cdd_Canonicalize",  IsCddPolyhedron  );
#! @InsertChunk Example3

#! @Arguments P
#! @Returns a CddPolyhedron
#! @Description 
#! The function takes a polyhedron and returns its reduced $V$-representation. 
DeclareAttribute( "Cdd_V_Rep",  IsCddPolyhedron  );

#! @Arguments P
#! @Returns a CddPolyhedron
#! @Description 
#! The function takes a polyhedron and returns its reduced $H$-representation. 
DeclareAttribute( "Cdd_H_Rep",  IsCddPolyhedron  );
#! @InsertChunk Example4

#! @Arguments P
#! @Returns The dimension of the ambient space of the polyhedron(i.e., the space that contains $P$).
DeclareAttribute( "Cdd_AmbientSpaceDimension", IsCddPolyhedron );

#! @Arguments P
#! @Returns The dimension of the polyhedron, where the dimension, $\mathrm{dim}(P)$, of a polyhedron $P$
#! is the maximum number of affinely independent points in $P$ minus 1.
DeclareAttribute( "Cdd_Dimension", IsCddPolyhedron );

#! @Arguments P
#! @Returns The reduced generating vertices of the polyhedron
DeclareAttribute( "Cdd_GeneratingVertices", IsCddPolyhedron );

#! @Arguments P
#! @Returns list
#! @Description 
#! The output is the reduced generating rays of the polyhedron
DeclareAttribute( "Cdd_GeneratingRays", IsCddPolyhedron );

#! @Arguments P
#! @Returns a list
#! @Description 
#! The output is the reduced equalities of the polyhedron.
DeclareAttribute( "Cdd_Equalities", IsCddPolyhedron );

#! @Arguments P
#! @Description 
#! The output is the reduced inequalities of the polyhedron.
DeclareAttribute( "Cdd_Inequalities", IsCddPolyhedron );

#! @Arguments P
#! @Returns a list
#! @Description 
#! The output is an interior point in the polyhedron
DeclareAttribute( "Cdd_InteriorPoint",  IsCddPolyhedron  );

#! @Arguments P
#! @Returns a list
#! @Description
#! This function takes a $H$-represented polyhedron **P** and returns a list. Every entry in this 
#! list is a again a list, contains the dimension and linearity of the face defined as a polyhedron over the 
#! same system of inequalities.
DeclareAttribute( "Cdd_Faces",  IsCddPolyhedron  );

#! @Arguments P, d
#! @Returns a list
#! @Description
#! This function takes a $H$-represented polyhedron **P** and a positive integer **d**. 
#! The output is a list. Every entry in this 
#! list is the linearity of an **d**- dimensional face of **P** defined as a polyhedron over the 
#! same system of inequalities.
KeyDependentOperation( "Cdd_FacesWithFixedDimension", IsCddPolyhedron, IsInt, ReturnTrue );

#! @Arguments P
#! @Returns a list
#! @Description
#! This function takes a $H$-represented polyhedron **P** and returns a list. Every entry in this 
#! list is a again a list, contains the dimension, linearity of the face defined as a polyhedron over the 
#! same system of inequalities and an interior point in the face.
DeclareAttribute( "Cdd_FacesWithInteriorPoints",  IsCddPolyhedron  );

#! @Arguments P, d
#! @Returns a list
#! @Description
#! This function takes a $H$-represented polyhedron **P** and a positive integer **d**.
#! The output is a list. Every entry in this 
#! list is a again a list, contains the linearity of the face defined as a polyhedron over the 
#! same system of inequalities and an interior point in this face.
KeyDependentOperation( "Cdd_FacesWithFixedDimensionAndInteriorPoints", IsCddPolyhedron, IsInt, ReturnTrue );


#! @Arguments P
#! @Returns a list
#! @Description
#! This function takes a $H$-represented polyhedron **P** and returns a list. Every entry in this 
#! is the linearity of a facet defined as a polyhedron over the 
#! same system of inequalities.
DeclareAttribute( "Cdd_Facets",  IsCddPolyhedron  );

#! @Arguments P
#! @Returns a list
#! @Description
#! This function takes a $H$-represented polyhedron **P** and returns a list. Every entry in this 
#! is the linearity of a ray ($1$-dimensional face) defined as a polyhedron over the
#! same system of inequalities.
DeclareAttribute( "Cdd_Lines",  IsCddPolyhedron  );

#! @Arguments P
#! @Returns a list
#! @Description
#! This function takes a $H$-represented polyhedron **P** and returns a list. Every entry in this 
#! list is the linearity of a vertex defined as a polyhedron over the same system of inequalities.
DeclareAttribute( "Cdd_Vertices",  IsCddPolyhedron  );

##################################
##
##  Properties
##
##################################

#! @Arguments P
#! @Returns true or false
#! @Description
#! The output is <C>true</C> if the polyhedron is empty and <C>false</C> otherwise
DeclareProperty( "Cdd_IsEmpty", IsCddPolyhedron );

#! @Arguments P
#! @Returns true or false
#! @Description
#! The output is <C>true</C> if the polyhedron is cone and <C>false</C> otherwise
DeclareProperty( "Cdd_IsCone", IsCddPolyhedron );

#! @Arguments P
#! @Returns true or false
#! @Description
#! The output is <C>true</C> if the polyhedron is pointed and <C>false</C> otherwise
DeclareProperty( "Cdd_IsPointed", IsCddPolyhedron );
#! @InsertChunk demo

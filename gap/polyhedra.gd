#
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


#! @Arguments arg 
#! @Returns a $\texttt{CddPolyhedron}$ Object
#! @Description  
#! The function takes a list in which every entry represents an inequality( or equality).
#! In case we want some entries to represent equalities we should refer  
#! in a second list to their indices.
DeclareGlobalFunction( "Cdd_PolyhedronByInequalities" );
#! @InsertChunk Example1

#! @Arguments arg 
#! @Returns a $\texttt{CddPolyhedron}$ Object
#! @Description  
#! The function takes a list in which every entry represents a vertex in the ambient vector space.
#! In case we want some vertices to be free( the vertex and its negative belong to the polyhedron) we should refer 
#! in a second list to their indices . 
DeclareGlobalFunction( "Cdd_PolyhedronByGenerators" );
#! @InsertChunk Example2

#! @Section Some operations on polyhedra

#! @Arguments poly
#! @Returns a $\texttt{CddPolyhedron}$ Object
#! @Description 
#! The function takes a polyhedron and reduces its defining inequalities ( generators set) by deleting all redundant inequalities ( generators ). 
DeclareOperation( "Cdd_Canonicalize", [ IsCddPolyhedron ] );
#! @InsertChunk Example3


#! @Arguments poly
#! @Returns a $\texttt{CddPolyhedron}$ Object
#! @Description 
#! The function takes a polyhedron and returns its reduced V-representation. 
DeclareOperation( "Cdd_V_Rep", [ IsCddPolyhedron ] );



#! @Arguments poly
#! @Returns a $\texttt{CddPolyhedron}$ Object
#! @Description 
#! The function takes a polyhedron and returns its reduced H-representation. 
DeclareOperation( "Cdd_H_Rep", [ IsCddPolyhedron ] );
#! @InsertChunk Example4


#! @Arguments poly, i
#! @Returns a $\texttt{CddPolyhedron}$ Object
#! @Description 
#! The function returns the Fourier projection of the polyhedron in the subspace $(O,x_1,\dots,x_{i-1},x_{i+1},\dots,x_n)$ after applying the Fourier elemination algorithm to get rid of the variable $x_{i}$.
DeclareOperation( "Cdd_FourierProjection" , [IsCddPolyhedron, IsInt] );
#! @InsertChunk Fourier


DeclareOperation( "Cdd_ExtendLinearity" , [IsCddPolyhedron, IsList] );



#! @Chapter Linear Programs
#! @Section Creating and solving linear programs

#! @Arguments poly, str, obj
#! @Returns a $\texttt{CddLinearProgram}$ Object
#! @Description 
#! The function takes three variables. The first is a polyhedron $\texttt{poly}$, the second $\texttt{str}$ should be max or min and the third $\texttt{obj}$ is the objective. 
DeclareOperation( "Cdd_LinearProgram", [IsCddPolyhedron, IsString, IsList] );

#! @Arguments lp
#! @Returns a list if the program is optimal, otherwise returns the value 0
#! @Description 
#! The function takes a linear program. If the program is optimal, the function returns a list of two
#! entries: the solution vector and the optimal value of the objective, otherwise it returns the 
#! value 0.
DeclareOperation( "Cdd_SolveLinearProgram", [IsCddLinearProgram] );
#! @InsertChunk Example5



##################################
##
##  Attributes
##
##################################

#! @Chapter Attributes and properties
#! @Section Attributes and properties of polyhedron

#! @Arguments poly
#! @Returns The dimension of the polyhedron
DeclareAttribute( "Cdd_Dimension", IsCddPolyhedron );

#! @Arguments poly
#! @Returns The dimension of the ambient space of the polyhedron
DeclareAttribute( "Cdd_AmbientSpaceDimension", IsCddPolyhedron );

#! @Arguments poly
#! @Returns The reduced generating vertices of the polyhedron
DeclareAttribute( "Cdd_GeneratingVertices", IsCddPolyhedron );

#! @Arguments poly
#! @Returns The reduced generating rays of the polyhedron
DeclareAttribute( "Cdd_GeneratingRays", IsCddPolyhedron );

#! @Arguments poly
#! @Returns The reduced defining equalities of the polyhedron
DeclareAttribute( "Cdd_Equalities", IsCddPolyhedron );

#! @Arguments poly
#! @Returns The reduced defining inequalities of the polyhedron
DeclareAttribute( "Cdd_Inequalities", IsCddPolyhedron );

#! @Arguments poly
#! @Returns An interior point of the polyhedron
DeclareAttribute( "Cdd_InteriorPoint",  IsCddPolyhedron  );

#! @Arguments poly
#! @Returns All faces with their dimensions
#! @Description
#! This function takes a H-represented polyhedron $\texttt{poly}$ and returns a list. Every entry in this 
#! list is a again a list, contains the dimension and linearity of the face defined as a polyhedron over the 
#! same system of inequalities.
DeclareAttribute( "Cdd_Faces",  IsCddPolyhedron  );


#! @Arguments poly
#! @Returns All faces with their dimensions and an interior point in each face
#! @Description
#! This function takes a H-represented polyhedron $\texttt{poly}$ and returns a list. Every entry in this 
#! list is a again a list, contains the dimension, linearity of the face defined as a polyhedron over the 
#! same system of inequalities and an interior point in the face.
DeclareAttribute( "Cdd_FacesWithInteriorPoints",  IsCddPolyhedron  );

#! @Arguments poly
#! @Returns All facets with their dimensions 
#! @Description
#! This function takes a H-represented polyhedron $\texttt{poly}$ and returns a list. Every entry in this 
#! list is a again a list, contains the dimension, linearity of the facet defined as a polyhedron over the 
#! same system of inequalities.
DeclareAttribute( "Cdd_Facets",  IsCddPolyhedron  );

#! @Arguments poly
#! @Returns All lines in the polyhedron 
#! @Description
#! This function takes a H-represented polyhedron $\texttt{poly}$ and returns a list. Every entry in this 
#! list is the linearity of a line defined as a polyhedron over the 
#! same system of inequalities.
DeclareAttribute( "Cdd_Lines",  IsCddPolyhedron  );

#! @Arguments poly
#! @Returns All Vertices 
#! @Description
#! This function takes a H-represented polyhedron $\texttt{poly}$ and returns a list. Every entry in this 
#! list is the linearity of a vertex defined as a polyhedron over the same system of inequalities.
DeclareAttribute( "Cdd_Vertices",  IsCddPolyhedron  );



##################################
##
##  Properties
##
##################################

#! @Arguments poly
#! @Returns $\texttt{true}$ if the polyhedron is empty and $\texttt{false}$ otherwise
DeclareProperty( "Cdd_IsEmpty", IsCddPolyhedron );

#! @Arguments poly
#! @Returns $\texttt{true}$ if the polyhedron is cone and $\texttt{false}$ otherwise
DeclareProperty( "Cdd_IsCone", IsCddPolyhedron );

#! @Arguments poly
#! @Returns $\texttt{true}$ if the polyhedron is pointed and $\texttt{false}$ otherwise
DeclareProperty( "Cdd_IsPointed", IsCddPolyhedron );

#! @InsertChunk demo

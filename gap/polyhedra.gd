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

# DeclareOperation( "\=" , [ IsCddPolyhedron, IsCddPolyhedron ] );


#! @Chapter Linear Programs
#! @Section Creating a linear program

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

DeclareOperation( "Cdd_Faces", [ IsCddPolyhedron ] );

DeclareOperation( "Cdd_Facets", [ IsCddPolyhedron ] );


DeclareOperation( "Cdd_FacesWithInteriorPoints", [ IsCddPolyhedron ] );

DeclareOperation( "Cdd_FacetsWithInteriorPoints", [ IsCddPolyhedron ] );

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


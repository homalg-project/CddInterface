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

DeclareGlobalVariable( "CddPolyhedraCalculations" );



#################################
##
##  Categories
##
#################################

DeclareCategory( "IsCddPolyhedra", IsObject );

DeclareCategory( "IsCddLinearProgram", IsObject );



##################################
##
## Operations and Global functions
##
##################################
# to activate the documentation press gap makedoc.g


#! @Chapter Creating polyhedras and their Operations
#! @Section Creating a polyhedra


#! @Arguments arg 
#! @Returns a $\texttt{CddPolyhedra}$ Object
#! @Description  
#! The function takes a list in which every entry represents an inequality( or equality).
#! In case we want some entries to represent equalities we should refer  
#! in a second list to their indices.
DeclareGlobalFunction( "Cdd_PolyhedraByInequalities" );
#! @InsertChunk Example1

#! @Arguments arg 
#! @Returns a $\texttt{CddPolyhedra}$ Object
#! @Description  
#! The function takes a list in which every entry represents a vertex in the ambient vector space.
#! In case we want some vertices to be free( the vertex and its negative belong to the polyhedra) we should refer 
#! in a second list to their indices . 
DeclareGlobalFunction( "Cdd_PolyhedraByGenerators" );
#! @InsertChunk Example2

#! @Section Some operations on polyhedras

#! @Arguments poly
#! @Returns a $\texttt{CddPolyhedra}$ Object
#! @Description 
#! The function takes a polyhedra and reduces its defining inequalities ( generators set) by deleting all redundant inequalities ( generators ). 
DeclareOperation( "Cdd_Canonicalize", [ IsCddPolyhedra ] );
#! @InsertChunk Example3


#! @Arguments poly
#! @Returns a $\texttt{CddPolyhedra}$ Object
#! @Description 
#! The function takes a polyhedra and returns its reduced V-representation. 
DeclareOperation( "Cdd_V_Rep", [ IsCddPolyhedra ] );



#! @Arguments poly
#! @Returns a $\texttt{CddPolyhedra}$ Object
#! @Description 
#! The function takes a polyhedra and returns its reduced H-representation. 
DeclareOperation( "Cdd_H_Rep", [ IsCddPolyhedra ] );
#! @InsertChunk Example4

# DeclareOperation( "\=" , [ IsCddPolyhedra, IsCddPolyhedra ] );


#! @Chapter Linear Programs
#! @Section Creating a linear program

#! @Arguments poly, str, obj
#! @Returns a $\texttt{CddLinearProgram}$ Object
#! @Description 
#! The function takes three variables. The first is a polyhedra $\texttt{poly}$, the second $\texttt{str}$ should be max or min and the third $\texttt{obj}$ is the objective. 
DeclareOperation( "Cdd_LinearProgram", [IsCddPolyhedra, IsString, IsList] );

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
#! @Section Attributes and properties of polyhedra

#! @Arguments poly
#! @Returns The dimension of the polyhedra
DeclareAttribute( "Cdd_Dimension", IsCddPolyhedra );

#! @Arguments poly
#! @Returns The dimension of the ambient space of the polyhedra
DeclareAttribute( "Cdd_AmbientSpaceDimension", IsCddPolyhedra );

#! @Arguments poly
#! @Returns The reduced generating vertices of the polyhedra
DeclareAttribute( "Cdd_GeneratingVertices", IsCddPolyhedra );

#! @Arguments poly
#! @Returns The reduced generating rays of the polyhedra
DeclareAttribute( "Cdd_GeneratingRays", IsCddPolyhedra );

#! @Arguments poly
#! @Returns The reduced defining equalities of the polyhedra
DeclareAttribute( "Cdd_Equalities", IsCddPolyhedra );

#! @Arguments poly
#! @Returns The reduced defining inequalities of the polyhedra
DeclareAttribute( "Cdd_Inequalities", IsCddPolyhedra );

##################################
##
##  Properties
##
##################################

#! @Arguments poly
#! @Returns $\texttt{true}$ if the polyhedra is empty and $\texttt{false}$ otherwise
DeclareProperty( "Cdd_IsEmpty", IsCddPolyhedra );

#! @Arguments poly
#! @Returns $\texttt{true}$ if the polyhedra is cone and $\texttt{false}$ otherwise
DeclareProperty( "Cdd_IsCone", IsCddPolyhedra );

#! @Arguments poly
#! @Returns $\texttt{true}$ if the polyhedra is pointed and $\texttt{false}$ otherwise
DeclareProperty( "Cdd_IsPointed", IsCddPolyhedra );


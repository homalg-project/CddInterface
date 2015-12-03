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


#! @Chapter Functions and Methods
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


DeclareOperation( "Cdd_LinearProgram", [IsCddPolyhedra, IsString, IsList] );



##################################
##
##  Attributes
##
##################################

DeclareAttribute( "Cdd_AmbientSpaceDimension", IsCddPolyhedra );

##################################
##
##  Properties
##
##################################

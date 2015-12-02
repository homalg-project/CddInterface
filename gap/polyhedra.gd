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
#! @Returns a CddPolyhedra Object
#! @Description  
#! The function takes a list in which every entry represents an inequality( or equality).
#! In case we want some entries to represent equalities we should refer to their indices 
#! in a second list.
DeclareGlobalFunction( "Cdd_PolyhedraByInequalities" );
#! @Example
 A:= Cdd_PolyhedraByInequalities( [ [ 0, 1, 3 ], [ 0, 4, 8 ] ] );
#! < Polyhedra given by its H-representation >
 Display( A ) ;
#! H-representation 
#! Begin 
#!   2 X 3  rational
#!            
#!   0  1  3 
#!   0  4  8 
#! End
 B:= Cdd_PolyhedraByInequalities( [ [ 0, 1, 3 ], [ 0, 4, 8 ] ], [ 2 ] );
#! < Polyhedra given by its H-representation >
 Display( B ) ;
#! H-representation 
#! Linearity 1, [ 2 ]
#! Begin 
#!   2 X 3  rational
#!            
#!   0  1  3 
#!   0  4  8 
#! End
#! @EndExample

DeclareGlobalFunction( "Cdd_PolyhedraByGenerators" );
DeclareOperation( "Cdd_Canonicalize", [ IsCddPolyhedra ] );
DeclareOperation( "Cdd_V_Rep", [ IsCddPolyhedra ] );
DeclareOperation( "Cdd_H_Rep", [ IsCddPolyhedra ] );
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

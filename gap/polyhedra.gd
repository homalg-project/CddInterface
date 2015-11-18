#
# LearnGap: This is written just to learn and test commands of Gap to understand it.
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

#DeclareCategory( "IsTriangle", IsObject );

#DeclareCategory( "IsRectangle", IsObject );

#DeclareCategory( "IsCircel", IsObject );


##################################
##
## Operations and Global functions
##
##################################


DeclareGlobalFunction( "Cdd_PolyhedraByInequalities" );
DeclareGlobalFunction( "Cdd_PolyhedraByGenerators" );
DeclareOperation( "Cdd_LinearProgram", [IsCddPolyhedra, IsString, IsList] );
# DeclareOperation( "Display",[ IsCddPolyhedra ] );
# DeclareOperation( "ViewObj", [IsCddPolyhedra] );
# DeclareGlobalFunction( "Cdd_PolyhedraByInequalities" );
# DeclareGlobalFunction( "Trianglee");
# DeclareGlobalFunction( "Rectanglee");
# DeclareGlobalFunction( "Circell");


##################################
##
##  Attributes
##
##################################

DeclareAttribute( "Cdd_AmbientSpaceDimension", IsCddPolyhedra );
# DeclareAttribute( "Area", IsTriangle );
# DeclareAttribute( "Area", IsRectangle );

##################################
##
##  Properties
##
##################################

# DeclareProperty( "IsRightAngled", IsTriangle );
# DeclareProperty( "IsIsosceles", IsTriangle );

#
# LearnGap: This is written just to learn and test commands of Gap to understand it.
#
# Implementations
#

#############################
##
## Representations
##
#############################

DeclareRepresentation( "IsCddPolyhedraRep",
                         IsCddPolyhedra and IsAttributeStoringRep,
                         [ ] );
                         
DeclareRepresentation( "IsCddLinearProgramRep",
                        IsCddLinearProgram and IsAttributeStoringRep,
                         [ ] );
 
##################################
##
## Family and Type
##
##################################

BindGlobal( "CddObjectsFamily",
  NewFamily( "CddObjectsFamily", IsObject ) );

  

BindGlobal( "TheTypeCddPolyhedra", 
  NewType( CddObjectsFamily, 
                      IsCddPolyhedraRep ) );
                      
BindGlobal( "TheTypeCddLinearProgram",
  NewType( CddObjectsFamily, 
                      IsCddLinearProgramRep ) );


##################################
##
## Constructors
##
##################################

###
InstallGlobalFunction( Cdd_PolyhedraByInequalities,
               "constructor for polyhedra by inequalities",
#              [IsMatrix, IsString],
   function( arg )
   local poly, i;
   
   if Length( arg )= 0 then Error( "inappropriate input" );
   
   elif Length( arg )= 1 and IsMatrix( arg[1] ) then
   
   poly := rec( poly_inequalities:= arg[1],
                linearity:= [],
                number_type:= "rational",
                rep_type := "H-rep" );
   
   ObjectifyWithAttributes( 
   poly, TheTypeCddPolyhedra
   );
   
   return  poly;
   
   elif Length( arg )= 2 and IsMatrix( arg[1] ) and IsString( arg[2] ) then
   
   poly := rec( poly_inequalities:= arg[1],
                linearity:= [],
                number_type:= arg[2],
                rep_type := "H-rep" );
   
   ObjectifyWithAttributes( 
   poly, TheTypeCddPolyhedra
   );
   
   return  poly;
   
   elif Length( arg )= 2 and IsMatrix( arg[1] ) and IsInt( arg[2][1] ) then
   
   for i in [1..Length( arg[2] ) ] do
    
       if arg[2][i]> Length( arg[1] ) or arg[2][i]<0 then Error("The linearity is not combatible");fi;
   
   od;
   
   poly := rec( poly_inequalities:= arg[1],
                linearity:= arg[2],
                number_type:= "rational",
                rep_type := "H-rep" );
   
   ObjectifyWithAttributes( 
   poly, TheTypeCddPolyhedra
   );
   
   return  poly;
    
   elif Length( arg )= 3 and IsMatrix( arg[1] ) and IsList( arg[2] ) 
                            and IsString( arg[3] ) then
   
           for i in [1..Length( arg[2] ) ] do
    
               if arg[2][i]> Length( arg[1] ) or arg[2][i]<0 then Error("The linearity is not combatible");fi;
   
           od; 
           
           poly := rec( poly_inequalities:= arg[1],
                linearity:= arg[2],
                number_type:= arg[3],
                rep_type := "H-rep" );
   
   ObjectifyWithAttributes( 
   poly, TheTypeCddPolyhedra
   );
   
   return  poly;
   
   fi;
   
   end );   

###
InstallGlobalFunction( Cdd_PolyhedraByGenerators,
               "constructor for polyhedra by generators",
#              [IsMatrix, IsString],
   function( arg )
   local poly,i;
   
   if Length( arg )= 0 then Error( "inappropriate input" );
   
   
   elif Length( arg )= 1 and IsMatrix( arg[1] ) then
   
   for i in [1..Length( arg[1]) ] do
   
     if not ( arg[1][i][1] in [0,1] ) then Error("The first column of the matrix should be only 1's or 0's");fi;
   
   od;
   poly := rec( poly_generators:= arg[1],
                linearity:= [],
                number_type:= "rational",
                rep_type := "V-rep" );
   
   ObjectifyWithAttributes( 
   poly, TheTypeCddPolyhedra
   );
   
   return  poly;
   
   elif Length( arg )= 2 and IsMatrix( arg[1] ) and IsString( arg[2] ) then
   
   for i in [1..Length( arg[1]) ] do
   
     if not ( arg[1][i][1] in [0,1] ) then Error("The first column of the matrix should be only 1's or 0's");fi;
   
   od;
   poly := rec( poly_generators:= arg[1],
                linearity:= [],
                number_type:= arg[2],
                rep_type := "V-rep" );
   
   ObjectifyWithAttributes( 
   poly, TheTypeCddPolyhedra
   );
   
   return  poly;
   
   elif Length( arg )= 2 and IsMatrix( arg[1] ) and IsInt( arg[2][1] ) then
   
   for i in [1..Length( arg[1]) ] do
   
       if not ( arg[1][i][1] in [0,1] ) then Error("The first column of the matrix should be only 1's or 0's");fi;
   
   od;
   
   for i in [1..Length( arg[2] ) ] do
    
               if arg[2][i]> Length( arg[1] ) or arg[2][i]<0 then Error("The linearity is not combatible");fi;
   
   od;
   poly := rec( poly_generators:= arg[1],
                linearity:= arg[2],
                number_type:= "rational",
                rep_type := "V-rep" );
   
   ObjectifyWithAttributes( 
   poly, TheTypeCddPolyhedra
   );
   
   return  poly;
    
   elif Length( arg )= 3 and IsMatrix( arg[1] ) and IsList( arg[2] ) 
                            and IsString( arg[3] ) then
           for i in [1..Length( arg[2] ) ] do
    
               if arg[2][i]> Length( arg[1] ) or arg[2][i]<0 then Error("The linearity is not combatible");fi;
   
           od;
           
           for i in [1..Length( arg[1]) ] do
   
               if not ( arg[1][i][1] in [0,1] ) then Error("The first column of the matrix should be only 1's or 0's");fi;
   
           od;
           
           poly := rec( poly_generators:= arg[1],
                linearity:= arg[2],
                number_type:= arg[3],
                rep_type := "V-rep" );
   
   ObjectifyWithAttributes( 
   poly, TheTypeCddPolyhedra
   );
   
   return  poly;
   
   fi;
   
   end );           
   

InstallMethod( Cdd_LinearProgram,
               "creating linear program",
               [ IsCddPolyhedra, IsString, IsList ],
function( poly, obj, rowvec )

   local r;
   
   if obj<> "max" and obj <> "min" then
   
       Error( "The second argument should be either 'max' or 'min' " );
       
   fi;
   
   r:= rec( polyhedra:= poly, objective:= obj, rowvector:= rowvec );
   
   ObjectifyWithAttributes(
   r, TheTypeCddLinearProgram
   );
   
   return r;
end );

# 
# 
# InstallMethod( Cdd_PolyhedraFromList,
#               [ IsList ],
#  function( list )
#  
#  local 
#  

##################################
##
##  Attributes and Properties
##
##################################

InstallMethod( Cdd_AmbientSpaceDimension,
              "finding the dimension of the ambient space",
              [ IsCddPolyhedra ],
function( poly )

if poly!.rep_type= "H-rep" then 

      return Length( poly!.poly_inequalities[1] )-1;

else  

      return Length( poly!.poly_generators[1] )-1;

fi;

end );


##################################
##
## Display Methods
##
##################################

###
InstallMethod( ViewObj,
               [ IsCddPolyhedra],
function( poly )

Print( "< Polyhedra given by its ",poly!.rep_type,"resentation >");

end );

###
InstallMethod( ViewObj,
               [ IsCddLinearProgram],
               
function( poly )

Print( "< Linear program >" );

end );

###
InstallMethod( Display,
               [ IsCddPolyhedra ],
              

function( poly )


Print("\n", poly!.rep_type, "resentation \n" );

if Length( poly!.linearity) <> 0 then Print( "Linearity ", Length(poly!.linearity),", ",poly!.linearity,"\n");fi;

Print( "Begin \n" );

if poly!.rep_type= "H-rep" then 
  
  Print("   ", Length( poly!.poly_inequalities)," X ", Length( poly!.poly_inequalities[1] ), "  ", poly!.number_type, "\n" );
  PTM( poly!.poly_inequalities );
  
else

  Print("   ", Length( poly!.poly_generators)," X ", Length( poly!.poly_generators[1] ), "  ", poly!.number_type, "\n" );
  PTM( poly!.poly_generators );

fi;

Print( "End\n" );

end );

###
InstallMethod( Display,
               [IsCddLinearProgram],
function( poly )

Print( "Linear program given by its " );
Display( poly!.polyhedra );
Print( poly!.objective, "  ",poly!.rowvector );

end );
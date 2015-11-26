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
   local poly, i, temp;
   
   if Length( arg )= 0 then Error( "inappropriate input" );
   
   elif Length( arg )= 1 and IsMatrix( arg[1] ) then
   
   if false in List([1..Length(arg[1])],i-> Length(arg[1][1])= Length(arg[1][i])) then
   
       return Error( "inappropriate input" );
       
   fi;
   
   poly := rec( poly_inequalities:= arg[1],
                linearity:= [],
                number_type:= "rational",
                rep_type := "H-rep" );
   
   ObjectifyWithAttributes( 
   poly, TheTypeCddPolyhedra
   );
   
   return  poly;
   
   elif Length( arg )= 2 and IsMatrix( arg[1] ) and IsString( arg[2] ) then
   
   if false in List([1..Length(arg[1])],i-> Length(arg[1][1])= Length(arg[1][i])) then
   
       return Error( "inappropriate input" );
       
   fi;
   
   if arg[2]= "integer" then 
   
       temp:= ConvertListOfVectorsToList( arg[1] );
       
       if false in List( [ 1..Length( temp ) ],i-> IsInt( temp[i] ) ) then 
       
           return Error("All entries in the generators should be integers");
           
       fi;
       
   fi;
   
   poly := rec( poly_inequalities:= arg[1],
                linearity:= [],
                number_type:= arg[2],
                rep_type := "H-rep" );
   
   ObjectifyWithAttributes( 
   poly, TheTypeCddPolyhedra
   );
   
   return  poly;
   
   elif Length( arg )= 2 and IsMatrix( arg[1] ) and IsInt( arg[2][1] ) then
   
   if false in List([1..Length(arg[1])],i-> Length(arg[1][1])= Length(arg[1][i])) then
   
       return Error( "inappropriate input" );
       
   fi;
   
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
                            
           if false in List([1..Length(arg[1])],i-> Length(arg[1][1])= Length(arg[1][i])) then
   
                return Error( "inappropriate input" );
       
           fi;                
   
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
   
   if arg[3]= "integer" then 
   
       temp:= ConvertListOfVectorsToList( arg[1] );
       
       if false in List( [ 1..Length( temp ) ],i-> IsInt( temp[i] ) ) then 
       
           return Error("All entries in the generators should be integers");
           
       fi;
       
   fi;
   
   return  poly;
   
   fi;
   
   end );   

###
InstallGlobalFunction( Cdd_PolyhedraByGenerators,
               "constructor for polyhedra by generators",
   function( arg )
   local poly,i, temp;
   
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
   
     if arg[2]= "integer" then 
   
       temp:= ConvertListOfVectorsToList( arg[1] );
       
       if false in List( [ 1..Length( temp ) ],i-> IsInt( temp[i] ) ) then 
       
           return Error("All entries in the generators should be integers");
           
       fi;
       
   fi;
   
   poly := rec( poly_generators:= arg[1],
                linearity:= [],
                number_type:= arg[2],
                rep_type := "V-rep" );
   
   ObjectifyWithAttributes( 
   poly, TheTypeCddPolyhedra
   );
   
   if arg[2]= "integer" then 
   
       temp:= ConvertListOfVectorsToList( arg[1] );
       
       if false in List( [ 1..Length( temp ) ],i-> IsInt( temp[i] ) ) then 
       
           return Error("All entries in the generators should be integers");
           
       fi;
       
   fi;
   
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
   
   if arg[3]= "integer" then 
   
       temp:= ConvertListOfVectorsToList( arg[1] );
       
       if false in List( [ 1..Length( temp ) ],i-> IsInt( temp[i] ) ) then 
       
           return Error("All entries in the generators should be integers");
           
       fi;
       
   fi;
   
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
##  Operations
##
##################################


InstallMethod( Cdd_Canonicalize,
               [ IsCddPolyhedra],
 function( poly )
 
 local L1, L2;
 
 L1:= Cdd_PolyToList( poly );
 
 L2:= CddInterface_Canonicalize( L1 );
 
 return Cdd_ListToPoly( L2 );
 
 end );
 

InstallMethod( Cdd_ListToPoly, 
               [ IsList ],
function( list )

local numtype, matrix, temp;

if not IsCompatiblePolyhedraList( list ) then return Error( "The given list is not compatible" ); fi;

if list[2]= 3 then numtype:= "integer";

   elif list[2]=2 then numtype:= "rational";

     elif list[2]=1 then numtype:= "real"; 
      
        else numtype:= "unknown"; 
      
fi;

temp:= ConvertIntListToRatList( list[7] );

matrix:= ConvertListToListOfVectors( temp, list[5] );

 if list[1]=2 then 

       if list[3]=0 then return Cdd_PolyhedraByGenerators( matrix, numtype );
       
          else return Cdd_PolyhedraByGenerators( matrix , list[6], numtype );
          
       fi;
 else 
 
      if list[3]=0 then return Cdd_PolyhedraByInequalities( matrix, numtype );
       
          else return Cdd_PolyhedraByInequalities( matrix , list[6], numtype );
       
      fi;
      
 fi;

end );


InstallMethod( Cdd_PolyToList,

               [ IsCddPolyhedra ],
               
function( poly )

local L, matrix, lin, temp;

L:= [];

if (poly!.rep_type= "H-rep" ) then 

     Add( L, 1 );
   
else 

    Add( L, 2 ) ;
    
fi;

if poly!.number_type = "real" then 

     Add( L, 1 );
     
elif poly!.number_type= "rational" then

     Add( L, 2 );
     
elif poly!.number_type= "integer" then

     Add( L, 3 );
     
elif poly!.number_type= "unknown" then 

     Add( L, 4 );
     
else return Error( "The number type is not recognized" );

fi;

if Length( poly!.linearity) = 0  then 

     Add( L, 0 );
    
else 

     Add( L, 1 );
     
fi;


if (poly!.rep_type= "H-rep" ) then 

     matrix:= poly!.poly_inequalities;
   
else 

    matrix:= poly!.poly_generators ;
    
fi;

Add(L, Length( matrix    )  );
Add(L, Length( matrix[1] )  );

lin := poly!.linearity;

temp:= [ Length( lin ) ];

Append( temp, lin );

Add( L, temp );

if poly!.number_type= "integer" then 

     Add( L, ConvertListOfVectorsToList( matrix ) );
     
else 

     Add( L, ConvertRatListToIntList( ConvertListOfVectorsToList( matrix ) ) );
     
fi;

Append( L, [ 0, [] ] );

return L;

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


Print( poly!.rep_type, "resentation \n" );

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

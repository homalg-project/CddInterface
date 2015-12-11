#
# Gap Interface to Cdd package.
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
   
   if Length( arg )= 0 then 
   
       Error( "inappropriate input" );
   
   elif Length( arg )= 1 and IsList( arg[1] ) then
   
   if Length( arg[ 1 ] )=0 then 
   
   poly := rec(    matrix:= [ [1, 0, 0] ],
                   inequalities:= [ ],
                   equalities:= [ [1, 0, 0] ],
                   linearity:= [],
                   number_type:= "rational",
                   rep_type := "H-rep" );
   
      ObjectifyWithAttributes( 
      poly, TheTypeCddPolyhedra
      );
   
      return  poly;
      
      
   fi;   
   
   if false in List([1..Length(arg[1])],i-> Length(arg[1][1])= Length(arg[1][i])) then
   
      Error( "inappropriate input" );
       
   fi;
   
   temp := GiveInequalitiesAndEqualities( arg[1], [] );

   poly := rec(    matrix:=arg[1],
                   inequalities:= temp[1],
                   equalities:= temp[2],
                   linearity:= [],
                   number_type:= "rational",
                   rep_type := "H-rep" );
   
      ObjectifyWithAttributes( 
      poly, TheTypeCddPolyhedra
      );
   
      return  poly;
   
   
   elif Length( arg )= 2 and IsList( arg[1] ) and IsInt( arg[2][1] ) then
   
   if false in List([1..Length(arg[1])],i-> Length(arg[1][1])= Length(arg[1][i])) then
   
       return Error( "inappropriate input" );
       
   fi;
   
   for i in [1..Length( arg[2] ) ] do
    
       if arg[2][i]> Length( arg[1] ) or arg[2][i]<0 then Error("The linearity is not combatible");fi;
   
   od;
   
   temp := GiveInequalitiesAndEqualities( arg[1], arg[2] );

   poly := rec(    matrix:=arg[1],
                   inequalities:= temp[1],
                   equalities:= temp[2],
                   linearity:= arg[2],
                   number_type:= "rational",
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
   function( arg )
   local poly,i, temp;
   
   if Length( arg )= 0 then Error( "inappropriate input" );
   
   
   elif Length( arg )= 1 and IsList( arg[1] ) then
   
   
   for i in [1..Length( arg[1]) ] do
   
     if not ( arg[1][i][1] in [0,1] ) then Error("The first column of the matrix should be only 1's or 0's");fi;
   
   od;
   
   temp:= GiveGeneratingVerticesAndGeneratingRays( arg[1], [ ] );
   
   poly := rec( generating_vertices := temp[1],
                generating_rays := temp[2],
                matrix:=arg[1],
                linearity:= [ ],
                number_type:= "rational",
                rep_type := "V-rep" );
   
   ObjectifyWithAttributes( 
   poly, TheTypeCddPolyhedra
   );
   
   return  poly;
   
   elif Length( arg )= 2 and IsList( arg[1] ) and IsInt( arg[2][1] ) then
   
   for i in [1..Length( arg[1]) ] do
   
       if not ( arg[1][i][1] in [0,1] ) then Error("The first column of the matrix should be only 1's or 0's");fi;
   
   od;
   
   for i in [1..Length( arg[2] ) ] do
    
               if arg[2][i]> Length( arg[1] ) or arg[2][i]<0 then Error("The linearity is not compatible");fi;
   
   od;
   
   
   temp:= GiveGeneratingVerticesAndGeneratingRays( arg[ 1 ], arg[ 2 ] );
   
   poly := rec( generating_vertices := temp[1],
                generating_rays := temp[2],
                matrix:=arg[1],
                linearity:= arg[ 2 ],
                number_type:= "rational",
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
   
   r:= rec( polyhedra:=  poly , objective:= obj, rowvector:= rowvec );
   
   ObjectifyWithAttributes(
   
   r, TheTypeCddLinearProgram
   
   );
   
   return r;
   
end );


##################################
##
##  Attributes and Properties
##
##################################
InstallMethod( Cdd_Dimension,
              " returns the dimension of the polyhedra",
              [ IsCddPolyhedra ],
function( poly )

  if Cdd_IsEmpty( poly ) then 

      return -1;
      
  else 

      return Cdd_AmbientSpaceDimension( poly)- Length( Cdd_H_Rep( poly )!.linearity );
      
  fi;

end );

InstallMethod( Cdd_Inequalities,
              " return the list of inequalities of a polyhedra",
              [ IsCddPolyhedra ],
function( poly )

  return Cdd_H_Rep( poly )!.inequalities;

end );

InstallMethod( Cdd_Equalities,
              " return the list of equalities of a poylhedra",
              [ IsCddPolyhedra ],
function( poly )

  return Cdd_H_Rep( poly )!.equalities;

end );


InstallMethod( Cdd_GeneratingVertices,
              " return the list of generating vertices",
              [ IsCddPolyhedra ],
function( poly )

  return Cdd_V_Rep( poly )!.generating_vertices;
      
end );

InstallMethod( Cdd_GeneratingRays,
              " return the list of generating vertices",
              [ IsCddPolyhedra ],
function( poly )

  return Cdd_V_Rep( poly )!.generating_rays;
      
end );
###
InstallMethod( Cdd_AmbientSpaceDimension,
              "finding the dimension of the ambient space",
              [ IsCddPolyhedra ],
function( poly ) 

  return Length( poly!.matrix[1] )-1;
 
end );


###
InstallMethod( Cdd_IsEmpty,
               "finding if the polyhedron empty is or not",
               [ IsCddPolyhedra ],
function( poly )

  return Length(  Cdd_V_Rep( poly )!.matrix ) = 0;

end );


InstallMethod( Cdd_IsCone, 
                "finding if the polyhedron is a cone or not",
                [ IsCddPolyhedra ],
 function( poly )
 
 return Length( Cdd_GeneratingVertices( poly ) ) = 0;
 
 end );
 
 
InstallMethod( Cdd_IsPointed,
               "finding if the polyhedron is pointed or not",
               [ IsCddPolyhedra ],
function( poly )

return Cdd_AmbientSpaceDimension( poly )= Length( Cdd_H_Rep( poly )!.matrix );

end );

##################################
##
##  Operations
##
##################################


InstallMethod( Cdd_Canonicalize,
               [ IsCddPolyhedra],
 function( poly )
 
 local temp, temp_poly, i, L1, L2;
 
  if  poly!.rep_type= "V-rep" and poly!.matrix = [] then 
       
      return poly;
     
  fi;
  
  
  if poly!.rep_type= "H-rep" then 
  
      temp:= StructuralCopy( poly!.matrix );
  
      for i in poly!.matrix do
      
          if IsZero( i ) then 
             
             i[1]:=1;
             
          fi;
          
      od;
      
      temp_poly:= rec( matrix:= temp,
                       linearity:= poly!.linearity,
                       number_type:= "rational",
                       rep_type := "H-rep" );
                
      ObjectifyWithAttributes( 
      temp_poly, TheTypeCddPolyhedra
      );
 
      return ListToPoly( CddInterface_Canonicalize( PolyToList( temp_poly ) ) );
   
  fi;

 return ListToPoly( CddInterface_Canonicalize( PolyToList( poly ) ) );
 
 end );
 

InstallMethod( Cdd_V_Rep, 
               [ IsCddPolyhedra ],
 function( poly )
 
 local L, p;
 
 if poly!.rep_type = "V-rep" then 
 
    return Cdd_Canonicalize( poly );
    
 else 
 
    return Cdd_Canonicalize( ListToPoly( CddInterface_Compute_V_rep( PolyToList( poly ) ) ) );
    
 fi;
    
end );

InstallMethod( Cdd_H_Rep, 
               [ IsCddPolyhedra ],
 function( poly )
 
 local L, p;
 
 if poly!.rep_type = "H-rep" then 
 
    return Cdd_Canonicalize( poly );
    
 else 
 
    if  poly!.rep_type= "V-rep" and poly!.matrix = [] then 
       
      return Cdd_PolyhedraByInequalities( [ [0, 1 ], [-1, -1 ] ] );
      
    fi;
 
    return Cdd_Canonicalize( ListToPoly( CddInterface_Compute_H_rep( PolyToList( poly ) ) ) );
    
 fi;
    
end );


InstallMethod( Cdd_SolveLinearProgram,
               [IsCddLinearProgram],
               
function( lp )

local temp;

temp:= LinearProgramToList( lp );

return CddInterface_LpSolution( temp );

end );

InstallMethod( \=,
               [ IsCddPolyhedra, IsCddPolyhedra ],
function( poly1, poly2 )
local generating_vertices1, generating_vertices2, generating_rays1, generating_rays2;

generating_vertices1:= Set(Cdd_GeneratingVertices( poly1 ) );
generating_vertices2:= Set(Cdd_GeneratingVertices( poly2 ) );

generating_rays1:= Set( Cdd_GeneratingRays( poly1 ) );
generating_rays2:= Set( Cdd_GeneratingRays( poly2 ) );

return generating_vertices1=generating_vertices2 and generating_rays1= generating_rays2;

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
  
 if  poly!.rep_type= "V-rep" and poly!.matrix = [] then 
    
         Print( "The empty polyhedra" );
         
 else 
    
      Print( poly!.rep_type, "resentation \n" );
  
      if Length( poly!.linearity) <> 0 then Print( "Linearity ", Length(poly!.linearity),", ",poly!.linearity,"\n");fi;

      Print( "begin \n" );
  
      Print("   ", Length( poly!.matrix)," X ", Length( poly!.matrix[1] ), "  ", poly!.number_type, "\n" );
  
      PTM( poly!.matrix );
  
      Print( "end\n" );
      
 fi; 

end );

###
InstallMethod( Display,
               [IsCddLinearProgram],
 function( poly )

 Print( "Linear program given by: \n" );

 Display( poly!.polyhedra );

 Print( poly!.objective, "  ",poly!.rowvector );

end );

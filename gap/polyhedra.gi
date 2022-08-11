#############################################################################
##
##  polyhedra.gi         CddInterface package                Kamal Saleh
##
##  Copyright 2019 Mathematics Faculty, Siegen University, Germany
##
##  Fans for NConvex package.
##
#############################################################################

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

DeclareRepresentation( "IsCddPolyhedronRep",
                         IsCddPolyhedron and IsAttributeStoringRep,
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

BindGlobal( "TheTypeCddPolyhedron", 
  NewType( CddObjectsFamily, 
                      IsCddPolyhedronRep ) );

BindGlobal( "TheTypeCddLinearProgram",
  NewType( CddObjectsFamily, 
                      IsCddLinearProgramRep ) );

##################################
##
## Constructors
##
##################################

###
InstallGlobalFunction( Cdd_PolyhedronByInequalities,
  #             "constructor for polyhedron by inequalities",
  #             [IsMatrix, IsString],
  function( arg )
    local poly, i, temp, matrix, dim;
    
    if Length( arg ) = 0 then 
      
      Error( "Wronge input: Please provide some input!" );
    
    elif Length( arg ) = 1 and IsList( arg[ 1 ] ) then
      
      return Cdd_PolyhedronByInequalities( arg[ 1 ], [ ] );
      
    elif Length( arg ) = 2 and IsList( arg[ 1 ] ) and IsList( arg[ 2 ] ) then
      
      if IsEmpty( arg[ 1 ] ) or ForAny( arg[ 1 ], IsEmpty ) then 
        
        Error( "Wronge input: Please remove the empty lists from the input!" );
      
      fi;
      
      if not IsMatrix( arg[ 1 ] ) then
        
        Error( "Wronge input: The first argument should be a Gap matrix!" );
       
      fi;
      
      if not ForAll( arg[ 2 ], i -> i in [ 1 .. NrRows( arg[ 1 ] ) ] ) then
        
        Error( "Wronge input for linearity" );
      
      fi;
      
      dim := Length( arg[ 1 ][ 1 ] ) - 1;
      
      matrix := Filtered( arg[ 1 ], row -> not IsZero( row ) );
      
      if IsEmpty( matrix ) then
        
        matrix := [ Concatenation( [ 1 ], ListWithIdenticalEntries( dim, 0 ) ) ];
      
      fi;
      
      temp := GiveInequalitiesAndEqualities( matrix, arg[ 2 ] );
      
      poly := rec( matrix := matrix,
                inequalities := temp[ 1 ],
                equalities := temp[ 2 ],
                linearity := arg[ 2 ],
                number_type := "rational",
                rep_type := "H-rep" );
      
      ObjectifyWithAttributes( poly, TheTypeCddPolyhedron );
      
      return poly;
    
    fi;
    
end );

###
InstallGlobalFunction( Cdd_PolyhedronByGenerators,
  #             "Constructor for polyhedron by generators",
  function( arg )
    local poly, i, matrix, temp, dim;
   
    if Length( arg )= 0 then
      
      Error( "Wronge input" );
   
    elif Length( arg ) = 1 and IsList( arg[1] ) then
     
     return Cdd_PolyhedronByGenerators( arg[ 1 ], [ ] );
     
    elif Length( arg ) = 2 and IsList( arg[ 1 ] ) and IsList( arg[ 2 ] ) then
      
      if IsEmpty( arg[ 1 ] ) or ForAny( arg[ 1 ], IsEmpty ) then
        
        poly := rec( generating_vertices := [ ],
                generating_rays := [ ],
                matrix:= arg[ 1 ],
                number_type := "rational",
                rep_type := "V-rep" );
        
        ObjectifyWithAttributes( poly, TheTypeCddPolyhedron );
        
        return poly;
      
      fi;
      
      if not IsMatrix( arg[ 1 ] ) then
        
        Error( "Wronge input: The first argument should be a Gap matrix!" );
       
      fi;
      
      if not ForAll( arg[ 1 ], row -> row[ 1 ] in [ 0, 1 ] ) then
        
        Error( "Wronge input: Please see the documentation!" );
        
      fi;
      
      if not ForAll( arg[ 2 ], i -> i in [ 1 .. NrRows( arg[ 1 ] ) ] ) then
        
        Error( "Wronge input for linearity" );
      
      fi;
      
      dim := Length( arg[ 1 ][ 1 ] ) - 1;
      
      matrix := Filtered( arg[ 1 ], row -> not IsZero( row ) );
      
      if IsEmpty( matrix ) then
        
        Error( "Wronge input: Please make sure the input has sensable direction vectors!" );
      
      fi;
      
      temp := GiveGeneratingVerticesAndGeneratingRays( arg[ 1 ], arg[ 2 ] );
   
      poly := rec( generating_vertices := temp[ 1 ],
                generating_rays := temp[ 2 ],
                matrix :=arg[ 1 ],
                linearity := arg[ 2 ],
                number_type := "rational",
                rep_type := "V-rep" );
                
      ObjectifyWithAttributes( poly, TheTypeCddPolyhedron );
   
      return poly;
    
    fi;
   
end );           
   

InstallMethod( Cdd_LinearProgram,
               "creating linear program",
               [ IsCddPolyhedron, IsString, IsList ],
  function( poly, obj, rowvec )
    local r;
    
    if obj <> "max" and obj <> "min" then
      
      Error( "The second argument should be either 'max' or 'min' " );
    
    fi;
    
    r := rec( polyhedron:=  poly , objective := obj, rowvector := rowvec );
    
    ObjectifyWithAttributes( r, TheTypeCddLinearProgram );
    
    return r;
   
end );


##################################
##
##  Attributes and Properties
##
##################################

# The dimension, dim(P ), of a polyhedron P is the maximum number of affinely
# independent points in P minus 1.
#
InstallMethod( Cdd_Dimension,
              " returns the dimension of the polyhedron",
            [ IsCddPolyhedron ],
  function( poly )
    
    if Cdd_IsEmpty( poly ) then 
      
      return -1;
    
    else
      
      return CddInterface_DimAndInteriorPoint( CDD_POLYHEDRON_TO_LIST( poly ) )[ 1 ];
    
    fi;
    
end );

InstallMethod( Cdd_Inequalities,
              " return the list of inequalities of a polyhedron",
              [ IsCddPolyhedron ],
  function( poly )
    
    return Set( Cdd_Canonicalize( Cdd_H_Rep( poly ) )!.inequalities );
  
end );

InstallMethod( Cdd_Equalities,
              " return the list of equalities of a poylhedra",
              [ IsCddPolyhedron ],
  function( poly )
    
    return Set(Cdd_Canonicalize( Cdd_H_Rep( poly ) )!.equalities );
  
end );


InstallMethod( Cdd_GeneratingVertices,
              " return the list of generating vertices",
              [ IsCddPolyhedron ],
  function( poly )
    
    return Set( Cdd_Canonicalize( Cdd_V_Rep( poly ) )!.generating_vertices );
  
end );

InstallMethod( Cdd_GeneratingRays,
              " return the list of generating vertices",
              [ IsCddPolyhedron ],
  function( poly )
    
    return Set( Cdd_Canonicalize( Cdd_V_Rep( poly ) )!.generating_rays );
  
end );

###
InstallMethod( Cdd_AmbientSpaceDimension,
              "finding the dimension of the ambient space",
              [ IsCddPolyhedron ],
  function( poly ) 
    
    return Length( Cdd_H_Rep( poly )!.matrix[1] )-1;
  
end );

####
###
InstallMethod( Cdd_IsEmpty,
               "finding if the polyhedron empty is or not",
               [ IsCddPolyhedron ],
  function( poly )
    
    return Length(  Cdd_V_Rep( poly )!.matrix ) = 0;
  
end );


InstallMethod( Cdd_IsCone, 
                "finding if the polyhedron is a cone or not",
                [ IsCddPolyhedron ],
  function( poly )
    
    return Length( Cdd_GeneratingVertices( poly ) ) = 0;
  
end );
 
 
InstallMethod( Cdd_IsPointed,
               "finding if the polyhedron is pointed or not",
               [ IsCddPolyhedron ],
  function( poly )
    
    return Length( Cdd_V_Rep( poly )!.linearity )= 0;
  
end );

##################################
##
##  Operations
##
##################################


InstallMethod( Cdd_Canonicalize,
               [ IsCddPolyhedron],
  function( poly )
    local temp, temp_poly, i, L1, L2, L, H;
    
    if  poly!.rep_type= "V-rep" and poly!.matrix = [] then 
      
      return poly;
    
    fi;
    
    return CallFuncList( LIST_TO_CDD_POLYHEDRON, CddInterface_Canonicalize( CDD_POLYHEDRON_TO_LIST( poly ) ) );
  
end );

InstallMethod( Cdd_V_Rep, 
               [ IsCddPolyhedron ],
  function( poly )
    local L, p, Q, L2;
    
    if poly!.rep_type = "V-rep" then 
      
      return Cdd_Canonicalize( poly );
    
    else 
      
      return CallFuncList( LIST_TO_CDD_POLYHEDRON, CddInterface_Compute_V_rep( CDD_POLYHEDRON_TO_LIST( poly ) ) );
      
    fi;
  
end );

InstallMethod( Cdd_H_Rep, 
               [ IsCddPolyhedron ],
  function( poly )
    local L, H, p, L2;
    
    if poly!.rep_type = "H-rep" then 
      
      return Cdd_Canonicalize( poly );
    
    else 
      
      if poly!.rep_type = "V-rep" and poly!.matrix = [] then
        
        return Cdd_PolyhedronByInequalities( [ [ 0, 1 ], [ -1, -1 ] ] );
      
      fi;
      
      return CallFuncList( LIST_TO_CDD_POLYHEDRON, CddInterface_Compute_H_rep( CDD_POLYHEDRON_TO_LIST( poly ) ) );
    
    fi;
  
end );


InstallMethod( Cdd_SolveLinearProgram,
               [IsCddLinearProgram],
               
  function( lp )
    local temp;
    
    temp := LinearProgramToList( lp );
    
    return CddInterface_LpSolution( temp );
  
end );

###
InstallMethod( Cdd_FacesWithFixedDimensionOp,
             [ IsCddPolyhedron, IsInt ],
  function( poly, d )
    local M, L;
    
    if poly!.rep_type = "V-rep" then
      
      Error( "The input should be in H-rep " );
    
    fi;
    
    M := CDD_POLYHEDRON_TO_LIST( poly );
    
    L := CddInterface_FacesWithDimensionAndInteriorPoints( M, d );
    
    L := CanonicalizeListOfFacesAndInteriorPoints( L );
    
    L := Filtered( L,  l -> l[ 1 ] = d );
    
    return List( L, l -> l[ 2 ] );
  
end );

###
InstallMethod( Cdd_Faces,
             [ IsCddPolyhedron],
  function( poly )
    local M, L;
    
    if poly!.rep_type = "V-rep" then
      
      Error( "The input should be in H-rep " );
    
    fi;
    
    M := CDD_POLYHEDRON_TO_LIST( poly );
    
    L := CddInterface_FacesWithDimensionAndInteriorPoints( M, 0 );
    
    L := CanonicalizeListOfFacesAndInteriorPoints( L );
    
    return List( L, l -> l{ [ 1, 2 ] } );
  
end );

###
InstallMethod( Cdd_Facets,
             [ IsCddPolyhedron ],
  function( poly )
    local d;
    
    d := Cdd_Dimension( poly );
      
    return Cdd_FacesWithFixedDimension( poly, d - 1 );
  
end );

InstallMethod( Cdd_Lines,
             [ IsCddPolyhedron ],
             
  function( poly )
    
    return Cdd_FacesWithFixedDimension( poly, 1 );

end );

###
InstallMethod( Cdd_Vertices,
             [ IsCddPolyhedron ],
             
  function( poly )
    
    return Cdd_FacesWithFixedDimension( poly, 0 );
  
end );

###
InstallMethod( Cdd_FacesWithInteriorPoints,
             [ IsCddPolyhedron ],
             
  function( poly )
    local M, L;
    
    if poly!.rep_type = "V-rep" then
      
      Error( "The input should be in H-rep " );
    
    fi;
    
    M := CDD_POLYHEDRON_TO_LIST( poly );
    
    L := CddInterface_FacesWithDimensionAndInteriorPoints( M, 0 );
    
    return CanonicalizeListOfFacesAndInteriorPoints( L );
  
end );

###
InstallMethod( Cdd_FacesWithFixedDimensionAndInteriorPointsOp,
             [ IsCddPolyhedron, IsInt ],
             
  function( poly, d )
    local M, L;
    
    if poly!.rep_type = "V-rep" then
      
      Error( "The input should be in H-rep " );
    
    fi;
    
    M := CDD_POLYHEDRON_TO_LIST( poly );
    
    L := CddInterface_FacesWithDimensionAndInteriorPoints( M, 0 );
    
    L := CanonicalizeListOfFacesAndInteriorPoints( L );
    
    L := Filtered( L, l -> l[ 1 ] = d );
    
    return List( L, l -> l{ [ 2, 3 ] } );
  
end );

####
InstallMethod( Cdd_ExtendLinearity, 
               [ IsCddPolyhedron, IsList],
               
  function( poly, lin )
    local temp, temp2, L, P;
    
    if poly!.rep_type = "V-rep" then 
      
      Error( "The polyhedron should be in H-rep");
    
    fi;
    
    temp := StructuralCopy( poly!.linearity );
    
    Append( temp, lin );
    
    temp := List( Set( temp ) );
    
    if temp = [ ] then 
      
      P := Cdd_PolyhedronByInequalities( poly!.matrix );
    
    else
      
      P := Cdd_PolyhedronByInequalities( poly!.matrix, temp );
    
    fi;
    
    return P;
  
end );


InstallMethod( Cdd_InteriorPoint, 
              [ IsCddPolyhedron ],
              
  function( poly )
    local dim_and_interior;
    
    dim_and_interior:= CddInterface_DimAndInteriorPoint( CDD_POLYHEDRON_TO_LIST( poly ) );
    
    if dim_and_interior[ 1 ] = -1 then 
      
      return fail ;
    
    else 
      
      Remove( dim_and_interior, 1 );
      
      return ShallowCopy( dim_and_interior ); 
    
    fi;
   
end );


InstallMethod( Cdd_FourierProjection,
              [ IsCddPolyhedron, IsInt ],
              
  function( poly, n )
    local f,temp_poly, temp, i,j,row_range, col_range, extra_row;
    
    if Cdd_IsEmpty( poly ) then
      
      return poly;
    
    fi;
    
    temp_poly := GetRidOfLinearity( Cdd_H_Rep( StructuralCopy( poly ) ) );
    
    col_range := Length( temp_poly!.matrix[1] );
    
    row_range := Length( temp_poly!.matrix );
    
    temp := temp_poly!.matrix;
    
    if n >= col_range then
      
      for j in [ 1 .. row_range ] do
        
        for i in [ col_range, n ] do
          
          Add( temp[ j ], 0 );
        
        od;
      
      od;
     
    else
      
      for i in [ 1 .. row_range ] do
        
        Add( temp[ i ], temp[ i, n + 1 ] );
        
        Remove( temp[ i ], n + 1 );
      
      od;
      
      temp_poly := Cdd_Canonicalize(
        CallFuncList(
          LIST_TO_CDD_POLYHEDRON,
          CddInterface_FourierElimination( CDD_POLYHEDRON_TO_LIST( Cdd_PolyhedronByInequalities( temp ) ) ) 
                    )
                                  );
      
      temp := temp_poly!.matrix;
      
      row_range := Length( temp );
      
      for i in [ 1 .. row_range ] do
        
        Add( temp[ i ], 0, n + 1 );
        
      od;
      
      f := function( t )
            if t <> n+1 then
              return 0;
            else
              return 1;
            fi;
          end;
      
      extra_row := List( [ 1 .. col_range ], f );
      
      Add( temp, extra_row );
      
      Add( temp_poly!.linearity, row_range + 1 );
      
    fi;
    
  return temp_poly;
  
end );

#################################
#
#  Operations on two polyhedrons
#
#################################

InstallMethod( \+,
               [ IsCddPolyhedron, IsCddPolyhedron ],
  function( poly1, poly2 )
    local col_range, g_vertices1, g_vertices2, g_rays1, g_rays2, new_generating_rays, new_generating_vertices, i,j, matrix, u ; 
    
    if Cdd_AmbientSpaceDimension( poly1) <> Cdd_AmbientSpaceDimension( poly1) then 
      
      Error( "The polyhedrons are not in the same space" );
    
    fi;
    
    col_range := Cdd_AmbientSpaceDimension( poly1 );
    
    g_vertices1 := ShallowCopy ( Cdd_GeneratingVertices( poly1 ) );
    
    if g_vertices1 = [ ] then
      
      g_vertices1 := [ List( [ 1 .. col_range ], i -> 0 ) ];
    
    fi;
    
    g_vertices2 := ShallowCopy( Cdd_GeneratingVertices( poly2 ) );
    
    if g_vertices2 = [ ] then
      
      g_vertices2 := [ List( [ 1 .. col_range ], i -> 0 ) ];
    
    fi;
    
    new_generating_vertices := [ ];
    
    for i in g_vertices1 do
      
      for j in g_vertices2 do
        
        Add( new_generating_vertices, i + j );
      
      od;
    
    od;
    
    matrix := [ ];
    
    for i in new_generating_vertices do 
      
      u := ShallowCopy( i );
      
      Add( u, 1, 1 );
      
      Add( matrix, u );
      
    od;
    
    g_rays1 := Cdd_GeneratingRays( poly1 );
    
    g_rays2 := Cdd_GeneratingRays( poly2 );
    
    new_generating_rays := Union( g_rays1 ,g_rays2 );
    
    for i in new_generating_rays do 
      
      u := ShallowCopy( i );
      
      Add( u, 0, 1 );
      
      Add( matrix, u );
    
    od;
    
    return Cdd_H_Rep( Cdd_PolyhedronByGenerators( matrix ) );
  
end );

##
InstallMethod( \=,
               [ IsCddPolyhedron, IsCddPolyhedron ],
  function( poly1, poly2 )
    local generating_vertices1, generating_vertices2, generating_rays1, generating_rays2;
    
    generating_vertices1 := Set(Cdd_GeneratingVertices( poly1 ) );
    
    generating_vertices2 := Set(Cdd_GeneratingVertices( poly2 ) );
    
    generating_rays1 := Set( Cdd_GeneratingRays( poly1 ) );
    
    generating_rays2 := Set( Cdd_GeneratingRays( poly2 ) );
    
    return generating_vertices1=generating_vertices2 and generating_rays1= generating_rays2;
  
end );

##
InstallMethod( Cdd_Intersection,
               [ IsCddPolyhedron, IsCddPolyhedron ],

  function( poly1, poly2 )
    local poly1_h, poly2_h, new_matrix, new_linearity, i, poly1_rowrange, poly2_rowrange;
    
    poly1_h := Cdd_H_Rep( poly1 );
    
    poly2_h := Cdd_H_Rep( poly2 );
    
    new_matrix := StructuralCopy( poly1_h!.matrix );
    
    new_linearity := StructuralCopy( poly1_h!.linearity );
    
    poly1_rowrange := Length( poly1_h!.matrix );
    
    poly2_rowrange := Length( poly2_h!.matrix );
    
    for i in [ 1 .. poly2_rowrange ] do
      
      Add( new_matrix, poly2_h!.matrix[ i ] );
      
      if i in poly2_h!.linearity then
        
        Add( new_linearity, i+poly1_rowrange );
             
      fi;
    
    od;
    
    if Length( new_linearity ) = 0 then
      
      return Cdd_Canonicalize( Cdd_PolyhedronByInequalities( new_matrix ) );
    
    else 
      
      return Cdd_Canonicalize( Cdd_PolyhedronByInequalities( new_matrix, new_linearity ) );
    
    fi;
  
end );
##
InstallMethod( Cdd_IsContained,
                [ IsCddPolyhedron, IsCddPolyhedron ],
               
  function( poly1, poly2 )
    local temp;
    
    temp := Cdd_Intersection( poly1, poly2 );
    
    return temp = poly1;
  
end );

##################################
##
## Display Methods
##
##################################

###
InstallMethod( ViewObj,
               [ IsCddPolyhedron ],
  function( poly )
    
    Print( "<Polyhedron given by its ", poly!.rep_type, "resentation>" );
  
end );

###
InstallMethod( ViewObj,
               [ IsCddLinearProgram ],
               
  function( poly )
    
    Print( "<Linear program>" );
  
end );

###
InstallMethod( Display,
               [ IsCddPolyhedron ],
  function( poly )
    
    if poly!.rep_type = "V-rep" and poly!.matrix = [] then 
      
      Print( "The empty polyhedron" );
    
    else 
      
      Print( poly!.rep_type, "resentation \n" );
      
      if Length( poly!.linearity) <> 0 then
        
        Print( "linearity ", Length( poly!.linearity ), ", ", poly!.linearity, "\n");
      
      fi;
      
      Print( "begin \n" );
      
      Print( "   ", Length( poly!.matrix ), " X ", Length( poly!.matrix[ 1 ] ), "  ", poly!.number_type, "\n" );
      
      PTM( poly!.matrix );
      
      Print( "end\n" );
      
    fi;
  
end );

###
InstallMethod( Display,
               [ IsCddLinearProgram ],
  function( poly )
    
    Print( "Linear program given by: \n" );
    
    Display( poly!.polyhedron );
    
    Print( poly!.objective, "  ", poly!.rowvector );
  
end );


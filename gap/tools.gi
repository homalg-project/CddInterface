InstallGlobalFunction( NumberOfDigitsOfTheNumber,
  function(a)     
    
    return Length( String( a ) );
    
end);

# this functions prints a matrix in good form
InstallMethod( PTM,
            [ IsMatrix ],
  function( matrix )
    local i,j,m,t,n;
    
    m := 1;
    
    n := 1;
     
    for i in [ 1 .. Length( matrix ) ] do
      
      if n < NumberOfDigitsOfTheNumber( matrix[ i ][ 1 ] ) then
        
        n:= NumberOfDigitsOfTheNumber( matrix[ i ][ 1 ] );
      
      fi;
    
    od;
    
    for i in [ 1 .. Length( matrix ) ] do
      
      for  j in [ 1 .. Length( matrix[ 1 ] ) ] do
        
        if m < NumberOfDigitsOfTheNumber( matrix[ i ][ j ] ) then
          
          m := NumberOfDigitsOfTheNumber( matrix[ i ][ j ] );
        
        fi;
      
      od;
    
    od;
    
    Print("   ");
    
    for i in [ 1 .. Length( matrix[ 1 ] ) * ( m + 2 ) - 2 ] do
      
      Print(" ");
    
    od;
    
    Print( "  ", "\n" );
    
    for i in [ 1 .. Length( matrix ) ] do
      
      Print( "   " );
      
      for j in [ 1 .. Length( matrix[ 1 ] ) ] do
        
        if j=1 then 
                           
          for t in [ 1 .. n - NumberOfDigitsOfTheNumber( matrix[ i ][ j ] ) ] do
            
            Print( " " );
          
          od;
        
        else 
          
          for t in [ 1 .. m + 2 - NumberOfDigitsOfTheNumber( matrix[ i ][ j ] ) ] do
            
            Print(" ");
          
          od;
        
        fi;
        
        Print( matrix[ i ][ j ] );
      
      od;
      
      Print(" ","\n");
    
    od;
    
end );

##
InstallMethod( IsCompatiblePolyhedronList,
               [ IsList ],
               
  function ( list )
    local i;
    
    if not ForAll( [1,4,5], i -> list[i] in NonnegativeIntegers) then
      Error( "The first five entries must be non-negative integers" );
    fi;
    
    if not( IsList( list[6]) and IsList( list[7] ) ) then
      
      Error( "The last two arguments should be lists" );
    
    fi;
    
    if not IsEmpty( list[ 7 ] ) then
      
      if NrRows( list[ 7 ] ) <> list[ 4 ] then
        
        Error( "The matrix has the wrong number of rows" );
      
      fi;
      
      if NrCols( list[ 7 ] ) <> list[ 5 ] then
        
        Error( "The matrix has the wrong number of columns" );
      
      fi;
    
    fi;
    
    for i in list[ 6 ] do
       
       if i > list[ 4 ] then
         
         Error( "The linearity is not compatible" );
       
       fi;
    
    od;
    
    return true;
    
end );

##
InstallMethod( LcmOfDenominatorRatInList,
               [ IsList ],
               
  function( list )
    
    return Lcm( List( list, DenominatorRat ) );
    
end );

##
InstallGlobalFunction( LIST_TO_CDD_POLYHEDRON,
  function( arg )
    local numtype, matrix, L, temp1, temp2, temp3, temp4, p, i;
    
    matrix := arg[ 5 ];
    
    if not IsEmpty( matrix ) and NrRows( matrix ) > 0 then
      
      matrix := CanonicalizeList( matrix, arg[ 1 ] );
    
    fi;
    
    if arg[ 1 ] = 2 then
      
      temp2 := GiveGeneratingVerticesAndGeneratingRays( matrix, [ ] )[ 1 ];
        
        if temp2 = [ List( [ 2 .. arg[ 3 ] ], i -> 0 ) ] and
            not NrRows( matrix ) = 1 then

          temp3 := StructuralCopy( matrix );
          
          temp4 := StructuralCopy( arg[ 4 ] );
          
          temp1 := [ 1 ];
          
          Append( temp1, temp2[ 1 ] );
          
          p := Position( temp3, temp1 );
          
          Remove( temp3, p );
          
          for i in [ p..Length( temp4 ) ] do
            temp4[ i ]:= temp4[ i ] - 1;
          od;
          
          if Length( arg[ 4 ] ) = 0 then
            
            return Cdd_PolyhedronByGenerators( temp3 );
          
          else 
            
            return Cdd_PolyhedronByGenerators( temp3 , temp4 );
          
          fi;
          
        fi;
        
        if Length( arg[ 4 ] ) = 0 then
          
          return Cdd_PolyhedronByGenerators( matrix );
        
        else
          
          return Cdd_PolyhedronByGenerators( matrix , arg[ 4 ] );
          
        fi;
    
    else 
      
      if arg[ 2 ] = 0 then
        
        L := ListWithIdenticalEntries( arg[ 3 ], 0 );
        L[ 1 ] := 1;
        return Cdd_PolyhedronByInequalities( [ L ] );
        
      fi;
      
      if Length( arg[ 4 ] ) = 0 then
        
        return Cdd_PolyhedronByInequalities( matrix );
      
      else
        
        return Cdd_PolyhedronByInequalities( matrix , arg[ 4 ] );
      
      fi;
    
    fi;
   
end );

##
InstallMethod( CDD_POLYHEDRON_TO_LIST,
        [ IsCddPolyhedron ],
  function( poly )
    local L, matrix, lin, temp;
    
    L := [  ];
    
    if (poly!.rep_type = "H-rep" ) then
      L[ 1 ] := 1;
    else
      L[ 1 ] := 2;
    fi;
    
    matrix := poly!.matrix;
    
    L[ 2 ] := NrRows( matrix );
    L[ 3 ] := NrCols( matrix );
    L[ 4 ] := poly!.linearity;
    L[ 5 ] := matrix;
    L[ 6 ] := 0;
    L[ 7 ] := [ ];
    
    return L;
    
end );

##
InstallMethod( CanonicalizeList,
               [ IsList, IsInt ],
               
  function( matrix, rep )
    local res, i;
    
    res:= [ ];
    
    if rep = 1 then
    
      for i in [ 1.. Length( matrix ) ] do
        
        if not IsZero( matrix[ i ] ) then
          
          res[ i ] := LcmOfDenominatorRatInList( matrix[ i ] )*
              matrix[ i ] / Iterated(
                  LcmOfDenominatorRatInList( matrix[ i ] )*matrix[ i ], Gcd
                                    );
           
        else 
          
          res[ i ] := matrix[ i ];
          
        fi;
      
      od;
      
      return res;
      
    fi;
    
    for i in [ 1.. Length( matrix ) ] do
      
      if matrix[ i ][ 1 ] = 0 then
        
        res[ i ]:= LcmOfDenominatorRatInList( matrix[ i ] )*
              matrix[ i ] / Iterated(
                  LcmOfDenominatorRatInList( matrix[ i ] )*matrix[ i ], Gcd
                                    );
      
      else 
        
        res[ i ] := matrix[ i ];
      
      fi;
    
    od;
    
    return res;
    
end );

InstallMethod( LinearProgramToList,
    [IsCddLinearProgram ],
  function( lp )
    local result;
    
    result:= ShallowCopy( CDD_POLYHEDRON_TO_LIST( Cdd_H_Rep( lp!.polyhedron ) ) );
    
    if lp!.objective = "max" then
      
      result[ 6 ] := 1;
    
    else
      
      result[ 6 ] := 2;
    
    fi;
    
    result[ 7 ] := lp!.rowvector;
    
    return result;
    
end );

###

InstallMethod( GiveGeneratingVerticesAndGeneratingRays,
               [ IsList, IsList ],
  function( matrix, linearity )
    local generating_vertices, generating_rays, current, temp, l, i;
    
    generating_vertices:= [  ];
    
    generating_rays:= [  ];
    
    temp := StructuralCopy( matrix );
    
    l := Length( temp );
    
    for i in [ 1..l ] do
      
      current := temp[ i ];
      
      if current[ 1 ] = 1 then
        
        Remove( current, 1 );
        
        if i in linearity then
          
          Add( generating_vertices, current );
          
          Add( generating_vertices, -current );
        
        else
          
          Add( generating_vertices, current );
        
        fi;
       
      else
      
        Remove( current, 1 ); 
        
        if not IsZero( current ) then
          
          if i in linearity then
            
            Add( generating_rays, current );
            
            Add( generating_rays, -current );
          
          else
            
            Add( generating_rays, current );
          
          fi;
        
        else 
         
         Add( generating_vertices, current );
         
        fi;
      
      fi;
    
    od;
    
    return [ generating_vertices, generating_rays ];
    
end );

####
InstallMethod( GiveInequalitiesAndEqualities,
               [ IsList, IsList ],
  function( matrix, linearity )
    local equalities, inequalities , current, temp, l, i;
    
    inequalities:= [];
    
    equalities:= [];
    
    l:= Length( matrix );
    
    for i in [ 1..l ] do
      
      current:= matrix[ i ];
      
      if i in linearity then
        
        Add( equalities, current );
      
      else
        
        Add( inequalities, current );
       
      fi;
    
    od;
    
  return [ inequalities, equalities ];

end );

InstallMethod( GetRidOfLinearity,
               [ IsCddPolyhedron ],
function( poly )
  local i, temp;
  
  if poly!.rep_type = "V-rep" then
    
    Error( "This function is written for H-rep polyhedra" );
  
  fi;
  
  temp:= StructuralCopy( poly!.matrix );
  
  for i in poly!.linearity do
    
    Add( temp, -temp[ i ] );
  
  od;
  
  return Cdd_PolyhedronByInequalities( temp );
  
end );

##
InstallGlobalFunction( CanonicalizeListOfFacesAndInteriorPoints,
  function( L )
    local new_L;
    
    if IsInt( L ) then
      
      return [];
    
    elif IsList( L ) and Length( L ) = 3 and IsInt( L[ 1 ] ) then
      
      new_L := List( L, ShallowCopy );
      
      return [ new_L ];
    
    else
      
      return Concatenation( List( L, CanonicalizeListOfFacesAndInteriorPoints ) );
    
    fi;

end );


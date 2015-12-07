InstallGlobalFunction( NumberOfDigitsOfTheNumber,
     function(a)
return Length( String( a ) );
end);

# this functions prints a matrix in good form
InstallMethod( PTM,
               [ IsMatrix ],
               
  function( matrix )
    local i,j,m,t,n;

     m:=1;n:=1;
     
    for i in [1..Length(matrix)] do
    
        if n<NumberOfDigitsOfTheNumber( matrix[i][1] ) then n:= NumberOfDigitsOfTheNumber( matrix[i][1] );fi;
       
    od;
     
     
    for  i in [1..Length(matrix)] do
    
       for  j in [1..Length(matrix[1])] do
    
           if m<NumberOfDigitsOfTheNumber(matrix[i][j]) then m:=NumberOfDigitsOfTheNumber(matrix[i][j]);fi;
      
       od;
      
    od;

    Print("   ");

    for i in [1..Length(matrix[1])*(m+2)-2] do

         Print(" ");
         
    od;
    
    Print("  ","\n");
 
    for i in [1..Length(matrix)] do
        
        Print("   ");
      
        for j in [1..Length(matrix[1])] do
             
             
              
                  if j=1 then 
                           
                           for t in [1..n-NumberOfDigitsOfTheNumber(matrix[i][j])] do
              
                                Print(" ");
                    
                           od;
                  else 
                           for t in [1..m+2-NumberOfDigitsOfTheNumber(matrix[i][j])] do
              
                           Print(" ");
                    
                           od;
                  fi;
         
                  Print(matrix[i][j]); 
             
         od;
       
        Print(" ","\n");
        
     od;

  end );
# this function returns if a list is compatible to define a polyhedra
# [ 2 , 2        , 1            , 3      , 3     , [ 1, 3 ] , [-2/5, 1/7, 1/11, 0, 1, 1, 0, 2, 2] ]
# [rep,numbertype,existlinearity, rowsize,closize, linearity, matrix                              ]

InstallMethod( IsCompatiblePolyhedraList,
               [ IsList ],
function ( list )
local i;

if not( list[1]>=0 and list[2]>=0 and list[3]>=0 and list[4]>=0 and list[5]>=0 ) then 
return Error( "The first five entries should be all positive" );fi;

if not( IsInt( list[1] ) and IsInt( list[2] ) and IsInt( list[3] ) and  IsInt( list[4] ) and IsInt( list[5] ) ) then

        return Error( "The first  five arguments should be integrs" );
        
fi;

if not( IsList( list[6]) and IsList( list[7] ) ) then return Error( "The last two arguments should be lists" );fi;

if not ( Length( list[ 7 ]  )=2*list[ 4 ]*list[ 5 ] ) then return Error( "The matrix is not compatible" );fi;

for i in list[6] do

   if i> list[4] then return Error( "The linearity is not compatible" );fi;

od;

return true;

end );

# this function takes [-2/3, 5/7, 5, 0] and returns [-2,3,5,7,5,1,0,1].

InstallMethod( ConvertRatListToIntList, 
                     [IsList],
function( list )
   local i, res;

    res:= [];
    
    for i in [1..Length( list ) ] do
  
       Add( res, NumeratorRat(   list[i] ) );
     
       Add( res, DenominatorRat( list[i] ) );
     
    od;

   return res;

end );


# this function takes [-2,3,5,7,5,1,0,1] and returns [-2/3, 5/7, 5, 0]. 

InstallMethod( ConvertIntListToRatList,
                      [ IsList ],
function( list )
   
return List( [1..Length( list )/2 ], i-> list[2*i-1]/list[2*i] );

end );

# this function takes [ [ 219,3,4,21 ], 2 ] and returns [ [219, 3 ], [4,21 ] ].
InstallMethod( ConvertListToListOfVectors,
                      [IsList, IsInt ],
                      
 function( list, size )
 
 if Length( list ) mod size <> 0 then return Error( "Not compatible" );fi;
 
 return List([1..Length(list)/size], i-> List([1..size], j-> list[size*(i-1)+j]) );
 
 end );

# this function takes [ [219, 3 ], [4,21 ] ]  and returns [ 219,3,4,21 ].

InstallMethod( ConvertListOfVectorsToList,
                      [ IsMatrix ],
function( list )
   
   local L,n, colsize, rowsize;
   
   L:= [];
   
   rowsize:= Length( list);
   
   colsize:= Length( list[1]);
   
   for n in [1.. rowsize*colsize ] do
   
      if RemInt(n,colsize)=0 then 
      
           Add( L, list[ QuoInt( n, colsize )][colsize              ] );
      
      else 
      
           Add( L, list[QuoInt( n, colsize )+1][ RemInt( n, colsize ) ] );
   
      fi;

   od;   
return L;

end );

## this function gives back Lcm of integers in a list
InstallMethod( LcmOfDenominatorRatInList,
               [ IsList ],
               
function( list )

  local res, i, L;

  L:= List( [ 1..Length( list ) ], i-> DenominatorRat( list[i] ) );
  
  res:= 1;

  for i in L do

     res:= LcmInt( res, i );
    
  od;

  return res;

end );

## 
InstallMethod( ListToPoly, 
               [ IsList ],
function( list )

local numtype, matrix, temp;

if not IsCompatiblePolyhedraList( list ) then return Error( "The given list is not compatible" ); fi;

temp:= ConvertIntListToRatList( list[7] );

matrix:= ConvertListToListOfVectors( temp, list[5] );

matrix:= CanonicalizeList( matrix, list[1] );

 if list[1]=2 then 

       if list[3]=0 then return Cdd_PolyhedraByGenerators( matrix );
       
          else return Cdd_PolyhedraByGenerators( matrix , list[6] );
          
       fi;
 else 
 
      if list[3]=0 then return Cdd_PolyhedraByInequalities( matrix );
       
          else return Cdd_PolyhedraByInequalities( matrix , list[6] );
       
      fi;
      
 fi;

end );


InstallMethod( PolyToList,

               [ IsCddPolyhedra ],
               
function( poly )

local L, matrix, lin, temp;

L:= [];

if (poly!.rep_type= "H-rep" ) then 

     Add( L, 1 );
   
else 

    Add( L, 2 ) ;
    
fi;

# the functions in c should be changned so that this can be deleted
Add( L, 2 );


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

Add( L, ConvertRatListToIntList( ConvertListOfVectorsToList( matrix ) ) );

Append( L, [ 0, [] ] );

return L;

end );

InstallMethod( CanonicalizeList, 
               [ IsList, IsInt ],
               
function( matrix, rep )

 local res, i;
 
 if rep = 1 then 
 
       res:= List( [ 1.. Length( matrix ) ], i->LcmOfDenominatorRatInList( matrix[ i ] )*matrix[ i ] ) ;
       
       return res;
       
 fi;
 
 res:= List( [ 1.. Length( matrix ) ], i->0 );
 
 for i in [ 1.. Length( matrix ) ] do
    
      if matrix[i][1]=0 then 
           
            res[i]:= LcmOfDenominatorRatInList( matrix[i] )* matrix[i];
            
      else 
        
      res[i]:= matrix[i];
            
      fi;
        
  od;

    return res;
 
end );
 

InstallMethod( LinearProgramToList,
               [IsCddLinearProgram ],
               
function( lp )
 local result;

 result:= PolyToList( Cdd_H_Rep( lp!.polyhedra ) );
 
 if lp!.objective="max" then 

     result[8]:= 1;
     
 else 

     result[8]:= 2;
     
 fi;

result[9]:= ConvertRatListToIntList( lp!.rowvector );

return result;

end );




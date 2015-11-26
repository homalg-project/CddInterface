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
             
              Print(matrix[i][j]);
              
                  if j=1 then 
                           
                           for t in [1..n-NumberOfDigitsOfTheNumber(matrix[i][j])] do
              
                                Print(" ");
                    
                           od;
                  else 
                           for t in [1..m+2-NumberOfDigitsOfTheNumber(matrix[i][j])] do
              
                           Print(" ");
                    
                           od;
                  fi;
         
             if j=1 then Print("|  ");fi;   
             
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


 
 
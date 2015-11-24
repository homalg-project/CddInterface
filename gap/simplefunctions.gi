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



InstallGlobalFunction( NumberOfDigitsOfTheNumber,
     function(a)
return Length( String( a ) );
end);

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


 
end);
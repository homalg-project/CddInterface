
DeclareOperation("PTM",
                  [ IsMatrix ] );
                  
DeclareOperation( "IsCompatiblePolyhedraList", [IsList] );
DeclareOperation( "ConvertRatListToIntList", [IsList] );
DeclareOperation( "ConvertIntListToRatList", [IsList] );
DeclareOperation( "ConvertListToListOfVectors", [IsList, IsInt] );
DeclareOperation( "ConvertListOfVectorsToList", [IsMatrix] );
DeclareGlobalFunction( "NumberOfDigitsOfTheNumber" );
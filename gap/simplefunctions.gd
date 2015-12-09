
DeclareOperation("PTM", [ IsMatrix ] );
DeclareOperation( "IsCompatiblePolyhedraList", [IsList] );
DeclareOperation( "GiveGeneratingVerticesAndGeneratingRays", [ IsList, IsList ] );
DeclareOperation( "ConvertRatListToIntList", [IsList] );
DeclareOperation( "ConvertIntListToRatList", [IsList] );
DeclareOperation( "ConvertListToListOfVectors", [IsList, IsInt] );
DeclareOperation( "ConvertListOfVectorsToList", [IsMatrix] );
DeclareOperation( "LcmOfDenominatorRatInList", [IsList] );
DeclareOperation( "CanonicalizeList", [IsList, IsInt] );
DeclareOperation( "ListToPoly", [ IsList ] );
DeclareOperation( "PolyToList", [ IsCddPolyhedra ] );
DeclareOperation( "LinearProgramToList", [ IsCddLinearProgram ] );
DeclareGlobalFunction( "NumberOfDigitsOfTheNumber" );
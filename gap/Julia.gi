##
InstallGlobalFunction( cdd_PolyhedronByInequalities,
 function( arg )
    
    return CallFuncList( Cdd_PolyhedronByInequalities, ConvertJuliaToGAP( arg ) );
    
end );

##
InstallGlobalFunction( cdd_PolyhedronByGenerators,
 function( arg )
    
    return CallFuncList( Cdd_PolyhedronByGenerators, ConvertJuliaToGAP( arg ) );
    
end );

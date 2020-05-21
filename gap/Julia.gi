##
InstallGlobalFunction( cdd_prepare_gap_input,
 function( arg )
    
    arg := arg[1];
    
    return
      List( arg,
            function( a )
              if IsJuliaObject( a ) then
                  a := JuliaToGAP( IsList, a );
              fi;
              return List( a,
                           function( b )
                             if IsJuliaObject( b ) then
                                 b := JuliaToGAP( IsList, b );
                             fi;
                             if IsList( b ) and ForAll( b, IsJuliaObject ) then
                                 return List( b, c -> JuliaToGAP( IsList, c ) );
                             fi;
                             return b;
                         end );
                     end );
    
end );

##
InstallGlobalFunction( cdd_PolyhedronByInequalities,
 function( arg )
    
    return CallFuncList( Cdd_PolyhedronByInequalities, cdd_prepare_gap_input( arg ) );
    
end );

##
InstallGlobalFunction( cdd_PolyhedronByGenerators,
 function( arg )
    
    return CallFuncList( Cdd_PolyhedronByGenerators, cdd_prepare_gap_input( arg ) );
    
end );

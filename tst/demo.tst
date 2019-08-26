gap> inequalities := [ [ -12161335039290869319572858042364783623509104285436155, 10301051460877537453973547267843, 1 ], [ -50046646252225799669024107132291046291965254437457, 42391158275216203514294433201, -1 ] ];;
gap> vertices_and_rays := [ [ 1, 2^70-1, 2^75-2 ], [ 0, 1, 3^60 ], [ 0, 1, -3^65 ] ];;
gap> P := Cdd_PolyhedronByGenerators( vertices_and_rays );;
gap> Q := Cdd_PolyhedronByInequalities( inequalities );;
gap> P = Q;
true

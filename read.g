#
# CddInterface: Gap interface to Cdd package
#
# Reading the implementation part of the package.
#
ReadPackage( "CddInterface", "gap/polyhedra.gi");
ReadPackage( "CddInterface", "gap/tools.gi");

if IsPackageMarkedForLoading( "JuliaInterface", ">= 0.2" ) then
    ReadPackage( "CddInterface", "gap/Julia.gi");
fi;

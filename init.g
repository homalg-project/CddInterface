#
# CddInterface: Gap interface to Cdd package
#
# Reading the declaration part of the package.
#

if not LoadKernelExtension("CddInterface") then
    Error("failed to load the CddInterface package kernel extension");
fi;

ReadPackage( "CddInterface", "gap/polyhedra.gd");
ReadPackage( "CddInterface", "gap/tools.gd");

if IsPackageMarkedForLoading( "JuliaInterface", ">= 0.2" ) and
   IsPackageMarkedForLoading( "ToolsForHomalg", ">= 2020.05.12" ) then
    ReadPackage( "CddInterface", "gap/Julia.gd");
fi;

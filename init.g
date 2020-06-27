#
# CddInterface: Gap interface to Cdd package
#
# Reading the declaration part of the package.
#
_PATH_SO:=Filename(DirectoriesPackagePrograms("CddInterface"), "CddInterface.so");
if _PATH_SO <> fail then
    LoadDynamicModule(_PATH_SO);
fi;
Unbind(_PATH_SO);

ReadPackage( "CddInterface", "gap/polyhedra.gd");
ReadPackage( "CddInterface", "gap/tools.gd");

if IsPackageMarkedForLoading( "JuliaInterface", ">= 0.2" ) and
   IsPackageMarkedForLoading( "ToolsForHomalg", ">= 2020.05.12" ) then
    ReadPackage( "CddInterface", "gap/Julia.gd");
fi;

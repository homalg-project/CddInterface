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

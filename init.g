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

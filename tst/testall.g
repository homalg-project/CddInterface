#
# CddInterface: Gap interface to Cdd package
#
# This file runs package tests. It is also referenced in the package
# metadata in PackageInfo.g.
#
LoadPackage( "CddInterface" );
dirs := DirectoriesPackageLibrary( "CddInterface", "tst" );
TestDirectory( dirs, rec( exitGAP := true, testOptions:= rec(compareFunction:="uptowhitespace" )) );
FORCE_QUIT_GAP(1);

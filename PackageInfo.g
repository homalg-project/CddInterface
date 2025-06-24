#
# CddInterface: Gap interface to Cdd package
#
# This file contains package meta data. For additional information on
# the meaning and correct usage of these fields, please consult the
# manual of the "Example" package as well as the comments in its
# PackageInfo.g file.
#
SetPackageInfo( rec(

PackageName := "CddInterface",
Subtitle := "Gap interface to Cdd package",
Version := "2025.06.24",
Date := ~.Version{[ 1 .. 10 ]},
Date := Concatenation( ~.Date{[ 9, 10 ]}, "/", ~.Date{[ 6, 7 ]}, "/", ~.Date{[ 1 .. 4 ]} ),
License := "GPL-2.0-or-later",

Persons := [
  rec(
    IsAuthor := true,
    IsMaintainer := true,
    FirstNames := "Kamal",
    LastName := "Saleh",
    WWWHome := "https://github.com/kamalsaleh",
    Email := "kamal.saleh@uni-siegen.de",
    PostalAddress := Concatenation(
                       "Department Mathematik\n",
                       "Universität Siegen\n",
                       "Walter-Flex-Straße 3\n",
                       "57072 Siegen\n",
                       "Germany" ),
    Place := "Siegen",
    Institution := "Universität Siegen",
  ),
],

SourceRepository := rec(
    Type := "git",
    URL := Concatenation( "https://github.com/homalg-project/", ~.PackageName )
),

PackageWWWHome := Concatenation( "https://homalg-project.github.io/", ~.PackageName ),
README_URL     := Concatenation( ~.PackageWWWHome, "/README.md" ),
PackageInfoURL := Concatenation( ~.PackageWWWHome, "/PackageInfo.g" ),
IssueTrackerURL := Concatenation( ~.SourceRepository.URL, "/issues" ),
ArchiveURL      := Concatenation( ~.SourceRepository.URL,
                                 "/releases/download/v", ~.Version,
                                 "/", ~.PackageName, "-", ~.Version ),
ArchiveFormats  := ".tar.gz",

##  Status information. Currently the following cases are recognized:
##    "accepted"      for successfully refereed packages
##    "submitted"     for packages submitted for the refereeing
##    "deposited"     for packages for which the GAP developers agreed
##                    to distribute them with the core GAP system
##    "dev"           for development versions of packages
##    "other"         for all other packages
##
Status := "deposited",

AbstractHTML   :=
  "The <span class='pkgname'>CddInterface</span> package provides\
 a GAP interface to <a href='https://inf.ethz.ch/personal/fukudak/cdd_home'>cdd</a>,\
 enabling direct access to the most of the functionality of cddlib, such as\
 translating between H,V- representations of a polyhedron and solving linear programming problems.",

PackageDoc := rec(
  BookName  := "CddInterface",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Gap interface to Cdd package",
),

Dependencies := rec(
  GAP := ">= 4.12",
  NeededOtherPackages := [ [ "GAPDoc", ">= 1.5" ] ],
  SuggestedOtherPackages := [ ],
  ExternalConditions := [ ],
),

AvailabilityTest :=
  function()
    if not IsKernelExtensionAvailable("CddInterface") then
      LogPackageLoadingMessage(PACKAGE_WARNING, [
        "The library `libcdd' is not yet installed on the system,",
        " or it is not correctly compiled!,",
        "Please, see the installation instructions in README.md."
      ]);
      return fail;
    fi;

    return true;
end,

TestFile := "tst/testall.g",

Keywords := [ "cddlib", "Polyhedra", "Convex Geometry", "NConvex" ],

));



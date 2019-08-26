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
Version := "2019.08.20",
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
    PostalAddress := "Walterfelx 3 ",
    Place := "Siegen",
    Institution := "Mathematik Fakultät",
  ),
],

PackageWWWHome := "https://kamalsaleh.github.io/CddInterface",

SourceRepository := rec(
    Type := "git",
    URL := "https://github.com/homalg-project/CddInterface" ),

IssueTrackerURL := Concatenation( ~.SourceRepository.URL, "/issues" ),
ArchiveURL     := Concatenation( ~.SourceRepository.URL, "/archive/", ~.Version ),
README_URL     := Concatenation( ~.SourceRepository.URL, "/releases/latest/download/README.md" ),
PackageInfoURL := Concatenation( ~.SourceRepository.URL, "/releases/latest/download/PackageInfo.g" ),

ArchiveFormats := ".tar.gz",

##  Status information. Currently the following cases are recognized:
##    "accepted"      for successfully refereed packages
##    "submitted"     for packages submitted for the refereeing
##    "deposited"     for packages for which the GAP developers agreed
##                    to distribute them with the core GAP system
##    "dev"           for development versions of packages
##    "other"         for all other packages
##
Status := "dev",

AbstractHTML   :=  "",

PackageDoc := rec(
  BookName  := "CddInterface",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Gap interface to Cdd package",
),

Dependencies := rec(
  GAP := ">= 4.6",
  NeededOtherPackages := [ [ "GAPDoc", ">= 1.5" ] ],
  SuggestedOtherPackages := [ ],
  ExternalConditions := [ ],
),

AvailabilityTest := function()
        return true;
    end,

TestFile := "tst/testall.g",

Keywords := [ "cddlib", "Polyhedra", "Convex Geometry", "NConvex" ],

));



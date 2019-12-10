#!/bin/bash

commit=$1

cp -f ../PackageInfo.g ../README* .
cp -f ../doc/*.{css,html,js,txt} doc/
gap update.g
git add PackageInfo.g README* doc/ _data/package.yml
git commit -m "$commit"

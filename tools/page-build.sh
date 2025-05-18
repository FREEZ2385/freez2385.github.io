#!/bin/bash:

rm -rf _site/
git checkout master
git add --all
git commit -m "[Post]`date`"
git push origin master
git subtree push --prefix=_site/ origin gh-pages
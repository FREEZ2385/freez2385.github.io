#!/bin/bash:

git checkout master
rm -rf _site/
bundle exec jekyll build
git add --all
git commit -m "[Post]`date`"
git push origin master
git subtree push --prefix=_site/ origin gh-pages
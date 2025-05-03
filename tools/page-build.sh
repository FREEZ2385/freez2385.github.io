rm -rf _site/
git checkout master
docker build -t freezblog:0.1 ./
docker run -v $(pwd)/_site:/mydir/_site freezblog:0.1
git add --all
git commit -m "[Post]`date`"
git push origin master
git subtree push --prefix=_site/ origin gh-pages
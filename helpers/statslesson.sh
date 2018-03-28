#!/bin/bash

# Script to combine the new version of locale with what was there before.
# Either by creating a new repository or updating a previous one

git checkout -b website
mkdir gh-pages
for lang in $( ls locale );  do
    echo "<h1>${lang}</h1>" >> gh-pages/index.html
    for lesson in $( ls locale/${lang} ); do
        echo "<h2>${lesson}</h2>" >> gh-pages/index.html
        msgfmt --statistics --check po/${lesson}.${lang}.po &>> gh-pages/index.html
    done
done

git add gh-pages/*
git commit -m  "update from $(date)"
git subtree split --prefix gh-pages -b gh-pages
git push -f origin gh-pages
git checkout master
git branch -D website


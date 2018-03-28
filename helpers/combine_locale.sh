#!/bin/bash

# Script to combine the new version of locale with what was there before.
# Either by creating a new repository or updating a previous one

mkdir ../output
for lang in $( ls locale );  do
    for lesson in $( ls locale/${lang} ); do
        echo $lesson
        # Can we checkout the lesson?
        # git clone gh:swcarpentry-i18n/${lesson}-${lang}.git ../output
        sha=$(git submodule status | grep ${lesson} | awk '{print $1}')
        git init ../output/${lesson}
        cd ../output/${lesson}
        git remote add origin https://github.com/swcarpentry/${lesson}.git
        git fetch origin ${sha}
        git reset --hard FETCH_HEAD
        git checkout -b gh-pages
        cd -
        cp -r locale/${lang}/${lesson}/* ../output/${lesson}
        cd -
        git commit -a -m "Translation reviewed"
        git remote add origin-${lang} git@github.com:swcarpentry-i18n/${lesson}-${lang}.git
        # TODO: Create repository on organisation
        git push origin-${lang}
        # move to output/lesson and commit changes
        # else!
        # create repo and push
    done
done


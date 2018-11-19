# Quickstart Guide

This is a very quick run-down of the [README](README.md) file.

## Before you start

* If in doubt, don't delete any files in this repository
* If you wish to contribute, please fork this repo and submit changes via Pull Request
* Please contact us by raising an Issue if you have any question(s)

## Setting up Git and contributing

1. Install Git for your OS
2. Fork this repo to your GitHub account via the Fork button on the top right corner
3. Clone the forked repo to your computer:
```
git clone git@github.com:<github_username>/i18n.git
```
4. Add remote so you can pull changes from original repo:
```
git remote add ja git@github.com:swcarpentry-ja/i18n.git
```
5. Create new branch for your edit (separate editing branch will make things easier for Pull Request):
```
git checkout -b <username or other descriptive word>-edit

# Examples:
git checkout -b rikutakei-edit
git checkout -b git-edit2
git checkout -b readme-edit
```
6. Make changes to your local repo - make sure to commit often:
```
git add -u
git commit -m "<replace this commit message with something sensible>"
```
7. When you're ready to submit changes, first pull all the changes from the `swcarpentry-ja` repo using the `--rebase` option.
The `--rebase` option is used to make sure your edit is *in addition* to the changes made in the `swcarpentry-ja` repo, as well as to prevent unnecessary merge commits.
```
git pull --rebase ja ja
```
8. Now push your editing branch to your remote repo (note that your editing branch will not be on the remote when you made it, so you need to push first):
```
# Pushing for the first time:
git push -u origin <branch name>

# Updating for the subsequent changes:
git pull
git push
```
9. In GitHub, submit a Pull Request with your editing branch to the `swcarpentry-ja` repo.
10. When additional changes are requested, repeat steps 6 and 8 in your editing branch - Pull Request will be updated automatically:
```
git add -u
git commit -m "<replace this commit message with something sensible>"
git pull
git push
```

## Guide for Translators

### Guideline for translation

Please refer to the [Guideline for Translators](TranslatorGuidelines.md) and make sure your translation style is consistent with the guideline.

Please use the [Glossary](https://github.com/swcarpentry-ja/i18n/wiki/Glossary-for-technical-terms) when translating technical terms. Standard translations for technical terms should be added here as they are encountered.

### Common files between lessons

Please note that there are files shared between lesson repositories:

```
CODE_OF_CONDUCT.md
CONTRIBUTING.md
LICENSE.md
README.md
```

While these files appear at the beginning of the PO files (since files are sorted alphabetically), they are not a priority to translate.
Please skip to the beginning of the lesson, following the README.


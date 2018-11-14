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
5. Make changes to your local repo - make sure to commit often:
```
git add *
git commit -m "<replace this commit message with something sensible>"
```
6. When you're ready to submit changes, pull all the changes from the `swcarpentry-ja` repo and push to **your** remote:
```
git pull ja ja
git pull # This is to pull changes from your remote
git push # This is to push changes to your remote
```
7. In GitHub, submit a Pull Request to the `swcarpentry-ja` repo

## Guide for Translators

### Guideline for translation

Please refer to the [Guideline for Translators](TranslatorGuidelines.md) and make sure your translation style is consistent with the guideline.

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


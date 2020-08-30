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
git remote add upstream git@github.com:swcarpentry-ja/i18n.git
```
5. Make changes to your local repo - make sure to commit often:
```
git add -u
git commit -m "<replace this commit message with something sensible>"
```
6. When you're ready to submit changes, first pull all the changes from the `swcarpentry-ja` repo:
```
git pull upstream ja
```
7. Fix any conflicts that arise when pulling and merging changes from the `swcarpentry-ja` repo.
8. Now push your changes to your remote repo :
```
git push
```
9. In GitHub, submit a Pull Request with your changes to the `swcarpentry-ja` repo.
10. When additional changes are requested, repeat steps 5 and 8 in your repo - Pull Request will be updated automatically:
```
git add -u
git commit -m "<replace this commit message with something sensible>"
git pull
git push
```

## Tips and recommendations for a better workflow (intermediate Git user)

These are some tips and recommendations to make your workflow more smooth and easier for you to work on multiple edits.
If you intend to follow these steps, here are the sequence of steps to follow (in order):

* Steps 1-4 as above
* Step 1 as below
* Step 5 as above
* Step 2 as below, instead of step 6 as above
* Step 7 as above
* Step 3 as below, instead of step 8 as above
* Step 4 as below, instead of step 9 as above
* Step 10 as above

### Steps

1. When you are starting a new edit, create a new branch for your edit (separate editing branch will make things easier for Pull Request as well).
Creating a branch will allow you to edit files without messing up changes that are being made on other branches.
```
git checkout -b <username or other descriptive word>-edit

# Examples:
git checkout -b rikutakei-edit
git checkout -b git-edit2
git checkout -b readme-edit
```
2. Use the `--rebase` option when you are pulling from the `swcarpentry-ja` repo.
The `--rebase` option is used to make sure your edit is *in addition* to the changes made in the `swcarpentry-ja` repo, and also allows you to prevent unnecessary merge commits, if possible.
Take a look at this [article](http://kernowsoul.com/blog/2012/06/20/4-ways-to-avoid-merge-commits-in-git/) and this [article](https://codeinthehole.com/tips/pull-requests-and-other-good-practices-for-teams-using-github/) for more explanation.
```
git pull --rebase upstream ja
```
3. When you are pushing your editing branch for the first time, make sure to set the upstream of the branch to the same name (note that your editing branch will not be on the remote repo when you made it, so you need to push to your remote **and** create that branch):
```
# Pushing the editing branch for the first time
git push -u origin <your branch name>

# Updating for the subsequent changes:
git pull
git push
```
4. When you are making a Pull Request, use your editing branch for it.
This allows you to edit other files (on a different branch) without adding commits/changes that are not related to your Pull Request.
For example, if you want to work on different files, either create a new branch or move to a different branch:
```
# List all branches:
git branch

# Create another branch to edit a different file:
git checkout -b <new branch name>

# Go to a diferent branch to work on different edits:
git checkout <branch name>
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


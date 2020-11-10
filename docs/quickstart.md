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
```bash
git clone git@github.com:<github_username>/i18n.git
```
4. Add remote so you can pull changes from original repo:
```bash
git remote add upstream git@github.com:swcarpentry-ja/i18n.git
```
5. Make changes to your local repo - make sure to commit often:
```bash
git add -u
git commit -m "<replace this commit message with something sensible>"
```
6. When you're ready to submit changes, first pull all the changes from the `swcarpentry-ja` repo:
```bash
git pull upstream ja
```
7. Fix any conflicts that arise when pulling and merging changes from the `swcarpentry-ja` repo.
8. Now push your changes to your remote repo :
```bash
git push
```
9. In GitHub, submit a Pull Request with your changes to the `swcarpentry-ja` repo.
10. When additional changes are requested, repeat steps 5 and 8 in your repo - Pull Request will be updated automatically:
```bash
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
```bash
git checkout -b <username or other descriptive word>-edit

# Examples:
git checkout -b rikutakei-edit
git checkout -b git-edit2
git checkout -b readme-edit
```
2. Use the `--rebase` option when you are pulling from the `swcarpentry-ja` repo.
The `--rebase` option is used to make sure your edit is *in addition* to the changes made in the `swcarpentry-ja` repo, and also allows you to prevent unnecessary merge commits, if possible.
Take a look at this [article](http://kernowsoul.com/blog/2012/06/20/4-ways-to-avoid-merge-commits-in-git/) and this [article](https://codeinthehole.com/tips/pull-requests-and-other-good-practices-for-teams-using-github/) for more explanation.
```bash
git pull --rebase upstream ja
```
3. When you are pushing your editing branch for the first time, make sure to set the upstream of the branch to the same name (note that your editing branch will not be on the remote repo when you made it, so you need to push to your remote **and** create that branch):
```bash
# Pushing the editing branch for the first time
git push -u origin <your branch name>

# Updating for the subsequent changes:
git pull
git push
```
4. When you are making a Pull Request, use your editing branch for it.
This allows you to edit other files (on a different branch) without adding commits/changes that are not related to your Pull Request.
For example, if you want to work on different files, either create a new branch or move to a different branch:
```bash
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

```bash
CODE_OF_CONDUCT.md
CONTRIBUTING.md
LICENSE.md
README.md
```

While these files appear at the beginning of the PO files (since files are sorted alphabetically), they are not a priority to translate.
Please skip to the beginning of the lesson, following the README.

We will translate these for the R lesson and migrate these to other lessons. Please contact the core team (via Slack or GitHub Issues) if you wish to assist with this. 

### Headings in lesson preamble

Some terms in the headings are automatically translated by the webpage [theme](https://github.com/carpentries-i18n/carp-theme). Please do not translate these variable names as they are required for correctly formatting the lesson. Please do not translate the following terms:

> \"title:
>
> \"teaching:
>
> \"exercises:
>
> \"questions:
>
> \"objectives:
>
> \"keypoints

If you wish to change the translations for the headings, please submit changes to the [japanese assets](https://github.com/swcarpentry-ja/carp-theme/blob/master/assets/i18n/ja.md) for the theme.

Please translate the text next to these headers. For example:

```bash
# Front Matter
#: r-novice-gapminder/_episodes/01-rstudio-intro.md:1
msgid ""
"---\n"
"# Please do not edit this file directly; it is auto generated.\n"
"# Instead, please edit 01-rstudio-intro.md in _episodes_rmd/\n"
"title: \"Introduction to R and RStudio\"\n"
"teaching: 45\n"
"exercises: 10\n"
"questions:\n"
"- \"How to find your way around RStudio?\"\n"
"- \"How to interact with R?\"\n"
"- \"How to manage your environment?\"\n"
"- \"How to install packages?\"\n"
"objectives:\n"
"- \"Describe the purpose and use of each pane in the RStudio IDE\"\n"
"- \"Locate buttons and options in the RStudio IDE\"\n"
"- \"Define a variable\"\n"
"- \"Assign data to a variable\"\n"
"- \"Manage a workspace in an interactive R session\"\n"
"- \"Use mathematical and comparison operators\"\n"
"- \"Call functions\"\n"
"- \"Manage packages\"\n"
"keypoints:\n"
"- \"Use RStudio to write and run R programs.\"\n"
"- \"R has the usual arithmetic operators and mathematical functions.\"\n"
"- \"Use `<-` to assign values to variables.\"\n"
"- \"Use `ls()` to list the variables in a program.\"\n"
"- \"Use `rm()` to delete objects in a program.\"\n"
"- \"Use `install.packages()` to install packages (libraries).\"\n"
"source: Rmd\n"
"---"
msgstr ""
"---\n"
"# Please do not edit this file directly; it is auto generated.\n"
"# Instead, please edit 01-rstudio-intro.md in _episodes_rmd/\n"
"title: \"R と RStudioの入門\"\n"
"teaching: 45\n"
"exercises: 10\n"
"questions:\n"
"- \"RStudio はどのように操作したらよいですか?\"\n"
"- \"R とはどのようにやりとりしたらよいですか?\"\n"
"- \"環境の管理はどうしたらよいですか?\"\n"
"- \"パッケージのインストールはどうしたらよいですか?\"\n"
"objectives:\n"
"- \"RStudio IDE の各ウィンドウの使用目的と使い方が説明出来るようになりましょう\"\n"
"- \"RStudio IDE のボタンやオプションの位置を理解しましょう\"\n"
"- \"変数が定義出来るようになりましょう\"\n"
"- \"変数に値の設定が出来るようになりましょう\"\n"
"- \"R セッションのワークスペース管理が出来るようになりましょう\"\n"
"- \"算術演算子や比較演算子が使えるようになりましょう。\"\n"
"- \"関数が呼び出せるようになりましょう。\"\n"
"- \"パッケージの管理が出来るようになりましょう。\"\n"
"keypoints:\n"
"- \"RStudio で R プロラムの作成と実行を行う。\"\n"
"- \"R は算術演算子や数学関数が使える。\"\n"
"- \"`<-` を使って変数に値を設定する。\"\n"
"- \"`ls()` を使ってプログラム内の変数をリストする。\"\n"
"- \"`rm()` を使ってプログラム内のオブジェクトを消去する。\"\n"
"- \"`install.packages()` を使ってパッケージ(ライブラリ)のインストールを行う。\"\n"
"source: Rmd\n"
"---"

```


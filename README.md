# Internationalisation of carpentry lessons

## Purpose of this repository

The repository is intended to host the files and tools need to facilitate translations of the Software Carpentry lessons 
from English into other languages. This repository is intended to merge with the Multi-lingual versions of the lessons
in English and Spanish. We plan for these to be compatible to be hosted along with other languages on the main
Software Carpentry website and to maintain updated copies of the Japanese lessons with new releases of the 
English lessons. Therefore:

* Please do not remove the files for other languages (currently Spanish) from the repository. 
These need to be retained to merge the lessons with the main i18n repository and existing lessons.

* Please do not delete the archived files for translation of previous versions of the English lessons.
  These will be needed to merge translations with updated English files for future releases of the 
  main Software Carpentry lessons. This means that we will only need to translate updated sections and
  translations to sections that have not been updated will be migrated to new releases.

* Please only submit changes specific to Japanese language translations to this repository as Pull Requests.
 Please submit issues specific to the English lessons to the main lesson repository. If you have a suggestion
 for a change to the content or examples, we cannot change these in the Japanese lesson and the main lessons
 need to be updated in English. We ask that these changes be raised as an Issue in Japanese rather than a 
 Pull Request if you prefer not to submit an Issue or Pull Request in English. 

* Please contact us if you wish to join the core translation team. Any contributions to the Japanese lessons
  are welcome as Pull Requests but please make sure you understand the English version of the lesson if
  you are able to.

* Please commit and push changes to a fork of the reposiory on your personal GitHub account and 
  submit a Pull Request. In this way, suggested changes can be reviewed and discussed. Please raise
  any matters that you are unsure of or want help with when submitting a Pull Request.

* Please track changes to all files needed to generate the translated lessons. This way we can combine
  all changes from contributors and track our progress. All contributions will be attributed to each
  contributor.

* Please contact us via an Issue if anything is unclear in the guides to set up or use the 
  translation tools in this repository so we can update the README and guides.
 
## How does this work?

### Importing a lesson for the first time

If you wish to start a translation of a lesson that has not been translated in your language before,
please follow these instructions. See the instructions below for if your lesson has an exisiting
translation and you wish to submit changes or an update.

1. Create a "Fork" for this repository on your personal GitHub account. (Click "Fork" in the top right
  corner of the `https://github.com/swcarpentry-ja/i18n` webpage)

2. Clone this repository from your personal account (e.g., GitHubUser). This is your local copy to manage your version of 
 the translation files.

```
cd directory
git clone git@github.com:GitHubUser/i18n.git
cd i18n
```

If you already have a fork of translation repository, please pull changes for the current
   version from the organisation repository:

```
git checkout ja
git remote add swc-ja git@github.com:swcarpentry-ja/i18n.git
git pull swc-ja ja
```


3. Add a submodule for the lessons that you want to translate

```
git submodule add https://github.com/swcarpentry/git-novice.git
```

4. Run `po4gitbook/update.sh` - That creates/updates the `po` directory with the `.pot` files to use in translations.

5. Create a `po` file and start translating!
 - copy `<file>.pot` to `<file>.<lang>.po`. e.g.,
 ```bash
 cd po
 cp shell-novice.pot shell-novice.es.po
 ```
 - Edit the file with your favourite po editor ([PoEdit](http://www.poedit.net),
 [GTranslator](https://wiki.gnome.org/Apps/Gtranslator), [Lokalize](https://userbase.kde.org/Lokalize), ...)
   Note:
    - "`Language`" field is needed to add to the header (at least with gtranslator), the rest is put by the tool.
    - "`Language-Team:`" needs the first letter in upper case (e.g., `Es` or `Ja`)
 - Create `po/LINGUAS`
 - run `po4gitbook/compile.sh` - This creates a `locale/<lang>/<lesson>` tree directory

This generates a translated version of the lessons. Please do not create a git repository within
  this repository. You can copy these files to another repository as described in the 
  "Guide for Translators" and submit changes to the PO files via Pull Request to GitHub.

Please note that there are files shared between lesson repositories:
```
CODE_OF_CONDUCT.md
CONTRIBUTING.md
LICENSE.md
README.md
```
These will be hosted on the translated Git repository but will not be included in the 
  webpages once they are generated. Apart from the `README`, these are the same files
  between each lesson. Please check that these files have not been already translated 
  for another lesson. If so you can copy these to ensure they are consistent.

While these files appear at the beginning of the PO files (since files are sorted alphabetically),
  they are not a priority to translate. Please skip to the beginning of the lesson,
  following the README.

### Contributing to a translation of an existing lesson

Please see these instructions if you wish to contribute to a translation in progress
  on the current version the main English lessons. This is for updating or translating
  sections to a translation in progress. To import updates from a new release of
  the main English lessons, please see the instructions below.

1. Create a "Fork" for this repository on your personal GitHub account. (Click "Fork" in the top right
  corner of the `https://github.com/swcarpentry-ja/i18n` webpage)

2. Clone this repository from your personal account (e.g., GitHubUser). This is your local copy to manage your version of
 the translation files.

```
cd directory
git clone git@github.com:GitHubUser/i18n.git
cd i18n
```

If you already have a fork of translation repository, please pull changes for the current
   version from the organisation repository:

```
git checkout ja
git remote add swc-ja git@github.com:swcarpentry-ja/i18n.git
git pull swc-ja ja
```

This repository should already contain a translation file for the lesson that you wish to contribute to
  in the `po` directory <lesson-name>.<lang>.po such as `git-novice.ja.po` 

```bash
cd po
ls git-novice.ja.po
```

3. Add and edit translations to the PO files.

 - Edit the file with your favourite po editor ([PoEdit](http://www.poedit.net),
 [GTranslator](https://wiki.gnome.org/Apps/Gtranslator), [Lokalize](https://userbase.kde.org/Lokalize), ...)
   Note:
    - "`Language`" field is needed to add to the header (at least with gtranslator), the rest is put by the tool.
    - "`Language-Team:`" needs the first letter in upper case (e.g., `Es`)
 - Create `po/LINGUAS`
 - Run `po4gitbook/compile.sh` - This creates a `locale/<lang>/<lesson>` tree directory

This generates a translated version of the lessons with your changes. You can add and commit 
  changes to the PO files and submit changes as a Pull Request on GitHub as described in the
  "Guide for Translators".

 Please do not create a git repository within this repository. You can copy these files to another repository
 as described in the "Guide for Maintainers and Administrators" and submit changes to translated
 lesson repository to update the webpages hosted on GitHub.

### Contributing to translation of an updated lesson with a new release of the main English lessons

If there is an existing (complete) translation of the lesson in your language but
  there has a new release of the main English lessons, the new updated version
  of the English lessons needs to be merged with the current translated. This way
  the sections have not been changed and have already been translated will be migrated
  to the new version of the lessons and only the sections that have been changed remain
  to be translated.

1. Create a "Fork" for this repository on your personal GitHub account. (Click "Fork" in the top right
  corner of the `https://github.com/swcarpentry-ja/i18n` webpage)

2. Clone this repository from your personal account (e.g., GitHubUser). This is your local copy to manage your version of
 the translation files.

```
cd directory
git clone git@github.com:GitHubUser/i18n.git
cd i18n
```

If you already have a fork of translation repository, please pull changes for the current
   version from the organisation repository:

```
git checkout ja
git remote add swc-ja git@github.com:swcarpentry-ja/i18n.git
git pull swc-ja ja
```

3. Import the current version of the main English lessons.

Update the submodule for the lesson that you want to translate

```
git submodule add https://github.com/swcarpentry/git-novice.git
```

Alternatively, you can update the submodules for every lesson:

```
git submodule foreach git pull origin master
```

4. Create translation files for the updated version of the lessons

Run `po4gitbook/update.sh` - That creates/updates the `po` directory with the `.pot` files to use in translations.

For an update: existing translations will be merged into an updated file.
```bash
cd po
ls git-novice.ja.po
```

5. This creates an updated `po` file with updated sections ready to translate.


 - Edit the file with your favourite po editor ([PoEdit](http://www.poedit.net),
 [GTranslator](https://wiki.gnome.org/Apps/Gtranslator), [Lokalize](https://userbase.kde.org/Lokalize), ...)
   Note:
    - "`Language`" field is needed to add to the header (at least with gtranslator), the rest is put by the tool.
    - "`Language-Team:`" needs the first letter in upper case (e.g., `Es`)
 - Create `po/LINGUAS`
 - Run `po4gitbook/compile.sh` - This creates a `locale/<lang>/<lesson>` tree directory

This generates a translated version of the lessons with your changes. You can add and commit
  changes to the PO files and submit changes as a Pull Request on GitHub as described in the
  "Guide for Translators".

 Please do not create a git repository within this repository. You can copy these files to another repository
 as described in the "Guide for Maintainers and Administrators" and submit changes to translated
 lesson repository to update the webpages hosted on GitHub.

## Guide for Translators

This assumes that you are familiar with using Git and GitHub.
We are translating (and keeping up-to-date) the Software Carpentry notes.
If you notice an issue with the lesson materials themselves, please send an issue for pull request to the English lesson materials.

### To contribute to lesson materials

Fork this repository on GitHub and clone the **forked repo** to your local machine:
```bash
git clone git@github.com:<github_username>/i18n.git
```

Some of the above procedure has been performed for some lessons already.
These scripts can be used to initialise translation of a new lesson
or update a translation of a lesson in progress.

1. Import lesson as instructed above (or pull current version from organisation repo)

2. Check that lang.md has the assets in the correct language

3. Translate sections (or check translations) and commit changes

4. Push or your personal repo and send pull request to organisation repository

    a. Clone the swcarpentry-ja lesson with "lesson-name-ja" or create a new lesson repo to (if one does not exist already) to host the translated lessons.
You can push commit changes to the submodule of the lesson before translation or create a fresh repository with the translated files.

    b. Copy changes from from automatically generated lessons `rsync -u i18n/locale/ja/git-novice/ git-novice-ja`

    c. Commit changes and push to GitHub

    d. Create a Pull Request from your repo to `swcarpentry-ja` for the translated lesson repo AND the updated PO files in `i18n`. Please reference your lesson pull request #Number when creating a pull request to i18n.

If you send a pull request of translated files, we can merge them into the lesson materials and generate the updated webpages. If you wish to generate a preview of these yourself on your local repo, please see the instructions below.

5. Please commit often and discuss issues on github to ensure that we are not repeating each other

6. Update the `ChangeLog.md` and `CultureNotes.md` files accordingly

ChangeLog.md is to track progress and goals. CultureNotes.md is a share record of non-literal translations to ensure consistency.

7. Add your name to the translation team if you wish (unless you want to remain anonymous)

Thank you for all your help. Even seemingly minor contributions will be appreciated!

## Guide for Maintainers and Administrators

### To update the GitHub pages lessons with Jekyll

This assumes a high level of familiarity with Git, GitHub, and how these lessons have been configured. These tools can be used to 
  update the webpages hosted on the organisation repository or create a hosted webpage on your personal fork.

Updates to the files can be managed by tracking changes to the PO files and translated lessons
can be viewed on the GitHub repository as Markdown files in the `_episodes` directory
of the respectve lesson repo. It is not necessary to update the webpages for every update to
the translations. This will be managed by lesson maintainers and organisers of the Japanese
language team.

1. Run `po4gitbook/compile.sh` on updated PO files (commit and push changes to PO files to i18n)

Note that in order for the lessons to compile the Credit line in the PO files HEADER
 "# FULL NAME <EMAIL@ADDRESS>, YEAR." must match the contact details of the "Last-Translator".
Please fill in your details or keep these consistent in order to build the new translated lessons.
 

```
git add -u po/*ja.po
git commit -m "update PO files"
git push origin ja
```

2. Clone the translated lesson repo (to a directory outside the i18n repository)
```
git clone https://github.com/swcarpentry-ja/git-novice-ja.git
```
Or pull to your copy of this repo
```
git pull origin master
```

3. Move updated translated files to the cloned translated lesson
```
rsync -ru i18n/locale/ja/git-novice/* git-novice-ja
```

4. Commit and push changes to the translated lesson
```
git add -u *
git commit -m "update lesson files"
git push origin master
```

6. Clone or pull a copy of the original lesson repo (again outside any existing git repos)
```
git clone https://github.com/swcarpentry-ja/git-novice.git
```

Or pull to your copy of this repo
```
git pull origin gh-pages
```

6. Sync changes to (master branch of) the pushed submodule files to the original lesson repository
```
git submodule foreach git pull origin master
```

7. Commit changes to the submodule to the original lesson
```
git add -u
git commit -m "update Japanese lessons"
```

8. Push to the lesson repo (or send a pull request)
```
git push origin gh-pages
```

Jekyll will update the "github.io" webpages once a new commit is pushed (but it will not see new commits to submodules unless these are pulled and committed)

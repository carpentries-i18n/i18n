# Internationalisation of carpentry lessons

Please take a look at the [quickstart guide](quickstart.md) if you wish to make small contribution(s).

If you wish to contribute by translating some of the material, please make sure you comply with the [Guideline for Translators](TranslatorGuidelines.md).

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

* Please commit often and discuss issues on github to ensure that we are not repeating each other.

* Add your name to the translation team if you wish (unless you want to remain anonymous).

## How does this work?

### Using git

If you need help installing git, please see the [guide on installing git](git.md).

### Importing a lesson for the first time

Lessons are imported as submodules. This only needs to happen once per lesson, so most translators will not need to do this. If you want to import a new lesson, please see the [guide on importing](importing.md).

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

If there is an existing (complete) translation of the lesson but
  there has a new release of the main English lessons, the updated version
  of the English lessons needs to be merged with the current translated one.

Please see the [guide on updating lessons](updating.md).

### Resources for translations

Please follow the following Guidelines for translators when editing the lessons:

https://github.com/swcarpentry-ja/i18n/blob/ja/TranslatorGuidelines.md

There is a list of technical terms to refer to for ensuring that terms are consistently used between lessons, please update and refer to this as needed:

https://github.com/swcarpentry-ja/i18n/wiki/Glossary-for-technical-terms

ChangeLog.md is to track progress and goals. CultureNotes.md is a share record of non-literal translations to ensure consistency.

### Guide for Maintainers and Administrators

Please see the [guide for maintainers and administrators](admin.md)

Thank you for all your help. Even seemingly minor contributions will be appreciated!

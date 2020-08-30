## Importing a lesson for the first time

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

### Updated lessons to correspond to a new release of the main English lessons

### Automation

This will automated with the script in the `i18n` repository. Clone or pull the repository and run the following command in the `i18n` directory.

```
sh wrapper.sh --repo r-novice-gapminder --account swcarpentry-ja --update
```

Note: *this is a work in progress and may not work as expected*

Please test this on a fork on your user account before doing it on the organisation repository.

### To update the GitHub pages lessons with Jekyll

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

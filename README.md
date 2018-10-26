# Internationalisation of carpentry lessons

## How does this work?

1. Add a submodule for the lessons that you want to translate
2. Run `po4gitbook/update.sh` - That creates/updates the `po` directory with the `.pot` files to use in translations.
3. first time for this lesson: `cp git-novice.pot .git-novice.po.ancestor` Please **do not delete** these files.

3. for an update: merge existing translations into updated file
```bash
git merge-file git-novice.pot .git-novice.pot.ancestor git-novice.ja.po
```
4. Create a `po` file and start translating!
 - copy `<file>.pot` to `<file>.<lang>.po`. e.g.,
 ```bash
 cd po
 cp shell-novice.pot shell-novice.es.po
 ```
 - Edit the file with your favourite po editor ([PoEdit](http://www.poedit.net),
 [GTranslator](https://wiki.gnome.org/Apps/Gtranslator), [Lokalize](https://userbase.kde.org/Lokalize), ...)
   Note:
    - "`Language`" field is needed to add to the header (at least with gtranslator), the rest is put by the tool.
    - "`Language-Team:`" needs the first letter in upper case (e.g., `Es`)
 - Create `po/LINGUAS`
 - run `po4gitbook/compile.sh` - This creates a `locale/<lang>/<lesson>` tree directory

### Guide for Translators

Fork this repository on GitHub and clone it to your local machine:
```bash
git clone git@github.com:swcarpentry-ja/i18n.git
```

Some of the above procedure has been performed for some lessons already.
These scripts can be used to initialise translation of a new lesson
or update a translation of a lesson in progress.

1. import lesson as instructed above (or pull current version from organisation repo)

2. check that lang.md has the assets in the correct language

3. translate sections (or check translations) and commit changes

4. push or your personal repo and send pull request to organisation repository

5. please commit often and discuss issues on github to ensure that we are not repeating each other

6. update the `ChangeLog.md` and `CultureNotes.md` files accordingly

ChangeLog.md is to track progress and goals. CultureNotes.md is a share record of non-literal translations to ensure consistency.

7. add your name to the translation team if you wish (unless you want to remain anonymous)

Thank you for all your help. Even seemingly minor contributions will be appreciated!

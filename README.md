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

## Guide for Translators

### To contribute to lesson materials

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

    a. clone the swcarpentry-ja lesson with "lesson-name-ja" or create a new lesson repo to (if one does not exist already) to host the translated lessons. 
You can push commit changes to the submodule of the lesson before translation or create a fresh repository with the translated files.

    b. copy changes from from automatically generated lessons `rsync -u i18n/locale/ja/git-novice/ git-novice-ja`

    c. commit changes and push to GitHub

    d. create a Pull Request from your repo to `swcarpentry-ja` for the translated lesson repo AND the updated PO files in `i18n`. Please reference your lesson pull request #Number when creating a pull request to i18n.   

If you send a pull request of translated files, we can merge them into the lesson materials and generate the updated webpages. If you wish to generate a preview of these yourself on your local repo, please see the instructions below.

5. please commit often and discuss issues on github to ensure that we are not repeating each other

6. update the `ChangeLog.md` and `CultureNotes.md` files accordingly

ChangeLog.md is to track progress and goals. CultureNotes.md is a share record of non-literal translations to ensure consistency.

7. add your name to the translation team if you wish (unless you want to remain anonymous)

Thank you for all your help. Even seemingly minor contributions will be appreciated!

### To update the GitHub pages lessons with Jekyll

1. run `po4gitbook/compile.sh` on updated PO files (commit and push changes to PO files to i18n)

`git add -u po/*ja.po`

`git commit -m "update PO files"`

`git push origin ja`	

2. clone the translated lesson repo (to a directory outside the i18n repository)

`git clone https://github.com/swcarpentry-ja/git-novice-ja.git`

Or pull to your copy of this repo

`git pull origin master"

3. move updated translated files to the cloned translated lesson

`rsync -ru i18n/locale/ja/git-novice/* git-novice-ja`

4. commit and push changes to the translated lesson

`git add -u *`

`git commit -m "update lesson files"`

`git push origin master`

6. clone or pull a copy of the original lesson repo (again outside any existing git repos)

`git clone https://github.com/swcarpentry-ja/git-novice.git`

Or pull to your copy of this repo

`git pull origin gh-pages"

6. sync changes to (master branch of) the pushed submodule files to the original lesson repository

`git submodule foreach git pull origin master`

7. commit changes to the submodule to the original lesson

`git add -u`

`git commit -m "update Japanese lessons"

8. Push to the lesson repo (or send a pull request)

`git push origin gh-pages`

Jekyll will update the "github.io" webpages once a new commit is pushed (but it will not see new commits to submodules unless these are pulled and committed)

## Information for Maintainers and Administrators

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
git submodule foreach 'case $name in po4gitbook) ;; *) git pull swc-ja gh-pages ;; esac'
git submodule update --recursive
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

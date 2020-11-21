# Internationalisation of carpentry lessons

## How does this work?

1. Add a submodule for the lessons that you want to translate
1. Run `po4gitbook/update.sh` - That creates/updates the `po` directory with the `.pot` files to use in translations.
1. Create a `po` file and start translating!
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


## Using Transifex

[Transifex]() is a collaborative platform for translations. We can upload the
`pot` files produced by the `update` command. However, to have a better user
experience on that platform we suggest that the `lesson_file.pot` is broken into
one per episode. To do so you can use the helper script available in this repository

```bash
$ lesson="TheSuperLesson"
$ python helpers/splitpot.py po/${lesson}.pot
```

This, by default, will break `TheSuperLesson.pot` file and create a
`TheSuperLesson` directory under `transifex` and fill it up with one file per
episode.

Now we will proceed to use the [transifex-client](https://docs.transifex.com/client/installing-the-client)
to push the split files.

1. Browse to the directory of the lesson and create the `<lang>` directory that
   you would like to get translating:

   ```bash
   $ cd transifex/${lesson}
   $ mkdir es
   ```
   
   We will proceed to generate the files to push to transifex. Read the [[appendix]] 
   below for more information to do it manually.
   
1. Run the transifex command to generate all the files needed.

   ```bash
   tx config mapping-bulk -p ${lesson} --source-language en --type PO -f '.pot' \
             --source-file-dir pot --expression "<lang>/{filename}.po" --execute
   ```
   
   Note that you need to create that project (lesson) manually in
   [transifex](https://www.transifex.com/carpentries-i18n/add/)

1. Next we proceed to push the sources to the website

   ```bash
   tx push -s --parallel
   ```
   
   This can take a while... 
   
1. Advertise between the translators, give access to people through the portal

1. translate, translate, translate

1. when you want to download a particular translation for building the lesson
   you need to, pull and combine:
   
   ```bash
   $ language="es"
   $ cd transifex/${lesson}
   $ tx pull -t ${language}  # This should download the `po` files in transifex/${lesson}/${language}
   $ # Then proceed to join the files into a single one
   $ cd ..
   $ python helpers/splitpot.py po/${lesson}.pot --join transifex/${lesson} --lang ${language}
   $ # Compile the repository with po4gitbook so it creates the locale for the lesson
   $ po4gitbook/compile.sh # This creates a `locale/<lang>/<lesson>` tree directory
   ```
   
# Appendix

## Transifex manual process
   
1. initialise the transifex project (if this is your first time then you may
   [set up your
   token](https://docs.transifex.com/client/init#first-tx-init-run)).

   ```bash
   $ tx init
   ```
   
   Answer the questions that follows as required. **Note** if the script hangs a
   the path expression step, is because it doesn't find the `<lang>` directory.
   Make sure to create one first (*e.g.,* `mkdir es`)
   

# カーペントリーのレッスンの国際化

小さな貢献をしたい場合は、[クイックスタートガイド](quickstart.md)を読んでみてください。

Before translating any material, please make sure you comply with the [Guidelines for Translators](TranslatorGuidelines.md) and read the [Rules of Conduct](rules.md).

資料を翻訳する前に、[翻訳者のガイドライン](TranslatorGuidelines.md)と、[行動規則](rules.md)を、読んでください

We encourage translators to [join our slack channel](https://r-wakalang.herokuapp.com/), #swcarpentry in the Tokyo.R workspace. This is a great place to ask any questions you may have about the workflow.

また、[Slackチャンネル](https://r-wakalang.herokuapp.com/), Tokyo R ワークスペースの #swcarpentry
 に参加することをおすすめします。ここは、翻訳を進める上で発生する疑問に関して質問するのに最適の場所です。

## 目的

The repository is intended to host the files and tools need to facilitate translations of the [Software Carpentry](https://software-carpentry.org/) lessons
from English into other languages (currently we are working on Japanese). This repository is intended to merge with the Multi-lingual versions of the lessons
in English and Spanish. We plan for these to be compatible to be hosted along with other languages on the main
Software Carpentry website and to maintain updated copies of the Japanese lessons with new releases of the
English lessons.

We are translating (and keeping up-to-date) the Software Carpentry lessons, not revising original lesson material.
If you notice an issue with the lesson materials themselves, please send an issue for pull request to the English lesson materials.

## gitについて

ここでは、あなたが、GitとGitHubについて知っているという仮定をしています。

もし、gitをインストールするのに手助けが必要ならば、[gitのインストールガイド](git.md)を読んでみてください

## About PO files

We use [PO files](https://www.gnu.org/software/gettext/manual/html_node/PO-Files.html) for translation, rather than translating the text of each lesson directly. A PO file is a plain text file consisting of multiple entries, where each entry contains a short portion of the original text and its translation. There is one PO file for each original lesson. For example, the [Software Carpentry 'git novice' lesson](https://github.com/swcarpentry/git-novice), which consists of multiple markdown documents, has a single PO file called `git-novice.ja.po` for translating into Japanese.

This way, we can keep track of the original text and know exactly what needs to be changed when the original lessons are updated, instead of manually tracking changes.

There are a number of free PO editors: [PoEdit](http://www.poedit.net),
[GTranslator](https://wiki.gnome.org/Apps/Gtranslator), [Lokalize](https://userbase.kde.org/Lokalize), to name a few. We recommend using one of these to edit the PO files.

## Importing a lesson for the first time

Lessons are imported as submodules. This only needs to happen once per lesson, so most translators will not need to do this. If you want to import a new lesson, please see the [guide on importing](importing.md).

## Contributing to a translation of an existing lesson

**This is the task that we need the most help with from translators!**

This assumes that the lesson has already been added to the `swcarpentry-ja/i18n` as a submodule as described in the [guide on importing](importing.md), and you would like to contribute translations for that lesson.

1. Create a "Fork" for this repository on your personal GitHub account. (Click "Fork" in the top right
  corner of the `https://github.com/swcarpentry-ja/i18n` webpage)

2. Clone this repository from your personal account (e.g., GitHubUser). This is your local copy to manage your version of
 the translation files.

```
cd directory
git clone git@github.com:GitHubUser/i18n.git
cd i18n
```

3. サブモジュールを使えるようにする.

```
git submodule init
git submodule update
```

このレポジトリはすでに、レッスンの翻訳ファイルが含まれています。翻訳に貢献したいときには、 `po` ディレクトリの中の `<レッスン名>.<言語>.po` 、例えば `git-novice.ja.po` に貢献することができます。

```bash
cd po
ls git-novice.ja.po
```

4. Edit the PO files. [As per the guidelines](rules.md), please commit your changes frequently and submit a pull request when you are satisfied with your work.

5. Your PR will be reviewed for accuracy. You may need to make edits so it can pass review. When doing so, always be sure to pull changes from the organisation repository first:

```
git checkout ja
git remote add swc-ja git@github.com:swcarpentry-ja/i18n.git
git pull swc-ja ja
```

Repeat steps 4 and 5 until the PR passes review.

A few notes:

Editing the PO file will not generate the translated website. That is left to the maintainers, as described in the [guide for maintainers and administrators](admin.md).

If you want to see a translated MD file after editing the PO file, run `bash po4gitbook/compile.sh`. This generates a translated version of the lesson with your changes, which you can find at `locale/<lang>/<lesson>`, e.g., `locale/ja/git-novice`.

## Contributing to translation of an updated lesson with a new release of the main English lessons

If there is an existing (complete) translation of the lesson but
  there has a new release of the main English lessons, the updated version
  of the English lessons needs to be merged with the current translated one.

Please see the [guide on updating lessons](updating.md).

## 翻訳のためのリソース

Please follow [guidelines for translators](TranslatorGuidelines.md) when editing the lessons.

There is a [list of technical terms](https://github.com/swcarpentry-ja/i18n/wiki/Glossary-for-technical-terms) to refer to for ensuring that terms are consistently used between lessons. Please update and refer to this as needed.

Please see the [culture notes](CultureNotes.md) for a standardized treatment of concepts that don't translate literally into Japanese to ensure consistency.

We have a [change log](ChangeLog.md) to track progress and goals.

## メンテナーと管理者のガイド

[メンテナーと管理者のガイド](admin.md) を見てください

ご協力いただきありがとうございます。たとえ小さな貢献であっても、大歓迎です。

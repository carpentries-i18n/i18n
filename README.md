# Internationalisation of carpentry lessons（カーペントリーのレッスンの国際化）

## [English README](README_en.md)

小さな貢献をしたい場合は、[クイックスタートガイド](docs/quickstart.md)を読んでみてください。

資料を翻訳する前に、[翻訳者のガイドライン](docs/TranslatorGuidelines.md)と、[行動規則](docs/rules.md)を、読んでください

また、私たちの[Slackワークスペース](http://carpentries-ja.slack.com)に参加してください。
[#swcarpentryのSlackチャンネル](https://r-wakalang.herokuapp.com/)もあります。
ここは、翻訳を進める上で発生する疑問に関して質問するのに最適の場所です。

ツイッターで[swcarpentry-ja](https://twitter.com/swcarpentry_ja)も更新の発表をやっています。ぜひフォローしてください。

## 目的

レポジトリは、[ソフトウェアカーペントリー](https://software-carpentry.org/)のレッスンを英語から他の言語(現在日本語に取り組んでいます)へ翻訳するのを容易にするために必要なファイルやツールをホストするためにあります。また、英語とスペイン語のレッスンの多言語化をしてマージするためでもあります。

ソフトウェアカーペントリーのメインのウェブサイトが他の言語と一緒にホストされ互換性があり、英語のレッスンの新しいリリースに合わせて日本語のレッスンも最新に維持するように計画しています。

私達は、ソフトウェアカーペントリーのオリジナルのレッスンを改定するのではなく、レッスを翻訳（そして最新の状態に維持）をしています。

もしあなたが、レッスン自体の問題に気づいたら、英語のレッスンに対して、issueをたてたり、プルリクエストを送ってください。

## gitについて

ここでは、あなたが、GitとGitHubについて知っているという仮定をしています。

もし、gitをインストールするのに手助けが必要ならば、[gitのインストールガイド](docs/git.md)を読んでみてください

## About PO files

各レッスンのテキストを直接翻訳するのではなく、翻訳には、[PO ファイル](https://www.gnu.org/software/gettext/manual/html_node/PO-Files.html)を使います。

POファイルは、複数のエントリで構成されるテキスト形式のファイルです。各エントリーは、元のテキストと、その翻訳の短い部分が含まれています。オリジナルのレッスンごとに、１つのPOファイルがあります。例えば、[Software Carpentry 'git novice' lesson](https://github.com/swcarpentry/git-novice)は、複数の markdown形式のドキュメントで構成され、日本語の翻訳に関しては１つの `git-novice.ja.po` というPOファイルがあります。これにより、手動ではなく、オリジナルのテキストの追跡を行うことができ、オリジナルのレッスンが更新されたときに、変更され翻訳が必要とされる部分を正確に把握することができます。無料のPOエディタは、いくつかあります: [PoEdit](http://www.poedit.net),[GTranslator](https://wiki.gnome.org/Apps/Gtranslator), [Lokalize](https://userbase.kde.org/Lokalize). これらのいずれかを使用して、POファイルを翻訳することをお勧めします。

## 初めてレッスンをインポートするとき

レッスンはサブモジュールとしてインポートされます。この作業はレッスンにつき１度だけ行われ、ほとんどの翻訳者はこれを行う必要はありません。もし、あなたが新しいレッスンをインポートしたいときには、[インポートのガイド](docs/importing.md)を参照してください。

## 既存のレッスンの翻訳へ貢献する

**これは、翻訳者からの手助けが最も必要なタスクです!**

これは、[インポートのガイド](docs/importing.md)で説明されているように、`swcarpentry-ja/i18n`がサブモジュールとして既に追加されていることを前提としています。あなたは、そのレッスンの翻訳に貢献したいとします。

1. 個人のGitHubアカウントで、このレポジトリの"フォーク"を作成します。 (`https://github.com/swcarpentry-ja/i18n`の右上の"フォーク(fork)"をクリックします。
  corner of the `https://github.com/swcarpentry-ja/i18n` webpage)

2. 個人のアカウント(GitHubUserなど)で、このレポジトリをクローンします。これは、翻訳ファイルのバージョン管理するためのローカルコピーです

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

4. POファイルを編集します。[ガイドラインに従って](docs/rules.md), 頻繁に変更をコミットし、十分だとおもったらpull request を投稿してください。

5. 正確を期すために、あなたのPRについて、レビューが行われます。レビューがパスするまで、編集を続けます。そのようなときは、まずはじめに、組織のレポジトリに対する変更を pull してください。

```
git checkout ja
git remote add swc-ja git@github.com:swcarpentry-ja/i18n.git
git pull swc-ja ja
```

PRがレビューをパスするまでステップ4と5を繰り返します

いくつかのメモ:

POファイルを編集しても、翻訳されたWebサイトができあがるわけではありません。[メンテナーと管理者ガイド](docs/admin.md)で述べられているように、これはメンテナーに任されています。

POファイルを編集したあと、翻訳された Markdown ファイルを見たいときには、 `bash po4gitbook/compile.sh` を実行します。これは、あなたの変更を含めた翻訳されたバージョンを生成します。これは、`locale/<lang>/<lesson>`, 例, `locale/ja/git-novice`で見つけることができます。

## メインの英語のレッスンが新しくリリースされたら、レッスンを更新するのに貢献する

レッスンの(完全な)翻訳が存在しても、メインの英語のレッスンが新しくリリースされることがあります。
更新されたバージョンの英語のレッスンは、現在の翻訳されたものにマージされる必要があります。

[レッスン更新時のガイド](docs/updating.md)を見てください。

## 翻訳のためのリソース

レッスンを編集するときには[翻訳者のためのガイドライン](docs/TranslatorGuidelines.md)に従ってください。

レッスン間で用語が一貫して使われていることを確認するために [技術用語のリスト](https://github.com/swcarpentry-ja/i18n/wiki/Glossary-for-technical-terms) があります。必要に応じてこれを参照したり更新したりしてください。

一貫性を担保するために、日本語に翻訳されない概念などの標準化された取り扱いについては、 [カルチャーノート](docs/CultureNotes.md) を参照してください。

進捗と、ゴールを記録するために[変更履歴](docs/ChangeLog.md)を持っています。

## メンテナーと管理者のガイド

[メンテナーと管理者のガイド](docs/admin.md) を見てください

ご協力いただきありがとうございます。たとえ小さな貢献であっても、大歓迎です。

# クイックススタート（取説）

このファイルは、[README](README.md)から必要最低限の情報をまとめたものです。

## 始める前に

* このリポジトリにあるファイルは削除しないようにして下さい
* このプロジェクトに貢献したい場合、このリポジトリをフォーク（コピー）して、プルリクエストにて変更点を提出して下さい
* 問題点・質問などがあれば、イシュー（Issue）を開いて下さい

## Git の設定、及び貢献の仕方

1. Gitの最新バージョンをダウンロード、そしてインストールして下さい
2. 右上にあるフォーク（Fork）ボタンを使って、このリポジトリのコピーを自身のアカウントに作って下さい
3. フォークしたリポジトリを自身のパソコンにダウンロードして下さい（この操作をクローン（clone）と呼びます）：
```bash
git clone git@github.com:<github_username>/i18n.git
```
4. オリジナルのリポジトリをリモート（remote）として追加して下さい：
```bash
git remote add upstream git@github.com:swcarpentry-ja/i18n.git
```
5. 自由にファイルの内容を変更・翻訳して下さい。
変更点はこまめにコミット（commit）することをお勧めします：
```bash
git add -u
git commit -m "<replace this commit message with something sensible>"
```
6. 変更点を提出する準備ができたら、オリジナルのリポジトリから最新のバージョンを「引き入れて」（プル（pull）して）下さい：
```bash
git pull upstream ja
```
7. コンフリクト（conflict；統合不能な変更点のこと）があれば、修正して下さい
8. 変更点を自身のリモートにプッシュ（push）して下さい：
```bash
git push
```
9. 自身のGitHubからプルリクエストを`swcarpentry-ja`へ提出して下さい
10. 新しい変更点を追加する場合は、ステップ５と８を自身のリポジトリで繰り返して下さい - 自動的にプルリクエストの内容が変更されます：
```bash
git add -u
git commit -m "<replace this commit message with something sensible>"
git pull
git push
```

## コツ・オススメのワークフロー（Git 中級者向け）

Gitを使ったワークフローをより便利にするためのコツを紹介します。
ここに記載されているコツを使う場合、上記のワークフローを以下のように変更して使って下さい：

* 上記ステップ１から４
* 下記ステップ１
* 上記ステップ５
* 上記ステップ６の代わりに、下記ステップ２
* 上記ステップ７
* 上記ステップ８の代わりに、下記ステップ３
* 上記ステップ９の代わりに、下記ステップ４
* 上記ステップ１０

### ステップ

1. 新しくファイル内容を変更・翻訳する場合、新しいブランチ（branch；「枝」）を使って下さい。
新しいブランチを作ることによって、プルリクエストがより楽になり、更に他のブランチにあるファイルの変更点などを気にせずにファイルを編集することができます。
```bash
git checkout -b <username or other descriptive word>-edit

# Examples:
git checkout -b rikutakei-edit
git checkout -b git-edit2
git checkout -b readme-edit
```
2. `swcarpentry-ja`のリポジトリからプルする際に、`--rebase`オプションを使って下さい。
`--rebase`を使うことによって、自身の変更点を`swcarpentry-ja`リポジトリにある変更点の*後に*持ってくることができます。
これによって、マージ・コミット（merge commit；変更点を統合する時に使われるコミットの事）をできるだけ省くことができます。
英文ですが、 [こちら](http://kernowsoul.com/blog/2012/06/20/4-ways-to-avoid-merge-commit
s-in-git/)と[こちら](https://codeinthehole.com/tips/pull-requests-and-other-good-practices-for-teams-using-github/)の記事を参考にして下さい。
```bash
git pull --rebase upstream ja
```
3. 初めてブランチをリモートにプッシュする際は、ブランチのアップストリーム（upstream；「上流」）を同じ名前に設定することをオススメします（これは、リ
モートに表示されるブランチ名に反映されるからです）。
```bash
# 初めてリモートにプッシュする際：
git push -u origin <your branch name>

# それ以降は普通にプッシュ・プルすることが可能です：
git pull
git push
```
4. プルリクエストを提出する際は、編集していたブランチから変更点を提出して下さい。
ブランチからプルリクエストを送ることによって、別のブランチで他のファイルを編集してコミットしても、プルリクエストにそのコミットが反映されることがなくなります。
例えば、別のファイルを編集する場合、新しくブランチを作るか、すでにあるブランチへ移動してからファイルを編集して下さい：
```bash
# すでにあるブランチを表示する：
git branch

# 新しくブランチを作る：
git checkout -b <new branch name>

# すでにあるブランチに移動する：
git checkout <branch name>
```

## 翻訳者のためのガイド

### 翻訳ガイドライン

[翻訳ガイドライン](TranslatorGuidelines.md)を参考に、翻訳内容を統一して下さい。

[単語リスト](https://github.com/swcarpentry-ja/i18n/wiki/Glossary-for-technical-term
s)
専門用語の翻訳は、統一性を維持するために[単語リスト](https://github.com/swcarpentry-ja/i18n/wiki/Glossar
y-for-technical-terms)を使ってください。
記載されていない場合は随時追加して下さい。

### 全レッスン共通のファイル

以下のファイルは全てのレッスンに共通しています：

```bash
CODE_OF_CONDUCT.md
CONTRIBUTING.md
LICENSE.md
README.md
```

POファイルの初めにこれらのファイルの内容が記載されていますが、翻訳は無視して、READMEの後にあるレッスン内容を翻訳して下さい。


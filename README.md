# 4D NetKitによるメールとフォルダーの管理

*Managing Email and Folders with 4D NetKit*: 日本語版。

4D NetKitを使ってGoogleのGmail APIとMicrosoft Graph APIに接続する方法を解説するテクニカルノートです。
OAuth 2.0による接続とアクセストークンの取得から、メールの送信・取得・削除、ラベルとフォルダーの管理までを扱います。
日本語のPDFと、日本語・英語のUIに対応した4Dデモを収録しています。
本文のプログラムコードは原文のまま保持しています。

## Download

| | |
|---|---|
| PDF（日本語） | [24-13_4DNetKit_ja.pdf](https://github.com/miyako/ManagingEmailFolders/releases/download/v1.0.0/24-13_4DNetKit_ja.pdf) |
| 4Dデモ | [ManagingEmailFolders.zip](https://github.com/miyako/ManagingEmailFolders/releases/download/v1.0.0/ManagingEmailFolders.zip) |
| 原文（英語） | [document/24-13_4DNetKit.pdf](document/24-13_4DNetKit.pdf) |

[v1.0.0](https://github.com/miyako/ManagingEmailFolders/releases/tag/v1.0.0)から日本語PDFと4Dデモをダウンロードできます。

## Demo

- 原文の動作要件は4D 20 R6以降です。ローカライズしたデモは4D 21 R3でコンパイルとオフラインチェックを実施しています。
- 4D NetKitと4D SVGが利用できる4Dで、`demo/ManagingEmailFolders/Project/ManagingEmailFolders.4DProject`を開きます。
- UIの言語は日本語・英語です。4DのUI言語に従い、翻訳リソースは`Resources/ja.lproj/`と`Resources/en.lproj/`にあります。
- 起動時にメイン画面を開きます。閉じた後は「デモを開く」で再表示でき、同じ画面が開いている場合はその画面を再利用します。

接続する前に、`Resources/oauth.example.json`を`Resources/oauth.local.json`にコピーし、ご自身のアプリケーションの認証情報を入力してください。
Googleでは`clientId`と`clientSecret`、Microsoftでは`clientId`が必要です。
実際の認証情報、メールデータ、実行時の設定ファイルは配布物に含みません。
詳細は[デモのセットアップ手順](demo/ManagingEmailFolders/SETUP.txt)を参照してください。

このデモは接続したアカウントの実データを扱います。メールの送信、ラベルやフォルダーの作成・名前の変更・削除は、実際のアカウントに影響します。
自動チェックでは、サインインやこれらの操作をおこないません。

## Differences from the original

- 本文と図01のOAuthシーケンス図を日本語化しました。
- 図02〜13のGoogle・Microsoftのスクリーンショットは英語の原図を保持しています。対応する本文の引用UIラベルも英語です。
- 表紙のノート番号を省略し、著者の役職を日本語表記にしました。
- 本文のコード、図の順序、コード中の例の値は原文のままです。独立したサンプルデータの置換はおこなっていません。
- デモの画面、メニュー、ダイアログをXLIFF化し、日本語と英語に対応しました。取得したメールやフォルダー名・ラベル名、APIが返すエラー詳細は翻訳しません。
- デモの起動を非ブロッキングにし、OAuthの認証情報をソースコードからローカル設定ファイルに分離しました。

**既知の制限：** Microsoftの送信処理には、Google側の入力データを確認してしまう原本由来の問題が残っています。
このローカライズでは、その動作を修正していません。本文のコードについても、原文由来の問題を含めて保持しています。

## Editing and rebuilding

PDFはテキストソースと図から生成します。PDFを直接編集せず、ソースを変更して`make`で再生成してください。

| File | What |
|---|---|
| `src/ja.md` | 日本語本文。コードブロックは変更しません。`make check`で原文との一致を確認します。 |
| `figures/fig-01.ja.txt` | 図01の日本語ラベル。各行が`fig-01.en.txt`の同じ行に対応します。 |
| `figures/layout/fig-NN.json` | 図の配置とラベル描画の調整。スクリーンショットは`localize: false`のまま保持しています。 |
| `glossary.md` | 用語と表記の方針。 |
| `demo/ManagingEmailFolders/Resources/` | デモのXLIFFと認証情報の設定テンプレート。実際の認証情報はGitの管理対象外です。 |

```sh
git submodule update --init .agents
make setup
make                 # check → figures → build/24-13_4DNetKit_ja.pdf
make check           # コードブロックと図の参照を確認
make review          # 図の比較シートをbuild/contact-N.pngに生成
make release-assets  # PDFとコミット済みデモのZIPを生成
```

Python 3、Google Chrome、日本語フォントが必要です。Tesseractは再抽出する場合に使用します。
macOSではヒラギノ、LinuxではNoto CJKを使用するため、PDFや図の見た目が少し異なります。
日本語版PDFの確認はmacOSでおこなっています。
詳しいワークフローは[ローカライズ用テンプレート](https://github.com/miyako/4d-technote-localisation-template)を参照してください。

## Credits

- 原著：Trina Nguyen（4D Inc. テクニカルサービスエンジニア）、Technical Note 24-13。
- [4D technical note localisation template](https://github.com/miyako/4d-technote-localisation-template)とGitHub Copilotを使用しています。

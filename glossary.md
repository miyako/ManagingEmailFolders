# 用語集 / Glossary

Keep terminology consistent across `src/<target>.md` and `figures/*.<target>.txt`.
Change an entry here first, then search and replace in both places.

Style (ja): です・ます調. Half-width alphanumerics, no space between Japanese and Latin text (e.g. `4D.Vector型`).
Full-width `（）` and `：` in prose. First occurrence of a technical term: 日本語（English）.

## 4D terms (from the official 4D Japanese documentation)

| English | 日本語 | Notes |
|---|---|---|
| entity / entity selection | エンティティ / エンティティセレクション | |
| datastore | データストア | |
| dataclass | データクラス | |
| attribute | 属性 | |
| computed attribute | 計算属性 | |
| collection | コレクション | |
| object | オブジェクト | |
| method | メソッド | |
| project method | プロジェクトメソッド | |
| function | 関数 | |
| class | クラス | |
| parameter | 引数 | |
| form | フォーム | |
| form object | フォームオブジェクト | |
| list box | リストボックス | |
| web area | Webエリア | |
| 4D Web Server | 4D Webサーバー | |
| worker | ワーカー | |
| process | プロセス | |
| query | クエリ | |
| formula | フォーミュラ | |
| component | コンポーネント | |

## Document-specific terms

| English | 日本語 | Notes |
|---|---|---|
| technical note | テクニカルノート | 本文書は24-13。 |
| email / mail | メール | 本文では「Eメール」「電子メール」と混在させない。API名とコードは変更しない。 |
| authorization | 認可 | authentication（認証）と区別する。 |
| authentication | 認証 | 本人確認。原文が認証と認可を混用している箇所は編集レビュー対象とする。 |
| token | トークン | コード内のプロパティ名は変更しない。 |
| access token | アクセストークン | [4D公式日本語記事][ms-access]で表記を確認。 |
| refresh token | リフレッシュトークン | 更新用トークン。動作は[NetKit公式リファレンス][oauth-provider]を参照。 |
| transporter | トランスポーター | [4D公式日本語記事][ms-access]の表記。 |
| client ID | クライアントID | [4D公式日本語記事][ms-access]で表記を確認。 |
| client secret | クライアントシークレット | [4D公式日本語記事][ms-access]で表記を確認。 |
| redirect URI | リダイレクトURI | [4D公式日本語記事][ms-access]に準拠し、和文と英数字の間の空白を省略。 |
| scope | スコープ | APIへのアクセスを許可する範囲。実際のURIは変更しない。 |
| permission | 権限 | 一般名詞の場合。`permission`引数名と`"signedIn"`値は原文どおり。 |
| credentials | 認証情報 | 一般名詞の場合。Google Cloudの画面名`Credentials`はUI文字列の確認まで英語を保持。 |
| consent | 同意 | OAuthのユーザーによる同意。画面名は別途確認する。 |
| signedIn mode | signedInモード | APIの識別子を保持する。 |
| inbox | 受信トレイ | 画面ラベルではなく一般名詞。コード内の`"inbox"`は変更しない。 |
| trash folder | ゴミ箱フォルダー | 原文の一般名詞。Googleの画面ラベルとしては未検証。 |
| folder | フォルダー | 本文中の一般名詞。API識別子は変更しない。 |
| label | ラベル | Gmailのメール分類。識別子と例のラベル名は原文どおり。 |
| mail ID | メールID | 識別子。数値であるという原文の説明は編集レビュー対象とする。 |
| message resource type | メッセージリソース型 | Microsoft Graphのデータ形式。`Microsoft`メールタイプと区別する。 |
| recoverable items deletion folder | 回復可能なアイテムの削除フォルダー | 説明文としての暫定訳。Microsoftの正式なUI表示名ではない。レビュー対象。 |
| delivery receipt / read receipt | 配信確認 / 開封確認 | メールの確認通知。 |
| importance flag | 重要度フラグ | メールの重要度。 |
| tenant | テナント | Microsoft Entraの管理単位。 |
| Microsoft Identity Platform | Microsoft IDプラットフォーム | [4D公式日本語記事][ms-access]の表記に準拠。 |
| Cloud Application Administrator | クラウドアプリケーション管理者 | Azureのロール名の訳。英語名を初出に併記する。 |
| Web Application Expansion license | Web Application Expansionライセンス | 製品名を原文のまま保持。現在のライセンス要件を保証する記述には変更しない。レビュー対象。 |
| Your App | アプリ | 図01の短いラベル。 |
| Google Servers | Googleサーバー | 図01。 |
| Request token | トークン要求 | 図01。 |
| User login & consent | ログインと同意 | 図01。 |
| User | ユーザー | 図01。 |
| Authorization code | 認可コード | 図01では原文と同じ2行に分ける。 |
| Exchange code for token | コードをトークンに交換 | 図01では原文と同じ2行に分ける。 |
| Token response | トークン応答 | 図01。 |
| Use token to call Google API | トークンでGoogle APIを呼び出す | 図01では原文と同じ2行に分ける。 |

UIの暫定方針：スクリーンショット内のGoogle Cloud、Googleアカウント、Microsoftの表示文字列は、
対応する公式日本語リソースと描画条件を確認するまで画像・本文ともに英語を保持します。
この用語集の説明訳を、未検証の公式UI文字列として画像に描画しません。

[ms-access]: https://blog.4d.com/ja/4d-and-microsoft-365-access/
[oauth-provider]: https://developer.4d.com/4D-NetKit/Documentation/Classes/OAuth2Provider.html

## Proper nouns in examples

| English | 日本語 | Notes |
|---|---|---|
| 4D / 4D NetKit | 4D / 4D NetKit | 製品・コンポーネント名。 |
| OAuth 2.0 / OAuth2 | OAuth 2.0 / OAuth2 | 原文の表記を文脈に応じて保持。API識別子は変更しない。 |
| Trina Nguyen | Trina Nguyen | 著者名を原綴りで保持。 |
| Technical Services Engineer | テクニカルサービスエンジニア | 著者の役職。 |
| 4D Inc. | 4D Inc. | 著者の所属。 |
| Google / Gmail / Google Gmail API | Google / Gmail / Google Gmail API | 固有名詞を保持。 |
| Google Calendar API / Google Workspace | Google Calendar API / Google Workspace | 固有名詞を保持。 |
| Microsoft / Microsoft365 / Microsoft 365 | Microsoft / Microsoft365 / Microsoft 365 | 本文ではMicrosoft 365に統一。 |
| Office365 / Office365 API | Office365 / Office365 API | 原文の製品・API表記を保持。`cs.NetKit.Office365`は変更しない。 |
| Microsoft Graph / Microsoft Graph API | Microsoft Graph / Microsoft Graph API | 固有名詞を保持。 |
| Microsoft Entra admin center | Microsoft Entra管理センター | サービス名。 |
| Azure | Azure | 固有名詞を保持。 |
| OAuth2Provider / GoogleProvider / MicrosoftProvider | OAuth2Provider / GoogleProvider / MicrosoftProvider | クラス名・メソッド名を保持。 |
| MIME / JMAP / JSON / REST | MIME / JMAP / JSON / REST | 形式名・技術名を保持。 |
| IMAP / SMTP / POP3 | IMAP / SMTP / POP3 | プロトコル名を保持。 |
| Backup / Backup January / Renamed Backup | Backup / Backup January / Renamed Backup | コード中の例と対応させるため本文でも変更しない。 |
| Work / IMPORTANT | Work / IMPORTANT | コード中のラベル値。変更しない。 |
| 4D NetKit Email Example | 4D NetKit Email Example | OAuth画面のアプリ名。原文にあるNetkitの大小文字の違いも引用では保持。 |
| HDI Manage Mails | HDI Manage Mails | 図13のアプリ名。表示値として保持。 |
| Fabrice Mainguené | Fabrice Mainguené | 人名を原綴りで保持。 |

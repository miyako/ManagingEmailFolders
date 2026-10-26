# 4D NetKitによるメールとフォルダーの管理

著者：Trina Nguyen（4D Inc.のテクニカルサービスエンジニア）

テクニカルノート24-13

## 概要

インターネットでより安全なプロトコルの採用が進むのに伴い、認可（authorization）の仕組みも進化しています。OAuth 2.0は、従来のユーザー名とパスワードを使う方式に代わる、より安全なログイン手順として導入されました。OAuth 2.0では、他のWebアプリから得たユーザー情報を含むトークン（token）を使い、自分のプラットフォームでユーザーを認証（authentication）するため、ユーザーが何度もログインする必要がありません。4D 19R3で導入された4D NetKitは、4Dアプリケーションと外部のWebサービスおよびそのAPIの間のOAuth 2.0接続を管理し、これらのトークンを取得します。このテクニカルノートでは、4D NetKitの基本と、GoogleのGmailおよびMicrosoftのOffice365への接続方法を説明します。

## はじめに

4D NetKitの中心となるOAuth 2.0は、オンラインの認可における業界標準のプロトコルです。4Dは以前からIMAP、SMTP、POP3のトランスポーター（transporter）でOAuth 2.0をサポートしていましたが、4D NetKitの導入により、Webブラウザーの起動と認証処理をより簡単に管理できるようになりました。

OAuth 2.0では、アクセストークン（access token）とリフレッシュトークン（refresh token）の2種類のトークンを使います。アクセストークンは従来のユーザー名とパスワードの代わりとなり、その取得時にはWebブラウザーからユーザーに認可が要求されます。アクセストークンの有効期限が切れると、OAuth 2.0はリフレッシュトークンのフラグが有効になっているかどうかを確認します。リフレッシュトークンはRESTを通じて取得され、アクセストークンの有効期限が切れた後も接続を維持し、期限が切れるたびに新しいアクセストークンを継続して取得できるようにします。このフラグが有効でない場合、ユーザーは新しいアクセストークンを取得するために、Webブラウザーで再び認証をおこなう必要があります。

![](fig-01)

取得したアクセストークンは外部のAPIに送信され、そのトークンに許可された操作を実行できるようになります。たとえば、Google Calendar API用に発行されたトークンと、Google Gmail API用に発行されたトークンでは、アクセスできる範囲が異なります。

## 4D NetKitを使用するための前提条件

まず、最新バージョンの4Dをインストールする必要があります。また、トークンの到着を待ち受けて受信するために、Web Application Expansionライセンスが必要です。このテクニカルノートで説明するメソッドと添付のサンプルデータベースには、4D 20 R6以降が必要です。

4D NetKitを使い始めるには、最初にクライアントID（client ID）とクライアントシークレット（client secret）を設定します。添付のサンプルデータベースにはデモ用に登録済みのアプリケーションが用意されていますが、開発者が自分のプログラムで使う場合は、自分でアプリケーションを登録する必要があります。このテクニカルノートでは、GoogleのGmail APIとMicrosoftのOffice365 APIについて、その設定方法を説明します。

## クライアントシークレットを取得するためのGoogleアプリケーションの登録

Googleアプリケーションのクライアントシークレットを取得するには、次の手順に従います。

1. https://console.developers.google.com/ にログインします。
2. 左側のサイドバーの「API’s & Services」で、**Credentials**をクリックします。

![](fig-02)

3. **Create Project**をクリックしてアプリケーションを作成します。
4. プロジェクト名を入力し、**Create**をクリックしてCredentials画面に戻ります。
5. **Configure Consent Screen**をクリックします。

![](fig-03)

6. User Typeで**External**を選択し、**Create**をクリックして次に進みます。

![](fig-04)

7. **Edit app registration**画面で必須項目を入力します。アプリのドメインの項目は、この時点では空欄のままでかまいません。**Save and Continue**をクリックして次に進みます。
8. **Scopes**画面で、**Save and Continue**をクリックします。アプリケーションに適した追加のスコープ（scope）は、後から設定できます。
9. **Test users**画面で、**Add Users**をクリックし、Testingモードでこのアプリケーションを使うユーザーのメールアドレスを追加します。**Save and continue**をクリックします。

![](fig-05)

10. **Summary**画面で、ページ下部の**Back to dashboard**をクリックします。
11. **Credentials**画面に戻り、**Create Credentials**をクリックして**OAuth client ID**を選択します。

![](fig-06)

12. **Desktop app**を選択し、アプリ名を入力して**Create**をクリックします。
13. アプリケーションのクライアントIDとクライアントシークレットを表示するポップアップウィンドウが開きます。**DOWNLOAD JSON**リンクをクリックすると、これらの情報を.jsonファイルとして保存できます。また、後から**Credentials**画面でいつでも確認できます。この情報は、このテクニカルノートの後半で使用します。**OK**をクリックして次に進みます。

![](fig-07)

14. 左側のサイドバーに戻り、**Library**タブをクリックします。

![](fig-08)

15. 下にスクロールし、**Google Workspace**の下にある**Gmail API**のタイルをクリックします。

![](fig-09)

16. 青い**Enable**ボタンをクリックして、このアプリケーションからGmail APIを呼び出せるようにします。

![](fig-10)

この時点で、アプリケーションを「testing」ステータスのままにして、公開後のプログラムの動作をテストできます。ただし、ユーザーのアカウントからメールを送受信する権限など、機密性の高いスコープを使う場合は、Googleの確認手続きを受けるための準備が必要です。詳細は次のリンクを参照してください。

https://support.google.com/cloud/answer/13463073?authuser=3&visit_id=638622395066771837-2271496442&rd=1

## 接続の確立とアクセストークンの取得

Googleからアクセストークンを取得して接続を確立するには、まず4D NetKitのOAuth2Providerオブジェクト（object）を作成し、前のセクションで取得したクライアントシークレットなどの情報を設定します。

```4d
// Creates the object that contains all the information for the OAuth2 connection
#DECLARE : cs.NetKit.OAuth2Provider

var $param : Object

$param:=New object()
$param.name:="Google"
$param.permission:="signedIn"
$param.clientId:="YOUR CLIENT ID"
$param.clientSecret:="YOUR CLIENT SECRET"
$param.redirectURI:="http://127.0.0.1:50993/authorize/"
$param.scope:="https://www.googleapis.com/auth/gmail.send"

// Create new OAuth2 object
return cs.NetKit.OAuth2Provider.new($param)
```

`.permission`引数（parameter）は、MicrosoftまたはGoogleを通じてユーザーをサインインさせる「signedIn」を使うのか、Microsoftにアプリケーション自身のIDでアクセスするのか、またはGoogleにユーザーなしでアクセスするのかを指定します。クライアントIDとクライアントシークレットには、前のセクションで取得したシークレットのJSONファイルにある値を使います。リダイレクトURI（redirect URI）は「signedIn」モードでのみ使用し、認証後にサーバーがユーザーを転送する場所を指定します。通常は、認可が成功したことを確認するために使います。スコープは、開発者がユーザーに同意を求めるAPIの権限の集合です。

次に、`.getToken()`メソッド（method）を使うと、既定のブラウザーウィンドウでURLが開き、ユーザーが認証情報を入力して接続できます。次のコードでは、上のコードで示した*GoogleProvider*メソッドが返すOAuth2オブジェクトを使います。

```4d
var $google : cs.NetKit.Google

Form.oAuth2:=GoogleProvider
Form.oAuth2.getToken()
```

開いたURLでは、次のような画面が表示されます。「Error 403: access_denied」画面が表示された場合は、認証に使うメールアドレスが、**OAuth consent screen**の**Test users**に追加したユーザーと一致していることを確認してください。アプリが「Testing」ステータスの場合、使うメールアドレスが**Test users**の一覧に含まれていれば接続できます。

![](fig-11)

この段階でアプリが「In Production」ステータスになっていて、まだ確認を受けていない場合、Googleは接続を許可する前にアプリの確認が必要であることを通知する画面を表示します。

サンプルデータベースはデモ用の簡単なテストアプリケーションであり、正式なWebドメインと関連付けられていないため、Googleが未確認のアプリであるという警告を表示することがあります。このサンプルアプリは4Dのプライバシーポリシーに従っており、個人情報やメールが共有または変更されることはありません。処理を続けるには、**Advanced**をクリックし、続いて**Go to 4D Netkit Email Example (unsafe)**をクリックします。

![](fig-12)

ユーザーは、アプリによるメールとメールラベルへのアクセスを許可するか、拒否するかを選択できます。接続を許可するには、**Continue**をクリックします。

接続に成功すると、ブラウザーはOAuth2オブジェクトに設定したリダイレクトURIを開こうとします。この例ではhttp://127.0.0.1:50993/authorize/です。「signedIn」モードでは、4D NetKitに含まれるWebサーバーが指定されたポート（50993）で自動的に起動し、プロバイダーからの応答を受け取ってブラウザーに表示します。この例では、既定のページが表示されます。

## Google Gmail APIによるメールの送信・受信・削除

Gmail APIで4D NetKitを使う最初の例として、メールの送信を説明します。まず、前のセクションのOAuth2オブジェクトを使ってGoogleオブジェクトを作成します。`mailType`引数はメールの送受信に使うメール形式を指定し、「MIME」と「JMAP」を選択できます。

```4d
$google:=cs.NetKit.Google.new(Form.oAuth2; New object("mailType"; "JMAP"))
```

作成したオブジェクトには、メールを送信する`mail.send()`関数（function）が含まれています。

```4d
// Email creation
$email:=New object
$email.from:="youremail@gmail.com"
$email.to:=”destinationmail@mail.com"
$email.subject:=”Test Gmail API"
$email.textBody:=”this is a Gmail API test"

// Email sending
$status:=$google.mail.send($email)
```

メールを取得するには、`.getMailIds()`関数を使って受信トレイ（inbox）内のすべてのメールIDを取得します。特定のIDのメール内容をダウンロードするには、`.getMail()`関数を使います。`.getMails()`関数を使って、`$mailIds`からメールのコレクション（collection）を取得することもできます。メールはMIME形式またはJMAP形式で返されます。

```4d
#DECLARE($OAuth2Provider : cs.NetKit.OAuth2Provider; $param : Object; $winRef : Integer)

var $mailIds:=[]
var $mails:=[]
var $mailId : Object
var $google : cs.NetKit.Google

$google:=cs.NetKit.Google.new($OAuth2Provider)

// Grabs the email ID
$mailIds:=$google.mail.getMailIds($param).mailIds

// Downloads the collection of emails from the mailID
If ($mailIds.length>0)

    $mails:=$google.mail.getMails($mailIds)
End if
```

4D NetKitでは、`.delete()`関数を使ってメールを完全に削除するか、ゴミ箱フォルダーに移動するかを選択できます。次の例は、受信トレイの最新のメールを完全に削除する場合と、ゴミ箱に移動する場合を示しています。

```4d
// Delete permanently a mail
$status:=$google.mail.delete($mailIds.mailIds.first().id; True)

// Move a mail to the trash
$status:=$google.mail.delete($mailIds.mailIds.first().id; False)
```

## メールラベルの作成・更新・割り当て

メールのラベル（label）は、`.createLabel()`関数で簡単に作成できます。次の例では「Backup」というラベルを作成します。

```4d
$status:=$google.mail.createLabel({name: "Backup"})
$labelId:=$status.label.id
```

ラベルIDを使って、ラベル名、メッセージの総数、未読メッセージ数を取得できます。

```4d
$info:=$google.mail.getLabel($labelId)
$name:=$info.name
$emailNumber:=$info.messagesTotal
$unread:=$info.messagesUnread
```

`type`が「user」のラベルでは、`.updateLabel()`関数を使って名前、表示設定、色を更新できます。たとえば、次のようにラベルの名前を変更できます。

```4d
$status:=$google.mail.updateLabel($labelId; {name:"Backup January"})
```

メールへのラベルの割り当てを更新するには、`.update()`関数を使い、特定のメールIDまたは複数のメールIDに対してラベルを追加・削除します。

```4d
// Updates email in $mailIds to have the "Work" and "IMPORTANT" labels
$status:=$google.mail.update($mailIds; {addLabelIds: ["Work"; "IMPORTANT"]})

// Updates email in $mailIds to remove the "IMPORTANT" label
$status:=$google.mail.update($mailIds; {removeLabelIds: ["IMPORTANT"]})
```

## Microsoft IDプラットフォームへのアプリケーションの登録

NetKitを使ってMicrosoft 365に接続する前に、Microsoft Entra管理センターでアプリケーションを登録する必要があります。

Microsoftへのアプリケーション登録には、いくつかの前提条件があります。有効なサブスクリプションを持つAzureアカウントが必要で、少なくともクラウドアプリケーション管理者（Cloud Application Administrator）のロールが割り当てられている必要があります。また、テナント（tenant）を設定するクイックスタートを完了しておく必要があります。

これらの手順については、次のリンク先にあるMicrosoftの説明に従ってください。https://learn.microsoft.com/en-us/entra/identity-platform/quickstart-register-app?tabs=certificate

## 接続の確立とアクセストークンの取得

アプリケーションを登録すると、Googleに接続した前の例とほぼ同じ手順で接続できます。まずOAuth2オブジェクトを作成し、登録したアプリケーションから取得したクライアントIDと関連情報を設定します。

```4d
// Creates the object that contains all the information for the OAuth2 connection
#DECLARE : cs.NetKit.OAuth2Provider

var $param : Object

$param:=New object()
$param.name:="Microsoft"
$param.permission:="signedIn"
$param.clientId:="YOUR CLIENT ID"
$param.redirectURI:="http://127.0.0.1:50993/authorize/"
$param.scope:=" https://graph.microsoft.com/.default"

// Create new OAuth2 object
return cs.NetKit.OAuth2Provider.new($param)
```

次に、`.getToken()`コマンドを使ってMicrosoft Officeのウィンドウを開き、アクセストークンを取得します。

```4d
var $office365 : cs.NetKit.Office365

Form.oAuth2:=MicrosoftProvider
Form.oAuth2.getToken()
```

ブラウザーウィンドウでは、次のようなページが開きます。

![](fig-13)

## Microsoft Graph APIによるメールの送信・受信・削除

まず、上のOAuth2情報からMicrosoft 365オブジェクトを作成します。Googleオブジェクトと同様に、Office365の`mailType`にはMIMEとJMAPを指定できます。ただし、既定値は追加のメール形式である「Microsoft」です。

```4d
$office365:=cs.NetKit.Office365.new($oAuth2; New object("mailType"; "Microsoft"))
```

次に、送信するメールのオブジェクトを作成します。次のコード例では、Microsoft Graphの「メッセージリソース型（message resource type）」の形式を使います。

```4d
var $office365 : cs.NetKit.Office365

$email:=New object
$email.from:=New object
$email.from.emailAddress:="yourEmail@mail.com"

$addressTo:=New object
$addressTo.emailAddress:=New object
$addressTo.emailAddress.email:="sendToAddress@mail.com"

$email.subject:="Hello world"

$email.body:=New object
$email.body.content:="Test content mail"
$email.body.contentType:="text"

$status:=$office365.mail.send($email)
```

これはメールオブジェクトの最小限の例ですが、受信者名の指定、配信確認や開封確認の要求、重要度フラグの付加なども可能です。

メールを取得するには、まずメールフォルダーのコレクションを取得し、その中から対象のフォルダーを選択します。

```4d
$folderList:=$office365.mail.getFolderList()

// Collection with all the mail folder directly under the root folder
$folders:=$folderList.folders
```

次に、`.getMails()`関数を使って、そのフォルダー内のすべてのメールを取得します。フォルダーは数値のIDで指定できます。また、ユーザー向けに既定で作成されるフォルダーの場合は、名前で指定することもできます。次のコード例では、受信トレイ内のメールを取得します。

```4d
$param:=New object
$param.folderId:="inbox"

$mails:=$office365.mail.getMails($param)
```

メールを削除するには、`.delete()`関数を使います。次の例では、`$mails`コレクション内のすべてのメールを削除します。

```4d
For each ($mail; $mails)

    $office365.mail.delete($mail.id)
End for each
```

> **注意：** Googleとは異なり、Microsoftの回復可能なアイテムの削除フォルダーからは、アイテムを完全に削除できない場合があります。詳細は、次のリンク先にあるMicrosoftのドキュメントを参照してください。https://learn.microsoft.com/en-us/graph/api/message-delete?view=graph-rest-1.0&tabs=http

## メールフォルダーの作成・名前の変更・削除

フォルダー（folder）は、`.createFolder()`関数を使う1行のコードで簡単に作成できます。作成したフォルダーには、`.move()`コマンドを使ってすぐにメールを移動できます。次のコードでは、「Backup」フォルダーの作成とメールの移動を示します。

```4d
// Creates a new folder in the root
$status:=$office365.mail.createFolder("Backup")
If ($status.success)

    $folderId:=$status.id


    // Moves your email in the new folder

    $status:=$office365.mail.move($mailId; $folderId)
End if
```

作成したフォルダーの名前は、`.renameFolder()`関数で変更できます。

```4d
$status:=$office365.mail.renameFolder($folderId; "Renamed Backup")
$folderId:=$status.id
```

最後に、`.deleteFolder()`コマンドでフォルダー全体を削除します。

```4d
$status:=$office365.mail.deleteFolder($folderId)
```

> **注意：** このコマンドは指定したフォルダー内のすべてのメールを削除するため、実行前に十分に確認してください。

## 参考資料

4D NetKitと、そのすべてのクラス（class）およびコマンドのドキュメントは、4DのGitHubリポジトリで公開されています。Google、Microsoft、および基本となるOAuth2Providerクラスで4D NetKitを使う追加の例は、Fabrice Mainguenéによる4Dブログの記事とサンプルデータベースで紹介されています。どちらの資料も、次のリンクから参照できます。

https://github.com/4d/4D-NetKit

https://blog.4d.com/tag/4d-netkit/

## おわりに

このテクニカルノートでは、GoogleのGmail APIとMicrosoftのOffice365 APIを使うためのアプリケーションの設定から、4D NetKitで接続を確立し、よく使う関数を呼び出す方法までを説明しました。インターネットのプロトコルが進化し、変化し続ける中で、既存の外部APIに簡潔で使いやすい方法で認証・接続できることが、4D開発者にとってますます重要になっています。

//#DECLARE : cs.NetKit.OAuth2Provider
var $google : cs:C1710.NetKit.Google
var $user : Object

Form:C1466.oAuth2:=GoogleProvider
If (Form:C1466.oAuth2=Null)
	return
End if
Form:C1466.oAuth2.getToken()

// Inits the office365 object
$google:=cs:C1710.NetKit.Google.new(Form:C1466.oAuth2; New object:C1471("mailType"; "JMAP"))


Form:C1466.numberMails:=10

//get label collection
$labels:=$google.mail.getLabelList()

//creating lists for the hierarchical list
$listObject:=cs:C1710.CreateLabelObject.new($labels).createList()
var $list:=cs:C1710.ListManager.new($listObject)

Form:C1466.listManager:=$list
Form:C1466.labels:=$labels.labels

$mailIds:=$google.mail.getMailIds($param).mailIds

If ($mailIds.length>0)
	$mails:=$google.mail.getMails($mailIds)
End if 

Form:C1466.mails:=$mails

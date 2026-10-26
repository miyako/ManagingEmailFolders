
var $office365 : cs:C1710.NetKit.Office365
var $user : Object

Form:C1466.oAuth2Micro:=MicrosoftProvider
If (Form:C1466.oAuth2Micro=Null)
	return
End if
Form:C1466.oAuth2Micro.getToken()

$folders:=cs:C1710.Folders.new(Form:C1466.oAuth2Micro)
$folders.createList()
Form:C1466.folders:=$folders

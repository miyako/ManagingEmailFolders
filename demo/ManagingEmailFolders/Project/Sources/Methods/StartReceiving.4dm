//%attributes = {}
// Start receiving of the mail list according to the number of mail defined by Form.numberMails
var $listID : Integer
var $param : Object

ARRAY LONGINT:C221($arr; 0)

If (Is a list:C621(Form:C1466.listManager.listRef))
	$listID:=Selected list items:C379(Form:C1466.listManager.listRef; $arr; *)
	
	If (Form:C1466.listManager.search($listID)#Null:C1517)
		
		// Search the label information of the selected label
		Form:C1466.currentlabel:=Form:C1466.listManager.search($listID)
		
		// Reset the mail list
		Form:C1466.mails:=New collection:C1472
		
		// getMails paramters
		$param:=New object:C1471()
		
		// Label containing the emails
		$param.labelIds:=[Form:C1466.currentlabel.id]
		
		// Number emails returned by the server
		$param.top:=Form:C1466.numberMails
		
		// Start the download of the emails
		CALL WORKER:C1389("myWorker"; Formula:C1597(GetMails); Form:C1466.oAuth2; $param; Current form window:C827)
	End if 
End if 
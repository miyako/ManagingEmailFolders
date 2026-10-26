var $office365 : cs:C1710.NetKit.Office365
var $status : Object
var $mail : Object


If ((Form:C1466.mail.to#"") && (Form:C1466.mail.from#""))
	Form:C1466.mail.sender:=Form:C1466.mail365.from
	// Creates a provider to send an email in Microsoft format
	$office365:=cs:C1710.NetKit.Office365.new(Form:C1466.oAuth2Micro; New object:C1471("mailType"; "JMAP"))
	
	// Send the email
	$status:=$office365.mail.send(Form:C1466.mail365)
	
	If ($status.success)
		ALERT:C41(Get localized string:C991("AlertEmailSent"))
	Else 
		ALERT:C41(Replace string(Get localized string:C991("AlertError"); "{error}"; $status.statusText))
	End if 
Else 
	ALERT:C41(Get localized string:C991("AlertMissingMailFields"))
End if 
//%attributes = {}
#DECLARE($OAuth2Provider : cs:C1710.NetKit.OAuth2Provider; $param : Object; $winRef : Integer)
// Download the emails according the $param
// $OAuth2Provider -> Provider for the connection to the server 
// $param -> Parameters for the NetKit getmails function
// $winRef -> Ref of the caller worker 

var $mails : Collection

// Downloads the emails
$mails:=cs:C1710.NetKit.Office365.new($OAuth2Provider).mail.getMails($param).mails

// Returns the formula to the mail process
CALL FORM:C1391($winRef; Formula:C1597(Form:C1466.mailsMicro:=$mails))

// Returns the OAuth2Provider with the updated token to the main process
CALL FORM:C1391($winRef; Formula:C1597(Form:C1466.oAuth2Micro:=$OAuth2Provider))

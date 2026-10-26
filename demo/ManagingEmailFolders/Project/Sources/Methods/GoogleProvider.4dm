//%attributes = {"invisible":true}
// Creates the object that contains all the information for the OAuth2 connection 
#DECLARE : cs:C1710.NetKit.OAuth2Provider

var $param : Object
var $configuration : Object

$configuration:=LoadOAuthConfiguration("Google")
If (Not($configuration.success))
	ALERT(Replace string(Get localized string:C991($configuration.messageId); "{provider}"; "Google"))
	return Null
End if

$param:=New object:C1471()
$param.name:="Google"
$param.permission:="signedIn"
$param.clientId:=$configuration.credentials.clientId
$param.clientSecret:=$configuration.credentials.clientSecret
$param.redirectURI:="http://127.0.0.1:50993/authorize/"
$param.scope:="https://www.googleapis.com/auth/gmail.modify"  //manage labels + send emails
$param.timeout:=60

// Create new OAuth2 object
return cs:C1710.NetKit.OAuth2Provider.new($param)
//%attributes = {"invisible":true}
var $status; $param : Object
var $configuration : Object

$configuration:=LoadOAuthConfiguration("Microsoft")
If (Not($configuration.success))
	ALERT(Replace string(Get localized string:C991($configuration.messageId); "{provider}"; "Microsoft"))
	return Null
End if

$param:=New object:C1471()
$param.name:="Microsoft"
$param.permission:="signedIn"
// Parameters created in Microsoft identity platform
$param.clientId:=$configuration.credentials.clientId
$param.redirectURI:="http://127.0.0.1:50993/authorize/"
$param.scope:="https://graph.microsoft.com/.default"


return cs:C1710.NetKit.OAuth2Provider.new($param)
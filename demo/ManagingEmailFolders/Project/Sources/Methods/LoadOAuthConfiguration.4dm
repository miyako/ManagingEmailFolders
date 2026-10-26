//%attributes = {"invisible":true}
#DECLARE($provider : Text; $file : 4D.File)->$result : Object

var $document; $credentials; $value : Variant
var $required : Collection
var $key; $previousHandler : Text
var DemoConfigurationReadFailed : Boolean

$result:={success: False; messageId: "ConfigurationMissing"}
If (Count parameters<2)
	$file:=File("/RESOURCES/oauth.local.json")
End if
If (Not($file.exists))
	return $result
End if

DemoConfigurationReadFailed:=False
$previousHandler:=Method called on error
ON ERR CALL("DemoConfigurationReadError")
$document:=JSON Parse($file.getText())
ON ERR CALL($previousHandler)

$result.messageId:="ConfigurationInvalid"
If (DemoConfigurationReadFailed)
	return $result
End if
If (Value type($document)#Is object)
	return $result
End if
$credentials:=$document[$provider]
$result.messageId:="ConfigurationProviderMissing"
If (Value type($credentials)#Is object)
	return $result
End if

$required:=["clientId"]
If ($provider="Google")
	$required.push("clientSecret")
End if
$result.messageId:="ConfigurationFieldsMissing"
For each ($key; $required)
	$value:=$credentials[$key]
	If (Value type($value)#Is text)
		return $result
	End if
	If ((Length(Replace string($value; " "; ""))=0) || (Position("YOUR "; $value)=1))
		return $result
	End if
End for each

$result:={success: True; credentials: $credentials}

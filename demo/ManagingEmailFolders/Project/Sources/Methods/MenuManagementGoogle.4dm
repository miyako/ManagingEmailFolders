//%attributes = {"invisible":true}
#DECLARE->$vlUserChoice : Integer

var $vtItems : Text

$vlUserChoice:=0

// Open pop up menu
If (Form:C1466.currentlabel#Null:C1517)
	$vtItems:=Get localized string:C991("MenuLabelActions")
	
	// Open the menu
	$vlUserChoice:=Pop up menu:C542($vtItems)
Else 
	// If no folder selected, you can create a folder 
	$vtItems:=Get localized string:C991("MenuNewLabel")
	$vlUserChoice:=Pop up menu:C542($vtItems)
End if 
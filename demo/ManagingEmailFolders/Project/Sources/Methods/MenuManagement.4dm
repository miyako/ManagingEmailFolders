//%attributes = {"invisible":true}
#DECLARE->$vlUserChoice : Integer

var $vtItems : Text

$vlUserChoice:=0

// Open pop up menu
If (Form:C1466.currentFolder#Null:C1517)
	$vtItems:=Get localized string:C991("MenuFolderActions")
	
	// Open the menu
	$vlUserChoice:=Pop up menu:C542($vtItems)
Else 
	// If no folder is selected, you can create a folder 
	$vtItems:=Get localized string:C991("MenuNewFolder")
	$vlUserChoice:=Pop up menu:C542($vtItems)
End if 

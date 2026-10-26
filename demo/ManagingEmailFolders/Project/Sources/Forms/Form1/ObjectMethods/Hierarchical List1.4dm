Case of 
	: (FORM Event:C1606.code=On Selection Change:K2:29)
		// Emails downloading
		StartReceivingMicro
		
		
	: (FORM Event:C1606.code=On Clicked:K2:4)
		var $office365 : cs:C1710.NetKit.Office365
		
		If (Right click:C712)
			var $status : Object
			var $name : Text
			var $vlUserChoice : Integer
			
			// Menu displaying dependent on whether folder is selected
			$vlUserChoice:=MenuManagement
			
			If (($vlUserChoice>0) && (Form:C1466.trace))
				TRACE:C157
			End if 
			
			$office365:=cs:C1710.NetKit.Office365.new(Form:C1466.oAuth2Micro)
			
			Case of 
					// Create a new mail box as child of the selected folder
				: ($vlUserChoice=1)
					
					$name:=Request:C163(Get localized string:C991("RequestNewFolderName"); ""; Get localized string:C991("AlertButtonCreate"); Get localized string:C991("CommonCancel"))
					If ((Bool:C1537(OK)) && ($name#""))
						If ((Form:C1466.currentFolder#Null:C1517) && (Form:C1466.currentFolder.id#Null:C1517))
							// Add a new children folder to the selected folder
							$status:=$office365.mail.createFolder($name; False:C215; Form:C1466.currentFolder.id)
						Else 
							// Add a new folder to the root
							$status:=$office365.mail.createFolder($name)
						End if 
					End if 
					
					//Remove a folder 
				: ($vlUserChoice=2)
					CONFIRM:C162(Replace string(Get localized string:C991("ConfirmDeleteFolder"); "{name}"; Form:C1466.currentFolder.displayName); Get localized string:C991("AlertButtonDelete"); Get localized string:C991("CommonCancel"))
					If (Bool:C1537(OK))
						// Deleting of the selected folder
						$status:=$office365.mail.deleteFolder(Form:C1466.currentFolder.id)
					End if 
					
					//Rename a folder
				: ($vlUserChoice=3)
					$name:=Request:C163(Replace string(Get localized string:C991("RequestRenameFolder"); "{name}"; Form:C1466.currentFolder.displayName); ""; Get localized string:C991("AlertButtonRename"); Get localized string:C991("CommonCancel"))
					If ((Bool:C1537(OK)) && ($name#""))
						// Rename the folder selected
						$status:=$office365.mail.renameFolder(Form:C1466.currentFolder.id; $name)
					End if 
					
					
			End case 
			
			If ($status#Null:C1517)
				// If no error, reloads the email list
				If (Bool:C1537($status.success))
					// Start the creation of the folder list
					CALL WORKER:C1389("myWorker"; Formula:C1597(GetFolders); Form:C1466.oAuth2Micro; Current form window:C827)
				Else 
					ALERT:C41(Replace string(Get localized string:C991("AlertError"); "{error}"; $status.statusText))
				End if 
			End if 
			
		End if 
End case 
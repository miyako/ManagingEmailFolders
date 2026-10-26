Case of 
	: (FORM Event:C1606.code=On Selection Change:K2:29)
		
		// init attachments list
		Form:C1466.attachments:=New object:C1471
		
		StartReceiving
		
	: (FORM Event:C1606.code=On Clicked:K2:4)
		var $google : cs:C1710.NetKit.Google
		
		If (Right click:C712)
			var $status : Object
			var $name : Text
			var $vlUserChoice : Integer
			
			// Menu displaying dependent on whether label is selected
			$vlUserChoice:=MenuManagementGoogle
			
			If (($vlUserChoice>0) && (Form:C1466.trace))
				TRACE:C157
			End if 
			
			$google:=cs:C1710.NetKit.Google.new(Form:C1466.oAuth2)
			
			Case of 
					// Create a new mail box as child of the selected folder
				: ($vlUserChoice=1)
					
					$name:=Request:C163(Get localized string:C991("RequestNewLabelName"); ""; Get localized string:C991("AlertButtonCreate"); Get localized string:C991("CommonCancel"))
					If ((Bool:C1537(OK)) && ($name#""))
						If ((Form:C1466.currentlabel#Null:C1517) && (Form:C1466.currentlabel.name#Null:C1517))
							// Add a new children folder to the selected folder
							// Need to cast the name as an object
							$status:=$google.mail.createLabel({name: $name})
						Else 
							// Add a new folder to the root
							// Need to cast the name as an object
							$status:=$google.mail.createLabel({name: $name})
						End if 
					End if 
					
					//Remove a folder 
				: ($vlUserChoice=2)
					CONFIRM:C162(Replace string(Get localized string:C991("ConfirmDeleteLabel"); "{name}"; Form:C1466.currentlabel.name); Get localized string:C991("AlertButtonDelete"); Get localized string:C991("CommonCancel"))
					If (Bool:C1537(OK))
						// Deleting of the selected folder
						$status:=$google.mail.deleteLabel(Form:C1466.currentlabel.id)
					End if 
					
					//Rename a folder
				: ($vlUserChoice=3)
					$name:=Request:C163(Replace string(Get localized string:C991("RequestRenameLabel"); "{name}"; Form:C1466.currentlabel.name); ""; Get localized string:C991("AlertButtonRename"); Get localized string:C991("CommonCancel"))
					If ((Bool:C1537(OK)) && ($name#""))
						// Rename the folder selected
						$status:=$google.mail.updateLabel(Form:C1466.currentlabel.id; {name: $name})
					End if 
					
					
			End case 
			
			If ($status#Null:C1517)
				// If no error, reloads the email list
				If (Bool:C1537($status.success))
					// Start the creation of the folder list
					CALL WORKER:C1389("myWorker"; Formula:C1597(GetLabels); Form:C1466.oAuth2; Current form window:C827)
				Else 
					ALERT:C41(Replace string(Get localized string:C991("AlertError"); "{error}"; $status.statusText))
				End if 
			End if 
			
		End if 
End case 
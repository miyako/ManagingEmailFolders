Class constructor($OAuth2Provider : cs:C1710.NetKit.OAuth2Provider)
	
	// List of folders returned by the server
	This:C1470._folders:=New collection:C1472
	This:C1470.OAuth2Provider:=$OAuth2Provider
	This:C1470.count:=0
	
	// Creation of a list to display the folder name in a hierarchical list
Function createList($parentFolderId : Text)->$listRef : Integer
	var $ref : Integer
	var $mailCount : Text
	var $folder; $param; $page : Object
	
	$listRef:=New list:C375
	
	$param:=New object:C1471
	$param.top:=100
	
	If ($parentFolderId="")
		// Gets the folder collection directly under the root folder.
		$page:=cs:C1710.NetKit.Office365.new(This:C1470.OAuth2Provider).mail.getFolderList($param)
		This:C1470.listRef:=$listRef
	Else 
		// Gets folder for children of the $parentFolderId folder 
		$param.folderId:=$parentFolderId
		$page:=cs:C1710.NetKit.Office365.new(This:C1470.OAuth2Provider).mail.getFolderList($param)
	End if 
	
	Repeat 
		
		// loop on all the folders
		For each ($folder; $page.folders)
			
			// test if it is necessary to create a new hierarchy
			If ($folder.childFolderCount>0)
				$ref:=This:C1470.createList($folder.id)
				This:C1470.count+=1
				$mailCount:=" ("+String:C10($folder.totalItemCount)+")"
				// create a new hierarchy with the folder information 
				APPEND TO LIST:C376($listRef; $folder.displayName+$mailCount; This:C1470.count; $ref; False:C215)
			Else   // add to the current hierarchy
				This:C1470.count+=1
				$mailCount:=" ("+String:C10($folder.totalItemCount)+")"
				// add the folder information to the current hierachy
				APPEND TO LIST:C376($listRef; $folder.displayName+$mailCount; This:C1470.count)
			End if 
			// add utils information in _folders collection for the search
			$folder.listId:=This:C1470.count
			This:C1470._folders.push($folder)
			
		End for each 
		
	Until (Not:C34($page.next()))
	
	// Search folder information according to the hierarchical list Id
Function search($listId : Integer) : Object
	
	var $folders : Collection
	
	// search by listId in the _folders collection
	$folders:=This:C1470._folders.query("listId=:1"; $listId)
	
	If ($folders.length=0)
		return Null:C1517
	Else 
		return $folders[0]
	End if 
	
	
	
	
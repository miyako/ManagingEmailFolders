Class constructor($labels : Object)
	
	// List of labels returned by the server
	This:C1470._labels:=$labels
	
	// Gets the label list from Gmail and transforms it to an object usable by ListManager class
Function createList() : Object
	var $label : Text
	var $root; $currentLvl; $labelInfo : Object
	var $split : Collection
	var $itemRef : Integer
	
	$root:={}
	If (This:C1470._labels.success)
		// Reads each item of the labels collection to create the label tree structure
		For each ($labelInfo; This:C1470._labels.labels.query("labelListVisibility=null or labelListVisibility!=labelHide"))
			$split:=Split string:C1554($labelInfo.name; "/")
			$currentLvl:=$root
			
			For each ($label; $split)
				// checks if a label already exist
				If ($currentLvl[$label]=Null:C1517)
					
					// adds the new children to the list
					$currentLvl[$label]:=cs:C1710.ListItem.new($itemRef)
					// calculates next item ref
					$itemRef+=1
				End if 
				$currentLvl:=$currentLvl[$label]
				
				If ($split.last()=$label)
					// Memorizes the current label object
					$currentLvl._label:=$labelInfo
					
					// Default text color
					$currentLvl.Color:=0
					
					// Creation of an icon if a background Color is present
					If ($labelInfo.color.backgroundColor#Null:C1517)
						$currentLvl.Icon:=This:C1470._createIcon(String:C10($labelInfo.color.backgroundColor); String:C10($labelInfo.color.textColor); $label[[1]])
					End if 
					
				End if 
				
			End for each 
		End for each 
	End if 
	return $root
	
	// Transforms hexadecimal color to decimal
Function _hexaToDec($hexa : Text) : Integer
	
	$hexa:=Replace string:C233($hexa; "#"; "")
	
	return Formula from string:C1601("0x"+$hexa).call()
	
	// Creates a circle icon with $backgroundColor as background color
	// Write a lettre in it if $char present with $textColor as text color
Function _createIcon($backgroundColor : Text; $textColor : Text; $char : Text) : Picture
	var $picture : Picture
	
	If ($backgroundColor#"")
		var $svg; $objectRef : Text
		
		$svg:=SVG_New(16; 16)
		
		// Circle creation
		$objectRef:=SVG_New_circle($svg; 8; 8; 7; $backgroundColor; $backgroundColor)
		
		// Text writing
		If ($char#"")
			$objectRef:=SVG_New_text($svg; $char; 8; 2; "Arial"; 9; 0; Align center:K42:3; $textColor)
		End if 
		
		SVG EXPORT TO PICTURE:C1017($svg; $picture)
		
	End if 
	
	return $picture
	
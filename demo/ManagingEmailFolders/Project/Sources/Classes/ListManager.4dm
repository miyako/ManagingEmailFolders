Class constructor($currentobject : Object)
	This:C1470.list:=[]
	This:C1470.listRef:=0
	This:C1470.create($currentobject)
	
Function create($currentobject : Object) : Integer
	var $label : Object
	var $listID : Integer
	var $icon : Picture
	var $labelName : Text
	
	$listID:=New list:C375
	
	For each ($labelName; $currentobject)
		// If $labelName first letter is "_", it is considered as hidden and not added to the list
		If (($labelName[[1]]#"_") && (Value type:C1509($currentobject[$labelName])=Is object:K8:27))
			
			$label:=$currentobject[$labelName]
			// Add the label to the search list
			This:C1470.list.push({itemRef: $label.ItemRef; item: $label})
			
			// Create the new item in the list
			APPEND TO LIST:C376($listID; $labelName; $label.ItemRef)
			
			// Set the enterable, style and color porperties
			SET LIST ITEM PROPERTIES:C386($listID; $label.ItemRef; Bool:C1537($label.Enterable); Num:C11($label.Style); 0; Num:C11($label.Color))
			
			// add an icon if $label.Icon exist 
			If ($label.Icon#Null:C1517)
				$icon:=$label.Icon
				SET LIST ITEM ICON:C950($listID; $label.ItemRef; $icon)
			End if 
			
			var $sublistRef:=This:C1470.create($label)
			If ($sublistRef>0)
				// Bind a sublist to the current item
				SET LIST ITEM:C385($listID; $label.ItemRef; $labelName; $label.ItemRef; $sublistRef; Bool:C1537($label.Expanded))
				
			End if 
			
		End if 
		
	End for each 
	
	This:C1470.listRef:=$listID
	
	return $listID
	
	
	// Search label information according to the hierarchical list Id
Function search($itemRef : Integer) : Object
	
	var $labels : Collection
	
	// search by listId in the _labels collection
	$labels:=This:C1470.list.query("itemRef=:1"; $itemRef)
	
	If ($labels.length=0)
		return Null:C1517
	Else 
		return $labels.first().item._label
	End if 
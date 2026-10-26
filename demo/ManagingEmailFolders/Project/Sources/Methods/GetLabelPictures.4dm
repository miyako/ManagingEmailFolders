//%attributes = {}
#DECLARE($labelIds : Collection)->$picture : Picture

var $svg; $objectRef; $backgroundColor; $textColor; $id : Text
var $defaultBackgroundColor:="#E5E4E2"
var $defaultTextColor:="black"
var $fontSize:=10
var $letterWidth:=6
var $offset:=0
var $margin:=4
var $padding:=2
var $width:=0
var $length:=0
var $labels:=[]
var $labelTmp : Collection
var $label : Object

For each ($id; $labelIds)
	$labelTmp:=Form:C1466.labels.query("id=:1"; $id)
	If ($labelTmp.length>0)
		// Creates the list of labels to present in the picture 
		$labels.push($labelTmp.first())
		
		// calculates the total width of the picture
		$width+=Length:C16($labelTmp.first().name)*$letterWidth+($padding*2)+$margin
	End if 
End for each 

// Create the picture with the width precalculated
$svg:=SVG_New($width; 16)

// Inserts in the picture the labels texts
For each ($label; $labels)
	$length:=Length:C16($label.name)
	$backgroundColor:=$label.color.backgroundColor=Null:C1517 ? $defaultBackgroundColor : $label.color.backgroundColor
	$textColor:=$label.color.textColor=Null:C1517 ? $defaultTextColor : $label.color.textColor
	
	// Rectangle creation
	$objectRef:=SVG_New_rect($svg; $offset; 0; $length*$letterWidth+($padding*2); 16; 0; 2; $backgroundColor; $backgroundColor)
	
	// Text writing
	$objectRef:=SVG_New_text($svg; $label.name; $offset+$padding; 2; "Courier New"; $fontSize; 0; Align left:K42:2; $textColor)
	
	// offset calculation
	$offset+=$length*$letterWidth+($padding*2)+$margin
End for each 

SVG EXPORT TO PICTURE:C1017($svg; $picture)

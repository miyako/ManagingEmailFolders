//%attributes = {}
#DECLARE($params : Object)

var $title : Text
var $window; $i : Integer
var $left; $top; $right; $bottom : Integer

$title:=Get localized string:C991("Form1_WindowTitle")

If (Count parameters=0)
	ARRAY LONGINT($windows; 0)
	WINDOW LIST($windows)
	For ($i; 1; Size of array($windows))
		$window:=$windows{$i}
		If ((Window process($window)=1) && (Get window title($window)=$title))
			GET WINDOW RECT($left; $top; $right; $bottom; $window)
			CALL FORM($window; Formula(SET WINDOW RECT($left; $top; $right; $bottom; $window)))
			return
		End if
	End for
	CALL WORKER(1; Current method name; {})
Else
	SET MENU BAR(1)
	$window:=Open form window("Form1"; Plain form window; Horizontally centered; Vertically centered)
	SET WINDOW TITLE($title; $window)
	DIALOG("Form1"; $params; *)
End if
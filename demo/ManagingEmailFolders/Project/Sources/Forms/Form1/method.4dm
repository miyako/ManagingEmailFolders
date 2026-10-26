If (Form event code:C388=On Load:K2:1)
	ARRAY TEXT:C222(myTabs; 3)
	myTabs{1}:=Get localized string:C991("Form1_TabIntroduction")
	myTabs{2}:=Get localized string:C991("Form1_TabGoogle")
	myTabs{3}:=Get localized string:C991("Form1_TabMicrosoft")
	
	Form:C1466.mail:=New object:C1471
	Form:C1466.mail365:=New object:C1471
	
End if 
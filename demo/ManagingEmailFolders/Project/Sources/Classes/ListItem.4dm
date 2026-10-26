// Object representing an item of a hierarchical list
// Text color
property Color : Integer
// Icon to be displayed before the label
property Icon : Variant
// Font style for the item (Bold 1, Italic 2, Plain 0, Underline 4)
property Style : Integer
// TRUE = Enterable, FALSE = Non-enterable
property Enterable : Boolean
// Indicates if the optional sublist will be expanded or collapsed
property Expanded : Boolean
// Item reference number
property ItemRef : Integer

Class constructor($itemRef : Integer)
	This:C1470.Style:=0  // plain
	This:C1470.Enterable:=False:C215
	This:C1470.Expanded:=True:C214
	This:C1470.ItemRef:=$itemRef
//%attributes = {}
#DECLARE($OAuth2Provider : cs:C1710.NetKit.OAuth2Provider; $winRef : Integer)
// Creates the hierarchical list of labels
// $OAuth2Provider -> Provider for the connection to the server 
// $winRef -> Ref of the caller worker 

// Gets the label collection
var $labels : Object:=cs:C1710.NetKit.Google.new($OAuth2Provider).mail.getLabelList()

// Creation of the list 
var $listObject:=cs:C1710.CreateLabelObject.new($labels).createList()
var $list:=cs:C1710.ListManager.new($listObject)

// Save the OAuth2Provider with the updated token in the main process
CALL FORM:C1391($winRef; Formula:C1597(Form:C1466.OAuth2Provider:=$OAuth2Provider))
// Set the item list of the hierarchical list in the main process
CALL FORM:C1391($winRef; Formula:C1597(Form:C1466.listManager:=$list))

// Set the labels list in the main process
CALL FORM:C1391($winRef; Formula:C1597(Form:C1466.labels:=$labels.labels))

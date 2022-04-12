// [ALL_TYPES] Entitty Class
Class extends Entity

// MARK:-[ALIAS]
exposed Alias aka_identifiant ID
exposed Alias aka_objet objectField
//exposed Alias aka_objet2 aka_objet
exposed Alias aka_blob blobField

// MARK:-[COMPUTED]
// +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++
exposed Function get calc_alpha() : Text
	
	return (This:C1470["Alpha field"])
	
	// +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++
exposed Function get calc_text() : Text
	
	return (This:C1470["Text field"])
	
	// +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++
exposed Function get calc_date() : Date
	
	return (This:C1470["Date field"])
	
	// +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++
	// FIXME: ⚠️ Time is displayed as Longint #ACI0102776
exposed Function get calc_heure() : Time
	
	return (This:C1470["Time field"])
	
	// +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++
exposed Function get calc_booléen() : Boolean
	
	return (This:C1470["Boolean field"])
	
exposed Function set calc_booléen($value : Boolean)
	
	This:C1470["Boolean field"]:=$value
	
	// +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++
exposed Function get calc_entier() : Integer
	
	return (This:C1470["Integer field"])
	
	// +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++
exposed Function get calc_réel() : Real
	
	return (This:C1470["Real field"])
	
	// +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++
exposed Function get calc_blob() : Blob
	
	return (This:C1470["Blob field"])
	
	// +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++
exposed Function get calc_image() : Picture
	
	return (This:C1470["Picture field"])
	
	// +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++
exposed Function get calc_objet() : Object
	
	return (This:C1470["Object field"])
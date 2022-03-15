// [ALL_TYPES] Entitty Class
Class extends Entity

// MARK:-[ALIAS]
exposed Alias aka_identifiant ID

// MARK:-[COMPUTED]
// +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++
exposed Function get calc_alpha() : Text
	
	// +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++
exposed Function get calc_text() : Text
	
	// +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++
exposed Function get calc_date() : Date
	
	// +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++
	// FIXME: ⚠️ Time is displayed as Longint #ACI0102776
exposed Function get calc_heure() : Time
	
	// +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++
exposed Function get calc_booléen() : Boolean
	
exposed Function set calc_booléen($value : Boolean)
	
	// +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++
exposed Function get calc_entier() : Integer
	
	// +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++
exposed Function get calc_réel() : Real
	
	// +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++
exposed Function get calc_blob() : Blob
	
	// +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++
exposed Function get calc_image() : Picture
	
	// +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++ +++
exposed Function get calc_objet() : Object
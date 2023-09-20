/datum/sprite_accessory/body_markings
	color_amount = 1 //DNA code can only handle 1 color per marking, changes to the code will be necessary if you want more, swine
	/// Default color for this marking, if this is a number instead of a string, we take from a list of mutant colors
	var/default_color = "#FFFFFF"
	/// Bitflags for bodyparts we are allowed on
	var/allowed_bodyparts = FULL_BODY
	/// Species this set is compatible with - Set to null for no species restrictions
	var/compatible_species = null

/datum/sprite_accessory/body_markings/proc/get_default_color(list/mutant_colors)
	if(isnum(default_color))
		return LAZYACCESS(mutant_colors, default_color) || "#FFFFFF"
	return default_color

/datum/sprite_accessory/body_markings/none
	name = SPRITE_ACCESSORY_NONE
	icon_state = "none"

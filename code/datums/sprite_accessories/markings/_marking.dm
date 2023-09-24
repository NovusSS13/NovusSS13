/datum/sprite_accessory/body_markings
	color_amount = 1 //DNA code can only handle 1 color per marking, changes to the code will be necessary if you want more, swine
	/// Default color for this marking, if this is a number instead of a string, we take from the given list of mutant colors
	var/default_color = 1
	/// Default marking colors list for get_default_color(), in case an override list is not provided
	var/default_colors = list(COLOR_MAGENTA, COLOR_CYAN, COLOR_LIGHT_PINK)
	/// Bitflags for bodyparts we are allowed on
	var/allowed_bodyparts = FULL_BODY
	/// Species this set is compatible with - Set to null for no species restrictions
	var/compatible_species = null

/// Gets a "default" color for this marking, though the color can be edited by the player under normal circumstances
/datum/sprite_accessory/body_markings/proc/get_default_color(list/mutant_colors = default_colors)
	if(isnum(default_color))
		return LAZYACCESS(mutant_colors, default_color) || "#FFFFFF"
	return default_color || "#FFFFFF"

/// Prepares a dummy for preview in the character setup
/datum/sprite_accessory/body_markings/proc/prepare_dummy(mob/living/carbon/human/dummy)
	// set species for species specific markings
	if(compatible_species)
		dummy.set_species(compatible_species[1])
	else
		dummy.set_species(/datum/species/mutant)

/datum/sprite_accessory/body_markings/none
	name = SPRITE_ACCESSORY_NONE
	icon_state = "none"

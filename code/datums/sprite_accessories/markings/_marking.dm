/datum/sprite_accessory/body_markings
	color_amount = 1 //DNA code can only handle 1 color per marking, changes to the code will be necessary if you want more, swine
	default_color = 1
	default_colors = list(COLOR_MAGENTA, COLOR_CYAN, COLOR_LIGHT_PINK)
	/// Bitflags for bodyparts we are allowed on
	var/allowed_bodyparts = FULL_BODY
	/// Species this set is compatible with - Set to null for no species restrictions
	var/compatible_species = null

/datum/sprite_accessory/body_markings/New()
	. = ..()
	if(compatible_species)
		compatible_species = typecacheof(compatible_species)

/// Prepares a dummy for preview in the character setup
/datum/sprite_accessory/body_markings/proc/prepare_dummy(mob/living/carbon/human/dummy)
	// set species for species specific markings
	if(compatible_species)
		dummy.set_species(compatible_species[1])
	else
		dummy.set_species(/datum/species/human)

/datum/sprite_accessory/body_markings/none
	name = SPRITE_ACCESSORY_NONE
	icon_state = "none"

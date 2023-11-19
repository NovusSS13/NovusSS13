/datum/body_marking_set
	/// The preview name of the body marking set - Must be unique!
	var/name
	/// Default colors in case the mutant_colors argument is not provided
	var/default_colors = list(COLOR_MAGENTA, COLOR_CYAN, COLOR_LIGHT_PINK)
	/// List of the body markings in this set
	var/body_marking_list = list()
	/// Species this set is compatible with - Set to null for no species restrictions
	var/compatible_species = null

/datum/body_marking_set/New()
	. = ..()
	if(compatible_species)
		compatible_species = typecacheof(compatible_species)

/// Prepares a dummy for preview in the character setup
/datum/body_marking_set/proc/prepare_dummy(mob/living/carbon/human/dummy)
	// set species for species specific markings
	if(compatible_species)
		dummy.set_species(compatible_species[1])
	else
		dummy.set_species(/datum/species/mutant)

/datum/body_marking_set/proc/assemble_body_markings_list(list/mutant_colors = default_colors, override_color)
	RETURN_TYPE(/list)
	var/list/final_markings = list()
	for(var/zone in body_marking_list)
		for(var/marking_name in body_marking_list[zone])
			var/datum/sprite_accessory/body_markings/markings = GLOB.body_markings[marking_name]
			if(!is_valid_rendering_sprite_accessory(markings)) //invalid marking...
				stack_trace("[type] had an invalid body_markings accessory ([marking_name]) in it's body_marking_list!")
				continue
			var/actual_color = sanitize_hexcolor(override_color || markings.get_default_color(mutant_colors), DEFAULT_HEX_COLOR_LEN, TRUE, "#FFFFFF")
			LAZYADDASSOC(final_markings[zone], marking_name, actual_color)
	return final_markings

/datum/body_marking_set/proc/apply_markings_to_dna(mob/living/carbon/human/human, list/markings_list)
	if(!markings_list)
		markings_list = assemble_body_markings_list()
	for(var/zone in markings_list)
		for(var/marking_index in 1 to length(markings_list[zone]))
			var/marking_key = "marking_[zone]_[marking_index]"
			var/marking_color_key = marking_key + "_color"
			var/marking_name = markings_list[zone][marking_index]
			var/marking_color = markings_list[zone][marking_name]
			human.dna.features[marking_key] = marking_name
			human.dna.features[marking_color_key] = marking_color

/datum/body_marking_set/none
	name = "None"

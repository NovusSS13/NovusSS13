/datum/body_marking_set
	/// The preview name of the body marking set - Must be unique!
	var/name
	/// List of the body markings in this set
	var/body_marking_list = list()
	/// Species this set is compatible with - Set to null for no species restrictions
	var/compatible_species = null

/datum/body_marking_set/proc/assemble_body_markings_list(list/mutant_colors, override_color)
	RETURN_TYPE(/list)
	var/list/sane_mutant_colors = list()
	var/default
	if(islist(mutant_colors))
		default = sanitize_hexcolor(mutant_colors[length(mutant_colors)], DEFAULT_HEX_COLOR_LEN, TRUE, "#FFFFFF")
		sane_mutant_colors = mutant_colors
	else
		default = sanitize_hexcolor(mutant_colors, DEFAULT_HEX_COLOR_LEN, TRUE, "#FFFFFF")
		sane_mutant_colors = list(mutant_colors)
	sane_mutant_colors.len = 3
	sane_mutant_colors = sanitize_hexcolor_list(mutant_colors, DEFAULT_HEX_COLOR_LEN, TRUE, default)
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

/datum/body_marking_set/none
	name = "None"

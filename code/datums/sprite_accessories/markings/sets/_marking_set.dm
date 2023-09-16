/datum/body_marking_set
	/// The preview name of the body marking set - Must be unique!
	var/name
	/// List of the body markings in this set
	var/body_marking_list = list()
	/// Species this set is compatible with - Set to null for no species restrictions
	var/compatible_species = null

/datum/body_marking_set/proc/assemble_body_markings_list(default_color = "#FFFFFF")
	RETURN_TYPE(/list)
	var/list/final_markings = list()
	for(var/zone in body_marking_list)
		for(var/marking_name in body_marking_list[zone])
			var/datum/sprite_accessory/body_markings/body_marking = GLOB.body_markings[marking_name]
			if(!body_marking || (marking_name == SPRITE_ACCESSORY_NONE)) //invalid marking...
				stack_trace("[type] had an invalid marking ([marking_name]) in it's body_marking_list!")
				continue
			LAZYADDASSOC(final_markings[zone], marking_name, default_color)
	return final_markings

/datum/body_marking_set/none
	name = "None"

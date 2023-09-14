/datum/body_marking_set
	/// The preview name of the body marking set - Must be unique!
	var/name
	/// List of the body markings in this set
	var/body_marking_list = list()
	/// Species this set is compatible with - Set to null for no species restrictions
	var/compatible_species = null

/datum/body_marking_set/none
	name = "None"

/proc/assemble_body_markings_from_set(datum/body_marking_set/body_marking_set, color = "#FFFFFF")
	var/list/body_markings = list()
	for(var/marking_name in body_marking_set.body_marking_list)
		var/datum/sprite_accessory/body_markings/body_marking = GLOB.body_markings[marking_name]
		for(var/zone in GLOB.body_markings_by_zone)
			if(body_marking.allowed_bodyparts & GLOB.marking_zone_to_bitflag[zone])
				LAZYSET(body_markings[zone], marking_name, color)
	return body_markings

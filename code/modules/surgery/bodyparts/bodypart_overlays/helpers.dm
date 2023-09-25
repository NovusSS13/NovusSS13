/**
 * Converts a bitflag to the right layer.
 * I'd love to make this a static index list, but byond made an attempt on my life when i did.
 */
/proc/external_bitflag_to_layer(layer)
	switch(layer)
		if(EXTERNAL_BEHIND)
			return -BODY_BEHIND_LAYER
		if(EXTERNAL_ADJACENT)
			return -BODY_ADJ_LAYER
		if(EXTERNAL_HIGH)
			return -BODY_HIGH_LAYER
		if(EXTERNAL_FRONT)
			return -BODY_FRONT_LAYER
	return layer

/**
 * This exists so sprite accessories can still be per-layer without having to include that layer's
 * number in their sprite name, which causes issues when those numbers change.
 */
/proc/mutant_bodyparts_layertext(layer)
	switch(layer)
		if(-BODY_BEHIND_LAYER)
			return "BEHIND"
		if(-BODY_ADJ_LAYER)
			return "ADJ"
		if(-BODY_HIGH_LAYER)
			return "HIGH"
		if(-BODY_FRONT_LAYER)
			return "FRONT"
	return layer

/// Helper that loops through a human's bodyparts, and removes all markings, and removes the markings from their dna
/mob/living/carbon/human/proc/clear_markings(update = TRUE)
	for(var/marking_zone in GLOB.marking_zones)
		for(var/marking_index in 1 to MAXIMUM_MARKINGS_PER_LIMB)
			var/marking_key = "marking_[marking_zone]_[marking_index]"
			dna.features[marking_key] = SPRITE_ACCESSORY_NONE
		var/obj/item/bodypart/bodypart = get_bodypart(check_zone(marking_zone))
		if(!bodypart)
			continue
		for(var/datum/bodypart_overlay/mutant/marking/marking in bodypart.bodypart_overlays)
			bodypart.remove_bodypart_overlay(marking)
			qdel(marking)
	if(update)
		update_body()

/// Helper that loops through a human's bodyparts, and applies their respective markings based on the human's DNA
/mob/living/carbon/human/proc/regenerate_markings(update = TRUE)
	//this shit is dumb and clearing needs to be done separately otherwise arm markings get fucked cause hands
	for(var/marking_zone in GLOB.marking_zones)
		var/obj/item/bodypart/bodypart = get_bodypart(check_zone(marking_zone))
		if(!bodypart)
			continue
		for(var/datum/bodypart_overlay/mutant/marking/marking_overlay in bodypart.bodypart_overlays)
			bodypart.remove_bodypart_overlay(marking_overlay)
	for(var/marking_zone in GLOB.marking_zones)
		var/obj/item/bodypart/bodypart = get_bodypart(check_zone(marking_zone))
		if(!bodypart)
			continue
		for(var/marking_index in 1 to MAXIMUM_MARKINGS_PER_LIMB)
			var/marking_key = "marking_[marking_zone]_[marking_index]"
			if(!dna.features[marking_key] || (dna.features[marking_key] == SPRITE_ACCESSORY_NONE))
				continue
			var/datum/sprite_accessory/body_markings/body_markings = GLOB.body_markings_by_zone[marking_zone][dna.features[marking_key]]
			if(!is_valid_rendering_sprite_accessory(body_markings)) //invalid marking...
				continue
			else if(body_markings.compatible_species && !is_path_in_list(dna.species.type, body_markings.compatible_species))
				continue
			var/marking_color_key = marking_key + "_color"
			var/datum/bodypart_overlay/mutant/marking/marking = new(marking_zone, marking_key, marking_color_key)
			marking.set_appearance(body_markings.type)
			bodypart.add_bodypart_overlay(marking)
	if(update)
		update_body()

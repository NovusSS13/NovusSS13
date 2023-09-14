/// Middleware to handle markings
/datum/preference_middleware/markings
	priority = MIDDLEWARE_PRIORITY_BEFORE //modifying dna features, therefore we go before for the sake of safety
	action_delegations = list(
		"add_marking" = .proc/add_marking,
		"change_marking" = .proc/change_marking,
		"remove_marking" = .proc/remove_marking,
		"color_marking" = .proc/color_marking,
		"move_marking_up" = .proc/move_marking_up,
		"move_marking_down" = .proc/move_marking_down,
		"set_preset" = .proc/set_preset,
	)

/datum/preference_middleware/markings/get_ui_data(mob/user)
	var/list/data = list()

	var/species_type = preferences.read_preference(/datum/preference/choiced/species)

	var/list/presets = list()
	for(var/set_name in GLOB.body_marking_sets)
		var/datum/body_marking_set/body_marking_set = GLOB.body_marking_sets[set_name]
		if(!body_marking_set.compatible_species || is_path_in_list(species_type, body_marking_set.compatible_species))
			presets += body_marking_set

	data["body_marking_sets"] = presets

	var/list/marking_parts = list()
	for(var/zone in GLOB.marking_zones)
		var/list/this_zone = list()

		this_zone["body_zone"] = zone
		this_zone["name"] = capitalize(parse_zone(zone))
		var/list/this_zone_marking_choices = list()
		if(LAZYACCESS(GLOB.body_markings_by_zone, zone))
			for(var/marking_name in GLOB.body_markings_by_zone[zone])
				if(marking_name == SPRITE_ACCESSORY_NONE)
					continue
				var/datum/sprite_accessory/body_markings/body_markings = GLOB.body_markings[marking_name]
				if(!body_markings.compatible_species || is_path_in_list(species_type, body_markings.compatible_species))
					this_zone_marking_choices += marking_name
		var/list/this_zone_markings = list()
		for(var/marking_name in preferences.body_markings[zone])
			this_zone_marking_choices -= marking_name
			var/list/this_marking = list()

			var/datum/sprite_accessory/body_markings/body_markings = GLOB.body_markings[marking_name]
			this_marking["name"] = marking_name
			this_marking["color"] = sanitize_hexcolor(preferences.body_markings[zone][marking_name], DEFAULT_HEX_COLOR_LEN, include_crunch = TRUE)
			this_marking["color_amount"] = body_markings.color_amount
			this_marking["marking_index"] = preferences.body_markings[zone].Find(marking_name)

			this_zone_markings += list(this_marking)
		this_zone["markings"] = this_zone_markings
		this_zone["markings_choices"] = this_zone_marking_choices
		this_zone["cant_add_markings"] = (LAZYLEN(this_zone_markings) >= MAXIMUM_MARKINGS_PER_LIMB ? "Marking limit reached!" : \
										(!LAZYLEN(this_zone_marking_choices) ? (LAZYLEN(this_zone_markings) ? "No more options found!" : "No options found!") : null))

		marking_parts += list(this_zone)

	data["marking_parts"] = marking_parts
	data["maximum_markings_per_limb"] = MAXIMUM_MARKINGS_PER_LIMB
	return data

/datum/preference_middleware/markings/apply_to_human(mob/living/carbon/human/target, datum/preferences/preferences)
	for(var/marking_zone in preferences.body_markings)
		for(var/marking_index in 1 to LAZYLEN(preferences.body_markings[marking_zone]))
			var/marking_name = preferences.body_markings[marking_zone][marking_index]
			if(!marking_name || (marking_name == SPRITE_ACCESSORY_NONE))
				continue
			var/datum/sprite_accessory/body_markings/markings = GLOB.body_markings_by_zone[marking_zone][marking_name]
			if(!markings) //invalid marking...
				continue
			var/marking_color = preferences.body_markings[marking_zone][marking_name]
			var/marking_key = "marking_[marking_zone]_[marking_index]"
			var/marking_color_key = marking_key + "_color"
			target.dna.features[marking_key] = marking_name
			target.dna.features[marking_color_key] = marking_color
	for(var/obj/item/bodypart/bodypart in target.bodyparts)
		for(var/datum/bodypart_overlay/mutant/marking/existing in bodypart.bodypart_overlays)
			bodypart.remove_bodypart_overlay(existing)
		var/list/marking_zones = list(bodypart.body_zone)
		if(bodypart.aux_zone)
			marking_zones |= bodypart.aux_zone
		for(var/marking_zone in marking_zones)
			for(var/marking_index in 1 to MAXIMUM_MARKINGS_PER_LIMB)
				var/marking_key = "marking_[marking_zone]_[marking_index]"
				if(!target.dna.features[marking_key] || (target.dna.features[marking_key] == SPRITE_ACCESSORY_NONE))
					continue
				var/datum/sprite_accessory/body_markings/markings = GLOB.body_markings_by_zone[marking_zone][target.dna.features[marking_key]]
				if(!markings) //invalid marking...
					continue
				var/bodypart_species = GLOB.species_list[bodypart.limb_id]
				if(!markings.compatible_species || is_path_in_list(bodypart_species, markings.compatible_species))
					var/marking_color_key = marking_key + "_color"
					var/datum/bodypart_overlay/mutant/marking/marking = new(marking_zone, marking_key, marking_color_key)
					marking.set_appearance(markings.type)
					bodypart.add_bodypart_overlay(marking)

/datum/preference_middleware/markings/proc/add_marking(list/params, mob/user)
	var/zone = params["body_zone"]
	LAZYINITLIST(preferences.body_markings[zone])
	var/species_type = preferences.read_preference(/datum/preference/choiced/species)
	var/list/marking_list = preferences.body_markings[zone]
	var/list/available_markings = list()
	for(var/marking_name in GLOB.body_markings_by_zone[zone])
		if(marking_name == SPRITE_ACCESSORY_NONE)
			continue
		var/datum/sprite_accessory/body_markings/body_markings = GLOB.body_markings[marking_name]
		if(!body_markings.compatible_species || is_path_in_list(species_type, body_markings.compatible_species))
			available_markings += marking_name
	available_markings -= SPRITE_ACCESSORY_NONE
	available_markings -= marking_list
	if(!length(available_markings))
		return FALSE
	if(LAZYLEN(marking_list) < MAXIMUM_MARKINGS_PER_LIMB)
		var/name = available_markings[1]
		var/mcolor = preferences.read_preference(/datum/preference/tricolor/mutant/mutant_color)
		mcolor = mcolor[1]
		marking_list[name] = sanitize_hexcolor(mcolor, DEFAULT_HEX_COLOR_LEN, include_crunch = TRUE)
		preferences.character_preview_view.update_body()
		return TRUE
	return FALSE

/datum/preference_middleware/markings/proc/change_marking(list/params, mob/user)
	var/zone = params["body_zone"]
	var/index = params["marking_index"]
	var/new_marking = params["new_marking"]
	var/list/marking_list = preferences.body_markings[zone].Copy()
	preferences.body_markings[zone] = list()
	var/count = 0
	for(var/previousmarking in marking_list)
		count++
		if(count == index)
			preferences.body_markings[zone][new_marking] = marking_list[previousmarking]
		else
			preferences.body_markings[zone][previousmarking] = marking_list[previousmarking]
	preferences.character_preview_view.update_body()
	return TRUE

/datum/preference_middleware/markings/proc/color_marking(list/params, mob/user)
	var/zone = params["body_zone"]
	var/marking_name = params["marking_name"]
	if(marking_name)
		var/old_color = preferences.body_markings[zone][marking_name]
		var/new_color = input(user, "Select new color", "[marking_name] color", old_color) as color
		preferences.body_markings[zone][marking_name] = sanitize_hexcolor(new_color, DEFAULT_HEX_COLOR_LEN, include_crunch = TRUE)
		preferences.character_preview_view.update_body()
		return TRUE
	return FALSE

/datum/preference_middleware/markings/proc/remove_marking(list/params, mob/user)
	var/zone = params["body_zone"]
	var/index = params["marking_index"]
	var/list/marking_list = preferences.body_markings[zone]
	if(LAZYACCESS(marking_list, index))
		marking_list -= marking_list[index]
		if(LAZYLEN(marking_list) <= 0)
			marking_list = null
		preferences.character_preview_view.update_body()
		return TRUE
	return FALSE

/datum/preference_middleware/markings/proc/move_marking_up(list/params, mob/user)
	var/zone = params["body_zone"]
	var/index = params["marking_index"]
	var/list/marking_list = preferences.body_markings[zone]
	if(LAZYLEN(marking_list) >= 2 && (index >= 2))
		marking_list.Swap(index, index-1)
		preferences.character_preview_view.update_body()
		return TRUE
	return FALSE

/datum/preference_middleware/markings/proc/move_marking_down(list/params, mob/user)
	var/zone = params["body_zone"]
	var/index = params["marking_index"]
	var/list/marking_list = preferences.body_markings[zone]
	if(LAZYLEN(marking_list) >= 2 && (index < LAZYLEN(marking_list)))
		marking_list.Swap(index, index+1)
		preferences.character_preview_view.update_body()
		return TRUE
	return FALSE

/datum/preference_middleware/markings/proc/set_preset(list/params, mob/user)
	var/preset = params["preset"]
	if(preset && GLOB.body_marking_sets[preset])
		var/datum/body_marking_set/body_marking_set = GLOB.body_marking_sets[preset]
		var/mcolor = preferences.read_preference(/datum/preference/tricolor/mutant/mutant_color)
		mcolor = mcolor[1]
		preferences.body_markings = assemble_body_markings_from_set(body_marking_set, mcolor)
		preferences.character_preview_view.update_body()
		return TRUE
	return FALSE

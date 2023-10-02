/// Middleware to handle markings
/datum/preference_middleware/markings
	priority = MIDDLEWARE_PRIORITY_BEFORE //modifying dna features, therefore we go before for the sake of safety
	action_delegations = list(
		"add_marking" = .proc/add_marking,
		"change_marking" = .proc/change_marking,
		"remove_marking" = .proc/remove_marking,
		"color_marking" = .proc/color_marking,
		"color_marking_mutant_colors" = .proc/color_marking_mutant_colors,
		"move_marking_up" = .proc/move_marking_up,
		"move_marking_down" = .proc/move_marking_down,
		"set_preset" = .proc/set_preset,
	)

/datum/preference_middleware/markings/get_ui_data(mob/user)
	var/list/data = list()

	var/species_type = preferences.read_preference(/datum/preference/choiced/species)

	var/list/body_marking_sets = list()
	for(var/set_name in GLOB.body_marking_sets)
		//we intentionally do not remove SPRITE_ACCESSORY_NONE so that you can easily clear your markings list
		var/datum/body_marking_set/body_marking_set = GLOB.body_marking_sets[set_name]
		if(!body_marking_set)
			continue
		else if(body_marking_set.compatible_species && !is_path_in_list(species_type, body_marking_set.compatible_species))
			continue
		var/list/this_set = list()

		this_set["name"] = set_name
		this_set["icon"] = sanitize_css_class_name("set_[set_name]")

		body_marking_sets += list(this_set)

	data["body_marking_sets"] = body_marking_sets

	var/list/marking_parts = list()
	for(var/zone in GLOB.marking_zones)
		var/list/this_zone = list()

		this_zone["body_zone"] = zone
		this_zone["name"] = capitalize(parse_zone(zone))
		var/list/this_zone_marking_choices = list()
		for(var/marking_name in GLOB.body_markings_by_zone[zone])
			var/datum/sprite_accessory/body_markings/body_markings = GLOB.body_markings[marking_name]
			if(body_markings.compatible_species && !is_path_in_list(species_type, body_markings.compatible_species))
				continue
			var/list/this_marking_choice = list()

			this_marking_choice["name"] = marking_name
			this_marking_choice["icon"] = sanitize_css_class_name("marking_[zone]_[marking_name]")

			this_zone_marking_choices += list(this_marking_choice)
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
	target.clear_markings(update = FALSE)
	for(var/marking_zone in preferences.body_markings)
		for(var/marking_index in 1 to LAZYLEN(preferences.body_markings[marking_zone]))
			var/marking_name = preferences.body_markings[marking_zone][marking_index]
			if(!marking_name || (marking_name == SPRITE_ACCESSORY_NONE))
				continue
			var/datum/sprite_accessory/body_markings/markings = GLOB.body_markings_by_zone[marking_zone][marking_name]
			if(!is_valid_rendering_sprite_accessory(markings)) //invalid marking...
				continue
			var/marking_color = preferences.body_markings[marking_zone][marking_name]
			var/marking_key = "marking_[marking_zone]_[marking_index]"
			var/marking_color_key = marking_key + "_color"
			target.dna.features[marking_key] = marking_name
			target.dna.features[marking_color_key] = marking_color
	target.regenerate_markings(update = TRUE)

/datum/preference_middleware/markings/proc/add_marking(list/params, mob/user)
	var/species_type = preferences.read_preference(/datum/preference/choiced/species)
	var/zone = params["body_zone"]
	LAZYINITLIST(preferences.body_markings[zone])
	var/list/marking_list = preferences.body_markings[zone]
	var/list/available_markings = list()
	for(var/marking_name in GLOB.body_markings_by_zone[zone])
		if(marking_name == SPRITE_ACCESSORY_NONE)
			continue
		var/datum/sprite_accessory/body_markings/body_markings = GLOB.body_markings[marking_name]
		if(body_markings.compatible_species && !is_path_in_list(species_type, body_markings.compatible_species))
			continue
		available_markings += marking_name
	available_markings -= SPRITE_ACCESSORY_NONE
	available_markings -= marking_list
	if(!length(available_markings))
		return FALSE
	if(LAZYLEN(marking_list) >= MAXIMUM_MARKINGS_PER_LIMB)
		return FALSE
	var/marking_name = available_markings[1]
	var/datum/sprite_accessory/body_markings/body_markings = GLOB.body_markings[marking_name]
	marking_list[marking_name] = body_markings.get_default_color(preferences.read_preference(/datum/preference/tricolor/mutant/mutant_color))
	preferences.character_preview_view.update_body()
	return TRUE

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

/datum/preference_middleware/markings/proc/color_marking_mutant_colors(list/params, mob/user)
	var/zone = params["body_zone"]
	var/marking_name = params["marking_name"]
	var/datum/sprite_accessory/body_markings/body_markings = GLOB.body_markings[marking_name]
	if(body_markings)
		var/new_color = body_markings.get_default_color(preferences.read_preference(/datum/preference/tricolor/mutant/mutant_color))
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
		var/species_type = preferences.read_preference(/datum/preference/choiced/species)
		var/datum/body_marking_set/body_marking_set = GLOB.body_marking_sets[preset]
		preferences.body_markings = list()
		var/list/assembled_markings = body_marking_set.assemble_body_markings_list(preferences.read_preference(/datum/preference/tricolor/mutant/mutant_color))
		for(var/zone in assembled_markings)
			for(var/marking_name in assembled_markings[zone])
				var/datum/sprite_accessory/body_markings/body_marking = GLOB.body_markings[marking_name]
				if(body_marking.compatible_species && !is_path_in_list(species_type, body_marking.compatible_species))
					continue
				LAZYADDASSOC(preferences.body_markings[zone], marking_name, assembled_markings[zone][marking_name])
		preferences.character_preview_view.update_body()
		return TRUE
	return FALSE

/datum/preference_middleware/markings/get_ui_assets()
	return list(
		get_asset_datum(/datum/asset/spritesheet/markings),
	)

/datum/asset/spritesheet/markings
	name = "markings"
	early = TRUE
	cross_round_cachable = TRUE

/datum/asset/spritesheet/markings/create_spritesheets()
	var/list/to_insert = list()
	var/static/icon/icon_fucked = icon('icons/effects/random_spawners.dmi', "questionmark")

	var/mob/living/carbon/human/dummy/consistent/dummy = new()

	//clean up the dummy... just in case
	dummy.clear_markings(update = FALSE)

	//prepare markings previews
	for(var/zone in GLOB.marking_zones)
		for(var/marking_name in GLOB.body_markings_by_zone[zone])
			var/datum/sprite_accessory/body_markings/body_marking = GLOB.body_markings_by_zone[zone][marking_name]
			if(!body_marking)
				//should not happen but if it does...
				to_insert[sanitize_css_class_name("marking_[zone]_[marking_name]")] = icon_fucked
				continue

			// prepares the dummy for preview
			body_marking.prepare_dummy(dummy)

			// create the marking on the given bodypart
			var/obj/item/bodypart/bodypart = dummy.get_bodypart(check_zone(zone))
			if(!bodypart)
				//should not happen but if it does...
				to_insert[sanitize_css_class_name("marking_[zone]_[marking_name]")] = icon_fucked
				continue

			//clear up the bodypart for the next marking to be applied
			for(var/datum/bodypart_overlay/mutant/marking/marking_overlay in bodypart.bodypart_overlays)
				bodypart.remove_bodypart_overlay(marking_overlay)
				qdel(marking_overlay)

			var/marking_key = "marking_[zone]_5"
			var/marking_color_key = marking_key + "_color"
			dummy.dna.features[marking_key] = marking_name
			dummy.dna.features[marking_color_key] = body_marking.get_default_color()

			var/datum/bodypart_overlay/marking_overlay = new /datum/bodypart_overlay/mutant/marking(zone, marking_key, marking_color_key)
			marking_overlay.set_appearance(body_marking.type)
			bodypart.add_bodypart_overlay(marking_overlay)

			var/image/bodypart_image = new()
			bodypart_image.add_overlay(bodypart.get_limb_icon())
			var/icon/bodypart_icon = getFlatIcon(bodypart_image)
			switch(zone)
				if(BODY_ZONE_HEAD)
					bodypart_icon.Crop(10, 19, 22, 31)
				if(BODY_ZONE_CHEST)
					bodypart_icon.Crop(9, 9, 23, 23)
				if(BODY_ZONE_L_ARM, BODY_ZONE_PRECISE_L_HAND)
					bodypart_icon.Crop(17, 10, 28, 21)
				if(BODY_ZONE_R_ARM, BODY_ZONE_PRECISE_R_HAND)
					bodypart_icon.Crop(4, 10, 15, 21)
				if(BODY_ZONE_L_LEG, BODY_ZONE_PRECISE_L_FOOT)
					bodypart_icon.Crop(9, 1, 23, 15)
				if(BODY_ZONE_R_LEG, BODY_ZONE_PRECISE_R_FOOT)
					bodypart_icon.Crop(9, 1, 23, 15)
			bodypart_icon.Scale(32, 32)

			to_insert[sanitize_css_class_name("marking_[zone]_[marking_name]")] = bodypart_icon

	//prepare marking set previews
	for(var/set_name in GLOB.body_marking_sets)
		var/datum/body_marking_set/marking_set = GLOB.body_marking_sets[set_name]
		if(!marking_set)
			//should not happen but if it does...
			to_insert[sanitize_css_class_name("set_[set_name]")] = icon_fucked
			continue

		// clean up the dummy for the next marking set to be applied
		dummy.clear_markings(update = FALSE)

		// prepare the dummy for preview
		marking_set.prepare_dummy(dummy)

		marking_set.apply_markings_to_dna(dummy)

		dummy.regenerate_markings(update = FALSE)
		dummy.regenerate_icons()
		var/icon/dummy_icon = getFlatIcon(dummy)
		dummy_icon.Scale(32, 32)

		to_insert[sanitize_css_class_name("set_[set_name]")] = dummy_icon

	SSatoms.prepare_deletion(dummy) //FUCK YOU STUPID DUMB DUMB DUMMY

	for(var/spritesheet_key in to_insert)
		Insert(spritesheet_key, to_insert[spritesheet_key])

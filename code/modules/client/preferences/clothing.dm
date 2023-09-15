/proc/generate_underwear_icon(datum/sprite_accessory/accessory, icon/base_icon, color)
	var/icon/final_icon = new(base_icon)

	if (!isnull(accessory))
		var/icon/accessory_icon = icon('icons/mob/clothing/underwear.dmi', accessory.icon_state)
		if (color && !accessory.use_static)
			accessory_icon.Blend(color, ICON_MULTIPLY)
		final_icon.Blend(accessory_icon, ICON_OVERLAY)

	final_icon.Crop(10, 1, 22, 13)
	final_icon.Scale(32, 32)

	return final_icon

/// Backpack preference
/datum/preference/choiced/backpack
	savefile_key = "backpack"
	savefile_identifier = PREFERENCE_CHARACTER
	main_feature_name = "Backpack"
	category = PREFERENCE_CATEGORY_CLOTHING
	should_generate_icons = TRUE

/datum/preference/choiced/backpack/init_possible_values()
	return list(
		PREF_GREY_BACKPACK,
		PREF_GREY_SATCHEL,
		PREF_LEATHER_SATCHEL,
		PREF_GREY_DUFFELBAG,
		PREF_DEP_BACKPACK,
		PREF_DEP_SATCHEL,
		PREF_DEP_DUFFELBAG,
	)

/datum/preference/choiced/backpack/icon_for(value)
	switch (value)
		if (PREF_GREY_BACKPACK)
			return /obj/item/storage/backpack
		if (PREF_GREY_SATCHEL)
			return /obj/item/storage/backpack/satchel
		if (PREF_LEATHER_SATCHEL)
			return /obj/item/storage/backpack/satchel/leather
		if (PREF_GREY_DUFFELBAG)
			return /obj/item/storage/backpack/duffelbag

		// In a perfect world, these would be your department's backpack.
		// However, this doesn't factor in assistants, or no high slot, and would
		// also increase the spritesheet size a lot.
		// I play medical doctor, and so medical doctor you get.
		if (PREF_DEP_BACKPACK)
			return /obj/item/storage/backpack/medic
		if (PREF_DEP_SATCHEL)
			return /obj/item/storage/backpack/satchel/med
		if (PREF_DEP_DUFFELBAG)
			return /obj/item/storage/backpack/duffelbag/med

/datum/preference/choiced/backpack/apply_to_human(mob/living/carbon/human/target, value)
	target.backpack = value

/datum/preference/choiced/backpack/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	if(preferences.current_char_key != "main")
		return FALSE

	var/datum/species/species_type = preferences.read_preference(/datum/preference/choiced/species)
	return !(ITEM_SLOT_BACK in initial(species_type.no_equip_flags))

/// Jumpsuit preference
/datum/preference/choiced/jumpsuit
	savefile_key = "jumpsuit_style"
	savefile_identifier = PREFERENCE_CHARACTER
	main_feature_name = "Jumpsuit"
	category = PREFERENCE_CATEGORY_CLOTHING
	should_generate_icons = TRUE

/datum/preference/choiced/jumpsuit/init_possible_values()
	return list(
		PREF_SUIT,
		PREF_SKIRT,
	)

/datum/preference/choiced/jumpsuit/icon_for(value)
	switch (value)
		if (PREF_SUIT)
			return /obj/item/clothing/under/color/grey
		if (PREF_SKIRT)
			return /obj/item/clothing/under/color/jumpskirt/grey

/datum/preference/choiced/jumpsuit/apply_to_human(mob/living/carbon/human/target, value)
	target.jumpsuit_style = value

/datum/preference/choiced/jumpsuit/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	if(preferences.current_char_key != "main")
		return FALSE

	var/datum/species/species_type = preferences.read_preference(/datum/preference/choiced/species)
	return !(ITEM_SLOT_ICLOTHING in initial(species_type.no_equip_flags))

/// Socks preference
/datum/preference/choiced/socks
	savefile_key = "socks"
	savefile_identifier = PREFERENCE_CHARACTER
	main_feature_name = "Socks"
	category = PREFERENCE_CATEGORY_CLOTHING
	should_generate_icons = TRUE

/datum/preference/choiced/socks/init_possible_values()
	return assoc_to_keys_features(GLOB.socks_list)

/datum/preference/choiced/socks/create_default_value(datum/preferences/preferences)
	return SPRITE_ACCESSORY_NONE

/datum/preference/choiced/socks/icon_for(value)
	var/static/icon/lower_half

	if (isnull(lower_half))
		lower_half = icon('icons/blanks/32x32.dmi', "nothing")
		lower_half.Blend(icon('icons/mob/species/human/bodyparts_greyscale.dmi', "human_r_leg"), ICON_OVERLAY)
		lower_half.Blend(icon('icons/mob/species/human/bodyparts_greyscale.dmi', "human_l_leg"), ICON_OVERLAY)

	//stupid byond goof, icon(icon_file, nonexistent_icon_state) == icon_file
	if(value == SPRITE_ACCESSORY_NONE)
		return generate_underwear_icon(null, lower_half)
	return generate_underwear_icon(GLOB.socks_list[value], lower_half)

/datum/preference/choiced/socks/apply_to_human(mob/living/carbon/human/target, value)
	target.socks = value

/datum/preference/choiced/socks/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	if(preferences.current_char_key != "main")
		var/datum/offstation_customization/ghost_role_data = GLOB.offstation_customization_by_save_key[preferences.current_char_key]
		if(ghost_role_data.barebones_spawn)
			return FALSE

	var/species_type = preferences.read_preference(/datum/preference/choiced/species)
	var/datum/species/species = new species_type
	return !(TRAIT_NO_UNDERWEAR in species.inherent_traits)

/// Undershirt preference
/datum/preference/choiced/undershirt
	savefile_key = "undershirt"
	savefile_identifier = PREFERENCE_CHARACTER
	main_feature_name = "Undershirt"
	category = PREFERENCE_CATEGORY_CLOTHING
	should_generate_icons = TRUE

/datum/preference/choiced/undershirt/init_possible_values()
	return assoc_to_keys_features(GLOB.undershirt_list)

/datum/preference/choiced/undershirt/create_default_value(datum/preferences/preferences)
	return SPRITE_ACCESSORY_NONE

/datum/preference/choiced/undershirt/icon_for(value)
	var/static/icon/body
	if (isnull(body))
		body = icon('icons/mob/species/human/bodyparts_greyscale.dmi', "human_r_leg")
		body.Blend(icon('icons/mob/species/human/bodyparts_greyscale.dmi', "human_l_leg"), ICON_OVERLAY)
		body.Blend(icon('icons/mob/species/human/bodyparts_greyscale.dmi', "human_r_arm"), ICON_OVERLAY)
		body.Blend(icon('icons/mob/species/human/bodyparts_greyscale.dmi', "human_l_arm"), ICON_OVERLAY)
		body.Blend(icon('icons/mob/species/human/bodyparts_greyscale.dmi', "human_r_hand"), ICON_OVERLAY)
		body.Blend(icon('icons/mob/species/human/bodyparts_greyscale.dmi', "human_l_hand"), ICON_OVERLAY)
		body.Blend(icon('icons/mob/species/human/bodyparts_greyscale.dmi', "human_chest_m"), ICON_OVERLAY)

	var/icon/icon_with_undershirt = icon(body)

	if (value != SPRITE_ACCESSORY_NONE)
		var/datum/sprite_accessory/accessory = GLOB.undershirt_list[value]
		icon_with_undershirt.Blend(icon('icons/mob/clothing/underwear.dmi', accessory.icon_state), ICON_OVERLAY)

	icon_with_undershirt.Crop(9, 9, 23, 23)
	icon_with_undershirt.Scale(32, 32)
	return icon_with_undershirt

/datum/preference/choiced/undershirt/apply_to_human(mob/living/carbon/human/target, value)
	target.undershirt = value

/datum/preference/choiced/undershirt/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	if(preferences.current_char_key != "main")
		var/datum/offstation_customization/ghost_role_data = GLOB.offstation_customization_by_save_key[preferences.current_char_key]
		if(ghost_role_data.barebones_spawn)
			return FALSE

	var/species_type = preferences.read_preference(/datum/preference/choiced/species)
	var/datum/species/species = new species_type
	return !(TRAIT_NO_UNDERWEAR in species.inherent_traits)

/// Underwear preference
/datum/preference/choiced/underwear
	savefile_key = "underwear"
	savefile_identifier = PREFERENCE_CHARACTER
	main_feature_name = "Underwear"
	category = PREFERENCE_CATEGORY_CLOTHING
	should_generate_icons = TRUE

/datum/preference/choiced/underwear/init_possible_values()
	return assoc_to_keys_features(GLOB.underwear_list)

/datum/preference/choiced/underwear/create_default_value(datum/preferences/preferences)
	return SPRITE_ACCESSORY_NONE

/datum/preference/choiced/underwear/icon_for(value)
	var/static/icon/lower_half

	if (isnull(lower_half))
		lower_half = icon('icons/blanks/32x32.dmi', "nothing")
		lower_half.Blend(icon('icons/mob/species/human/bodyparts_greyscale.dmi', "human_chest_m"), ICON_OVERLAY)
		lower_half.Blend(icon('icons/mob/species/human/bodyparts_greyscale.dmi', "human_r_leg"), ICON_OVERLAY)
		lower_half.Blend(icon('icons/mob/species/human/bodyparts_greyscale.dmi', "human_l_leg"), ICON_OVERLAY)


	//stupid byond goof, icon(icon_file, nonexistent_icon_state) == icon_file
	if(value == SPRITE_ACCESSORY_NONE)
		return generate_underwear_icon(null, lower_half)
	return generate_underwear_icon(GLOB.underwear_list[value], lower_half, COLOR_ALMOST_BLACK)

/datum/preference/choiced/underwear/apply_to_human(mob/living/carbon/human/target, value)
	target.underwear = value

/datum/preference/choiced/underwear/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	if(preferences.current_char_key != "main")
		var/datum/offstation_customization/ghost_role_data = GLOB.offstation_customization_by_save_key[preferences.current_char_key]
		if(ghost_role_data.barebones_spawn)
			return FALSE

	var/species_type = preferences.read_preference(/datum/preference/choiced/species)
	var/datum/species/species = new species_type
	return !(TRAIT_NO_UNDERWEAR in species.inherent_traits)

/datum/preference/choiced/underwear/compile_constant_data()
	var/list/data = ..()

	data[SUPPLEMENTAL_FEATURE_KEY] = "underwear_color"

	return data

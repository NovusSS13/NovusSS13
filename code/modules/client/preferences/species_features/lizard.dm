/proc/generate_lizard_side_shots(list/sprite_accessories, key, include_snout = TRUE)
	var/list/values = list()

	var/icon/lizard = icon('icons/mob/species/lizard/bodyparts.dmi', "lizard_head", EAST)
	var/icon/eyes = icon('icons/mob/species/human/human_face.dmi', "eyes", EAST)
	eyes.Blend(COLOR_GRAY, ICON_MULTIPLY)
	lizard.Blend(eyes, ICON_OVERLAY)

	if (include_snout)
		lizard.Blend(icon('icons/mob/species/lizard/lizard_misc.dmi', "m_snout_round_ADJ", EAST), ICON_OVERLAY)

	for (var/name in sprite_accessories)
		var/datum/sprite_accessory/sprite_accessory = sprite_accessories[name]

		var/icon/final_icon = icon(lizard)

		if (sprite_accessory.icon_state != "none")
			var/icon/accessory_icon = icon(sprite_accessory.icon, "m_[key]_[sprite_accessory.icon_state]_ADJ", EAST)
			final_icon.Blend(accessory_icon, ICON_OVERLAY)

		final_icon.Crop(11, 20, 23, 32)
		final_icon.Scale(32, 32)
		final_icon.Blend(COLOR_VIBRANT_LIME, ICON_MULTIPLY)

		values[name] = final_icon

	return values

/datum/preference/choiced/mutant/lizard_body_markings
	savefile_key = "feature_lizard_body_markings"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Body markings"
	should_generate_icons = TRUE
	relevant_mutant_bodypart = "body_markings"
	relevant_feature = "body_markings"

/datum/preference/choiced/mutant/lizard_body_markings/init_possible_values()
	var/list/values = list()

	var/icon/lizard = icon('icons/mob/species/lizard/bodyparts.dmi', "lizard_chest_m")

	for (var/name in GLOB.body_markings_list)
		var/datum/sprite_accessory/sprite_accessory = GLOB.body_markings_list[name]

		var/icon/final_icon = icon(lizard)

		if (sprite_accessory.icon_state != "none")
			var/icon/body_markings_icon = icon(
				'icons/mob/species/lizard/lizard_misc.dmi',
				"m_body_markings_[sprite_accessory.icon_state]_ADJ",
			)

			final_icon.Blend(body_markings_icon, ICON_OVERLAY)

		final_icon.Blend(COLOR_VIBRANT_LIME, ICON_MULTIPLY)
		final_icon.Crop(10, 8, 22, 23)
		final_icon.Scale(26, 32)
		final_icon.Crop(-2, 1, 29, 32)

		values[name] = final_icon

	return values

/datum/preference/choiced/mutant/lizard_legs
	savefile_key = "feature_lizard_legs"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_mutant_bodypart = "legs"
	relevant_feature = "legs"

/datum/preference/choiced/mutant/lizard_legs/init_possible_values()
	return assoc_to_keys_features(GLOB.legs_list)

/datum/preference/choiced/mutant/lizard_frills
	savefile_key = "feature_lizard_frills"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Frills"
	should_generate_icons = TRUE
	relevant_cosmetic_organ = /obj/item/organ/frills
	relevant_feature = "frills"
	supplemental_feature_key = "feature_lizard_frills_color"

/datum/preference/choiced/mutant/lizard_frills/init_possible_values()
	return generate_lizard_side_shots(GLOB.frills_list, "frills")

/datum/preference/tricolor/mutant/lizard_frills
	savefile_key = "feature_lizard_frills_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/frills
	relevant_feature = "frills_color"
	primary_feature_key = "feature_lizard_frills"

/datum/preference/tricolor/mutant/lizard_frills/get_global_feature_list()
	return GLOB.frills_list

/datum/preference/choiced/mutant/lizard_horns
	savefile_key = "feature_lizard_horns"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Horns"
	should_generate_icons = TRUE
	relevant_cosmetic_organ = /obj/item/organ/horns
	relevant_feature = "horns"
	supplemental_feature_key = "feature_lizard_horns_color"

/datum/preference/choiced/mutant/lizard_horns/init_possible_values()
	return generate_lizard_side_shots(GLOB.horns_list, "horns")

/datum/preference/tricolor/mutant/lizard_horns
	savefile_key = "feature_lizard_horns_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/horns
	relevant_feature = "horns_color"
	primary_feature_key = "feature_lizard_horns"

/datum/preference/tricolor/mutant/lizard_horns/get_global_feature_list()
	return GLOB.horns_list

/datum/preference/choiced/mutant/lizard_snout
	savefile_key = "feature_lizard_snout"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Snout"
	should_generate_icons = TRUE
	relevant_cosmetic_organ = /obj/item/organ/snout
	relevant_feature = "snout"
	supplemental_feature_key = "feature_lizard_snout_color"

/datum/preference/choiced/mutant/lizard_snout/init_possible_values()
	return generate_lizard_side_shots(GLOB.snouts_list, "snout", include_snout = FALSE)

/datum/preference/tricolor/mutant/lizard_snout
	savefile_key = "feature_lizard_snout_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/snout
	relevant_feature = "snout_color"
	primary_feature_key = "feature_lizard_snout"

/datum/preference/tricolor/mutant/lizard_snout/get_global_feature_list()
	return GLOB.snouts_list

/datum/preference/choiced/mutant/lizard_spines
	savefile_key = "feature_lizard_spines"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/spines
	relevant_feature = "spines"
	supplemental_feature_key = "feature_lizard_spines_color"

/datum/preference/choiced/mutant/lizard_spines/init_possible_values()
	return assoc_to_keys_features(GLOB.spines_list)

/datum/preference/choiced/mutant/lizard_spines/create_default_value()
	var/datum/sprite_accessory/spines/no_spines = /datum/sprite_accessory/spines/none
	return initial(no_spines.name)

/datum/preference/tricolor/mutant/lizard_spines
	savefile_key = "feature_lizard_spines_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/spines
	relevant_feature = "spines_color"
	primary_feature_key = "feature_lizard_spines"

/datum/preference/tricolor/mutant/lizard_spines/get_global_feature_list()
	return GLOB.spines_list

/datum/preference/choiced/mutant/lizard_tail
	savefile_key = "feature_lizard_tail"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/tail/lizard
	relevant_feature = "tail"
	supplemental_feature_key = "feature_lizard_tail_color"

/datum/preference/choiced/mutant/lizard_tail/init_possible_values()
	return assoc_to_keys_features(GLOB.tails_list_lizard)

/datum/preference/choiced/mutant/lizard_tail/create_default_value()
	var/datum/sprite_accessory/tails/lizard/smooth/tail = /datum/sprite_accessory/tails/lizard/smooth
	return initial(tail.name)

/datum/preference/tricolor/mutant/lizard_tail
	savefile_key = "feature_lizard_tail_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/tail/lizard
	relevant_feature = "tail_color"
	primary_feature_key = "feature_lizard_tail"

/datum/preference/tricolor/mutant/lizard_tail/get_global_feature_list()
	return GLOB.tails_list

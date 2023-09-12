/proc/generate_lizard_side_shot(datum/sprite_accessory/sprite_accessory, key, include_snout = TRUE)
	var/static/icon/lizard
	var/static/icon/lizard_with_snout

	if (isnull(lizard))
		lizard = icon('icons/mob/species/lizard/bodyparts.dmi', "lizard_head", EAST)
		var/icon/eyes = icon('icons/mob/species/human/human_face.dmi', "eyes", EAST)
		eyes.Blend(COLOR_GRAY, ICON_MULTIPLY)
		lizard.Blend(eyes, ICON_OVERLAY)

		lizard_with_snout = icon(lizard)
		lizard_with_snout.Blend(icon('icons/mob/species/lizard/lizard_misc.dmi', "m_snout_round_ADJ", EAST), ICON_OVERLAY)

	var/icon/final_icon = include_snout ? icon(lizard_with_snout) : icon(lizard)

	if (!isnull(sprite_accessory))
		var/icon/accessory_icon = icon(sprite_accessory.icon, "m_[key]_[sprite_accessory.icon_state]_ADJ", EAST)
		final_icon.Blend(accessory_icon, ICON_OVERLAY)

	final_icon.Crop(11, 20, 23, 32)
	final_icon.Scale(32, 32)
	final_icon.Blend(COLOR_VIBRANT_LIME, ICON_MULTIPLY)

	return final_icon

/datum/preference/choiced/mutant/lizard_frills
	savefile_key = "feature_lizard_frills"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Frills"
	should_generate_icons = TRUE
	relevant_cosmetic_organ = /obj/item/organ/frills/lizard
	modified_feature = "frills"
	supplemental_feature_key = "feature_lizard_frills_color"

/datum/preference/choiced/mutant/lizard_frills/init_possible_values()
	return assoc_to_keys_features(GLOB.frills_list)

/datum/preference/choiced/mutant/lizard_frills/icon_for(value)
	return generate_lizard_side_shot(GLOB.frills_list[value], "frills")

/datum/preference/tricolor/mutant/lizard_frills
	savefile_key = "feature_lizard_frills_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/frills/lizard
	modified_feature = "frills_color"
	primary_feature_key = "feature_lizard_frills"

/datum/preference/tricolor/mutant/lizard_frills/get_global_feature_list()
	return GLOB.frills_list

/datum/preference/choiced/mutant/lizard_horns
	savefile_key = "feature_lizard_horns"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Horns"
	should_generate_icons = TRUE
	relevant_cosmetic_organ = /obj/item/organ/horns/lizard
	modified_feature = "horns"
	supplemental_feature_key = "feature_lizard_horns_color"

/datum/preference/choiced/mutant/lizard_horns/init_possible_values()
	return assoc_to_keys_features(GLOB.horns_list)

/datum/preference/choiced/mutant/lizard_horns/icon_for(value)
	return generate_lizard_side_shot(GLOB.horns_list[value], "horns")

/datum/preference/tricolor/mutant/lizard_horns
	savefile_key = "feature_lizard_horns_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/horns/lizard
	modified_feature = "horns_color"
	primary_feature_key = "feature_lizard_horns"

/datum/preference/tricolor/mutant/lizard_horns/get_global_feature_list()
	return GLOB.horns_list

/datum/preference/choiced/mutant/lizard_snout
	savefile_key = "feature_lizard_snout"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Snout"
	should_generate_icons = TRUE
	relevant_cosmetic_organ = /obj/item/organ/snout/lizard
	modified_feature = "snout"
	supplemental_feature_key = "feature_lizard_snout_color"

/datum/preference/choiced/mutant/lizard_snout/init_possible_values()
	return assoc_to_keys_features(GLOB.snouts_list)

/datum/preference/choiced/mutant/lizard_snout/icon_for(value)
	return generate_lizard_side_shot(GLOB.snouts_list[value], "snout", include_snout = FALSE)

/datum/preference/tricolor/mutant/lizard_snout
	savefile_key = "feature_lizard_snout_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/snout/lizard
	modified_feature = "snout_color"
	primary_feature_key = "feature_lizard_snout"

/datum/preference/tricolor/mutant/lizard_snout/get_global_feature_list()
	return GLOB.snouts_list

/datum/preference/choiced/mutant/lizard_spines
	savefile_key = "feature_lizard_spines"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/spines/lizard
	modified_feature = "spines"
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
	modified_feature = "spines_color"
	primary_feature_key = "feature_lizard_spines"

/datum/preference/tricolor/mutant/lizard_spines/get_global_feature_list()
	return GLOB.spines_list

/datum/preference/choiced/mutant/lizard_tail
	savefile_key = "feature_lizard_tail"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/tail/lizard
	modified_feature = "tail"
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
	modified_feature = "tail_color"
	primary_feature_key = "feature_lizard_tail"

/datum/preference/tricolor/mutant/lizard_tail/get_global_feature_list()
	return GLOB.tails_list

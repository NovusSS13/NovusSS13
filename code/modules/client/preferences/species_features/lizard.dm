/proc/generate_lizard_side_shot(datum/sprite_accessory/sprite_accessory, key, include_snout = TRUE, color_accessory = TRUE)
	var/static/icon/lizard
	if (isnull(lizard))
		lizard = icon('icons/mob/species/lizard/bodyparts.dmi', "lizard_head", EAST)
		lizard.Blend(COLOR_VIBRANT_LIME, ICON_MULTIPLY)
		var/icon/eyes = icon('icons/mob/species/human/human_face.dmi', "eyes", EAST)
		eyes.Blend(COLOR_GRAY, ICON_MULTIPLY)
		lizard.Blend(eyes, ICON_OVERLAY)

	var/static/icon/lizard_cropped
	if (isnull(lizard_cropped))
		lizard_cropped = icon(lizard)
		lizard_cropped.Crop(11, 20, 23, 32)
		lizard_cropped.Scale(32, 32)

	var/static/icon/lizard_with_snout
	if (isnull(lizard_with_snout))
		lizard_with_snout = icon(lizard)
		var/icon/snout = icon('icons/mob/species/lizard/lizard_misc.dmi', "m_snout_round_ADJ", EAST)
		snout.Blend(COLOR_VIBRANT_LIME, ICON_MULTIPLY)
		lizard_with_snout.Blend(snout, ICON_OVERLAY)

	var/static/icon/lizard_with_snout_cropped
	if (isnull(lizard_with_snout_cropped))
		lizard_with_snout_cropped = icon(lizard_with_snout)
		lizard_with_snout_cropped.Crop(11, 20, 23, 32)
		lizard_with_snout_cropped.Scale(32, 32)

	if (isnull(sprite_accessory) || !sprite_accessory.icon_state)
		return include_snout ? lizard_with_snout_cropped : lizard_cropped

	var/icon/final_icon = include_snout ? icon(lizard_with_snout) : icon(lizard)

	var/icon/accessory_icon = icon(sprite_accessory.icon, "m_[key]_[sprite_accessory.icon_state]_ADJ", EAST)
	if(color_accessory)
		accessory_icon.Blend(COLOR_VIBRANT_LIME, ICON_MULTIPLY)
	final_icon.Blend(accessory_icon, ICON_OVERLAY)

	final_icon.Crop(11, 20, 23, 32)
	final_icon.Scale(32, 32)

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
	return generate_lizard_side_shot(GLOB.horns_list[value], "horns", color_accessory = FALSE)

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

/datum/preference/choiced/mutant/lizard_snout/create_default_value()
	var/datum/sprite_accessory/snouts/round = /datum/sprite_accessory/snouts/lizard/round
	return initial(round.name)

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
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Tail"
	should_generate_icons = TRUE
	relevant_cosmetic_organ = /obj/item/organ/tail/lizard
	modified_feature = "tail"
	supplemental_feature_key = "feature_lizard_tail_color"

/datum/preference/choiced/mutant/lizard_tail/init_possible_values()
	return assoc_to_keys_features(GLOB.tails_list_lizard)

/datum/preference/choiced/mutant/lizard_tail/create_default_value()
	return SPRITE_ACCESSORY_NONE

/datum/preference/choiced/mutant/lizard_tail/icon_for(value)
	var/static/icon/groin_icon
	if (isnull(groin_icon))
		groin_icon = icon('icons/mob/species/lizard/bodyparts.dmi', "lizard_chest_m", EAST)
		groin_icon.Blend(icon('icons/mob/species/lizard/bodyparts.dmi', "lizard_l_leg", EAST), ICON_UNDERLAY)
		groin_icon.Blend(icon('icons/mob/species/lizard/bodyparts.dmi', "lizard_r_leg", EAST), ICON_OVERLAY)
		groin_icon.Blend(COLOR_VIBRANT_LIME, ICON_MULTIPLY)

	var/static/icon/groin_icon_cropped
	if (isnull(groin_icon_cropped))
		groin_icon_cropped = icon(groin_icon)
		groin_icon_cropped.Crop(1, 1, 15, 13)
		groin_icon_cropped.Scale(32, 32)

	var/datum/sprite_accessory/sprite_accessory = GLOB.tails_list[value]
	if (isnull(sprite_accessory) || !sprite_accessory.icon_state)
		return groin_icon_cropped

	var/icon/final_icon = icon(groin_icon)

	var/static/layers = list("BEHIND", "FRONT") //futureproofing...
	for(var/layer in layers)
		var/icon/accessory_icon = icon(sprite_accessory.icon, "m_tail_lizard_[sprite_accessory.icon_state]_[layer]", EAST)
		accessory_icon.Blend(COLOR_VIBRANT_LIME, ICON_MULTIPLY)
		final_icon.Blend(accessory_icon, ICON_UNDERLAY)

	final_icon.Crop(1, 1, 15, 13)
	final_icon.Scale(32, 32)

	return final_icon

/datum/preference/tricolor/mutant/lizard_tail
	savefile_key = "feature_lizard_tail_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/tail/lizard
	modified_feature = "tail_color"
	primary_feature_key = "feature_lizard_tail"

/datum/preference/tricolor/mutant/lizard_tail/get_global_feature_list()
	return GLOB.tails_list

/datum/preference/choiced/mutant/lizard_spines
	savefile_key = "feature_lizard_spines"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Spines"
	should_generate_icons = TRUE
	relevant_cosmetic_organ = /obj/item/organ/spines/lizard
	modified_feature = "spines"
	supplemental_feature_key = "feature_lizard_spines_color"

/datum/preference/choiced/mutant/lizard_spines/init_possible_values()
	return assoc_to_keys_features(GLOB.spines_list)

/datum/preference/choiced/mutant/lizard_spines/create_default_value(datum/preferences/preferences)
	return SPRITE_ACCESSORY_NONE

/datum/preference/choiced/mutant/lizard_spines/icon_for(value)
	var/static/icon/groin_with_tail
	if (isnull(groin_with_tail))
		groin_with_tail = icon('icons/mob/species/lizard/bodyparts.dmi', "lizard_chest_m", EAST)
		groin_with_tail.Blend(icon('icons/mob/species/lizard/bodyparts.dmi', "lizard_l_leg", EAST), ICON_UNDERLAY)
		groin_with_tail.Blend(icon('icons/mob/species/lizard/bodyparts.dmi', "lizard_r_leg", EAST), ICON_OVERLAY)
		groin_with_tail.Blend(COLOR_VIBRANT_LIME, ICON_MULTIPLY)

		var/icon/tail = icon('icons/mob/species/lizard/lizard_tails.dmi', "m_tail_lizard_smooth_BEHIND", EAST)
		tail.Blend(COLOR_VIBRANT_LIME, ICON_MULTIPLY)
		groin_with_tail.Blend(tail, ICON_UNDERLAY)

	var/static/icon/groin_icon_cropped
	if (isnull(groin_icon_cropped))
		groin_icon_cropped = icon(groin_with_tail)
		groin_icon_cropped.Crop(1, 1, 15, 13)
		groin_icon_cropped.Scale(32, 32)

	var/datum/sprite_accessory/sprite_accessory = GLOB.spines_list[value]
	if (isnull(sprite_accessory) || !sprite_accessory.icon_state)
		return groin_icon_cropped

	var/icon/final_icon = icon(groin_with_tail)

	var/icon/accessory_icon = icon(sprite_accessory.icon, "m_spines_[sprite_accessory.icon_state]_ADJ", EAST)
	accessory_icon.Blend(COLOR_VIBRANT_LIME, ICON_MULTIPLY)
	final_icon.Blend(accessory_icon, ICON_UNDERLAY)

	final_icon.Crop(1, 1, 15, 13)
	final_icon.Scale(32, 32)

	return final_icon

/datum/preference/choiced/mutant/lizard_spines/icon_for(value)
	var/static/icon/groin_with_tail
	if (isnull(groin_with_tail))
		groin_with_tail = icon('icons/mob/species/lizard/bodyparts.dmi', "lizard_chest_m", EAST)
		groin_with_tail.Blend(icon('icons/mob/species/lizard/bodyparts.dmi', "lizard_l_leg", EAST), ICON_UNDERLAY)
		groin_with_tail.Blend(icon('icons/mob/species/lizard/bodyparts.dmi', "lizard_r_leg", EAST), ICON_OVERLAY)
		groin_with_tail.Blend(COLOR_VIBRANT_LIME, ICON_MULTIPLY)

		var/icon/tail = icon('icons/mob/species/lizard/lizard_tails.dmi', "m_tail_lizard_smooth_BEHIND", EAST)
		tail.Blend(COLOR_VIBRANT_LIME, ICON_MULTIPLY)
		groin_with_tail.Blend(tail, ICON_UNDERLAY)

	var/static/icon/groin_icon_cropped
	if (isnull(groin_icon_cropped))
		groin_icon_cropped = icon(groin_with_tail)
		groin_icon_cropped.Crop(1, 1, 15, 13)
		groin_icon_cropped.Scale(32, 32)

	var/datum/sprite_accessory/sprite_accessory = GLOB.spines_list[value]
	if (isnull(sprite_accessory) || !sprite_accessory.icon_state)
		return groin_icon_cropped

	var/icon/final_icon = icon(groin_with_tail)

	var/static/layers = list("ADJ") //futureproofing...
	for(var/layer in layers)
		var/icon/accessory_icon = icon(sprite_accessory.icon, "m_spines_[sprite_accessory.icon_state]_[layer]", EAST)
		accessory_icon.Blend(COLOR_VIBRANT_LIME, ICON_MULTIPLY)
		final_icon.Blend(accessory_icon, ICON_UNDERLAY)

	final_icon.Crop(1, 1, 15, 13)
	final_icon.Scale(32, 32)

	return final_icon

/datum/preference/tricolor/mutant/lizard_spines
	savefile_key = "feature_lizard_spines_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/spines/lizard
	modified_feature = "spines_color"
	primary_feature_key = "feature_lizard_spines"

/datum/preference/tricolor/mutant/lizard_spines/get_global_feature_list()
	return GLOB.spines_list

/datum/preference/choiced/mutant/avali_tail
	savefile_key = "feature_avali_tail"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Tail"
	should_generate_icons = TRUE
	relevant_cosmetic_organ = /obj/item/organ/tail/avali
	modified_feature = "tail"
	supplemental_feature_key = "feature_avali_tail_color"

/datum/preference/choiced/mutant/avali_tail/init_possible_values()
	return assoc_to_keys_features(GLOB.tails_list_avali)

/datum/preference/choiced/mutant/avali_tail/create_default_value()
	var/datum/sprite_accessory/tails/chicken = /datum/sprite_accessory/tails/avali/default
	return initial(chicken.name)

/datum/preference/choiced/mutant/avali_tail/icon_for(value)
	var/static/icon/groin
	if(isnull(groin))
		groin = icon('icons/mob/species/avali/bodyparts_greyscale.dmi', "avali_chest_m", EAST)
		groin.Blend(icon('icons/mob/species/avali/bodyparts_greyscale.dmi', "avali_l_leg", EAST), ICON_UNDERLAY)
		groin.Blend(icon('icons/mob/species/avali/bodyparts_greyscale.dmi', "avali_r_leg", EAST), ICON_OVERLAY)
		groin.Blend(icon('icons/mob/species/avali/bodyparts_greyscale.dmi', "avali_head_m", EAST), ICON_OVERLAY)
		groin.Blend("#c0965f", ICON_MULTIPLY)

	var/datum/sprite_accessory/sprite_accessory = GLOB.tails_list[value]
	var/icon/final_icon = icon(groin)
	var/static/list/colors = list("#c0965f", "#c0965f", "#c0965f")
	blend_bodypart_overlay(final_icon, new /datum/bodypart_overlay/mutant/tail/avali(), sprite_accessory, sprite_accessory.get_default_color(colors), dir = EAST)

	final_icon.Crop(1, 1, 17, 24)
	final_icon.Scale(32, 32)

	return final_icon

/datum/preference/tricolor/mutant/avali_tail
	savefile_key = "feature_avali_tail_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/tail/avali
	modified_feature = "tail_color"
	primary_feature_key = "feature_avali_tail"

/datum/preference/tricolor/mutant/avali_tail/get_global_feature_list()
	return GLOB.tails_list_avali

/datum/preference/choiced/mutant/avali_ears
	savefile_key = "feature_avali_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Ears"
	should_generate_icons = TRUE
	relevant_cosmetic_organ = /obj/item/organ/ears/avali
	modified_feature = "ears"
	supplemental_feature_key = "feature_avali_ears_color"

/datum/preference/choiced/mutant/avali_ears/init_possible_values()
	return assoc_to_keys_features(GLOB.ears_list_avali)

/datum/preference/choiced/mutant/avali_ears/create_default_value()
	var/datum/sprite_accessory/ears/ears = /datum/sprite_accessory/ears/avali/regular
	return initial(ears.name)

/datum/preference/choiced/mutant/avali_ears/icon_for(value)
	var/static/icon/head_icon
	if (isnull(head_icon))
		head_icon = icon('icons/mob/species/avali/bodyparts_greyscale.dmi', "avali_head_f", SOUTH)
		head_icon.Blend("#c0965f", ICON_MULTIPLY)

		var/icon/eyes = icon('icons/mob/species/avali/avali_eyes.dmi', "eyes", SOUTH)
		eyes.Blend(COLOR_GRAY, ICON_MULTIPLY)
		head_icon.Blend(eyes, ICON_OVERLAY)

	var/datum/sprite_accessory/sprite_accessory = GLOB.ears_list[value]
	var/icon/final_icon = icon(head_icon)
	var/static/list/colors = list("#e4c49b", "#e4c49b", "#e4c49b")
	blend_bodypart_overlay(final_icon, new /datum/bodypart_overlay/mutant/ears/avali(), sprite_accessory, sprite_accessory.get_default_color(colors), dir = SOUTH)

	final_icon.Crop(10, 19, 22, 31)
	final_icon.Scale(32, 32)

	return final_icon

/datum/preference/tricolor/mutant/avali_ears
	savefile_key = "feature_avali_ears_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/ears/avali
	modified_feature = "ears_color"
	primary_feature_key = "feature_avali_ears"

/datum/preference/tricolor/mutant/avali_ears/get_global_feature_list()
	return GLOB.ears_list_avali

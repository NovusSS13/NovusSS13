/datum/preference/choiced/mutant/felinid_tail
	savefile_key = "feature_felinid_tail"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Tail"
	should_generate_icons = TRUE
	relevant_cosmetic_organ = /obj/item/organ/tail/cat
	modified_feature = "tail"
	supplemental_feature_key = "feature_felinid_tail_color"

/datum/preference/choiced/mutant/felinid_tail/init_possible_values()
	return assoc_to_keys_features(GLOB.tails_list_human)

/datum/preference/choiced/mutant/felinid_tail/create_default_value()
	var/datum/sprite_accessory/tails/cat = /datum/sprite_accessory/tails/human/cat
	return initial(cat.name)

/datum/preference/choiced/mutant/felinid_tail/icon_for(value)
	var/static/icon/groin
	if (isnull(groin))
		groin = icon('icons/mob/human/bodyparts_greyscale.dmi', "human_chest_m", EAST)
		groin.Blend(icon('icons/mob/human/bodyparts_greyscale.dmi', "human_l_leg", EAST), ICON_UNDERLAY)
		groin.Blend(icon('icons/mob/human/bodyparts_greyscale.dmi', "human_r_leg", EAST), ICON_OVERLAY)
		groin.Blend(icon('icons/mob/human/bodyparts_greyscale.dmi', "human_head_m", EAST), ICON_OVERLAY)
		var/icon/hair = icon('icons/mob/human/sprite_accessory/human_face.dmi', "hair_long", EAST)
		hair.Blend(COLOR_PINK, ICON_MULTIPLY)
		groin.Blend(hair, ICON_OVERLAY)

	var/static/icon/groin_cropped
	if (isnull(groin_cropped))
		groin_cropped = icon(groin)
		groin_cropped.Crop(1, 10, 15, 26)
		groin_cropped.Scale(32, 32)

	var/datum/sprite_accessory/sprite_accessory = GLOB.tails_list[value]
	if (!is_valid_rendering_sprite_accessory(sprite_accessory))
		return groin_cropped

	var/icon/final_icon = icon(groin)
	var/static/list/colors = list(COLOR_PINK, COLOR_PINK, COLOR_PINK)
	blend_bodypart_overlay(final_icon, new /datum/bodypart_overlay/mutant/tail/cat(), sprite_accessory, sprite_accessory.get_default_color(colors), dir = EAST)

	final_icon.Crop(1, 10, 15, 26)
	final_icon.Scale(32, 32)

	return final_icon

/datum/preference/tricolor/mutant/felinid_tail
	savefile_key = "feature_felinid_tail_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/tail/cat
	modified_feature = "tail_color"
	primary_feature_key = "feature_felinid_tail"

/datum/preference/tricolor/mutant/felinid_tail/get_global_feature_list()
	return GLOB.tails_list

/datum/preference/choiced/mutant/felinid_ears
	savefile_key = "feature_felinid_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Ears"
	should_generate_icons = TRUE
	relevant_cosmetic_organ = /obj/item/organ/ears/cat
	modified_feature = "ears"
	supplemental_feature_key = "feature_felinid_ears_color"

/datum/preference/choiced/mutant/felinid_ears/init_possible_values()
	return assoc_to_keys_features(GLOB.ears_list_human)

/datum/preference/choiced/mutant/felinid_ears/create_default_value()
	var/datum/sprite_accessory/ears/ears = /datum/sprite_accessory/ears/human/cat
	return initial(ears.name)

/datum/preference/choiced/mutant/felinid_ears/icon_for(value)
	var/static/icon/head_icon
	if (isnull(head_icon))
		head_icon = icon('icons/mob/human/bodyparts_greyscale.dmi', "human_head_f", SOUTH)
		var/icon/eyes = icon('icons/mob/human/sprite_accessory/human_face.dmi', "eyes", SOUTH)
		eyes.Blend(COLOR_GRAY, ICON_MULTIPLY)
		head_icon.Blend(eyes, ICON_OVERLAY)
		var/icon/hair = icon('icons/mob/human/sprite_accessory/human_face.dmi', "hair_long", SOUTH)
		hair.Blend(COLOR_PINK, ICON_MULTIPLY)
		head_icon.Blend(hair, ICON_OVERLAY)

	var/static/icon/head_icon_cropped //for baldies
	if (isnull(head_icon_cropped))
		head_icon_cropped = icon(head_icon)
		head_icon_cropped.Crop(10, 19, 22, 31)
		head_icon_cropped.Scale(32, 32)

	var/datum/sprite_accessory/sprite_accessory = GLOB.ears_list[value]
	if (!is_valid_rendering_sprite_accessory(sprite_accessory))
		return head_icon_cropped

	var/icon/final_icon = icon(head_icon)
	var/static/list/colors = list(COLOR_PINK, COLOR_PINK, COLOR_PINK)
	blend_bodypart_overlay(final_icon, new /datum/bodypart_overlay/mutant/ears/cat(), sprite_accessory, sprite_accessory.get_default_color(colors), dir = SOUTH)

	final_icon.Crop(10, 19, 22, 31)
	final_icon.Scale(32, 32)

	return final_icon

/datum/preference/tricolor/mutant/felinid_ears
	savefile_key = "feature_felinid_ears_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/ears/cat
	modified_feature = "ears_color"
	primary_feature_key = "feature_felinid_ears"

/datum/preference/tricolor/mutant/felinid_ears/get_global_feature_list()
	return GLOB.ears_list_human

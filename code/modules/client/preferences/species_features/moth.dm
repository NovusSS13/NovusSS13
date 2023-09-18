/datum/preference/choiced/mutant/moth_antennae
	savefile_key = "feature_moth_antennae"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Antennae"
	should_generate_icons = TRUE
	relevant_cosmetic_organ = /obj/item/organ/antennae
	modified_feature = "moth_antennae"

/datum/preference/choiced/mutant/moth_antennae/init_possible_values()
	return assoc_to_keys_features(GLOB.moth_antennae_list)

/datum/preference/choiced/mutant/moth_antennae/icon_for(value)
	var/static/icon/moth_head

	if (isnull(moth_head))
		moth_head = icon('icons/mob/species/moth/bodyparts.dmi', "moth_head", SOUTH)
		moth_head.Blend(icon('icons/mob/species/sprite_accessory/human_face.dmi', "motheyes_l", SOUTH), ICON_OVERLAY)
		moth_head.Blend(icon('icons/mob/species/sprite_accessory/human_face.dmi', "motheyes_r", SOUTH), ICON_OVERLAY)

	var/datum/sprite_accessory/sprite_accessory = GLOB.moth_antennae_list[value]
	if (!is_valid_rendering_sprite_accessory(sprite_accessory))
		return moth_head

	var/icon/final_icon = new(moth_head)
	blend_bodypart_overlay(final_icon, new /datum/bodypart_overlay/mutant/antennae, sprite_accessory, dir = SOUTH)

	final_icon.Scale(64, 64)
	final_icon.Crop(15, 64, 15 + 31, 64 - 31)

	return final_icon

/datum/preference/choiced/mutant/moth_wings
	savefile_key = "feature_moth_wings"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Moth wings"
	should_generate_icons = TRUE
	modified_feature = "moth_wings"
	relevant_cosmetic_organ = /obj/item/organ/wings/moth

/datum/preference/choiced/mutant/moth_wings/init_possible_values()
	return assoc_to_keys_features(GLOB.moth_wings_list)

/datum/preference/choiced/mutant/moth_wings/icon_for(value)
	var/static/icon/moth_chest = icon('icons/mob/species/moth/bodyparts.dmi', "moth_chest_m", NORTH)

	var/datum/sprite_accessory/sprite_accessory = GLOB.moth_wings_list[value]
	if (!is_valid_rendering_sprite_accessory(sprite_accessory))
		return moth_chest

	var/icon/final_icon = new(moth_chest)
	blend_bodypart_overlay(final_icon, new /datum/bodypart_overlay/mutant/wings/moth, sprite_accessory, dir = NORTH)

	final_icon.Crop(10, 1, 22, 13)
	final_icon.Scale(32, 32)

	return final_icon

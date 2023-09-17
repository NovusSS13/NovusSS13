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
		moth_head = icon('icons/mob/species/moth/bodyparts.dmi', "moth_head")
		moth_head.Blend(icon('icons/mob/species/sprite_accessory/human_face.dmi', "motheyes_l"), ICON_OVERLAY)
		moth_head.Blend(icon('icons/mob/species/sprite_accessory/human_face.dmi', "motheyes_r"), ICON_OVERLAY)

	var/datum/sprite_accessory/antennae = GLOB.moth_antennae_list[value]

	var/icon/icon_with_antennae = new(moth_head)
	icon_with_antennae.Blend(icon(antennae.icon, "m_moth_antennae_[antennae.icon_state]_FRONT"), ICON_OVERLAY)
	icon_with_antennae.Scale(64, 64)
	icon_with_antennae.Crop(15, 64, 15 + 31, 64 - 31)

	return icon_with_antennae

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
	var/datum/sprite_accessory/moth_wings = GLOB.moth_wings_list[value]
	var/icon/final_icon = icon(moth_wings.icon, "m_moth_wings_[moth_wings.icon_state]_BEHIND")
	final_icon.Blend(icon(moth_wings.icon, "m_moth_wings_[moth_wings.icon_state]_FRONT"), ICON_OVERLAY)
	return final_icon

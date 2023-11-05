/datum/preference/choiced/mutant/pod_hair
	savefile_key = "feature_pod_hair"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Hairstyle"
	should_generate_icons = TRUE
	modified_feature = "pod_hair"

/datum/preference/choiced/mutant/pod_hair/init_possible_values()
	return assoc_to_keys_features(GLOB.pod_hair_list)

/datum/preference/choiced/mutant/pod_hair/icon_for(value)
	var/static/icon/icon_with_hair
	if (isnull(icon_with_hair))
		icon_with_hair = icon('icons/mob/human/bodyparts_greyscale.dmi', "pod_head_m")

	var/datum/sprite_accessory/sprite_accessory = GLOB.pod_hair_list[value]
	if (!is_valid_rendering_sprite_accessory(sprite_accessory))
		return icon_with_hair

	var/icon/icon_adj = icon(sprite_accessory.icon, "m_pod_hair_[sprite_accessory.icon_state]_ADJ")
	var/icon/icon_front = icon(sprite_accessory.icon, "m_pod_hair_[sprite_accessory.icon_state]_FRONT")
	icon_adj.Blend(icon_front, ICON_OVERLAY)
	icon_with_hair.Blend(icon_adj, ICON_OVERLAY)
	icon_with_hair.Scale(64, 64)
	icon_with_hair.Crop(15, 64, 15 + 31, 64 - 31)
	icon_with_hair.Blend(COLOR_GREEN, ICON_MULTIPLY)

	return icon_with_hair

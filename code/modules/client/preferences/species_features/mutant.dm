/proc/generate_mutant_face_shot(datum/sprite_accessory/sprite_accessory, bodypart_overlay_type = /datum/bodypart_overlay/mutant, include_snout = TRUE, color_accessory = TRUE)
	var/static/icon/head_icon
	if (isnull(head_icon))
		head_icon = icon('icons/mob/species/mutant/mutant_bodyparts.dmi', "mutant_head_m", SOUTH)
		head_icon.Blend(COLOR_ORANGE, ICON_MULTIPLY)
		var/icon/eyes = icon('icons/mob/species/sprite_accessory/human_face.dmi', "eyes", SOUTH)
		eyes.Blend(COLOR_GRAY, ICON_MULTIPLY)
		head_icon.Blend(eyes, ICON_OVERLAY)

	var/static/icon/head_icon_cropped
	if (isnull(head_icon_cropped))
		head_icon_cropped = icon(head_icon)
		head_icon_cropped.Crop(10, 19, 22, 31)
		head_icon_cropped.Scale(32, 32)

	var/static/icon/head_icon_with_snout
	if (isnull(head_icon_with_snout))
		head_icon_with_snout = icon(head_icon)
		var/icon/snout = icon('icons/mob/species/lizard/lizard_features.dmi', "m_snout_sharplight_ADJ", SOUTH)
		snout.Blend(COLOR_ORANGE, ICON_MULTIPLY)
		head_icon_with_snout.Blend(snout, ICON_OVERLAY)

	var/static/icon/head_icon_with_snout_cropped
	if (isnull(head_icon_with_snout_cropped))
		head_icon_with_snout_cropped = icon(head_icon_with_snout)
		head_icon_with_snout_cropped.Crop(10, 19, 22, 31)
		head_icon_with_snout_cropped.Scale(32, 32)

	if (!is_valid_rendering_sprite_accessory(sprite_accessory))
		return include_snout ? head_icon_with_snout_cropped : head_icon_cropped

	var/icon/final_icon = include_snout ? icon(head_icon_with_snout) : icon(head_icon)
	var/static/list/colors = list(COLOR_ORANGE, COLOR_SOFT_RED, COLOR_WHITE)
	blend_bodypart_overlay(final_icon, new bodypart_overlay_type(), sprite_accessory, color_accessory ? colors : null, dir = SOUTH)

	final_icon.Crop(10, 19, 22, 31)
	final_icon.Scale(32, 32)

	return final_icon

/datum/preference/tricolor/mutant/mutant_color
	savefile_key = "feature_mcolor"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	modified_feature = "mcolor"

/datum/preference/tricolor/mutant/mutant_color/is_accessible(datum/preferences/preferences)
	. = ..()
	if(!.)
		return FALSE

	var/species_type = preferences.read_preference(/datum/preference/choiced/species)
	var/datum/species/species = new species_type
	return !(TRAIT_FIXED_MUTANT_COLORS in species.inherent_traits)

/datum/preference/tricolor/mutant/mutant_color/create_default_value()
	var/random_color = sanitize_hexcolor("[pick("7F", "FF")][pick("7F", "FF")][pick("7F", "FF")]", include_crunch = TRUE)
	return list(random_color, random_color, random_color)

/datum/preference/tricolor/mutant/mutant_color/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["mcolor"] = value

/datum/preference/choiced/mutant/bodypart_type
	priority = PREFERENCE_PRIORITY_BODYPARTS //kinda obvious, isn't it?
	savefile_key = "feature_bodypart_type"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES

/datum/preference/choiced/mutant/bodypart_type/is_accessible(datum/preferences/preferences)
	. = ..()
	if(!.)
		return FALSE

	var/datum/species/species_type = preferences.read_preference(/datum/preference/choiced/species)
	return (initial(species_type.custom_bodyparts))

/datum/preference/choiced/mutant/bodypart_type/init_possible_values()
	return GLOB.pref_bodypart_names

/datum/preference/choiced/mutant/bodypart_type/create_default_value()
	return GLOB.pref_bodypart_names[1] //should be "Mutant"

/datum/preference/choiced/mutant/bodypart_type/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/prefs)
	if(!is_accessible(prefs))
		return
	/*
	//this is such a niche thing that I don't think it's worth it to make it a global
	var/static/list/bodypart_id_to_zone_to_dimorphic
	*/
	if(!length(GLOB.bodypart_id_to_zone_to_dimorphic))
		GLOB.bodypart_id_to_zone_to_dimorphic = list()
		for(var/pref_name in GLOB.pref_bodypart_names)
			var/limb_id = GLOB.pref_bodypart_names[pref_name]
			for(var/path in GLOB.bodyparts_by_limb_id[limb_id])
				var/obj/item/bodypart/bodypart = GLOB.bodyparts_by_limb_id[limb_id][path]
				if(!bodypart.body_zone)
					continue
				LAZYSET(GLOB.bodypart_id_to_zone_to_dimorphic[limb_id], bodypart.body_zone, bodypart.is_dimorphic)
	var/limb_id = GLOB.pref_bodypart_names[value]
	for(var/obj/item/bodypart/bodypart as anything in target.bodyparts)
		bodypart.change_appearance(GLOB.pref_bodypart_id_to_icon[limb_id], \
								limb_id, \
								TRUE,
								GLOB.bodypart_id_to_zone_to_dimorphic[limb_id][bodypart.body_zone], \
								update = FALSE)
	target.update_body(is_creating = TRUE)

/datum/preference/choiced/mutant/leg_type
	savefile_key = "feature_leg_type"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	modified_feature = "legs"

/datum/preference/choiced/mutant/leg_type/is_accessible(datum/preferences/preferences)
	. = ..()
	if(!.)
		return FALSE

	var/datum/species/species_type = preferences.read_preference(/datum/preference/choiced/species)
	return (initial(species_type.digitigrade_customization) == DIGITIGRADE_OPTIONAL)

/datum/preference/choiced/mutant/leg_type/init_possible_values()
	return assoc_to_keys_features(GLOB.legs_list)

/datum/preference/choiced/mutant/ears
	savefile_key = "feature_mutant_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Ears"
	should_generate_icons = TRUE
	relevant_cosmetic_organ = /obj/item/organ/ears/mutant
	modified_feature = "ears"
	supplemental_feature_key = "feature_mutant_ears_color"

/datum/preference/choiced/mutant/ears/init_possible_values()
	return assoc_to_keys_features(GLOB.ears_list)

/datum/preference/choiced/mutant/ears/create_default_value()
	return SPRITE_ACCESSORY_NONE

/datum/preference/choiced/mutant/ears/icon_for(value)
	return generate_mutant_face_shot(GLOB.ears_list[value], /datum/bodypart_overlay/mutant/ears/mutant)

/datum/preference/tricolor/mutant/ears
	savefile_key = "feature_mutant_ears_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/ears/mutant
	modified_feature = "ears_color"
	primary_feature_key = "feature_mutant_ears"

/datum/preference/tricolor/mutant/ears/get_global_feature_list()
	return GLOB.ears_list

/datum/preference/choiced/mutant/tail
	savefile_key = "feature_mutant_tail"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Tail"
	should_generate_icons = TRUE
	relevant_cosmetic_organ = /obj/item/organ/tail/mutant
	modified_feature = "tail"
	supplemental_feature_key = "feature_mutant_tail_color"

/datum/preference/choiced/mutant/tail/init_possible_values()
	return assoc_to_keys_features(GLOB.tails_list)

/datum/preference/choiced/mutant/tail/create_default_value()
	return SPRITE_ACCESSORY_NONE

/datum/preference/choiced/mutant/tail/icon_for(value)
	var/static/icon/groin_icon
	if (isnull(groin_icon))
		groin_icon = icon('icons/mob/species/mutant/mutant_bodyparts.dmi', "mutant_chest_m", EAST)
		groin_icon.Blend(icon('icons/mob/species/mutant/mutant_bodyparts.dmi', "mutant_l_leg", EAST), ICON_UNDERLAY)
		groin_icon.Blend(icon('icons/mob/species/mutant/mutant_bodyparts.dmi', "mutant_r_leg", EAST), ICON_OVERLAY)
		groin_icon.Blend(COLOR_ORANGE, ICON_MULTIPLY)

	var/static/icon/groin_icon_cropped
	if (isnull(groin_icon_cropped))
		groin_icon_cropped = icon(groin_icon)
		groin_icon_cropped.Crop(1, 1, 15, 13)
		groin_icon_cropped.Scale(32, 32)

	var/datum/sprite_accessory/sprite_accessory = GLOB.tails_list[value]
	if (!is_valid_rendering_sprite_accessory(sprite_accessory))
		return groin_icon_cropped

	var/icon/final_icon = icon(groin_icon)
	var/static/list/colors = list(COLOR_ORANGE, COLOR_SOFT_RED, COLOR_WHITE)
	blend_bodypart_overlay(final_icon, new /datum/bodypart_overlay/mutant/tail/mutant(), sprite_accessory, colors, dir = EAST)

	final_icon.Crop(1, 1, 15, 13)
	final_icon.Scale(32, 32)

	return final_icon

/datum/preference/tricolor/mutant/tail
	savefile_key = "feature_mutant_tail_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/tail/mutant
	modified_feature = "tail_color"
	primary_feature_key = "feature_mutant_tail"

/datum/preference/tricolor/mutant/tail/get_global_feature_list()
	return GLOB.tails_list

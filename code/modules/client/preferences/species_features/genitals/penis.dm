/datum/preference/choiced/penis
	savefile_key = "feature_penis"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/genital/penis

/datum/preference/choiced/penis/init_possible_values()
	return assoc_to_keys_features(GLOB.penis_list)

/datum/preference/choiced/penis/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["penis"] = value

/datum/preference/choiced/penis/create_informed_default_value(datum/preferences/preferences)
	if(preferences.read_preference(/datum/preference/choiced/gender) != MALE)
		return SPRITE_ACCESSORY_NONE

	var/datum/sprite_accessory/penis/boring_human_penis = /datum/sprite_accessory/penis/human
	return initial(boring_human_penis.name)


/datum/preference/choiced/penis_size
	savefile_key = "feature_penis_size"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/genital/penis

/datum/preference/choiced/penis_size/init_possible_values()
	return assoc_to_keys(GLOB.penis_size_names)

/datum/preference/choiced/penis_size/compile_constant_data()
	var/list/data = ..()

	data[CHOICED_PREFERENCE_DISPLAY_NAMES] = GLOB.penis_size_names

	return data

/datum/preference/choiced/penis_size/is_accessible(datum/preferences/preferences)
	return ..() && preferences.read_preference(/datum/preference/choiced/penis) != SPRITE_ACCESSORY_NONE

/datum/preference/choiced/penis_size/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["penis_size"] = value

/datum/preference/choiced/penis_size/create_default_value()
	return "2"


/datum/preference/toggle/penis_uses_skintone
	savefile_key = "feature_penis_skintone"
	savefile_identifier = PREFERENCE_CHARACTER
	priority = PREFERENCE_PRIORITY_BODYPARTS
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/genital/penis

/datum/preference/toggle/penis_uses_skintone/is_accessible(datum/preferences/preferences)
	return ..() && preferences.read_preference(/datum/preference/choiced/penis) != SPRITE_ACCESSORY_NONE

/datum/preference/toggle/penis_uses_skintone/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/prefs)
	var/obj/item/organ/genital/penis = target.get_organ_slot(ORGAN_SLOT_PENIS)
	if(isnull(penis))
		return

	var/datum/bodypart_overlay/mutant/genital/overlay = penis.bodypart_overlay
	overlay.uses_skintone = value

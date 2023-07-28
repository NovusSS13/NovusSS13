/datum/preference/choiced/vagina_shape
	savefile_key = "feature_vagina_shape"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/genital/vagina

/datum/preference/choiced/vagina_shape/init_possible_values()
	return assoc_to_keys_features(GLOB.vagina_list)

/datum/preference/choiced/vagina_shape/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["vagina"] = value

/datum/preference/choiced/vagina_shape/create_informed_default_value(datum/preferences/preferences)
	if(preferences.read_preference(/datum/preference/choiced/body_type) != FEMALE)
		return SPRITE_ACCESSORY_NONE

	var/datum/sprite_accessory/penis/boring_human_vagina = /datum/sprite_accessory/vagina/human
	return initial(boring_human_vagina.name)


/datum/preference/toggle/vagina_uses_skintone
	savefile_key = "feature_vagina_skintone"
	savefile_identifier = PREFERENCE_CHARACTER
	priority = PREFERENCE_PRIORITY_BODYPARTS
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/genital/vagina

/datum/preference/toggle/vagina_uses_skintone/is_accessible(datum/preferences/preferences)
	return ..() && preferences.read_preference(/datum/preference/choiced/vagina_shape) != SPRITE_ACCESSORY_NONE

/datum/preference/toggle/vagina_uses_skintone/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/prefs)
	var/obj/item/organ/genital/vagina = target.get_organ_slot(ORGAN_SLOT_VAGINA)
	if(isnull(vagina))
		return

	var/datum/bodypart_overlay/mutant/genital/overlay = vagina.bodypart_overlay
	overlay.uses_skintone = value

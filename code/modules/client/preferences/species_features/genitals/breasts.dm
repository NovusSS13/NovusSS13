/datum/preference/choiced/breasts
	savefile_key = "feature_breasts"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/genital/breasts

/datum/preference/choiced/breasts/init_possible_values()
	return assoc_to_keys_features(GLOB.breasts_list)

/datum/preference/choiced/breasts/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["breasts"] = value

/datum/preference/choiced/breasts/create_informed_default_value(datum/preferences/preferences)
	if(preferences.read_preference(/datum/preference/choiced/gender) != FEMALE)
		return SPRITE_ACCESSORY_NONE

	var/datum/sprite_accessory/penis/boring_human_breasts = /datum/sprite_accessory/breasts/pair
	return initial(boring_human_breasts.name)


/datum/preference/choiced/breasts_size
	savefile_key = "feature_breasts_size"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/genital/breasts

/datum/preference/choiced/breasts_size/init_possible_values()
	return assoc_to_keys(GLOB.breasts_size_names)

/datum/preference/choiced/breasts_size/compile_constant_data()
	var/list/data = ..()

	data[CHOICED_PREFERENCE_DISPLAY_NAMES] = GLOB.breasts_size_names

	return data

/datum/preference/choiced/breasts_size/is_accessible(datum/preferences/preferences)
	return ..() && preferences.read_preference(/datum/preference/choiced/breasts) != SPRITE_ACCESSORY_NONE

/datum/preference/choiced/breasts_size/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["breasts_size"] = value

/datum/preference/choiced/breasts_size/create_default_value()
	return "2"


/datum/preference/toggle/breasts_uses_skintone
	savefile_key = "feature_breasts_skintone"
	savefile_identifier = PREFERENCE_CHARACTER
	priority = PREFERENCE_PRIORITY_BODYPARTS
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/genital/breasts

/datum/preference/toggle/breasts_uses_skintone/is_accessible(datum/preferences/preferences)
	return ..() && preferences.read_preference(/datum/preference/choiced/breasts) != SPRITE_ACCESSORY_NONE

/datum/preference/toggle/breasts_uses_skintone/create_informed_default_value(datum/preferences/preferences)
	var/species_type = preferences.read_preference(/datum/preference/choiced/species)
	var/datum/species/species = new species_type
	return (TRAIT_USES_SKINTONES in species.inherent_traits)

/datum/preference/toggle/breasts_uses_skintone/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/prefs)
	var/obj/item/organ/genital/breasts = target.get_organ_slot(ORGAN_SLOT_BREASTS)
	if(isnull(breasts))
		return

	var/datum/bodypart_overlay/mutant/genital/overlay = breasts?.bodypart_overlay
	overlay.uses_skintone = value

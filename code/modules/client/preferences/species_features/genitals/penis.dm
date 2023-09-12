/datum/preference/choiced/mutant/penis
	savefile_key = "feature_penis"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/genital/penis
	modified_feature = "penis"
	supplemental_feature_key = "feature_penis_color"

/datum/preference/choiced/mutant/penis/init_possible_values()
	return assoc_to_keys_features(GLOB.penis_list)

/datum/preference/choiced/mutant/penis_size
	savefile_key = "feature_penis_size"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/genital/penis
	modified_feature = "penis_size"

/datum/preference/choiced/mutant/penis_size/init_possible_values()
	return assoc_to_keys(GLOB.penis_size_names)

/datum/preference/choiced/mutant/penis_size/compile_constant_data()
	var/list/data = ..()

	data[CHOICED_PREFERENCE_DISPLAY_NAMES] = GLOB.penis_size_names

	return data

/datum/preference/choiced/mutant/penis_size/is_accessible(datum/preferences/preferences)
	return ..() && preferences.read_preference(/datum/preference/choiced/mutant/penis) != SPRITE_ACCESSORY_NONE

/datum/preference/choiced/mutant/penis_size/create_default_value()
	return "2"

/datum/preference/tricolor/mutant/penis
	savefile_key = "feature_penis_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/genital/penis
	modified_feature = "penis_color"
	primary_feature_key = "feature_penis"

/datum/preference/tricolor/mutant/penis/is_accessible(datum/preferences/preferences)
	return ..() && preferences.read_preference(/datum/preference/choiced/mutant/penis) != SPRITE_ACCESSORY_NONE

/datum/preference/tricolor/mutant/penis/get_global_feature_list()
	return GLOB.penis_list

/datum/preference/toggle/penis_uses_skintone
	savefile_key = "feature_penis_skintone"
	savefile_identifier = PREFERENCE_CHARACTER
	priority = PREFERENCE_PRIORITY_BODYPARTS
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_inherent_trait = TRAIT_USES_SKINTONES
	relevant_cosmetic_organ = /obj/item/organ/genital/penis

/datum/preference/toggle/penis_uses_skintone/is_accessible(datum/preferences/preferences)
	return ..() && preferences.read_preference(/datum/preference/choiced/mutant/penis) != SPRITE_ACCESSORY_NONE

/datum/preference/toggle/penis_uses_skintone/create_informed_default_value(datum/preferences/preferences)
	var/species_type = preferences.read_preference(/datum/preference/choiced/species)
	var/datum/species/species = new species_type
	return (TRAIT_USES_SKINTONES in species.inherent_traits)

/datum/preference/toggle/penis_uses_skintone/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/prefs)
	var/obj/item/organ/genital/penis = target.get_organ_slot(ORGAN_SLOT_PENIS)
	if(isnull(penis) || !HAS_TRAIT_FROM(target, TRAIT_USES_SKINTONES, SPECIES_TRAIT))
		return

	var/datum/bodypart_overlay/mutant/genital/overlay = penis.bodypart_overlay
	overlay.uses_skintone = value

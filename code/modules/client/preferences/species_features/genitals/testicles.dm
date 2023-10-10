/datum/preference/choiced/mutant/testicles
	savefile_key = "feature_testicles"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/genital/testicles
	modified_feature = "testicles"
	supplemental_feature_key = "feature_testicles_color"
	randomize_by_default = FALSE

/datum/preference/choiced/mutant/testicles/init_possible_values()
	return assoc_to_keys_features(GLOB.testicles_list)

/datum/preference/choiced/mutant/testicles/included_in_randomization_flags(randomize_flags)
	return ..() && !!(randomize_flags & RANDOMIZE_GENITALS)

/datum/preference/choiced/mutant/testicles/create_default_value(datum/preferences/preferences)
	return SPRITE_ACCESSORY_NONE // the gender checks dont work rn, aaaa
	/*
	if(preferences?.read_preference(/datum/preference/choiced/gender) != MALE)
		return SPRITE_ACCESSORY_NONE

	var/datum/sprite_accessory/genital/testicles/testicles = /datum/sprite_accessory/genital/testicles/pair
	return initial(testicles.name)
	*/

/datum/preference/choiced/mutant/testicles_size
	savefile_key = "feature_testicles_size"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/genital/testicles
	modified_feature = "testicles_size"
	randomize_by_default = FALSE

/datum/preference/choiced/mutant/testicles_size/init_possible_values()
	return assoc_to_keys(GLOB.testicles_size_names)

/datum/preference/choiced/mutant/testicles_size/included_in_randomization_flags(randomize_flags)
	return ..() && !!(randomize_flags & RANDOMIZE_GENITALS)

/datum/preference/choiced/mutant/testicles_size/compile_constant_data()
	var/list/data = ..()

	data[CHOICED_PREFERENCE_DISPLAY_NAMES] = GLOB.penis_size_names

	return data

/datum/preference/choiced/mutant/testicles_size/is_accessible(datum/preferences/preferences)
	return ..() && preferences.read_preference(/datum/preference/choiced/mutant/testicles) != SPRITE_ACCESSORY_NONE

/datum/preference/choiced/mutant/testicles_size/create_default_value(datum/preferences/preferences)
	return "2"

/datum/preference/tricolor/mutant/testicles
	savefile_key = "feature_testicles_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/genital/testicles
	modified_feature = "testicles_color"
	primary_feature_key = "feature_testicles"
	randomize_by_default = FALSE

/datum/preference/tricolor/mutant/testicles/is_accessible(datum/preferences/preferences)
	if(preferences.read_preference(/datum/preference/choiced/mutant/testicles) == SPRITE_ACCESSORY_NONE)
		return FALSE
	/*
	if(preferences.read_preference(/datum/preference/toggle/testicles_uses_skintone))
		return FALSE
	*/
	return ..()

/datum/preference/tricolor/mutant/testicles/get_global_feature_list()
	return GLOB.testicles_list

/datum/preference/tricolor/mutant/testicles/included_in_randomization_flags(randomize_flags)
	return ..() && !!(randomize_flags & RANDOMIZE_GENITALS)


/datum/preference/toggle/testicles_uses_skintone
	savefile_key = "feature_testicles_skintone"
	savefile_identifier = PREFERENCE_CHARACTER
	priority = PREFERENCE_PRIORITY_BODYPARTS
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_inherent_trait = TRAIT_USES_SKINTONES
	relevant_cosmetic_organ = /obj/item/organ/genital/testicles
	randomize_by_default = FALSE
	priority = PREFERENCE_PRIORITY_BODYPARTS

/datum/preference/toggle/testicles_uses_skintone/included_in_randomization_flags(randomize_flags)
	return ..() && !!(randomize_flags & RANDOMIZE_GENITALS)

/datum/preference/toggle/testicles_uses_skintone/is_accessible(datum/preferences/preferences)
	return ..() && preferences.read_preference(/datum/preference/choiced/mutant/testicles) != SPRITE_ACCESSORY_NONE

/datum/preference/toggle/testicles_uses_skintone/create_default_value(datum/preferences/preferences)
	if(!preferences)
		return TRUE

	var/species_type = preferences.read_preference(/datum/preference/choiced/species)
	var/datum/species/species = new species_type
	return (TRAIT_USES_SKINTONES in species.inherent_traits)

/datum/preference/toggle/testicles_uses_skintone/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/prefs)
	var/obj/item/organ/genital/testicles = target.get_organ_slot(ORGAN_SLOT_TESTICLES)
	if(isnull(testicles) || !HAS_TRAIT_FROM(target, TRAIT_USES_SKINTONES, SPECIES_TRAIT))
		return

	var/datum/bodypart_overlay/mutant/genital/overlay = testicles.bodypart_overlay
	overlay.uses_skintone = value

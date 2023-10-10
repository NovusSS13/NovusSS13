/datum/preference/choiced/mutant/anus
	savefile_key = "feature_anus"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/genital/anus
	modified_feature = "anus"
	randomize_by_default = FALSE

/datum/preference/choiced/mutant/anus/init_possible_values()
	return assoc_to_keys_features(GLOB.anus_list)

/datum/preference/choiced/mutant/anus/included_in_randomization_flags(randomize_flags)
	return ..() && !!(randomize_flags & RANDOMIZE_GENITALS)

/datum/preference/choiced/mutant/anus/create_default_value(datum/preferences/preferences)
	return SPRITE_ACCESSORY_NONE

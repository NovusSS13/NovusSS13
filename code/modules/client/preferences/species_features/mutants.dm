/datum/preference/choiced/mutant/leg_type
	savefile_key = "feature_leg_type"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	modified_feature = "legs"

/datum/preference/choiced/mutant/leg_type/is_accessible(datum/preferences/preferences)
	. = ..()
	if(!.)
		return FALSE

	var/species_type = preferences.read_preference(/datum/preference/choiced/species)
	var/datum/species/species = new species_type
	return (species.digitigrade_customization == DIGITIGRADE_OPTIONAL)

/datum/preference/choiced/mutant/leg_type/init_possible_values()
	return assoc_to_keys_features(GLOB.legs_list)

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

/datum/preference/tricolor/mutant/mutant_color/create_default_value(datum/preferences/preferences)
	return list(COLOR_VIBRANT_LIME, COLOR_VIBRANT_LIME, COLOR_VIBRANT_LIME)

/datum/preference/tricolor/mutant/mutant_color/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["mcolor"] = value

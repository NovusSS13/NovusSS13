/datum/preference/tricolor/mutant/mutant_color
	savefile_key = "feature_mcolor"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	modified_feature = "mcolor"

/datum/preference/tricolor/mutant/mutant_color/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	var/species_type = preferences.read_preference(/datum/preference/choiced/species)
	var/datum/species/species = new species_type
	return !(TRAIT_FIXED_MUTANT_COLORS in species.inherent_traits)

/datum/preference/tricolor/mutant/mutant_color/create_default_value()
	var/random_color = sanitize_hexcolor("[pick("7F", "FF")][pick("7F", "FF")][pick("7F", "FF")]", include_crunch = TRUE)
	return list(random_color, random_color, random_color)

/datum/preference/tricolor/mutant/mutant_color/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["mcolor"] = value

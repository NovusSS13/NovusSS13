/datum/preference/tri_color/mutant/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/prefs)
	// Doesn't make sense
	if(!relevant_feature)
		return
	// Mutant preferences do not apply if inaccessible
	else if(!is_accessible(prefs))
		return
	target.dna.features[relevant_feature] = value

/datum/preference/tri_color/mutant/mutant_color
	savefile_key = "feature_mcolor"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_inherent_trait = TRAIT_MUTANT_COLORS
	relevant_feature = "mcolor"

/datum/preference/tri_color/mutant/mutant_color/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	var/species_type = preferences.read_preference(/datum/preference/choiced/species)
	var/datum/species/species = new species_type
	return !(TRAIT_FIXED_MUTANT_COLORS in species.inherent_traits)

/datum/preference/tri_color/mutant/mutant_color/create_default_value()
	var/random_color = sanitize_hexcolor("[pick("7F", "FF")][pick("7F", "FF")][pick("7F", "FF")]", include_crunch = TRUE)
	return list(random_color, random_color, random_color)

/datum/preference/tri_color/mutant/mutant_color/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["mcolor"] = value

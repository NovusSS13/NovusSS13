/// Body size preference
/datum/preference/numeric/body_size
	priority = PREFERENCE_PRIORITY_BODYPARTS
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_key = "body_size"
	savefile_identifier = PREFERENCE_CHARACTER
	minimum = BODY_SIZE_PREF_MINIMUM
	maximum = BODY_SIZE_PREF_MAXIMUM
	randomize_by_default = FALSE

/datum/preference/numeric/body_size/create_default_value()
	return BODY_SIZE_STANDARD

/datum/preference/numeric/body_size/apply_to_human(mob/living/carbon/human/target, value)
	target.set_body_size(value)

/// Body size scaling preference
/datum/preference/choiced/body_scaling
	priority = PREFERENCE_PRIORITY_BODYPARTS
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_key = "body_scaling"
	savefile_identifier = PREFERENCE_CHARACTER
	randomize_by_default = FALSE

/datum/preference/choiced/body_scaling/init_possible_values()
	return list("Nearest Neighbor", "Bilinear")

/datum/preference/choiced/body_scaling/create_default_value(datum/preferences/preferences)
	return "Nearest Neighbor"

/datum/preference/choiced/body_scaling/apply_to_human(mob/living/carbon/human/target, value)
	if(value != "Nearest Neighbor")
		target.appearance_flags &= ~PIXEL_SCALE
	else
		target.appearance_flags |= PIXEL_SCALE

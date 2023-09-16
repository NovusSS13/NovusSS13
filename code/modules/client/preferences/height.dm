/// Height preference
/datum/preference/choiced/height
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_key = "height"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/choiced/height/init_possible_values()
	return list("Shorter", "Short", "Medium", "Tall", "Taller")

/datum/preference/choiced/height/create_default_value()
	return "Medium"

/datum/preference/choiced/height/apply_to_human(mob/living/carbon/human/target, value)
	target.set_mob_height(GLOB.height_names[value], update_body = FALSE)

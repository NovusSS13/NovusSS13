/datum/preference/choiced/blood_type
	priority = PREFERENCE_PRIORITY_BODYPARTS
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "blood_type"

/datum/preference/choiced/blood_type/init_possible_values()
	return GLOB.human_blood_types

/datum/preference/choiced/blood_type/should_apply_to_human(mob/living/carbon/human/target, datum/preferences/prefs)
	var/species_type = prefs.read_preference(/datum/preference/choiced/species)
	var/datum/species/species = new species_type
	if(species.exotic_blood || species.exotic_bloodtype)
		return FALSE
	return ..()

/datum/preference/choiced/blood_type/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.blood_type = value

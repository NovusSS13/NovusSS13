/datum/preference/choiced/voice_pack
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	priority = PREFERENCE_PRIORITY_BODYPARTS
	savefile_key = "voice_pack"
	savefile_identifier = PREFERENCE_CHARACTER
	randomize_by_default = FALSE

/datum/preference/choiced/voice_pack/init_possible_values()
	return GLOB.voice_packs

/datum/preference/choiced/voice_pack/create_default_value(datum/preferences/preferences)
	var/species_type = preferences.read_preference(/datum/preference/choiced/species)
	var/datum/species/species = new species_type
	var/datum/voice/voice_pack = GLOB.voice_packs_by_type[species.voice_pack]
	return voice_pack.name

/datum/preference/choiced/voice_pack/create_random_value(datum/preferences/preferences)
	var/species_type = preferences.read_preference(/datum/preference/choiced/species)
	var/datum/species/species = new species_type
	var/datum/voice/voice_pack = GLOB.voice_packs[pick(species.get_voice_packs())]
	return voice_pack.name

/datum/preference/choiced/voice_pack/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/prefs)
	var/list/possible_values = target.dna.species.get_voice_packs()
	if(value in possible_values)
		target.set_voice_pack(value)
		return
	target.set_voice_pack(initial(target.dna.species.voice_pack.name))

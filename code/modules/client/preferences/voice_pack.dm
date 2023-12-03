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
	var/datum/species/species = species_type
	var/obj/item/organ/tongue/faketongue = initial(species.mutanttongue)
	var/datum/voice/fakevoice = initial(faketongue.voice_pack)
	return initial(fakevoice.name)

/datum/preference/choiced/voice_pack/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/prefs)
	target.set_voice_pack(value)
	var/obj/item/organ/tongue/tongue = target.get_organ_slot(ORGAN_SLOT_TONGUE)
	if(tongue)
		var/datum/voice/voice_pack = GLOB.voice_packs[value]
		tongue.voice_pack = voice_pack.type

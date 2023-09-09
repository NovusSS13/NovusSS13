/datum/preference/text/flavor_text
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_key = "flavor_text"
	savefile_identifier = PREFERENCE_CHARACTER

	maximum_value_length = 2048

/datum/preference/text/flavor_text/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	if(isnull(target.examine_panel))
		if(length(value) == 0)
			return
		target.examine_panel = new(target, preferences) //sets these for me
		return
	target.examine_panel.flavor_text = value


/datum/preference/text/naked_flavor_text
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_key = "naked_flavor_text"
	savefile_identifier = PREFERENCE_CHARACTER

	maximum_value_length = 2048

/datum/preference/text/naked_flavor_text/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	if(isnull(target.examine_panel))
		if(length(value) == 0)
			return
		target.examine_panel = new(target, preferences)
		return
	target.examine_panel.naked_flavor_text = value



/datum/preference/text/cyborg_flavor_text
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "cyborg_flavor_text"

	maximum_value_length = 2048

/datum/preference/text/cyborg_flavor_text/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return


/datum/preference/text/ai_flavor_text
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "ai_flavor_text"

	maximum_value_length = 2048

/datum/preference/text/ai_flavor_text/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return


/datum/preference/text/custom_species_name
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "custom_species_name"

	maximum_value_length = 2048

/datum/preference/text/custom_species_name/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	if(isnull(target.examine_panel))
		if(length(value) == 0)
			return
		target.examine_panel = new(target, preferences)
		return
	target.examine_panel.custom_species_name = value

/datum/preference/text/custom_species_desc
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "custom_species_desc"

	maximum_value_length = 2048

/datum/preference/text/custom_species_desc/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	if(isnull(target.examine_panel))
		if(length(value) == 0)
			return
		target.examine_panel = new(target, preferences)
		return
	target.examine_panel.custom_species_desc = value

/datum/preference/text/custom_say_mod
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "custom_say_mod"

	maximum_value_length = 32 // why TF would you need a speech verb longer than this

/datum/preference/text/custom_say_mod/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE // trying to apply the tongue shit here just bugs out, we have to do it through apply_prefs_job

/datum/preference/text/ooc_notes
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_key = "ooc_notes"
	savefile_identifier = PREFERENCE_CHARACTER

	maximum_value_length = 512

/datum/preference/text/ooc_notes/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	if(isnull(target.examine_panel))
		if(length(value) == 0)
			return
		target.examine_panel = new(target, preferences)
		return
	target.examine_panel.ooc_notes = value


/datum/preference/text/headshot_link
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_key = "headshot_link"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/text/headshot_link/is_valid(value)
	if(length(value) == 0) //no link
		return TRUE

	//zone, you suck at regex
	var/static/regex/link_regex = regex(@"^https?://(?:i\.gyazo\.com)|(?:media\.discordapp\.net)|(?:cdn\.discordapp\.com)/.+\.(?:jpg)|(?:jpeg)|(?:png)$")
	if(findtext(value, link_regex) == 0) //apparently findtext doesnt care about what you pass into it. neat!
		to_chat(usr, span_info("<b>The headshot link must be a valid Gyazo/Discord link.</b>"))
		return FALSE

	return TRUE

/datum/preference/text/headshot_link/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	if(isnull(target.examine_panel))
		if(length(value) == 0)
			return
		target.examine_panel = new(target, preferences)
		return
	target.examine_panel.headshot_link = value

/datum/preference/text/flavor
	abstract_type = /datum/preference/text/flavor
	priority = PREFERENCE_PRIORITY_AFTER_NAMES

/datum/preference/text/flavor/should_apply_to_human(mob/living/carbon/human/target, datum/preferences/prefs)
	//flavor text honestly makes no sense when using an anonymous theme, so scrap it in that case
	if(GLOB.current_anonymous_theme || !is_accessible(prefs) || isdummy(target))
		return FALSE
	return ..()

/datum/preference/text/flavor/flavor_text
	category = PREFERENCE_CATEGORY_BACKGROUND
	savefile_key = "flavor_text"
	savefile_identifier = PREFERENCE_CHARACTER

	maximum_value_length = 2048

/datum/preference/text/flavor/flavor_text/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	var/datum/flavor_holder/flavor_holder = get_or_create_flavor_holder(target.real_name)
	flavor_holder?.flavor_text = value


/datum/preference/text/flavor/naked_flavor_text
	category = PREFERENCE_CATEGORY_BACKGROUND
	savefile_key = "naked_flavor_text"
	savefile_identifier = PREFERENCE_CHARACTER

	maximum_value_length = 2048

/datum/preference/text/flavor/naked_flavor_text/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	var/datum/flavor_holder/flavor_holder = get_or_create_flavor_holder(target.real_name)
	flavor_holder?.naked_flavor_text = value


/datum/preference/text/flavor/cyborg_flavor_text
	category = PREFERENCE_CATEGORY_BACKGROUND
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "cyborg_flavor_text"

	maximum_value_length = 2048

/datum/preference/text/flavor/cyborg_flavor_text/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return


/datum/preference/text/flavor/ai_flavor_text
	category = PREFERENCE_CATEGORY_BACKGROUND
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "ai_flavor_text"

	maximum_value_length = 2048

/datum/preference/text/flavor/ai_flavor_text/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return


/datum/preference/text/flavor/custom_species_name
	category = PREFERENCE_CATEGORY_BACKGROUND
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "custom_species_name"

	maximum_value_length = 2048

/datum/preference/text/flavor/custom_species_name/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	var/datum/flavor_holder/flavor_holder = get_or_create_flavor_holder(target.real_name)
	flavor_holder?.custom_species_name = value

/datum/preference/text/flavor/custom_species_desc
	category = PREFERENCE_CATEGORY_BACKGROUND
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "custom_species_desc"

	maximum_value_length = 2048

/datum/preference/text/flavor/custom_species_desc/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	var/datum/flavor_holder/flavor_holder = get_or_create_flavor_holder(target.real_name)
	flavor_holder?.custom_species_desc = value


/datum/preference/text/flavor/ooc_notes
	category = PREFERENCE_CATEGORY_BACKGROUND
	savefile_key = "ooc_notes"
	savefile_identifier = PREFERENCE_CHARACTER

	maximum_value_length = 512

/datum/preference/text/flavor/ooc_notes/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	var/datum/flavor_holder/flavor_holder = get_or_create_flavor_holder(target.real_name)
	flavor_holder?.ooc_notes = value


/datum/preference/text/flavor/headshot_link
	category = PREFERENCE_CATEGORY_BACKGROUND
	savefile_key = "headshot_link"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/text/flavor/headshot_link/is_valid(value)
	if(length(value) == 0) //no link
		return TRUE

	//zone, you suck at regex
	var/static/regex/link_regex = regex(@"^https?://(?:i\.gyazo\.com)|(?:media\.discordapp\.net)|(?:cdn\.discordapp\.com)/.+\.(?:jpg)|(?:jpeg)|(?:png)$")
	if(findtext(value, link_regex) == 0) //apparently findtext doesnt care about what you pass into it. neat!
		to_chat(usr, span_info("<b>The headshot link must be a valid Gyazo/Discord link.</b>"))
		return FALSE

	return TRUE

/datum/preference/text/flavor/headshot_link/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	var/datum/flavor_holder/flavor_holder = get_or_create_flavor_holder(target.real_name)
	flavor_holder?.headshot_link = value

/// Simple holder that stores flavor texts and other things, and gets indexed by name in the global flavor_holders list
/datum/flavor_holder
	var/flavor_text
	var/naked_flavor_text //mmm very sechs
	var/cyborg_flavor_text
	var/ai_flavor_text
	var/custom_species_name //you might ask "null u stupid why are you storing all this when read_preference() exists"
	var/custom_species_desc //see, besides temp flavor text, i dont want people changing these mid-round
	var/ooc_notes //also ooc notes will be an epic meme
	var/headshot_link

/datum/flavor_holder/New(key, datum/preferences/prefs)
	. = ..()
	if(!key)
		stack_trace("[type] got initialized without a key.")
		qdel(src)
		return

	if(prefs)
		update(prefs)

	GLOB.flavor_holders[key] = src

/// Updates the flavor holder with the given preferences datum
/datum/flavor_holder/proc/update(datum/preferences/prefs)
	src.flavor_text = prefs.read_preference(/datum/preference/text/flavor/flavor_text)
	src.naked_flavor_text = prefs.read_preference(/datum/preference/text/flavor/naked_flavor_text)
	src.cyborg_flavor_text = prefs.read_preference(/datum/preference/text/flavor/cyborg_flavor_text)
	src.ai_flavor_text = prefs.read_preference(/datum/preference/text/flavor/ai_flavor_text)
	src.custom_species_name = prefs.read_preference(/datum/preference/text/flavor/custom_species_name)
	src.custom_species_desc = prefs.read_preference(/datum/preference/text/flavor/custom_species_desc)
	src.ooc_notes = prefs.read_preference(/datum/preference/text/flavor/ooc_notes)
	src.headshot_link = prefs.read_preference(/datum/preference/text/flavor/headshot_link)

/proc/create_or_update_flavor_holder(key, datum/preferences/prefs)
	var/datum/flavor_holder/flavor_holder = GLOB.flavor_holders[key]
	if(!flavor_holder)
		flavor_holder = new(key, prefs)
	else
		flavor_holder.update(prefs)
	return flavor_holder

/proc/get_or_create_flavor_holder(key)
	var/datum/flavor_holder/flavor_holder = GLOB.flavor_holders[key]
	if(!flavor_holder)
		flavor_holder = new(key)
	return flavor_holder

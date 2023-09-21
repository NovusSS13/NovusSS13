/**
 * Datums for ghost role customization, responsible for handling what character slots roles share, as well as applying relevant restrictions on them.
 * Pretty bare-bones for now, but still probably better to keep those as datums.
 */
/datum/offstation_customization
	/// What slot name will be used on the character setup?
	var/slot_name = ""
	/// The savefile key we'll be using. MUST use dashes for spaces (i.e "very-epic-ghostrole")
	var/savefile_key = ""
	/// What species are we restricted to? Leave as null if you want to inherit GLOB.roundstart_races.
	var/datum/species/forced_species = null
	/// If set to TRUE, preferences regarding underwear and loadout will not be shown.
	var/barebones_spawn = FALSE


/datum/offstation_customization/ashwalker
	slot_name = "Ashwalkers"
	savefile_key = "ashwalker"
	forced_species = /datum/species/lizard/ashwalker
	barebones_spawn = TRUE

/datum/offstation_customization/syndicate_outpost
	slot_name = "Syndicate Outpost"
	savefile_key = "syndicate-lavaland"
	//forced_species = /datum/species/human //someday my love

/datum/offstation_customization/golem
	slot_name = "Free Golems"
	savefile_key = "golem"
	forced_species = /datum/species/golem
	barebones_spawn = TRUE

/datum/offstation_customization/hermit
	slot_name = "Stranded Hermit"
	savefile_key = "hermit"

/datum/offstation_customization/syndicate_battlecruiser
	slot_name = "Syndicate Battlecruiser Crew"
	savefile_key = "cybersun"
	//forced_species = /datum/species/human

/datum/offstation_customization/lifebringer
	slot_name = "Lifebringers"
	savefile_key = "lifebringer"
	forced_species = /datum/species/pod
	barebones_spawn = TRUE

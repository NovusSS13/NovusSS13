/datum/sprite_accessory/body_markings
	color_amount = 1 //DNA code can only handle 1 color per marking, changes to the code will be necessary if you want more, swine
	/// Bitflags for bodyparts we are allowed on
	var/allowed_bodyparts = FULL_BODY
	/// Species this set is compatible with - Set to null for no species restrictions
	var/compatible_species = null

/datum/sprite_accessory/body_markings/none
	name = SPRITE_ACCESSORY_NONE
	icon_state = "none"

/datum/sprite_accessory/body_markings/lizard
	icon = 'icons/mob/species/lizard/lizard_misc.dmi'
	gender_specific = TRUE
	allowed_bodyparts = CHEST
	compatible_species = list(/datum/species/lizard)

/datum/sprite_accessory/body_markings/lizard/dtiger
	name = "Dark Tiger Body"
	icon_state = "dtiger"

/datum/sprite_accessory/body_markings/lizard/ltiger
	name = "Light Tiger Body"
	icon_state = "ltiger"

/datum/sprite_accessory/body_markings/lizard/lbelly
	name = "Light Belly"
	icon_state = "lbelly"

/datum/sprite_accessory/body_markings/moth // the markings that moths can have. finally something other than the boring tan
	icon = 'icons/mob/species/moth/moth_markings.dmi'
	compatible_species = list(/datum/species/moth)
	color_amount = 0

/datum/sprite_accessory/body_markings/moth/reddish
	name = "Reddish"
	icon_state = "reddish"

/datum/sprite_accessory/body_markings/moth/royal
	name = "Royal"
	icon_state = "royal"

/datum/sprite_accessory/body_markings/moth/gothic
	name = "Gothic"
	icon_state = "gothic"

/datum/sprite_accessory/body_markings/moth/whitefly
	name = "White Fly"
	icon_state = "whitefly"

/datum/sprite_accessory/body_markings/moth/lovers
	name = "Lovers"
	icon_state = "lovers"

/datum/sprite_accessory/body_markings/moth/burnt_off
	name = "Burnt Off"
	icon_state = "burnt_off"

/datum/sprite_accessory/body_markings/moth/firewatch
	name = "Firewatch"
	icon_state = "firewatch"

/datum/sprite_accessory/body_markings/moth/deathhead
	name = "Deathshead"
	icon_state = "deathhead"

/datum/sprite_accessory/body_markings/moth/poison
	name = "Poison"
	icon_state = "poison"

/datum/sprite_accessory/body_markings/moth/ragged
	name = "Ragged"
	icon_state = "ragged"

/datum/sprite_accessory/body_markings/moth/moonfly
	name = "Moon Fly"
	icon_state = "moonfly"

/datum/sprite_accessory/body_markings/moth/oakworm
	name = "Oak Worm"
	icon_state = "oakworm"

/datum/sprite_accessory/body_markings/moth/jungle
	name = "Jungle"
	icon_state = "jungle"

/datum/sprite_accessory/body_markings/moth/witchwing
	name = "Witch Wing"
	icon_state = "witchwing"

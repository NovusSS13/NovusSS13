//////////.//////////////////
// MutantParts Definitions //
/////////////////////////////
/datum/sprite_accessory/tails
	/// Whether or not we can wag
	var/can_wag = FALSE

/datum/sprite_accessory/tails/lizard
	icon = 'icons/mob/species/lizard/lizard_tails.dmi'
	feature_suffix = "lizard"

/datum/sprite_accessory/tails/lizard/smooth
	name = "Smooth"
	icon_state = "smooth"

/datum/sprite_accessory/tails/lizard/dtiger
	name = "Dark Tiger"
	icon_state = "dtiger"

/datum/sprite_accessory/tails/lizard/ltiger
	name = "Light Tiger"
	icon_state = "ltiger"

/datum/sprite_accessory/tails/lizard/spikes
	name = "Spikes"
	icon_state = "spikes"

/datum/sprite_accessory/tails/human
	icon = 'icons/mob/species/human/cat_features.dmi'

/datum/sprite_accessory/tails/human/cat
	name = "Cat"
	icon_state = "default"
	feature_suffix = "cat"

/datum/sprite_accessory/tails/monkey
	feature_suffix = "monkey"
	color_amount = 0

/datum/sprite_accessory/tails/monkey/monkey
	name = "Monkey"
	icon = 'icons/mob/species/monkey/monkey_tail.dmi'
	icon_state = "monkey"

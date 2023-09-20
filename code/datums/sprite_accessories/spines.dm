/datum/sprite_accessory/spines
	/**
	 * Whether or not we can wag
	 * Not about actually preventing the emote, it's just for sprite updates
	 */
	var/can_wag = FALSE

/datum/sprite_accessory/spines/lizard
	icon = 'icons/mob/species/lizard/lizard_spines.dmi'
	color_amount = 1
	can_wag = TRUE

/datum/sprite_accessory/spines/lizard/short
	name = "Short"
	icon_state = "short"

/datum/sprite_accessory/spines/lizard/shortmeme
	name = "Short + Membrane"
	icon_state = "shortmeme"

/datum/sprite_accessory/spines/lizard/long
	name = "Long"
	icon_state = "long"

/datum/sprite_accessory/spines/lizard/longmeme
	name = "Long + Membrane"
	icon_state = "longmeme"

/datum/sprite_accessory/spines/lizard/aquatic
	name = "Aquatic"
	icon_state = "aqua"

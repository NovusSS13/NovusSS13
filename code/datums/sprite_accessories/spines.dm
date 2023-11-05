/datum/sprite_accessory/spines
	default_color = 1
	default_colors = list(COLOR_WHITE, COLOR_OFF_WHITE, COLOR_VERY_LIGHT_GRAY)
	/**
	 * Whether or not we can wag
	 * Not about actually preventing the emote, it's just for sprite updates
	 */
	var/can_wag = FALSE

/datum/sprite_accessory/spines/lizard
	icon = 'icons/mob/human/species/lizard/lizard_spines.dmi'
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

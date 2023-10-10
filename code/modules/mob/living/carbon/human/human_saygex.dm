/mob/living/carbon/human/get_all_covered_flags_with_underwear()
	. = ..()
	if(undershirt && (undershirt != SPRITE_ACCESSORY_NONE))
		. |= CHEST
	if(underwear && (underwear != SPRITE_ACCESSORY_NONE))
		. |= GROIN
	if(socks && (socks != SPRITE_ACCESSORY_NONE))
		. |= LEGS | FEET

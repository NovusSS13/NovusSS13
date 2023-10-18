/mob/living/carbon/human/get_all_covered_flags_with_underwear()
	. = ..()
	if(underwear && (underwear != SPRITE_ACCESSORY_NONE) && !HAS_TRAIT(src, TRAIT_NO_UNDERWEAR))
		. |= GROIN
	if(undershirt && (undershirt != SPRITE_ACCESSORY_NONE) && !HAS_TRAIT(src, TRAIT_NO_UNDERSHIRT))
		. |= CHEST
	if(socks && (socks != SPRITE_ACCESSORY_NONE) && !HAS_TRAIT(src, TRAIT_NO_SOCKS))
		. |= LEGS | FEET

/mob/living/carbon/get_interaction_qualities(temp_gender)
	. = ..()
	var/p_is = p_are(temp_gender)
	var/p_has = p_have(temp_gender)
	var/covered_flags = get_all_covered_flags_with_underwear()
	if(get_bodypart(BODY_ZONE_HEAD))
		. += "[p_has] a mouth, which is [is_mouth_covered() ? "covered" : "uncovered"]"
	if(!(covered_flags & (CHEST | GROIN)))
		. += "[p_is] naked"
	else if((covered_flags & CHEST) && (covered_flags & GROIN))
		. += "[p_is] clothed"
	else
		. += "[p_is] partially clothed"
	for(var/obj/item/organ/genital/genital in organs)
		if(!genital.bodypart_overlay?.can_draw_on_body(get_bodypart(genital.zone), src))
			continue
		. += "[p_has] [genital.get_genital_examine()]"

/mob/living/carbon/proc/get_all_covered_flags_with_underwear()
	return get_all_covered_flags()

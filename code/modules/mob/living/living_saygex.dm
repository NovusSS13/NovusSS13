/// Returns lust this mob currently has
/mob/living/proc/get_lust()
	return lust

/// Adjust lust by this set amount
/mob/living/proc/adjust_lust(change)
	lust = clamp(lust + change, 0, LUST_CLIMAX)

/// Force set the lust to this amount
/mob/living/proc/set_lust(change)
	return adjust_lust(change - lust)

/// Handle a generic climax, one that didn't get handled by an interaction in a custom way
/mob/living/proc/handle_climax()
	if(get_organ_slot(ORGAN_SLOT_PENIS))
		visible_message(span_love("<b>[src]</b> cums on [src.loc]!"),\
								span_userlove("You cum on [src.loc]!"))
	else if(get_organ_slot(ORGAN_SLOT_VAGINA))
		visible_message(span_love("<b>[src]</b> squirts on [src.loc]!"),\
								span_userlove("You squirt on [src.loc]!"))
	else
		visible_message(span_love("<b>[src]</b> climaxes on [src.loc]!"),\
								span_userlove("You climax on [src.loc]!"))
	// PROPEL YOURSELF WITH COOM
	if(!Process_Spacemove(REVERSE_DIR(src.dir)))
		newtonian_move(REVERSE_DIR(src.dir))
	var/static/list/genital_slots = list(
		ORGAN_SLOT_PENIS,
		ORGAN_SLOT_TESTICLES,
		ORGAN_SLOT_BREASTS,
		ORGAN_SLOT_VAGINA,
	)
	for(var/organ_slot in genital_slots)
		var/obj/item/organ/genital/genital = get_organ_slot(organ_slot)
		if(genital?.can_climax)
			genital.handle_climax(get_turf(src), TOUCH)
	set_lust(0)
	return TRUE

/// Returns qualities, descriptive strings for the interaction menu
/mob/living/proc/get_interaction_qualities(temp_gender)
	RETURN_TYPE(/list)
	var/list/qualities = list()
	var/p_is = p_are(temp_gender)
	var/p_has = p_have(temp_gender)
	if(combat_mode)
		qualities += "[p_is] acting rough"
	else
		qualities += "[p_is] acting gentle"
	switch(num_hands)
		if(2)
			. += "[p_has] a pair of hands."
		if(1)
			. += "[p_has] a hand"
		if(0)
			. += "[p_has] no hands"
		else
			. += "[p_has] [num_hands] hands"
	switch(num_legs)
		if(2)
			. += "[p_has] a pair of feet"
		if(1)
			. += "[p_has] a foot"
		if(0)
			. += "[p_has] no feet"
		else
			. += "[p_has] [num_legs] feet"
	return qualities

// Sweet ass copypasta, couldn't figure out another way to handle this
/mob/living/carbon/handle_climax()
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
	for(var/obj/item/organ/genital/genital in organs)
		if(genital.can_climax)
			genital.handle_climax(get_turf(src), TOUCH, spill = TRUE)
	set_lust(0)
	if(!HAS_TRAIT(src, TRAIT_INTERACTABLE))
		return TRUE
	var/datum/component/interactable/interactable = GetComponent(/datum/component/interactable)
	if(interactable)
		var/refractory_period = rand(45 SECONDS, 90 SECONDS)
		// Generic refractory period, this normally will get overriden by interactions
		COOLDOWN_START(interactable, next_sexual_interaction, refractory_period)
	return TRUE

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
		if(!genital.bodypart_overlay)
			continue
		var/datum/bodypart_overlay/mutant/genital/genital_overlay = genital.bodypart_overlay
		if(!genital_overlay.is_genital_visible(get_bodypart(check_zone(genital.zone)), src))
			continue
		. += "[p_has] [genital.get_genital_examine()]"

/mob/living/carbon/proc/get_all_covered_flags_with_underwear()
	return get_all_covered_flags()

GLOBAL_LIST_INIT(creamable, typecacheof(list(
	/mob/living/carbon/human,
	/mob/living/basic/pet/dog/corgi,
	/mob/living/silicon/ai,
)))

/datum/component/creamed/pie
	cover_lips = span_color("cream", "#fffdda")

/datum/component/creamed/pie/create_overlays()
	if(my_head)
		bodypart_overlay = new bodypart_overlay()
		if((my_head.bodytype | my_head.external_bodytypes) & BODYTYPE_SNOUTED)
			bodypart_overlay.icon_state = "creampie_lizard"
		else if(my_head.bodytype & BODYTYPE_MONKEY)
			bodypart_overlay.icon_state = "creampie_monkey"
		else
			bodypart_overlay.icon_state = "creampie_human"
		my_head.add_bodypart_overlay(bodypart_overlay)
		my_head.owner.update_body_parts()
	else if(iscorgi(parent))
		normal_overlay = mutable_appearance('icons/effects/creampie.dmi', "creampie_corgi")
	else if(isAI(parent))
		normal_overlay = mutable_appearance('icons/effects/creampie.dmi', "creampie_ai")

/datum/component/creamed/pie/get_creamable_list()
	return GLOB.creamable

/datum/component/creamed/pie/on_creamed()
	add_memory_in_range(parent, 7, /datum/memory/witnessed_creampie, protagonist = parent)
	if(ishuman(parent))
		var/mob/living/carbon/human/human_parent = parent
		human_parent.add_mood_event("creampie", /datum/mood_event/creampie)

/datum/component/creamed/pie/on_uncreamed()
	if(ishuman(parent))
		var/mob/living/carbon/human/human_parent = parent
		human_parent.clear_mood_event("creampie")

/// A creampie drawn on the head
/datum/bodypart_overlay/simple/creampie
	required_bodytype = BODYTYPE_HUMANOID | BODYTYPE_MONKEY
	icon = 'icons/effects/creampie.dmi'
	icon_state = "creampie_human"
	layers = EXTERNAL_FRONT

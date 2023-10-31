GLOBAL_LIST_INIT(bloodymouthable, typecacheof(list(
	/mob/living/carbon/human,
)))

/datum/component/creamed/blood
	cover_lips = span_bloody("<b>blood</b>")
	bodypart_overlay = /datum/bodypart_overlay/simple/bloodymouth

/datum/component/creamed/blood/create_overlays()
	if(my_head)
		bodypart_overlay = new bodypart_overlay()
		if((my_head.bodytype | my_head.external_bodytypes) & BODYTYPE_SNOUTED)
			bodypart_overlay.icon_state = "bloodmouth_lizard"
		else if(my_head.bodytype & BODYTYPE_MONKEY)
			bodypart_overlay.icon_state = "bloodmouth_monkey"
		else
			bodypart_overlay.icon_state = "bloodmouth_human"
		my_head.add_bodypart_overlay(bodypart_overlay)
		my_head.owner.update_body_parts()

/datum/component/creamed/blood/get_creamable_list()
	return GLOB.bloodymouthable

/// Bloody lips drawn on the head
/datum/bodypart_overlay/simple/bloodymouth
	required_bodytype = BODYTYPE_HUMANOID | BODYTYPE_MONKEY
	icon = 'icons/effects/blood.dmi'
	icon_state = "bloodmouth_human"
	layers = EXTERNAL_FRONT

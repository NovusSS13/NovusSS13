GLOBAL_LIST_INIT(bukkakeable, typecacheof(list(
	/mob/living/carbon/human,
)))

/datum/component/creamed/bukkake
	cover_lips = span_color("cum", COLOR_CUM)
	bodypart_overlay = /datum/bodypart_overlay/simple/bukkake
	/// The BIG cummies (tm)
	var/big_cummies = FALSE

/datum/component/creamed/bukkake/Initialize(big_cummies = FALSE)
	. = ..()
	src.big_cummies = big_cummies
	update_lips()

/datum/component/creamed/bukkake/create_overlays()
	if(my_head)
		bodypart_overlay = new bodypart_overlay()
		bodypart_overlay.draw_color = COLOR_CUM
		var/cummy_state = "[big_cummies ? "big" : null]cumface"
		if((my_head.bodytype | my_head.external_bodytypes) & BODYTYPE_SNOUTED)
			bodypart_overlay.icon_state = "[cummy_state]_lizard"
		else if(my_head.bodytype & BODYTYPE_MONKEY)
			bodypart_overlay.icon_state = "[cummy_state]_monkey"
		else
			bodypart_overlay.icon_state = "[cummy_state]_human"
		my_head.add_bodypart_overlay(bodypart_overlay)
		my_head.owner.update_body_parts()

/datum/component/creamed/bukkake/get_creamable_list()
	return GLOB.bukkakeable

/datum/component/creamed/bukkake/proc/update_lips()
	if(big_cummies)
		cover_lips = span_color("a lot of cum", COLOR_CUM)
	else
		cover_lips = span_color("cum", COLOR_CUM)

/// A "creampie" drawn on the head
/datum/bodypart_overlay/simple/bukkake
	required_bodytype = BODYTYPE_HUMANOID | BODYTYPE_MONKEY
	icon = 'icons/effects/cum.dmi'
	icon_state = "cumface_human"
	layers = EXTERNAL_FRONT

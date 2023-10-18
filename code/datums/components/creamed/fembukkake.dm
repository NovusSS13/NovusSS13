/datum/component/creamed/bukkake/fem
	cover_lips = span_color("squirt", COLOR_FEMCUM)
	bodypart_overlay = /datum/bodypart_overlay/simple/bukkake/fem

/datum/component/creamed/bukkake/fem/create_overlays()
	if(my_head)
		bodypart_overlay = new bodypart_overlay()
		bodypart_overlay.draw_color = COLOR_FEMCUM
		var/cummy_state = "[big_cummies ? "big" : null]femcumface"
		if((my_head.bodytype | my_head.external_bodytypes) & BODYTYPE_SNOUTED)
			bodypart_overlay.icon_state = "[cummy_state]_lizard"
		else if(my_head.bodytype & BODYTYPE_MONKEY)
			bodypart_overlay.icon_state = "[cummy_state]_monkey"
		else
			bodypart_overlay.icon_state = "[cummy_state]_human"
		my_head.add_bodypart_overlay(bodypart_overlay)
		carbon_parent.update_body_parts()

/datum/component/creamed/bukkake/fem/update_lips()
	if(big_cummies)
		cover_lips = span_color("<b>a lot of squirt</b>", copytext(COLOR_FEMCUM, 1, -2)) //remove the alpha
	else
		cover_lips = span_color("squirt", copytext(COLOR_FEMCUM, 1, -2)) //remove the alpha

/// A "creampie" drawn on the head
/datum/bodypart_overlay/simple/bukkake/fem
	required_bodytype = BODYTYPE_HUMANOID | BODYTYPE_MONKEY
	icon = 'icons/effects/femcum.dmi'
	icon_state = "femcumface_human"
	layers = EXTERNAL_FRONT

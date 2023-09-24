/*
	These are simple defaults for your project.
 */

/world
	fps = 25		// 25 frames per second
	icon_size = 32	// 32x32 icon size by default
	view = 6		// show up to 6 tiles outward from center (13x13 view)

//Actual important code
/client/verb/butcher_humans()
	set name = "Butcher Humans"
	set desc = "Cut them up nice."
	set category = "Butcher"

	var/inputfile = input(usr, "Select an icon to butcher. Cancel for default icon.", "Slaughterhouse", null) as file|null
	if(isnull(inputfile))
		return

	var/icon/human
	if(isnull(inputfile))
		human = icon('icons/Human.dmi')
	else
		human = icon(inputfile)
	//All body zones tg has
	var/static/list/all_bodyzones = list("head", "chest", "r_arm", "l_arm", "r_leg", "l_leg")

	var/icon/scissors = icon('icons/Scissors.dmi')
	var/list/scissors_states = icon_states(scissors)

	var/icon/output = new()

	//For each original icon
	var/list/icon_states = icon_states(human)
	for(var/icon_state in icon_states)
		//We don't care about digitards
		//If digitard located, move on
		if(findtext(icon_state, "digitigrade"))
			output.Insert(icon(human, icon_state), icon_state)
			continue
		var/genderless_state = icon_state
		if(findtext(genderless_state, "_m", -2) || findtext(genderless_state, "_f", -2))
			genderless_state = copytext(genderless_state, 1, -2)
		world.log << "gendered icon: [icon_state]"
		world.log << "ungendered icon: [genderless_state]"

		var/unparsed_body_zone
		var/current_body_zone
		for(var/zone in all_bodyzones)
			if(findtext(genderless_state, zone))
				current_body_zone = zone
				break
		if(!current_body_zone)
			world.log << "Unable to find associated body zone for [icon_state]"
		else
			world.log << "current body zone: [current_body_zone]"
			var/after_zone = copytext(genderless_state, findtext(genderless_state, current_body_zone))
			unparsed_body_zone = "[current_body_zone][after_zone]"
			world.log << "unparsed body zone: [unparsed_body_zone]"

		//Skip this body zone if there is no associated cookie cutter sprite -
		//Literally just throw the original in
		if(!current_body_zone || !(current_body_zone in scissors_states))
			output.Insert(icon(human, icon_state), icon_state)
			continue

		var/zoneless_state = copytext(icon_state, 1, findtext(icon_state, current_body_zone))
		world.log << "zoneless state: [zoneless_state]"
		//For each piece we're going to cut
		for(var/cutterstate in scissors_states)
			//Skip if necessary
			if((findtext(cutterstate, "r_foot") || findtext(cutterstate, "r_leg")) && !findtext(genderless_state, "r_leg"))
				continue
			if((findtext(cutterstate, "l_foot") || findtext(cutterstate, "l_leg")) && !findtext(genderless_state, "l_leg"))
				continue
			if((findtext(cutterstate, "groin") || findtext(cutterstate, "chest")) && !findtext(genderless_state, "chest"))
				continue
			var/found_state = FALSE
			var/list/check_redundacy = list("r_hand", "l_hand", "r_foot", "l_foot")
			if(cutterstate in check_redundacy)
				for(var/this_icon_state in icon_states)
					if(findtext(this_icon_state, cutterstate))
						found_state = TRUE
						break
			if(found_state)
				continue

			//The fully assembled icon to cut
			var/icon/tobecut = icon(human, icon_state)

			//Our cookie cutter sprite
			var/icon/cutter = icon(scissors, cutterstate)

			//We have to make these all black to cut with
			cutter.Blend(rgb(0,0,0),ICON_MULTIPLY)

			//Blend with AND to cut
			tobecut.Blend(cutter,ICON_AND) //AND, not ADD

			//Make a useful name
			var/good_name = "[zoneless_state][cutterstate]"
			if(findtext(icon_state, "_m", -2) || findtext(icon_state, "_f", -2))
				good_name += copytext(icon_state, -2)

			//Add to the output with the good name
			output.Insert(tobecut, good_name)
			world.log << "current cutter: [cutterstate]"
			world.log << "final icon_state: [good_name]"

	//Give the output
	usr << ftp(output, "butchered.dmi")

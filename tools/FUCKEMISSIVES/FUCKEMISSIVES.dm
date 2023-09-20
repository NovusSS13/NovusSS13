/*
	These are simple defaults for your project.
 */
/world
	fps = 25		// 25 frames per second
	icon_size = 32	// 32x32 icon size by default
	view = 6		// show up to 6 tiles outward from center (13x13 view)

//Actual important code
/client/verb/unfuck_accessories()
	set name = "Unfuck sprite accessories"
	set desc = "Fuck you, skyrat. Fuck you."
	set category = "Unfuck"

	var/inputfile = input(usr, "Select an icon to unfuck. Cancel for default icon.", "HATE", null) as file|null
	if(isnull(inputfile))
		return

	var/icon/iconfile = icon(inputfile)
	var/icon/output = icon('icons/blank.dmi', "blank")
	var/static/list/colors = list(
		"_primary" = "#FF0000",
		"_secondary" = "#00FF00",
		"_tertiary" = "#0000FF",
	)
	for(var/icon_state in icon_states(iconfile))
		world.log << "original state: [icon_state]"
		var/found_primary = findtext(icon_state, "_primary", -length("_primary"))
		var/found_secondary = findtext(icon_state, "_secondary", -length("_secondary"))
		var/found_tertiary = findtext(icon_state, "_tertiary", -length("_tertiary"))
		if(found_primary)
			world.log << "found primary"
		else if(found_secondary)
			world.log << "found secondary"
		else if(found_tertiary)
			world.log << "found tertiary"
		else
			world.log << "found nothing"
			output.Insert(icon(iconfile, icon_state), icon_state)
			continue
		var/final_state
		if(found_primary)
			final_state = copytext(icon_state, 1, found_primary)
		else if(found_secondary)
			final_state = copytext(icon_state, 1, found_secondary)
		else
			final_state = copytext(icon_state, 1, found_tertiary)
		world.log << "new state: [final_state]"
		var/icon/blended_up_icon = icon('icons/blank.dmi', "blank")
		for(var/color in colors)
			var/icon/newicon = icon(inputfile, "[final_state][color]")
			newicon.Blend(colors[color], ICON_MULTIPLY)
			blended_up_icon.Blend(newicon, ICON_OVERLAY)
		output.Insert(blended_up_icon, final_state)
	//Give the output
	usr << ftp(output, "[inputfile]")

/client/verb/fuck_me_in_the_ass()
	set name = "HADGBEADGBSDBNAEBNHASWBHAWS"
	set desc = "CBT"
	set category = "Unfuck"

	var/inputfile = input(usr, "Select an icon to unfuck. Cancel for default icon.", "HATEEEEEEEEEEEE", null) as file|null
	if(isnull(inputfile))
		return

	var/icon/iconfile = icon(inputfile)
	var/icon/output = icon('icons/blank.dmi', "blank")
	var/static/list/colors = list(
		"_primary" = "#FF0000",
		"_secondary" = "#00FF00",
		"_tertiary" = "#0000FF",
	)
	for(var/icon_state in icon_states(iconfile))
		world.log << "original state: [icon_state]"
		var/final_state = icon_state
		if(length(icon_state))
			final_state = replacetext(final_state, "m_", "m_markings_", 1, 3)
			final_state = replacetext(final_state, "f_", "f_markings_", 1, 3)
		world.log << "new state: [final_state]"
		output.Insert(icon(iconfile, icon_state), final_state)
	//Give the output
	usr << ftp(output, "[inputfile]")

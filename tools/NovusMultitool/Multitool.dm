/*
	These are simple defaults for your project.
 */
/world
	fps = 25		// 25 frames per second
	icon_size = 32	// 32x32 icon size by default
	view = 6		// show up to 6 tiles outward from center (13x13 view)
	mob = /mob

//Actual important code

/client/verb/unfuck_accessories()
	set name = "Unfuck Tri-color Accessories"
	set desc = "Fuck you, skyrat. Fuck you."
	set category = "CBT"

	var/input_file = input(usr, "Select an icon to unfuck.", "HATE", null) as file|null
	if(isnull(input_file))
		return

	var/icon/iconfile = icon(input_file)
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
			var/icon/newicon = icon(input_file, "[final_state][color]")
			newicon.Blend(colors[color], ICON_MULTIPLY)
			blended_up_icon.Blend(newicon, ICON_OVERLAY)
		output.Insert(blended_up_icon, final_state)
	//Give the output
	usr << ftp(output, "[input_file]")

/client/verb/unfuck_markings()
	set name = "Unfuck Markings"
	set category = "CBT"

	var/input_file = input(usr, "Select a marking icon to unfuck.", "HATE", null) as file|null
	if(isnull(input_file))
		return

	var/icon/iconfile = icon(input_file)
	var/icon/output = icon('icons/blank.dmi', "blank")
	for(var/icon_state in icon_states(iconfile))
		world.log << "original state: [icon_state]"
		var/final_state = icon_state
		if(length(icon_state))
			final_state = replacetext(final_state, "m_", "m_markings_", 1, 3)
			final_state = replacetext(final_state, "f_", "f_markings_", 1, 3)
		if(!findtext(final_state, "_BEHIND", -length("_BEHIND")) && \
			!findtext(final_state, "_ADJ", -length("_ADJ")) && \
			!findtext(final_state, "_FRONT", -length("_FRONT")))
			final_state += "_ADJ"
		world.log << "new state: [final_state]"
		output.Insert(icon(iconfile, icon_state), final_state)

	//Give the output
	usr << ftp(output, "[input_file]")

/client/verb/apply_displacement()
	set name = "Apply Displacement"
	set category = "CBT"

	var/displacement_file = input(usr, "Select an icon to use as a displacement map.", "HATE", null) as file|null
	if(isnull(displacement_file))
		return

	var/list/displacement_states = icon_states(icon(displacement_file))
	var/displacement_state = input(usr, "Select a displacement state.", "HATE", displacement_states[1]) as anything in displacement_states
	if(isnull(displacement_state))
		return

	var/input_file = input(usr, "Select an icon to apply the displacement map to.", "HATE", null) as file|null
	if(isnull(input_file))
		return

	var/displace_x = input(usr, "Displacement X?", "HATE", 0) as num
	var/displace_y = input(usr, "Displacement Y?", "HATE", 0) as num
	var/displace_size = input(usr, "Displacement size?", "HATE", 0) as num

	var/icon/input_icon = icon(input_file)
	var/icon/output_icon = icon('icons/blank.dmi', "blank")
	var/static/list/dirs = list(
		NORTH,
		SOUTH,
		WEST,
		EAST,
	)

	for(var/icon_state in icon_states(input_icon))
		for(var/dir in dirs)
			var/obj/target = new(mob.loc)
			target.icon = input_file
			target.icon_state = icon_state
			target.dir = dir
			target.filters += filter(type = "displace", \
										x = displace_x, \
										y = displace_y, \
										size = displace_size, \
										icon = icon(displacement_file, displacement_state, dir))

			var/icon/finalized_icon = icon(RenderIcon(target))

			output_icon.Insert(finalized_icon, icon_state, dir)

			del(target)

	//Give the output
	usr << ftp(output_icon, "[input_file]")

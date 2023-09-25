/datum/keybinding/movement
	category = CATEGORY_MOVEMENT
	weight = WEIGHT_HIGHEST

/datum/keybinding/movement/pixelshift
	var/shift_direction

/datum/keybinding/movement/pixelshift/down(client/user)
	. = ..()
	if(.)
		return

	if(!user.pixelshift_time)
		user.pixelshift_time = world.time

	user.pixelshifting_towards |= shift_direction
	return //bulk of functionality dodne in subtypes

/datum/keybinding/movement/pixelshift/up(client/user)
	user.pixelshifting_towards &= ~shift_direction
	if(!user.pixelshifting_towards)
		user.pixelshift_time = 0
	return TRUE


/datum/keybinding/movement/pixelshift/north //originally pixelshift/up but that gave me migraines
	hotkey_keys = list("CtrlShiftNorth")
	name = "Pixelshift Up"
	full_name = "Pixelshift Upwards"
	description = "Pixelshifts you upwards."
	keybind_signal = COMSIG_KB_MOVEMENT_PIXELSHIFT_NORTH_DOWN
	shift_direction = NORTH

/datum/keybinding/movement/pixelshift/north/down(client/user)
	. = ..()
	if(.)
		return

	var/mob/mob = user.mob
	if(mob.current_pixelshift_y >= 16)
		return TRUE

	spawn(-1) //cursed cursed cursed
		while(1) //FUCKIGN CURSED
			if(!user || !(user.pixelshifting_towards & shift_direction))
				break
			if(mob.current_pixelshift_y >= 16)
				break

			mob.pixel_y++
			mob.current_pixelshift_y++
			UNTIL(user.pixelshift_time + 0.5 SECONDS < world.time)
			sleep(1)
			continue

		//this amount of voodoo makes me not trust keybind code
		user?.pixelshifting_towards &= ~shift_direction

	return TRUE

/datum/keybinding/movement/pixelshift/south
	hotkey_keys = list("CtrlShiftSouth")
	name = "Pixelshift Down"
	full_name = "Pixelshift Downwards"
	description = "Pixelshifts you downwards."
	keybind_signal = COMSIG_KB_MOVEMENT_PIXELSHIFT_SOUTH_DOWN
	shift_direction = SOUTH

/datum/keybinding/movement/pixelshift/south/down(client/user)
	. = ..()
	if(.)
		return

	var/mob/mob = user.mob
	if(mob.current_pixelshift_y <= -16)
		return TRUE

	spawn(-1)
		while(1)
			if(!user || !(user.pixelshifting_towards & shift_direction))
				break
			if(mob.current_pixelshift_y <= -16)
				break

			mob.pixel_y--
			mob.current_pixelshift_y--
			UNTIL(user.pixelshift_time + 0.5 SECONDS < world.time)
			sleep(1)
			continue

		//this amount of voodoo makes me not trust keybind code
		user?.pixelshifting_towards &= ~shift_direction

/datum/keybinding/movement/pixelshift/west
	hotkey_keys = list("CtrlShiftWest")
	name = "Pixelshift Left"
	full_name = "Pixelshift Left"
	description = "Pixelshifts you to the left."
	keybind_signal = COMSIG_KB_MOVEMENT_PIXELSHIFT_WEST_DOWN
	shift_direction = WEST

/datum/keybinding/movement/pixelshift/west/down(client/user)
	. = ..()
	if(.)
		return

	var/mob/mob = user.mob
	if(mob.current_pixelshift_x <= -16)
		return TRUE

	spawn(-1)
		while(1)
			if(!user || !(user.pixelshifting_towards & shift_direction))
				break
			if(mob.current_pixelshift_x <= -16)
				break

			mob.pixel_x--
			mob.current_pixelshift_x--
			UNTIL(user.pixelshift_time + 0.5 SECONDS < world.time)
			sleep(1)
			continue

		//this amount of voodoo makes me not trust keybind code
		user?.pixelshifting_towards &= ~shift_direction

/datum/keybinding/movement/pixelshift/east
	hotkey_keys = list("CtrlShiftEast")
	name = "Pixelshift Right"
	full_name = "Pixelshift Right"
	description = "Pixelshifts you to the right."
	keybind_signal = COMSIG_KB_MOVEMENT_PIXELSHIFT_EAST_DOWN
	shift_direction = EAST

/datum/keybinding/movement/pixelshift/east/down(client/user)
	. = ..()
	if(.)
		return

	var/mob/mob = user.mob
	if(mob.current_pixelshift_x >= 16)
		return TRUE

	spawn(-1)
		while(1)
			if(!user || !(user.pixelshifting_towards & shift_direction))
				break
			if(mob.current_pixelshift_x >= 16)
				break

			mob.pixel_x++
			mob.current_pixelshift_x++
			UNTIL(user.pixelshift_time + 0.5 SECONDS < world.time)
			sleep(1)
			continue

		//this amount of voodoo makes me not trust keybind code
		user?.pixelshifting_towards &= ~shift_direction


/datum/keybinding/movement/pixeltilt_west
	hotkey_keys = list("CtrlAltWest")
	name = "Pixeltilt Left"
	full_name = "Pixeltilt Left"
	description = "Tilts you to the left."
	keybind_signal = COMSIG_KB_MOVEMENT_TILT_WEST_DOWN

/datum/keybinding/movement/pixeltilt_west/down(client/user)
	. = ..()
	if(.)
		return

	. = TRUE
	var/mob/mob = user.mob
	if(mob.current_pixeltilt <= -45)
		return

	if(!user.pixelshift_time)
		user.pixelshift_time = world.time

	user.pixelshifting_towards |= (WEST << 2) //32
	spawn(-1)
		while(1)
			if(!user || !(user.pixelshifting_towards & (WEST << 2)))
				break
			if(mob.current_pixeltilt <= -45)
				break

			mob.transform = mob.transform.Turn(-1)
			mob.current_pixeltilt--

			UNTIL(user.pixelshift_time + 0.5 SECONDS < world.time)
			sleep(1)
			continue

		//this amount of voodoo makes me not trust keybind code
		user?.pixelshifting_towards &= ~(WEST << 2) //32

	return TRUE

/datum/keybinding/movement/pixeltilt_west/up(client/user)
	if(user)
		user.pixelshifting_towards &= ~(WEST << 2) //32
		if(!user.pixelshifting_towards)
			user.pixelshift_time = 0
	return TRUE


/datum/keybinding/movement/pixeltilt_east
	hotkey_keys = list("CtrlAltEast")
	name = "Pixeltilt Right"
	full_name = "Pixeltilt Right"
	description = "Tilts you to the right."
	keybind_signal = COMSIG_KB_MOVEMENT_TILT_EAST_DOWN

/datum/keybinding/movement/pixeltilt_east/down(client/user)
	. = ..()
	if(.)
		return

	. = TRUE
	var/mob/mob = user.mob
	if(mob.current_pixeltilt >= 45)
		return

	if(!user.pixelshift_time)
		user.pixelshift_time = world.time

	user.pixelshifting_towards |= (EAST << 2) //16
	spawn(-1)
		while(1)
			if(!user || !(user.pixelshifting_towards & (EAST << 2)))
				break
			if(mob.current_pixeltilt >= 45)
				break

			mob.transform = mob.transform.Turn(1)
			mob.current_pixeltilt--
			UNTIL(user.pixelshift_time + 0.5 SECONDS < world.time)
			sleep(1)
			continue

		//this amount of voodoo makes me not trust keybind code
		user?.pixelshifting_towards &= ~(EAST << 2) //16

	return TRUE

/datum/keybinding/movement/pixeltilt_east/up(client/user)
	user.pixelshifting_towards &= ~(EAST << 2) //16
	if(!user.pixelshifting_towards)
		user.pixelshift_time = 0
	return TRUE


/datum/keybinding/movement/north
	hotkey_keys = list("W", "North")
	name = "North"
	full_name = "Move North"
	description = "Moves your character north"
	keybind_signal = COMSIG_KB_MOVEMENT_NORTH_DOWN

/datum/keybinding/movement/south
	hotkey_keys = list("S", "South")
	name = "South"
	full_name = "Move South"
	description = "Moves your character south"
	keybind_signal = COMSIG_KB_MOVEMENT_SOUTH_DOWN

/datum/keybinding/movement/west
	hotkey_keys = list("A", "West")
	name = "West"
	full_name = "Move West"
	description = "Moves your character left"
	keybind_signal = COMSIG_KB_MOVEMENT_WEST_DOWN

/datum/keybinding/movement/east
	hotkey_keys = list("D", "East")
	name = "East"
	full_name = "Move East"
	description = "Moves your character east"
	keybind_signal = COMSIG_KB_MOVEMENT_EAST_DOWN

/datum/keybinding/movement/zlevel_upwards
	hotkey_keys = list("Northeast") // PGUP
	name = "Upwards"
	full_name = "Move Upwards"
	description = "Moves your character up a z-level if possible"
	keybind_signal = COMSIG_KB_MOVEMENT_ZLEVEL_MOVEUP_DOWN

/datum/keybinding/movement/zlevel_upwards/down(client/user)
	. = ..()
	if(.)
		return
	user.mob.up()
	return TRUE

/datum/keybinding/movement/zlevel_downwards
	hotkey_keys = list("Southeast") // PGDOWN
	name = "Downwards"
	full_name = "Move Downwards"
	description = "Moves your character down a z-level if possible"
	keybind_signal = COMSIG_KB_MOVEMENT_ZLEVEL_MOVEDOWN_DOWN

/datum/keybinding/movement/zlevel_downwards/down(client/user)
	. = ..()
	if(.)
		return
	user.mob.down()
	return TRUE

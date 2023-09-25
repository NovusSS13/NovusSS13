/datum/keybinding/movement
	category = CATEGORY_MOVEMENT
	weight = WEIGHT_HIGHEST

/datum/keybinding/movement/up(client/user)
	if(user.pixelshifting && !max(user.keys_held["North"], user.keys_held["South"], user.keys_held["East"], user.keys_held["West"]))
		user.pixelshift_time = 0

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


/datum/keybinding/movement/pixelshift
	hotkey_keys = list("`")
	name = "Pixelshift"
	full_name = "Enable Pixelshift"
	description = "Lets you pixelshift."
	keybind_signal = COMSIG_KB_MOVEMENT_PIXELSHIFT_DOWN

/datum/keybinding/movement/pixelshift/down(client/user)
	. = ..()
	if(.)
		return

	if(user.pixelshifting)
		return

	RegisterSignal(user.mob, COMSIG_MOUSE_SCROLL_ON, PROC_REF(on_scroll))
	user.pixelshifting = TRUE

/datum/keybinding/movement/pixelshift/up(client/user)
	. = ..()
	UnregisterSignal(user.mob, COMSIG_MOUSE_SCROLL_ON)
	user.pixelshifting = FALSE
	return TRUE

/datum/keybinding/movement/pixelshift/proc/on_scroll(mob/source, atom/target, delta_x, delta_y, params)
	SIGNAL_HANDLER

	var/tilt_result = clamp(source.current_pixeltilt + SIGN(delta_y), -45, 45)
	var/tilt_amount = tilt_result - source.current_pixeltilt

	if(tilt_amount)
		source.transform = source.transform.Turn(tilt_amount)
		source.current_pixeltilt = tilt_result

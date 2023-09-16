GLOBAL_LIST_EMPTY(preferences_datums)

/datum/preferences
	var/client/parent
	/// The path to the general savefile for this datum
	var/path
	/// Whether or not we allow saving/loading. Used for guests, if they're enabled
	var/load_and_save = TRUE
	/// Ensures that we always load the last used save, QOL
	var/list/current_ids = list()
	/// The current charset we're editing. "main" for station characters, everything else in GLOB.valid_char_savekeys
	var/current_char_key = "main"

	var/max_save_slots = 10
	/// Above, but for ghost roles.
	var/max_ghost_role_slots = 2
	/// The amount of main slots we're actually using. Assoc list of character savekeys to the amount of slots used.
	var/list/used_slot_amount = list()

	/// Bitflags for communications that are muted
	var/muted = NONE
	/// Last IP that this client has connected from
	var/last_ip
	/// Last CID that this client has connected from
	var/last_id

	/// Cached changelog size, to detect new changelogs since last join
	var/lastchangelog = ""

	/// List of ROLE_X that the client wants to be eligible for
	var/list/be_special = list() //Special role selection

	/// Custom keybindings. Map of keybind names to keyboard inputs.
	/// For example, by default would have "swap_hands" -> list("X")
	var/list/key_bindings = list()

	/// Cached list of keybindings, mapping keys to actions.
	/// For example, by default would have "X" -> list("swap_hands")
	var/list/key_bindings_by_key = list()

	var/toggles = TOGGLES_DEFAULT
	var/db_flags
	var/chat_toggles = TOGGLES_DEFAULT_CHAT
	var/ghost_form = "ghost"

	//character preferences
	var/slot_randomized //keeps track of round-to-round randomization of the character slot, prevents overwriting

	var/list/randomise = list()

	//Quirk list
	var/list/all_quirks = list()

	/// A list of every marking zone and it's associated body markings
	var/list/list/body_markings = list()

	//Job preferences 2.0 - indexed by job title , no key or value implies never
	var/list/job_preferences = list()

	/// The current window, PREFERENCE_TAB_* in [`code/__DEFINES/preferences.dm`]
	var/current_window = PREFERENCE_TAB_CHARACTER_PREFERENCES

	var/unlock_content = 0

	var/list/ignoring = list()

	var/list/exp = list()

	var/action_buttons_screen_locs = list()

	///Someone thought we were nice! We get a little heart in OOC until we join the server past the below time (we can keep it until the end of the round otherwise)
	var/hearted
	///If we have a hearted commendations, we honor it every time the player loads preferences until this time has been passed
	var/hearted_until
	///What outfit typepaths we've favorited in the SelectEquipment menu
	var/list/favorite_outfits = list()

	/// A preview of the current character
	var/atom/movable/screen/map_view/char_preview/character_preview_view

	/// A list of instantiated middleware
	var/list/datum/preference_middleware/middleware = list()

	/// The json savefile for this datum
	var/datum/json_savefile/savefile

	/// The savefile relating to character preferences, PREFERENCE_CHARACTER
	var/list/character_data

	/// If set to TRUE, will update character_profiles on the next ui_data tick.
	var/tainted_character_profiles = FALSE

/datum/preferences/Destroy(force, ...)
	QDEL_NULL(character_preview_view)
	QDEL_LIST(middleware)
	return ..()

/datum/preferences/New(client/parent)
	src.parent = parent

	for(var/middleware_type in subtypesof(/datum/preference_middleware))
		middleware += new middleware_type(src)

	if(IS_CLIENT_OR_MOCK(parent))
		load_and_save = !is_guest_key(parent.key)
		load_path(parent.ckey)
		if(load_and_save && !fexists(path))
			try_savefile_type_migration()
		unlock_content = !!parent.IsByondMember()
		if(unlock_content)
			max_save_slots = 15
	else
		CRASH("attempted to create a preferences datum without a client or mock!")
	load_savefile()

	// give them default keybinds and update their movement keys
	key_bindings = deep_copy_list(GLOB.default_hotkeys)
	key_bindings_by_key = get_key_bindings_by_key(key_bindings)
	randomise = get_default_randomization()

	var/loaded_preferences_successfully = load_preferences()
	if(loaded_preferences_successfully)
		if(load_character())
			return

	if(parent)
		apply_all_client_preferences()
		parent.set_macros()

	if(!loaded_preferences_successfully)
		save_preferences()
	save_character() //let's save this new random character so it doesn't keep generating new ones.

/datum/preferences/ui_interact(mob/user, datum/tgui/ui)
	// There used to be code here that readded the preview view if you "rejoined"
	// I'm making the assumption that ui close will be called whenever a user logs out, or loses a window
	// If this isn't the case, kill me and restore the code, thanks

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		character_preview_view = create_character_preview_view(user)

		ui = new(user, src, "PreferencesMenu")
		ui.set_autoupdate(FALSE)
		ui.open()

		// HACK: Without this the character starts out really tiny because of some BYOND bug.
		// You can fix it by changing a preference, so let's just forcably update the body to emulate this.
		// Lemon from the future: this issue appears to replicate if the byond map (what we're relaying here)
		// Is shown while the client's mouse is on the screen. As soon as their mouse enters the main map, it's properly scaled
		// I hate this place
		addtimer(CALLBACK(character_preview_view, TYPE_PROC_REF(/atom/movable/screen/map_view/char_preview, update_body)), 1 SECONDS)

/datum/preferences/ui_state(mob/user)
	return GLOB.always_state

// Without this, a hacker would be able to edit other people's preferences if
// they had the ref to Topic to.
/datum/preferences/ui_status(mob/user, datum/ui_state/state)
	return user.client == parent ? UI_INTERACTIVE : UI_CLOSE

/datum/preferences/ui_data(mob/user)
	var/list/data = list()

	if(tainted_character_profiles)
		data["character_profiles"] = create_character_profiles()
		tainted_character_profiles = FALSE

	data["character_preferences"] = compile_character_preferences(user)

	data["active_slot_ids"] = current_ids
	data["active_slot_key"] = current_char_key

	for(var/datum/preference_middleware/preference_middleware as anything in middleware)
		data += preference_middleware.get_ui_data(user)

	return data

/datum/preferences/ui_static_data(mob/user)
	var/list/data = list()

	data["character_profiles"] = create_character_profiles()

	data["character_preview_view"] = character_preview_view.assigned_map
	data["overflow_role"] = SSjob.GetJobType(SSjob.overflow_role).title
	data["window"] = current_window

	data["max_slots_main"] = max_save_slots
	data["max_slots_ghost"] = max_ghost_role_slots

	data["is_guest"] = is_guest_key(user.key)
	data["content_unlocked"] = unlock_content

	for(var/datum/preference_middleware/preference_middleware as anything in middleware)
		data += preference_middleware.get_ui_static_data(user)

	return data

/datum/preferences/ui_assets(mob/user)
	var/list/assets = list(
		get_asset_datum(/datum/asset/spritesheet/preferences),
		get_asset_datum(/datum/asset/json/preferences),
	)

	for(var/datum/preference_middleware/preference_middleware as anything in middleware)
		assets += preference_middleware.get_ui_assets()

	return assets

/datum/preferences/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch (action)
		if("change_slot")
			// Save existing character
			save_character()

			// SAFETY: `load_character` performs sanitization the slot number
			if(!load_character(params["slot_id"], params["slot_key"]))
				tainted_character_profiles = TRUE
				save_character()

			for(var/datum/preference_middleware/preference_middleware as anything in middleware)
				preference_middleware.on_new_character(usr)

			character_preview_view.update_body()

			return TRUE

		if("new_slot")
			// Save existing character
			save_character()

			tainted_character_profiles = TRUE
			if(!add_character_slot(params["slot_key"]))
				return FALSE

			character_preview_view.update_body()
			return TRUE

		if("rotate")
			character_preview_view.dir = turn(character_preview_view.dir, -90)

			return TRUE

		if("set_preference")
			var/requested_preference_key = params["preference"]
			var/value = params["value"]

			for(var/datum/preference_middleware/preference_middleware as anything in middleware)
				if(preference_middleware.pre_set_preference(usr, requested_preference_key, value))
					return TRUE

			var/datum/preference/requested_preference = GLOB.preference_entries_by_key[requested_preference_key]
			if(isnull(requested_preference))
				return FALSE

			// SAFETY: `update_preference` performs validation checks
			if(!update_preference(requested_preference, value))
				return FALSE

			if(istype(requested_preference, /datum/preference/name))
				tainted_character_profiles = TRUE

			for (var/datum/preference_middleware/preference_middleware as anything in middleware)
				if (preference_middleware.post_set_preference(usr, requested_preference_key, value))
					return TRUE

			return TRUE

		if("set_color_preference")
			var/requested_preference_key = params["preference"]

			var/datum/preference/requested_preference = GLOB.preference_entries_by_key[requested_preference_key]
			if(isnull(requested_preference))
				return FALSE

			if(!istype(requested_preference, /datum/preference/color))
				return FALSE

			var/default_value = read_preference(requested_preference.type)

			// Yielding
			var/new_color = input(
				usr,
				"Select new color",
				null,
				default_value || COLOR_WHITE,
			) as color | null

			if(!new_color)
				return FALSE

			return update_preference(requested_preference, new_color)

		if ("set_color_mutant_colors")
			var/requested_preference_key = params["preference"]

			var/datum/preference/requested_preference = GLOB.preference_entries_by_key[requested_preference_key]
			if (isnull(requested_preference))
				return FALSE

			if (!istype(requested_preference, /datum/preference/color))
				return FALSE

			var/list/color_list = read_preference(/datum/preference/tricolor/mutant/mutant_color)
			if (!islist(color_list))
				return FALSE //wtf?

			return update_preference(requested_preference, color_list[1])

		if ("set_tricolor_preference")
			var/requested_preference_key = params["preference"]
			var/requested_preference_index = params["value"]

			var/datum/preference/requested_preference = GLOB.preference_entries_by_key[requested_preference_key]
			if(isnull(requested_preference))
				return FALSE

			if(!istype(requested_preference, /datum/preference/tricolor))
				return FALSE

			var/list/color_list = read_preference(requested_preference.type)
			if(!islist(color_list))
				return FALSE //wtf?

			var/default_value = sanitize_hexcolor(color_list[requested_preference_index], DEFAULT_HEX_COLOR_LEN, include_crunch = TRUE)

			// Yielding
			var/new_color = input(
				usr,
				"Select new color",
				null,
				default_value || COLOR_WHITE,
			) as color | null
			if(!new_color)
				return FALSE

			color_list[requested_preference_index] = new_color
			return update_preference(requested_preference, jointext(color_list, ";"))

		if ("set_tricolor_mutant_colors")
			var/requested_preference_key = params["preference"]

			var/datum/preference/requested_preference = GLOB.preference_entries_by_key[requested_preference_key]
			if (isnull(requested_preference))
				return FALSE

			if (!istype(requested_preference, /datum/preference/tricolor))
				return FALSE

			var/list/color_list = read_preference(/datum/preference/tricolor/mutant/mutant_color)
			if (!islist(color_list))
				return FALSE //wtf?

			return update_preference(requested_preference, jointext(color_list, ";"))

	for(var/datum/preference_middleware/preference_middleware as anything in middleware)
		var/delegation = preference_middleware.action_delegations[action]
		if(!isnull(delegation))
			return call(preference_middleware, delegation)(params, usr)

	return FALSE

/datum/preferences/ui_close(mob/user)
	save_character()
	save_preferences()
	QDEL_NULL(character_preview_view)

/datum/preferences/Topic(href, list/href_list)
	. = ..()
	if(.)
		return

	if(href_list["open_keybindings"])
		current_window = PREFERENCE_TAB_KEYBINDINGS
		update_static_data(usr)
		ui_interact(usr)
		return TRUE

/datum/preferences/proc/create_character_preview_view(mob/user)
	character_preview_view = new(null, src)
	character_preview_view.generate_view("character_preview_[REF(character_preview_view)]")
	character_preview_view.update_body()
	character_preview_view.display_to(user)

	return character_preview_view

/datum/preferences/proc/compile_character_preferences(mob/user)
	var/list/preferences = list()

	for(var/datum/preference/preference as anything in get_preferences_in_priority_order())
		if(!preference.is_accessible(src))
			continue

		LAZYINITLIST(preferences[preference.category])

		var/value = read_preference(preference.type)
		var/data = preference.compile_ui_data(user, value, src)

		preferences[preference.category][preference.savefile_key] = data

	for(var/datum/preference_middleware/preference_middleware as anything in middleware)
		var/list/append_character_preferences = preference_middleware.get_character_preferences(user)
		if(isnull(append_character_preferences))
			continue

		for(var/category in append_character_preferences)
			if(category in preferences)
				preferences[category] += append_character_preferences[category]
			else
				preferences[category] = append_character_preferences[category]

	return preferences

/// Applies all PREFERENCE_PLAYER preferences
/datum/preferences/proc/apply_all_client_preferences()
	for(var/datum/preference/preference as anything in get_preferences_in_priority_order())
		if(preference.savefile_identifier != PREFERENCE_PLAYER)
			continue

		preference.apply_to_client(parent, read_preference(preference.type))

/// A preview of a character for use in the preferences menu
/atom/movable/screen/map_view/char_preview
	name = "character_preview"
	/// The body that is displayed
	var/mob/living/carbon/human/dummy/body
	/// The preferences this refers to
	var/datum/preferences/preferences

/atom/movable/screen/map_view/char_preview/Initialize(mapload, datum/preferences/preferences)
	. = ..()
	src.preferences = preferences

/atom/movable/screen/map_view/char_preview/Destroy()
	QDEL_NULL(body)
	preferences?.character_preview_view = null
	preferences = null
	return ..()

/// Updates the currently displayed body
/atom/movable/screen/map_view/char_preview/proc/update_body()
	if(isnull(body))
		create_body()
	else
		body.wipe_state()
	appearance = preferences.render_new_preview_appearance(body)

/atom/movable/screen/map_view/char_preview/proc/create_body()
	QDEL_NULL(body)

	body = new

/datum/preferences/proc/create_character_profiles()
	var/list/profiles = list("main" = list())

	for(var/save_key in GLOB.valid_char_savekeys)
		profiles[save_key] = list() //insert blank data
		for(var/index in 1 to used_slot_amount[save_key] || 0)
			var/save_data = savefile.get_entry("character_[save_key]_[index]")
			var/name = save_data?["real_name"]

			profiles[save_key] += name

	return profiles

/datum/preferences/proc/set_job_preference_level(datum/job/job, level)
	if(!job)
		return FALSE

	if(level == JP_HIGH)
		var/datum/job/overflow_role = SSjob.overflow_role
		var/overflow_role_title = initial(overflow_role.title)

		for(var/other_job in job_preferences)
			if(job_preferences[other_job] == JP_HIGH)
				// Overflow role needs to go to NEVER, not medium!
				if(other_job == overflow_role_title)
					job_preferences[other_job] = null
				else
					job_preferences[other_job] = JP_MEDIUM

	if(level == null)
		job_preferences -= job.title
	else
		job_preferences[job.title] = level

	return TRUE

/datum/preferences/proc/GetQuirkBalance()
	var/bal = 0
	for(var/quirk_name in all_quirks)
		var/datum/quirk/quirk = SSquirks.quirks[quirk_name]
		bal -= initial(quirk.value)
	return bal

/datum/preferences/proc/GetPositiveQuirkCount()
	. = 0
	for(var/quirk_name in all_quirks)
		if(SSquirks.quirk_points[quirk_name] > 0)
			.++

/datum/preferences/proc/validate_quirks()
	all_quirks = SSquirks.filter_invalid_quirks(all_quirks)
	if(GetQuirkBalance() < 0)
		all_quirks = list()
	return all_quirks

/datum/preferences/proc/validate_markings()
	var/species_type = read_preference(/datum/preference/choiced/species)
	var/list/final_markings = list()
	for(var/zone in body_markings)
		for(var/marking_name in body_markings[zone])
			var/datum/sprite_accessory/body_markings/body_marking = GLOB.body_markings_by_zone[zone][marking_name]
			if(!body_marking || (body_marking.name == SPRITE_ACCESSORY_NONE)) //invalid marking...
				continue
			if(!body_marking.compatible_species || is_path_in_list(species_type, body_marking.compatible_species))
				LAZYADDASSOC(final_markings[zone], marking_name, sanitize_hexcolor(body_markings[zone][marking_name], DEFAULT_HEX_COLOR_LEN, TRUE))
	body_markings = final_markings
	return final_markings

/// Returns a list of our middlewares that should be applied BEFORE normal prefs, in priority order
/datum/preferences/proc/get_middlewares_before_prefs_in_priority_order()
	var/list/preferences_before[MIDDLEWARE_PRIORITY_BEFORE]

	for (var/datum/preference_middleware/pref_middleware in middleware)
		if (pref_middleware.priority <= MIDDLEWARE_PRIORITY_BEFORE)
			LAZYADD(preferences_before[pref_middleware.priority], pref_middleware)

	var/list/flattened = list()
	for (var/index in 1 to MIDDLEWARE_PRIORITY_BEFORE)
		flattened += preferences_before[index]
	return flattened

/// Returns a list of our middlewares that should be applied AFTER normal prefs, in priority order
/datum/preferences/proc/get_middlewares_after_prefs_in_priority_order()
	var/list/preferences_after[MIDDLEWARE_PRIORITY_AFTER - MIDDLEWARE_PRIORITY_BEFORE]

	for (var/datum/preference_middleware/pref_middleware in middleware)
		if (pref_middleware.priority > MIDDLEWARE_PRIORITY_BEFORE)
			LAZYADD(preferences_after[pref_middleware.priority - MIDDLEWARE_PRIORITY_BEFORE], pref_middleware)

	var/list/flattened = list()
	for (var/index in 1 to MIDDLEWARE_PRIORITY_AFTER - MIDDLEWARE_PRIORITY_BEFORE)
		flattened += preferences_after[index]
	return flattened

/// Sanitizes the preferences, applies the randomization prefs, and then applies the preference to the human mob.
/datum/preferences/proc/safe_transfer_prefs_to(mob/living/carbon/human/character, icon_updates = TRUE, is_antag = FALSE, char_id = current_ids["main"], char_key = "main")
	load_character(char_id, char_key) //we MUST do this because ASS
	apply_character_randomization_prefs(is_antag)
	apply_prefs_to(character, icon_updates)

/// Applies the given preferences to a human mob.
/datum/preferences/proc/apply_prefs_to(mob/living/carbon/human/character, icon_updates = TRUE)
	character.dna.features = list()

	//Apply markings before normal prefs are done
	for (var/datum/preference_middleware/preference_middleware as anything in get_middlewares_before_prefs_in_priority_order())
		preference_middleware.apply_to_human(character, src)

	//Normal preference datums with no snowflake handling
	for (var/datum/preference/preference as anything in get_preferences_in_priority_order())
		if (preference.savefile_identifier != PREFERENCE_CHARACTER)
			continue

		preference.apply_to_human(character, read_preference(preference.type), src)

	//Apply augments/etc after normal prefs are done
	for (var/datum/preference_middleware/preference_middleware as anything in get_middlewares_after_prefs_in_priority_order())
		preference_middleware.apply_to_human(character, src)

	character.dna.real_name = character.real_name
	if(icon_updates)
		character.icon_render_keys = list()
		character.update_body(is_creating = TRUE)

/// Returns whether the parent mob should have the random hardcore settings enabled. Assumes it has a mind.
/datum/preferences/proc/should_be_random_hardcore(datum/job/job, datum/mind/mind)
	if(!read_preference(/datum/preference/toggle/random_hardcore))
		return FALSE
	if(job.departments_bitflags & DEPARTMENT_BITFLAG_COMMAND) //No command staff
		return FALSE
	for(var/datum/antagonist/antag as anything in mind.antag_datums)
		if(antag.get_team()) //No team antags
			return FALSE
	return TRUE

/// Inverts the key_bindings list such that it can be used for key_bindings_by_key
/datum/preferences/proc/get_key_bindings_by_key(list/key_bindings)
	var/list/output = list()

	for(var/action in key_bindings)
		for(var/key in key_bindings[action])
			LAZYADD(output[key], action)

	return output

/// Returns the default `randomise` variable ouptut
/datum/preferences/proc/get_default_randomization()
	var/list/default_randomization = list()

	for(var/preference_key in GLOB.preference_entries_by_key)
		var/datum/preference/preference = GLOB.preference_entries_by_key[preference_key]
		if(preference.is_randomizable() && preference.randomize_by_default)
			default_randomization[preference_key] = RANDOM_ENABLED

	return default_randomization

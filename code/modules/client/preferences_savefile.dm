//This is the lowest supported version, anything below this is completely obsolete and the entire savefile will be wiped.
#define SAVEFILE_VERSION_MIN 32

//This is the current version, anything below this will attempt to update (if it's not obsolete)
// You do not need to raise this if you are adding new values that have sane defaults.
// Only raise this value when changing the meaning/format/name/layout of an existing value
// where you would want the updater procs below to run
#define SAVEFILE_VERSION_MAX 43

/*
SAVEFILE UPDATING/VERSIONING - 'Simplified', or rather, more coder-friendly ~Carn
	This proc checks if the current directory of the savefile S needs updating
	It is to be used by the load_character and load_preferences procs.
	(S.cd == "/" is preferences, S.cd == "/character[integer]" is a character slot, etc)

	if the current directory's version is below SAVEFILE_VERSION_MIN it will simply wipe everything in that directory
	(if we're at root "/" then it'll just wipe the entire savefile, for instance.)

	if its version is below SAVEFILE_VERSION_MAX but above the minimum, it will load data but later call the
	respective update_preferences() or update_character() proc.
	Those procs allow coders to specify format changes so users do not lose their setups and have to redo them again.

	Failing all that, the standard sanity checks are performed. They simply check the data is suitable, reverting to
	initial() values if necessary.
*/
/datum/preferences/proc/save_data_needs_update(list/save_data)
	if(!length(save_data)) // empty list, either savefile isnt loaded or its a new char
		return -1
	if(save_data["version"] < SAVEFILE_VERSION_MIN)
		return -2
	if(save_data["version"] < SAVEFILE_VERSION_MAX)
		return save_data["version"]
	return -1

//should these procs get fairly long
//just increase SAVEFILE_VERSION_MIN so it's not as far behind
//SAVEFILE_VERSION_MAX and then delete any obsolete if clauses
//from these procs.
//This only really meant to avoid annoying frequent players
//if your savefile is 3 months out of date, then 'tough shit'.

/datum/preferences/proc/update_preferences(current_version, datum/json_savefile/S)
	if(current_version < 34)
		write_preference(/datum/preference/toggle/auto_fit_viewport, TRUE)

	if(current_version < 35) //makes old keybinds compatible with #52040, sets the new default
		var/newkey = FALSE
		for(var/list/key in key_bindings)
			for(var/bind in key)
				if(bind == "quick_equipbelt")
					key -= "quick_equipbelt"
					key |= "quick_equip_belt"

				if(bind == "bag_equip")
					key -= "bag_equip"
					key |= "quick_equip_bag"

				if(bind == "quick_equip_suit_storage")
					newkey = TRUE
		if(!newkey && !key_bindings["ShiftQ"])
			key_bindings["ShiftQ"] = list("quick_equip_suit_storage")

	if(current_version < 36)
		if(key_bindings["ShiftQ"] == "quick_equip_suit_storage")
			key_bindings["ShiftQ"] = list("quick_equip_suit_storage")

	if(current_version < 37)
		if(read_preference(/datum/preference/numeric/fps) == 0)
			write_preference(GLOB.preference_entries[/datum/preference/numeric/fps], -1)

	if (current_version < 38)
		var/found_block_movement = FALSE

		for (var/list/key in key_bindings)
			for (var/bind in key)
				if (bind == "block_movement")
					found_block_movement = TRUE
					break
			if (found_block_movement)
				break

		if (!found_block_movement)
			LAZYADD(key_bindings["Ctrl"], "block_movement")

	if (current_version < 39)
		LAZYADD(key_bindings["F"], "toggle_combat_mode")
		LAZYADD(key_bindings["4"], "toggle_combat_mode")
	if (current_version < 40)
		LAZYADD(key_bindings["Space"], "hold_throw_mode")

	if (current_version < 41)
		migrate_preferences_to_tgui_prefs_menu()

/datum/preferences/proc/update_character(current_version, list/save_data)
	if (current_version < 41)
		migrate_character_to_tgui_prefs_menu()

	if (current_version < 42)
		migrate_body_types(save_data)

	if (current_version < 43)
		migrate_legacy_sound_toggles(savefile)

/// checks through keybindings for outdated unbound keys and updates them
/datum/preferences/proc/check_keybindings()
	if(!parent)
		return
	var/list/binds_by_key = get_key_bindings_by_key(key_bindings)
	var/list/notadded = list()
	for (var/name in GLOB.keybindings_by_name)
		var/datum/keybinding/kb = GLOB.keybindings_by_name[name]
		if(kb.name in key_bindings)
			continue // key is unbound and or bound to something

		var/addedbind = FALSE
		key_bindings[kb.name] = list()

		if(parent.hotkeys)
			for(var/hotkeytobind in kb.hotkey_keys)
				if(hotkeytobind == "Unbound")
					addedbind = TRUE
				else if(!length(binds_by_key[hotkeytobind])) //Only bind to the key if nothing else is bound
					key_bindings[kb.name] |= hotkeytobind
					addedbind = TRUE
		else
			for(var/classickeytobind in kb.classic_keys)
				if(classickeytobind == "Unbound")
					addedbind = TRUE
				else if(!length(binds_by_key[classickeytobind])) //Only bind to the key if nothing else is bound
					key_bindings[kb.name] |= classickeytobind
					addedbind = TRUE

		if(!addedbind)
			notadded += kb
	save_preferences() //Save the players pref so that new keys that were set to Unbound as default are permanently stored
	if(length(notadded))
		addtimer(CALLBACK(src, PROC_REF(announce_conflict), notadded), 5 SECONDS)

/datum/preferences/proc/announce_conflict(list/notadded)
	to_chat(parent, "<span class='warningplain'><b><u>Keybinding Conflict</u></b></span>\n\
					<span class='warningplain'><b>There are new <a href='?src=[REF(src)];open_keybindings=1'>keybindings</a> that default to keys you've already bound. The new ones will be unbound.</b></span>")
	for(var/item in notadded)
		var/datum/keybinding/conflicted = item
		to_chat(parent, span_danger("[conflicted.category]: [conflicted.full_name] needs updating"))

/datum/preferences/proc/load_path(ckey, filename="preferences.json")
	if(!ckey || !load_and_save)
		return
	path = "data/player_saves/[ckey[1]]/[ckey]/[filename]"

/datum/preferences/proc/load_savefile()
	if(load_and_save && !path)
		CRASH("Attempted to load savefile without first loading a path!")
	savefile = new /datum/json_savefile(load_and_save ? path : null)

/datum/preferences/proc/load_preferences()
	if(!savefile)
		stack_trace("Attempted to load the preferences of [parent] without a savefile; did you forget to call load_savefile?")
		load_savefile()
		if(!savefile)
			stack_trace("Failed to load the savefile for [parent] after manually calling load_savefile; something is very wrong.")
			return FALSE

	var/needs_update = save_data_needs_update(savefile.get_entry())
	if(load_and_save && (needs_update == -2)) //fatal, can't load any data
		var/bacpath = "[path].updatebac" //todo: if the savefile version is higher then the server, check the backup, and give the player a prompt to load the backup
		if (fexists(bacpath))
			fdel(bacpath) //only keep 1 version of backup
		fcopy(savefile.path, bacpath) //byond helpfully lets you use a savefile for the first arg.
		return FALSE

	apply_all_client_preferences()

	//general preferences
	lastchangelog = savefile.get_entry("lastchangelog", lastchangelog)
	be_special = savefile.get_entry("be_special", be_special)
	current_ids = savefile.get_entry("current_ids", current_ids)
	used_slot_amount = savefile.get_entry("used_slot_amount", used_slot_amount)
	chat_toggles = savefile.get_entry("chat_toggles", chat_toggles)
	toggles = savefile.get_entry("toggles", toggles)
	ignoring = savefile.get_entry("ignoring", ignoring)

	// OOC commendations
	hearted_until = savefile.get_entry("hearted_until", hearted_until)
	if(hearted_until > world.realtime)
		hearted = TRUE
	//favorite outfits
	favorite_outfits = savefile.get_entry("favorite_outfits", favorite_outfits)

	var/list/parsed_favs = list()
	for(var/typetext in favorite_outfits)
		var/datum/outfit/path = text2path(typetext)
		if(ispath(path)) //whatever typepath fails this check probably doesn't exist anymore
			parsed_favs += path
	favorite_outfits = unique_list(parsed_favs)

	// Custom hotkeys
	key_bindings = savefile.get_entry("key_bindings", key_bindings)

	//try to fix any outdated data if necessary
	if(needs_update >= 0)
		var/bacpath = "[path].updatebac" //todo: if the savefile version is higher then the server, check the backup, and give the player a prompt to load the backup
		if (fexists(bacpath))
			fdel(bacpath) //only keep 1 version of backup
		fcopy(savefile.path, bacpath) //byond helpfully lets you use a savefile for the first arg.
		update_preferences(needs_update, savefile) //needs_update = savefile_version if we need an update (positive integer)

	check_keybindings() // this apparently fails every time and overwrites any unloaded prefs with the default values, so don't load anything after this line or it won't actually save
	key_bindings_by_key = get_key_bindings_by_key(key_bindings)

	//Sanitize
	lastchangelog = sanitize_text(lastchangelog, initial(lastchangelog))
	used_slot_amount = SANITIZE_LIST(used_slot_amount)
	for(var/slot in GLOB.valid_char_savekeys)
		//IMPORTANT: 0, not 1. This is because we can sometimes not have a ghost role slot.
		//Main gets sanitized down the line.
		used_slot_amount[slot] = sanitize_integer(used_slot_amount[slot], 0, slot == "main" ? max_save_slots : max_ghost_role_slots, 0)

	current_char_key = "main"
	current_ids = SANITIZE_LIST(current_ids)
	for(var/id in current_ids)
		// if a ghost role slot wasnt added, the correspoinding key wont be in current_ids
		current_ids[id] = sanitize_integer(current_ids[id], 1, used_slot_amount[id], 1)

	toggles = sanitize_integer(toggles, 0, (2**24)-1, initial(toggles))
	be_special = sanitize_be_special(SANITIZE_LIST(be_special))
	key_bindings = sanitize_keybindings(key_bindings)
	favorite_outfits = SANITIZE_LIST(favorite_outfits)

	if(used_slot_amount["main"] <= 0)
		add_character_slot("main")

	if(needs_update >= 0) //save the updated version
		var/list/old_char_ids = current_ids.Copy()
		var/old_max_save_slots = max_save_slots
		var/old_max_ghost_role_slots = max_ghost_role_slots

		for (var/slot in savefile.get_entry()) //but first, update all current character slots.
			var/list/slot_data = splittext(slot, "_")
			if(slot_data[1] != "character")
				continue

			if(length(slot_data) != 3) //someone didnt follow the formatting
				stack_trace("Invalid character savefile data, expected len == 3 but got [length(slot_data)]! ([slot])")
				return FALSE

			var/slot_key = slot_data[2]
			var/slot_id = text2num(slot_data[3])

			max_save_slots = max(slot_data[2] == "main" ? max_save_slots : max_ghost_role_slots, slot_id) //so we can still update byond member slots after they lose memeber status

			if(load_character(slot_id, slot_key))
				save_character(slot_id, slot_key)

		current_ids = old_char_ids
		max_save_slots = old_max_save_slots
		max_ghost_role_slots = old_max_ghost_role_slots
		save_preferences()

	return TRUE

/datum/preferences/proc/save_preferences()
	if(!savefile)
		CRASH("Attempted to save the preferences of [parent] without a savefile. This should have been handled by load_preferences()")

	savefile.set_entry("version", SAVEFILE_VERSION_MAX) //updates (or failing that the sanity checks) will ensure data is not invalid at load. Assume up-to-date
	savefile.set_entry("lastchangelog", lastchangelog)
	savefile.set_entry("be_special", be_special)
	savefile.set_entry("current_ids", current_ids)
	savefile.set_entry("current_char_key", current_char_key)
	savefile.set_entry("used_slot_amount", used_slot_amount)
	savefile.set_entry("toggles", toggles)
	savefile.set_entry("chat_toggles", chat_toggles)
	savefile.set_entry("ignoring", ignoring)
	savefile.set_entry("key_bindings", key_bindings)
	savefile.set_entry("hearted_until", (hearted_until > world.realtime ? hearted_until : null))
	savefile.set_entry("favorite_outfits", favorite_outfits)
	savefile.save()
	return TRUE

/datum/preferences/proc/load_character(char_id = current_ids[current_char_key], char_savekey = current_char_key)
	SHOULD_NOT_SLEEP(TRUE)

	char_savekey = sanitize_inlist(char_savekey, GLOB.valid_char_savekeys, "main")
	char_id = sanitize_integer(char_id, 1, max(used_slot_amount[char_savekey], 1), 1) //used_slot_amount[] COULD return null, and therefore 0

	if(char_savekey != current_char_key || char_id != current_ids[char_savekey])
		current_ids[char_savekey] = char_id
		savefile.set_entry("current_ids", char_id)

	if(char_savekey != current_char_key)
		current_char_key = char_savekey
		savefile.set_entry("current_char_key", char_savekey)

	var/list/save_data = savefile.get_entry("character_[char_savekey]_[char_id]")
	var/needs_update = save_data_needs_update(save_data)
	if(needs_update == -2) //fatal, can't load any data
		return FALSE

	randomise = save_data?["randomise"]
	job_preferences = save_data?["job_preferences"]
	all_quirks = save_data?["all_quirks"]

	//Markings
	body_markings = save_data?["body_markings"]

	//try to fix any outdated data if necessary
	//preference updating will handle saving the updated data for us.
	if(needs_update >= 0)
		update_character(needs_update, save_data) //needs_update == savefile_version if we need an update (positive integer)

	//Sanitize
	randomise = SANITIZE_LIST(randomise)
	job_preferences = SANITIZE_LIST(job_preferences)
	all_quirks = SANITIZE_LIST(all_quirks)
	body_markings = SANITIZE_LIST(body_markings)

	//Validate job prefs
	for(var/j in job_preferences)
		if(job_preferences[j] != JP_LOW && job_preferences[j] != JP_MEDIUM && job_preferences[j] != JP_HIGH)
			job_preferences -= j

	validate_quirks()
	validate_markings()

	return TRUE

/datum/preferences/proc/save_character(char_id = current_ids[current_char_key], char_savekey = current_char_key)
	SHOULD_NOT_SLEEP(TRUE)
	if(!path)
		return FALSE

	var/tree_key = "character_[char_savekey]_[char_id]"
	if(!(tree_key in savefile.get_entry()))
		savefile.set_entry(tree_key, list())

	var/save_data = savefile.get_entry(tree_key)

	//lets write some data that write_preference didnt handle
	save_data["version"] = SAVEFILE_VERSION_MAX //load_character will sanitize any bad data, so assume up-to-date.
	save_data["randomise"] = randomise
	save_data["job_preferences"] = job_preferences
	save_data["all_quirks"] = all_quirks
	save_data["body_markings"] = body_markings

	return TRUE

/datum/preferences/proc/add_character_slot(char_key)
	if(!(char_key in GLOB.valid_char_savekeys))
		return FALSE

	if(used_slot_amount[char_key] >= (char_key == "main" ? max_save_slots : max_ghost_role_slots))
		return FALSE

	save_character(++used_slot_amount[char_key], char_key) //init new char slot
	load_character(used_slot_amount[char_key], char_key)
	randomise_appearance_prefs() //randomize

	return TRUE

/datum/preferences/proc/sanitize_be_special(list/input_be_special)
	var/list/output = list()

	for (var/role in input_be_special)
		if (role in GLOB.special_roles)
			output += role

	return output.len == input_be_special.len ? input_be_special : output

/proc/sanitize_keybindings(value)
	var/list/base_bindings = sanitize_islist(value,list())
	for(var/keybind_name in base_bindings)
		if (!(keybind_name in GLOB.keybindings_by_name))
			base_bindings -= keybind_name
	return base_bindings

#undef SAVEFILE_VERSION_MAX
#undef SAVEFILE_VERSION_MIN

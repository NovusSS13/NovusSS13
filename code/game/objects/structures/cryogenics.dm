
// Cryopods themselves.
/obj/machinery/cryopod
	name = "cryogenic freezer"
	desc = "Suited for Cyborgs and Humanoids, the pod is a safe place for personnel affected by the Space Sleep Disorder to get some rest."
	icon = 'icons/obj/structures/cryogenics.dmi'
	icon_state = "cryopod-open"
	base_icon_state = "cryopod"
	use_power = IDLE_POWER_USE
	power_channel = AREA_USAGE_ENVIRON
	density = TRUE
	anchored = TRUE
	state_open = TRUE
	vis_flags = NONE

	/// if false, plays announcement on cryo
	var/quiet = FALSE
	/// Has the occupant been tucked in?
	var/tucked = FALSE
	/// Set to true if someone leaves the game while inside the pod. Skips the "hasn't rejoined in x" time checks.
	var/skip_ssd_check = FALSE

	/// The linked cryopod console weakref. On compile-time it's the string ID of the console to locate - leave as null to pull from the current area.
	var/datum/weakref/linked_console = null
	/// stupid shit because mutapps break
	var/atom/movable/visual/cryopod_occupant/vis_obj = TRUE
	/// The linked "go cryo" action.
	var/datum/action/cryopod/pod_action

/obj/machinery/cryopod/Initialize(mapload)
	. = ..()
	pod_action = new
	if(vis_obj)
		vis_obj = new(null, src)
		vis_contents += vis_obj

	return INITIALIZE_HINT_LATELOAD

/obj/machinery/cryopod/LateInitialize()
	. = ..()
	if(istype(linked_console)) //not interested in skeerats breaking shit out of stupidity
		return

	var/area/area_loc = get_area(src)
	var/console_id = linked_console

	if(isnull(console_id))
		//we don't actually care if there's no console if linked_console == null
		for(var/obj/machinery/computer/cryopod/console as anything in GLOB.cryopod_consoles)
			if(get_area(console) != area_loc)
				continue

			linked_console = WEAKREF(console)
			break
		return

	for(var/obj/machinery/computer/cryopod/console as anything in GLOB.cryopod_consoles)
		if(console.console_id == console_id)
			linked_console = WEAKREF(console)
			break

	//different case when it's not however, as that implies a mapping fuckup
	if(console_id && !istype(linked_console))
		stack_trace("Cryopod with a non-null console id ([console_id]) couldn't find a console to link with!")


/obj/machinery/cryopod/Destroy()
	QDEL_NULL(pod_action)
	linked_console = null

	return ..()

/obj/machinery/cryopod/attack_hand_secondary(mob/living/user, list/modifiers)
	if(user == src.occupant || !GLOB.default_state.can_use_topic(src, user))
		return ..()

	var/mob/living/occupant = src.occupant
	if(!istype(occupant))
		to_chat(user, span_warning("There's no one inside to cryo!"))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(occupant.client)
		to_chat(user, span_warning("\The [src] beeps: \"Error: User is concious. External cryosleep request denied."))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(occupant.mind)
		if(!skip_ssd_check && occupant.mind.last_client_time - world.time <= 30 MINUTES)
			to_chat(user, span_warning("\The [src] beeps: \"Error: User has not yet entered the REM stage of SSD. Try again later."))
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	var/input = tgui_alert(user, "Are you sure you want to put the occupant into cryogenic sleep?", "Send Cryo?", list("Yes", "No"))
	if(input != "Yes")
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	go_cryo(occupant)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/cryopod/update_appearance(updates)
	. = ..()
	if(state_open)
		vis_contents -= vis_obj
	else
		vis_contents |= vis_obj

/obj/machinery/cryopod/update_icon_state()
	icon_state = base_icon_state
	if(state_open)
		icon_state += "-open"
	return ..()

/obj/machinery/cryopod/update_overlays()
	. = ..()
	if(state_open || !occupant || !initial(vis_obj))
		return

	. += mutable_appearance(icon, "[base_icon_state]-lid", ABOVE_ALL_MOB_LAYER, src, plane = ABOVE_GAME_PLANE, alpha = 128)

/obj/machinery/cryopod/open_machine(drop = TRUE, density_to_set = TRUE)
	if(state_open)
		return

	if(occupant)
		pod_action.Remove(occupant)
		UnregisterSignal(occupant, list(COMSIG_MOB_LOGOUT, COMSIG_MOB_LOGIN))

	tucked = FALSE
	skip_ssd_check = FALSE
	return ..()

/obj/machinery/cryopod/close_machine(atom/movable/target, density_to_set = TRUE)
	if(!state_open || panel_open)
		return
	..(target, TRUE)
	if(isnull(target))
		return

	to_chat(occupant, span_boldnotice("You feel cool air surround you. You go numb as your senses turn inward."))
	RegisterSignal(occupant, COMSIG_MOB_LOGIN, PROC_REF(on_login))
	RegisterSignal(occupant, COMSIG_MOB_LOGOUT, PROC_REF(on_logout))
	pod_action.Grant(occupant)

/obj/machinery/cryopod/proc/on_login(mob/source)
	skip_ssd_check = FALSE

/obj/machinery/cryopod/proc/on_logout(mob/source)
	skip_ssd_check = TRUE


#define AHELP_MSG "Make sure to adminhelp before you do so (even if there are no admins online)!"
/obj/machinery/cryopod/proc/attempt_cryo(mob/living/user)
	var/datum/ui_state/used_ui_state = GLOB.contained_state
	if(used_ui_state.can_use_topic(src, user) < UI_INTERACTIVE)
		return FALSE

	var/message = "Are you sure you want to enter cryogenic storage?"
	var/unsafe_antag = FALSE
	for(var/datum/antagonist/antag_datum as anything in user.mind?.antag_datums)
		if(antag_datum.antag_flags & FLAG_ANTAG_SAFE_TO_CRYO)
			continue

		unsafe_antag = TRUE
		break


	if(unsafe_antag)
		message += "\n\n(You are an antagonist! [AHELP_MSG])"
	else //we dont need to spam them twice
		var/datum/job/occupant_job = SSjob.GetJob(user.job)
		if(occupant_job.req_admin_notify)
			message += "\n\n(You are playing an important job! [AHELP_MSG])"

	var/input = tgui_alert(user, message, "Cryo Storage", list("Yes", "No"), ui_state = GLOB.contained_state, ui_host = src)
	if(input != "Yes")
		return FALSE

	go_cryo(occupant)
#undef AHELP_MSG //thanks, bug id 2072419

/obj/machinery/cryopod/proc/go_cryo(mob/living/occupant)
	SSjob.FreeRole(occupant.job)

	//SEND_SIGNAL(occupant, COMSIG_MOB_ON_CRYO, src) //so uh, apparently /objective code sucks?
	for(var/datum/objective/objective as anything in GLOB.objectives) //so instead of hooks we do this shitmafuck
		if(objective.target != occupant.mind)
			continue

		if(istype(objective,/datum/objective/mutiny))
			objective.team.objectives -= objective
			qdel(objective)
			for(var/datum/mind/mind in objective.team.members)
				to_chat(mind.current, "<BR>[span_userdanger("Your target is no longer within reach. Objective removed!")]")
				mind.announce_objectives()
//		else if(istype(objective, /datum/objective/contract))
//			pass()
		else
			objective.find_target(blacklist = list(occupant))
			objective.update_explanation_text()
			for(var/datum/mind/objective_owner as anything in objective.get_owners())
				to_chat(objective_owner.current, span_userdanger("\nYou get the feeling your target is no longer within reach. Time for Plan [pick("A","B","C","D","X","Y","Z")]. Objectives updated!"))
				objective_owner.announce_objectives()


	var/obj/machinery/computer/cryopod/cryopod_console = linked_console.resolve()
	for(var/obj/item/item in occupant.contents)
		if(HAS_TRAIT(item, TRAIT_NODROP)) //cant drop
			continue
		if(issilicon(occupant) && istype(item, /obj/item/mmi))
			continue
		if(isnull(cryopod_console))
			occupant.transferItemToLoc(item, drop_location(), force = TRUE, silent = TRUE)
			continue

		//pdas need special handling
		if(istype(item, /obj/item/modular_computer))
			var/obj/item/modular_computer/computer = item
			for(var/datum/computer_file/program/messenger/message_app in computer.stored_files)
				message_app.invisible = TRUE

		occupant.transferItemToLoc(item, cryopod_console, force = TRUE, silent = TRUE)
		cryopod_console.stored_items += item
		continue

	var/announced_rank = null
	for(var/datum/record/crew/possible_target_record as anything in GLOB.manifest.general)
		if(possible_target_record.name != occupant.real_name || possible_target_record.trim != occupant.mind?.assigned_role.title)
			continue

		announced_rank = possible_target_record.rank
		qdel(possible_target_record)
		break

	visible_message(span_notice("[src] hums and hisses as it moves [occupant.real_name] into storage."))
	if(cryopod_console)
		cryopod_console.frozen_crew[occupant.real_name] = announced_rank
		if(!quiet)
			cryopod_console.announce_cryo(occupant, announced_rank)

	occupant.ghostize(FALSE) //we don't *have* to do this but it throws a runtime if we don't
	qdel(occupant)
	update_appearance()


/obj/machinery/cryopod/MouseDrop_T(atom/dropping, mob/living/user)
	if(HAS_TRAIT(user, TRAIT_UI_BLOCKED) || !iscarbon(dropping) || !Adjacent(user) || !user.Adjacent(dropping) || !ISADVANCEDTOOLUSER(user))
		return

	if(!do_after(user, 0.5 SECONDS, src))
		return

	close_machine(dropping)

/obj/machinery/cryopod/container_resist_act(mob/living/user)
	visible_message(
		span_notice("[occupant] emerges from [src]!"),
		span_notice("You climb out of [src]!")
	)
	open_machine()

/obj/machinery/cryopod/relaymove(mob/user)
	container_resist_act(user)



/obj/machinery/computer/cryopod
	name = "cryogenic oversight console"
	desc = "An interface between crew and the cryogenic storage oversight systems."
	icon = 'icons/obj/structures/cryogenics.dmi'
	icon_state = "cellconsole_1"
	base_icon_state = "cellconsole"
	icon_keyboard = null
	icon_screen = null
	use_power = IDLE_POWER_USE
	density = FALSE
	req_one_access = list(ACCESS_COMMAND, ACCESS_ARMORY) // Heads of staff or the warden can go here to claim recover items from their department that people went were cryodormed with.
	verb_say = "coldly states"
	verb_ask = "queries"
	verb_exclaim = "alarms"

	/// Used for logging people entering cryosleep and important items they are carrying. Structure: list(name:rank)
	var/list/frozen_crew = list()
	/// The items currently stored in the cryopod control panel.
	var/list/stored_items = list()

	/// Console ID for the cryopods to link with. Set in map editors. Only matters on mapload.
	var/console_id = null

	/// This is what the announcement system uses to make announcements. Make sure to set a radio that has the channel you want to broadcast on.
	var/obj/item/radio/headset/radio = /obj/item/radio/headset/silicon/pai
	/// The channel to be broadcast on, valid values are the values of any of the "RADIO_CHANNEL_" defines.
	var/announcement_channel = null // RADIO_CHANNEL_COMMON doesn't work here.

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/computer/cryopod, 32)

/obj/machinery/computer/cryopod/Initialize(mapload)
	. = ..()
	radio = new radio(src)
	GLOB.cryopod_consoles += src

/obj/machinery/computer/cryopod/Destroy()
	QDEL_NULL(radio)
	GLOB.cryopod_consoles -= src
	return ..()

/obj/machinery/computer/cryopod/update_icon_state()
	icon_state = base_icon_state
	if(!(machine_stat & (NOPOWER|BROKEN)))
		icon_state += "_1"
	return ..()

/obj/machinery/computer/cryopod/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	if(machine_stat & (NOPOWER|BROKEN))
		return

	add_fingerprint(user)

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CryopodConsole", name)
		ui.open()

/obj/machinery/computer/cryopod/ui_data(mob/user)
	var/list/data = list()
	for(var/name in frozen_crew)
		LAZYADD(data["frozen_crew"], list(list(
			"name" = name,
			"rank" = frozen_crew[name]
		)))

	for(var/obj/item/item as anything in stored_items)
		LAZYADDASSOC(data["item_refs"], REF(item), item.name)

	// Check Access for item dropping.
	data["item_retrieval_allowed"] = allowed(user)

	if(isliving(user))
		var/mob/living/card_owner = user
		var/obj/item/card/id/id_card = card_owner.get_idcard()
		data["account_name"] = id_card?.registered_name

	return data

/obj/machinery/computer/cryopod/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	switch(action)
		if("get_item")
			var/obj/item/item = locate(params["item_ref"]) in contents
			if(!item)
				return FALSE

			item.forceMove(drop_location())
			visible_message("[src] dispenses \the [item].")
			return TRUE


/obj/machinery/computer/cryopod/proc/announce_cryo(mob/living/occupant, occupant_rank)
	ASSERT(istype(occupant))

	var/occupant_name = occupant.real_name
	radio.talk_into(src, "[occupant_name][occupant_rank ? ", [occupant_rank]" : ""] has been moved into cryo storage.", announcement_channel)


/// This is a visual helper that shows the occupant inside the cryo cell.
/atom/movable/visual/cryopod_occupant
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	appearance_flags = KEEP_TOGETHER
	/// The current occupant being presented
	var/mob/living/occupant

/atom/movable/visual/cryopod_occupant/Initialize(mapload, obj/machinery/cryopod/parent)
	. = ..()
	RegisterSignal(parent, COMSIG_MACHINERY_SET_OCCUPANT, PROC_REF(on_set_occupant))
	RegisterSignal(parent, COMSIG_ATOM_DIR_CHANGE, PROC_REF(on_dir_change))
	on_dir_change(parent) //lol

/atom/movable/visual/cryopod_occupant/proc/on_set_occupant(obj/machinery/source, mob/living/new_occupant)
	SIGNAL_HANDLER

	if(occupant)
		vis_contents -= occupant
		occupant.vis_flags &= ~VIS_INHERIT_PLANE
		occupant.remove_traits(list(TRAIT_FORCED_STANDING), CRYO_TRAIT)

	occupant = new_occupant
	if(!occupant)
		return

	occupant.setDir(SOUTH)
	occupant.vis_flags |= VIS_INHERIT_PLANE // We want to pull our occupant up to our plane so we look right
	vis_contents += occupant

	// Keep them standing! They'll go sideways in the tube when they fall asleep otherwise.
	occupant.add_traits(list(TRAIT_FORCED_STANDING), CRYO_TRAIT)

/atom/movable/visual/cryopod_occupant/proc/on_dir_change(obj/machinery/source)
	SIGNAL_HANDLER

	dir = source.dir

	var/matrix/new_transform = new //reset it
	new_transform = new_transform.Turn(dir2angle(REVERSE_DIR(source.dir))) //orient with the pod
	if(source.dir == WEST || source.dir == EAST)
		new_transform = new_transform.Translate(0, -2) //move it a bit downwards

	transform = new_transform
	add_filter("cryopod_alpha", 1, alpha_mask_filter(icon = icon(source.icon, "[source.base_icon_state]-lid", source.dir)))

/datum/action/cryopod
	name = "Go Cryo"
	desc = "Go into cryogenic storage, removing you from the round."
	button_icon = 'icons/obj/structures/cryogenics.dmi'
	button_icon_state = "cryopod"
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_INCAPACITATED

/datum/action/cryopod/Trigger(trigger_flags)
	. = ..()
	if(!.)
		return FALSE

	var/obj/machinery/cryopod/used_pod = owner.loc
	if(!istype(used_pod))
		return FALSE

	return used_pod.attempt_cryo(owner)


/obj/machinery/cryopod/quiet
	quiet = TRUE


/// Special wall mounted cryopod for the prison, making it easier to autospawn.
/obj/machinery/cryopod/prison
	icon_state = "prisonpod"
	base_icon_state = "prisonpod"
	density = FALSE
	vis_obj = FALSE

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/cryopod/prison, 18)

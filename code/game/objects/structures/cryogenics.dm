
// Cryopods themselves.
/obj/machinery/cryopod
	name = "cryogenic freezer"
	desc = "Suited for Cyborgs and Humanoids, the pod is a safe place for personnel affected by the Space Sleep Disorder to get some rest."
	icon = 'icons/obj/structures/cryogenics.dmi'
	icon_state = "cryopod-open"
	base_icon_state = "cryopod"
	use_power = FALSE
	density = TRUE
	anchored = TRUE
	state_open = TRUE

	/// if false, plays announcement on cryo
	var/quiet = FALSE
	/// Has the occupant been tucked in?
	var/tucked = FALSE
	/// The linked cryopod console weakref. On compile-time it's the string ID of the console to locate - leave as null to pull from the current area.
	var/datum/weakref/linked_console = null
	/// The linked "go cryo" action.
	var/datum/action/cryopod/pod_action

/obj/machinery/cryopod/Initialize(mapload)
	. = ..()
	pod_action = new

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
	return ..()

/obj/machinery/cryopod/update_icon_state()
	icon_state = base_icon_state
	if(state_open)
		icon_state += "-open"
	return ..()

/obj/machinery/cryopod/update_overlays()
	. = ..()
	if(state_open)
		return

	var/mutable_appearance/occupant_overlay = get_occupant_overlay()
	if(!occupant_overlay)
		return

	. += occupant_overlay //first the guy
	. += mutable_appearance(icon, "[base_icon_state]-base") //then the base, so the edges are obscured
	. += mutable_appearance(icon, "[base_icon_state]-lid", alpha = 128) //then the glass.

/obj/machinery/cryopod/proc/get_occupant_overlay()
	if(!occupant)
		return null //nothing to do

	var/mutable_appearance/mob_appearance = new /mutable_appearance(occupant)
	if(dir == NORTH)
		mob_appearance.dir = SOUTH //laying on your face looks like ass
	else
		mob_appearance.dir = src.dir

	var/matrix/mob_transform = new
	mob_transform = mob_transform.Turn(dir2angle(src.dir)) //make us oriented with the pod
	mob_transform = mob_transform.Scale(occupant.body_size / 100)
	mob_transform = mob_transform.Translate(0, -8)
	mob_transform.add_filter("cryopod_anticlip", 1, alpha_mask_filter(icon = icon(icon, icon_state), flags = MASK_INVERSE))

	mob_appearance.transform = mob_transform

	return mob_appearance


/obj/machinery/cryopod/open_machine(drop = TRUE, density_to_set = TRUE)
	if(state_open)
		return

	if(occupant)
		pod_action.Remove(occupant)

	tucked = FALSE
	return ..()

/obj/machinery/cryopod/close_machine(atom/movable/target, density_to_set = TRUE)
	if(!state_open || panel_open)
		return
	..(target, TRUE)
	if(isnull(target))
		return

	to_chat(occupant, span_boldnotice("You feel cool air surround you. You go numb as your senses turn inward."))
	pod_action.Grant(occupant)


#define AHELP_MSG "Make sure to adminhelp before you do so (even if there are no admins online)!"
/obj/machinery/cryopod/proc/attempt_cryo(mob/living/user)
	var/datum/ui_state/used_ui_state = GLOB.contained_state
	if(used_ui_state.can_use_topic(src, user))
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
		continue

	var/announced_rank = null
	for(var/datum/record/crew/possible_target_record as anything in GLOB.manifest.general)
		if(possible_target_record.name != occupant.real_name || possible_target_record.trim != occupant.mind?.assigned_role.title)
			continue

		announced_rank = possible_target_record.rank
		qdel(possible_target_record)
		break

	visible_message(span_notice("[src] hums and hisses as it moves [occupant.real_name] into storage."))
	if(!quiet)
		cryopod_console?.announce_cryo(occupant, announced_rank)

	qdel(occupant)
	update_appearance()

/obj/machinery/cryopod/MouseDrop_T(atom/dropping, mob/living/user)
	if(HAS_TRAIT(user, TRAIT_UI_BLOCKED) || !Adjacent(user) || !user.Adjacent(target) || !iscarbon(target) || !ISADVANCEDTOOLUSER(user))
		return
	close_machine(target)


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
	use_power = FALSE
	density = FALSE
	interaction_flags_machine = INTERACT_MACHINE_OFFLINE
	req_one_access = list(ACCESS_COMMAND, ACCESS_ARMORY) // Heads of staff or the warden can go here to claim recover items from their department that people went were cryodormed with.
	verb_say = "coldly states"
	verb_ask = "queries"
	verb_exclaim = "alarms"

/*
	/// Used for logging people entering cryosleep and important items they are carrying.
	var/list/frozen_crew = list()
	/// The items currently stored in the cryopod control panel.
	var/list/frozen_item = list()
*/
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
	data["frozen_crew"] = contents //= frozen_crew

	data["item_names"] = list()
	data["item_refs"] = list()
	for(var/obj/item/item in contents)
		var/ref = REF(item)
		data["item_names"] = item.name
		data["item_refs"] += ref

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
	radio.talk_into(src, "[occupant_name][occupant_rank ? ", [occupant_rank]" : ""] has woken up from cryo storage.", announcement_channel)


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

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/cryopod/prison, 18)

/obj/machinery/cryopod/prison/get_occupant_overlay()
	return null //we dont use these

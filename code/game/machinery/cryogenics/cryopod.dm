// Cryopods themselves.
/obj/machinery/cryopod
	name = "cryogenic freezer"
	desc = "Suited for Cyborgs and Humanoids, the pod is a safe place for personnel affected by the Space Sleep Disorder to get some rest."
	icon = 'icons/obj/machines/cryogenics.dmi'
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
	var/obj/effect/overlay/vis/cryopod_occupant/occupant_vis = /obj/effect/overlay/vis/cryopod_occupant
	/// The linked "go cryo" action.
	var/datum/action/cryopod/pod_action

/obj/machinery/cryopod/Initialize(mapload)
	. = ..()
	pod_action = new
	if(ispath(occupant_vis))
		occupant_vis = new occupant_vis(null, src)
		vis_contents += occupant_vis

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
	QDEL_NULL(occupant_vis)
	linked_console = null

	return ..()

/obj/machinery/cryopod/attack_hand_secondary(mob/living/user, list/modifiers)
	if((user == src.occupant) || !can_interact(user))
		return ..()

	var/mob/living/occupant = src.occupant
	if(!istype(occupant))
		to_chat(user, span_warning("There's no one inside to cryo!"))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(occupant.client)
		say("Error: User is conscious. External cryosleep request denied.")
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(occupant.mind)
		if(!skip_ssd_check && occupant.mind.last_client_time - world.time <= 30 MINUTES)
			say("Error: User has not yet entered the REM stage of SSD. Try again later.")
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	var/input = tgui_alert(user, "Are you sure you want to put the occupant into cryogenic sleep?", "Send to cryo", list("Yes", "No"))
	if((input != "Yes") || !can_interact(user))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	go_cryo(occupant)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/cryopod/update_appearance(updates)
	. = ..()
	if(state_open)
		vis_contents -= occupant_vis
	else
		vis_contents |= occupant_vis

/obj/machinery/cryopod/update_icon_state()
	. = ..()
	icon_state = base_icon_state
	if(state_open)
		icon_state += "-open"

/obj/machinery/cryopod/update_overlays()
	. = ..()
	if(state_open || !occupant || !initial(occupant_vis))
		return

	// layer needs to be explicitly above us, so it overlays above the occupant overlay
	. += mutable_appearance(icon, "[base_icon_state]-lid", layer = src.layer+0.01, alpha = 128)

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
	. = ..(target, TRUE)
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
		message += "\n\n(You are an antagonist!)"
	else //we dont need to spam them twice
		var/datum/job/occupant_job = SSjob.GetJob(user.job)
		if(occupant_job.req_admin_notify)
			message += "\n\n(You are playing an important job!)"

	var/input = tgui_alert(user, message, "Cryo Storage", list("Yes", "No"), ui_state = GLOB.contained_state, ui_host = src)
	if((input != "Yes") || !can_interact(user))
		return FALSE

	go_cryo(occupant)

/obj/machinery/cryopod/proc/go_cryo(mob/living/occupant)
	SSjob.FreeRole(occupant.job)

	//SEND_SIGNAL(occupant, COMSIG_MOB_ON_CRYO, src) //so uh, apparently /objective code sucks?
	var/datum/mind/occupant_mind = occupant.mind
	if(occupant_mind)
		for(var/datum/objective/objective as anything in GLOB.objectives) //so instead of hooks we do this shitmafuck
			if(objective.target != occupant_mind)
				continue

			if(istype(objective,/datum/objective/mutiny))
				objective.team.objectives -= objective
				qdel(objective)
				for(var/datum/mind/mind in objective.team.members)
					to_chat(mind.current, span_userdanger("[occupant_mind.name] is no longer within reach. [objective.objective_name] removed!"))
					mind.announce_objectives()
			else
				objective.find_target(blacklist = list(occupant))
				objective.update_explanation_text()
				objective.current_plan++
				var/static/list/plan_codes = list(
					"A",
					"B",
					"C",
					"D",
					"E",
					"F",
					"X",
					"Y",
					"Z",
					"\"Consider giving up\"",
				)
				var/plan_code = plan_codes[min(objective.current_plan, length(plan_codes))]
				for(var/datum/mind/objective_owner as anything in objective.get_owners())
					to_chat(objective_owner.current, span_userdanger("You get the feeling [occupant_mind.name] is no longer within reach. Time for plan [plan_code]. [objective.objective_name] updated!"))
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
	if(HAS_TRAIT(user, TRAIT_UI_BLOCKED) || !can_interact(user) || !iscarbon(dropping) || !Adjacent(user) || !user.Adjacent(dropping) || !ISADVANCEDTOOLUSER(user))
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

/// This is a visual helper that shows the occupant inside the cryopod
/obj/effect/overlay/vis/cryopod_occupant
	appearance_flags = KEEP_TOGETHER|TILE_BOUND|PIXEL_SCALE|LONG_GLIDE
	vis_flags = VIS_INHERIT_ID | VIS_INHERIT_PLANE | VIS_INHERIT_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	/// The cryopod that owns us
	var/obj/machinery/cryopod/owner
	/// The current occupant being presented
	var/mob/living/occupant

/obj/effect/overlay/vis/cryopod_occupant/Initialize(mapload, obj/machinery/cryopod/parent)
	. = ..()
	if(!parent)
		stack_trace("[type] initialized without a cryopod parent!")
		return INITIALIZE_HINT_QDEL
	src.owner = parent
	RegisterSignal(parent, COMSIG_MACHINERY_SET_OCCUPANT, PROC_REF(on_set_occupant))
	RegisterSignal(parent, COMSIG_ATOM_DIR_CHANGE, PROC_REF(on_dir_change))
	on_dir_change(parent, parent.dir, parent.dir) //lol
	if(parent.occupant)
		on_set_occupant(parent, parent.occupant)

/obj/effect/overlay/vis/cryopod_occupant/Destroy(force)
	. = ..()
	owner = null
	occupant = null

/obj/effect/overlay/vis/cryopod_occupant/update_overlays()
	. = ..()
	if(!occupant)
		return

	var/mutable_appearance/occupant_overlay = new(occupant)
	occupant_overlay.plane = FLOAT_PLANE
	occupant_overlay.layer = FLOAT_LAYER

	var/matrix/new_transform = new //reset it
	new_transform = new_transform.Turn(dir2angle(REVERSE_DIR(owner.dir))) //orient with the pod
	if(owner.dir == WEST || owner.dir == EAST)
		new_transform = new_transform.Translate(0, -2) //move it a bit downwards
	if(ishuman(occupant))
		var/mob/living/carbon/human/human_occupant = occupant
		new_transform *= (human_occupant.body_size/100)
	occupant_overlay.transform = new_transform

	. += occupant_overlay

/obj/effect/overlay/vis/cryopod_occupant/setDir(newdir)
	. = ..()
	//not really necessary, but the occupant should face the same dir as us for consistency
	if(occupant)
		occupant.setDir(newdir)
	update_appearance(UPDATE_ICON)

/obj/effect/overlay/vis/cryopod_occupant/proc/on_set_occupant(obj/machinery/source, mob/living/new_occupant)
	SIGNAL_HANDLER

	if(occupant)
		occupant.remove_traits(list(TRAIT_FORCED_STANDING), CRYO_TRAIT)

	occupant = new_occupant
	if(!occupant)
		update_appearance(UPDATE_ICON)
		return

	if(owner.dir == NORTH || owner.dir == SOUTH)
		occupant.setDir(SOUTH)
	else
		occupant.setDir(owner.dir)

	// Keep them standing! They'll go sideways in the pod when they fall asleep otherwise.
	occupant.add_traits(list(TRAIT_FORCED_STANDING), CRYO_TRAIT)
	update_appearance(UPDATE_ICON)

/obj/effect/overlay/vis/cryopod_occupant/proc/on_dir_change(obj/machinery/source, olddir, newdir)
	SIGNAL_HANDLER

	add_filter("cryopod_mask", 1, alpha_mask_filter(icon = icon(source.icon, "[source.base_icon_state]-lid", dir = source.dir)))
	if(owner.dir == NORTH || owner.dir == SOUTH)
		setDir(SOUTH)
	else
		setDir(owner.dir)

/datum/action/cryopod
	name = "Go Cryo"
	desc = "Go into cryogenic storage, removing you from the round."
	button_icon = 'icons/obj/machines/cryogenics.dmi'
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
	occupant_vis = null

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/cryopod/prison, 18)

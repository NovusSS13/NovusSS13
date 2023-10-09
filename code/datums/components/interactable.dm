//Add this component to an atom to make them sexable, basically
/datum/component/interactable
	/// Cooldown until we can do another interaction with INTERACTION_RESPECT_COOLDOWN
	COOLDOWN_DECLARE(next_interaction)
	/// Cooldown until we can do another interaction with INTERACTION_RESPECT_SEX_COOLDOWN
	COOLDOWN_DECLARE(next_sexual_interaction)
	/// Does not need to be a weakref since interaction datums are singletons
	var/datum/interaction/last_interaction_as_user
	/// Last world.time we did an interaction
	var/last_interaction_as_user_time = 0
	/// Used to clear var/last_interaction_as_user, important for rendering appropriate messages
	var/clear_user_interaction_timer
	/// Does not need to be a weakref since interaction datums are singletons
	var/datum/interaction/last_interaction_as_target
	/// Last world.time we received an interaction
	var/last_interaction_as_target_time = 0
	/// Used to clear var/last_interaction_as_target, important for rendering appropriate messages
	var/clear_target_interaction_timer

	/// Last interaction target, for use with repeat_last_action
	var/datum/weakref/last_interaction_target
	/// Time to wait before repeating our last action as user, null if we don't want to repeats
	var/repeat_last_action

/datum/component/interactable/Initialize()
	if(!isatom(parent) || isarea(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/interactable/RegisterWithParent()
	ADD_TRAIT(parent, TRAIT_INTERACTABLE, "[type]")
	RegisterSignal(parent, COMSIG_MOUSEDROP_ONTO, PROC_REF(mousedrop_onto))
	RegisterSignal(parent, COMSIG_INTERACTABLE_TRY_INTERACT, PROC_REF(try_interact))

/datum/component/interactable/UnregisterFromParent()
	REMOVE_TRAIT(parent, TRAIT_INTERACTABLE, "[type]")
	UnregisterSignal(parent, COMSIG_MOUSEDROP_ONTO)
	UnregisterSignal(parent, COMSIG_INTERACTABLE_TRY_INTERACT)

/datum/component/interactable/Destroy(force, silent)
	. = ..()
	last_interaction_as_user = null
	last_interaction_as_target = null
	if(clear_user_interaction_timer)
		deltimer(clear_user_interaction_timer)
		clear_user_interaction_timer = null
	if(clear_target_interaction_timer)
		deltimer(clear_target_interaction_timer)
		clear_target_interaction_timer = null
	last_interaction_target = null
	repeat_last_action = null

/datum/component/interactable/process(seconds_per_tick)
	var/datum/component/interactable/target = last_interaction_target?.resolve()
	if(!target)
		last_interaction_target = null
		repeat_last_action = null
		return PROCESS_KILL
	else if(!repeat_last_action)
		return PROCESS_KILL
	if(last_interaction_as_user_time + repeat_last_action < world.time)
		return
	if(last_interaction_as_user.allow_interaction(src, target, silent = TRUE, check_cooldown = TRUE) && last_interaction_as_user.do_interaction(src, target))
		last_interaction_as_user.after_interaction(src, target)

/datum/component/interactable/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "InteractionMenu")
		ui.set_autoupdate(TRUE)
		ui.open()

/datum/component/interactable/ui_status(mob/user, datum/ui_state/state)
	var/atom/atom_parent = parent
	if(get_dist(user, atom_parent) > DEFAULT_MESSAGE_RANGE)
		return UI_CLOSE
	return min(ui_status_only_living(user, atom_parent), ui_status_user_is_abled(user, atom_parent))

/datum/component/interactable/ui_data(mob/user)
	var/list/data = list()

	var/atom/target = parent
	var/datum/component/interactable/user_interactable = user.GetComponent(/datum/component/interactable)

	data["target_name"] = target.name
	var/list/categories = list()
	for(var/category in GLOB.interactions_by_category)
		var/list/this_category = list()

		this_category["name"] = category

		var/list/this_category_interactions = list()
		for(var/path in GLOB.interactions_by_category[category])
			var/datum/interaction/interaction = GLOB.interactions_by_category[category][path]
			//we want to display interactions that are on cooldown, still
			if(!interaction.allow_interaction(user_interactable, src, silent = TRUE, check_cooldown = FALSE))
				continue

			var/list/this_interaction = list()
			this_interaction["name"] = interaction.name
			this_interaction["desc"] = interaction.desc
			this_interaction["icon"] = interaction.icon
			this_interaction["path"] = interaction.type
			this_interaction["minimum_repeat_time"] = interaction.minimum_repeat_time
			this_interaction["maximum_repeat_time"] = interaction.maximum_repeat_time
			//NOW we check the cooldown
			this_interaction["block_interact"] = !interaction.allow_interaction(user_interactable, src, silent = TRUE, check_cooldown = TRUE)

			this_category_interactions += list(this_interaction)

		this_category["interactions"] = this_category_interactions

		if(length(this_category_interactions))
			categories += list(this_category)

	data["categories"] = categories
	if(user_interactable.repeat_last_action)
		if(user_interactable.last_interaction_as_user)
			var/datum/interaction/interaction = user_interactable.last_interaction_as_user

			var/list/this_interaction = list()

			this_interaction["name"] = interaction.name
			this_interaction["desc"] = interaction.desc
			this_interaction["icon"] = interaction.icon
			this_interaction["path"] = interaction.type
			this_interaction["minimum_repeat_time"] = interaction.minimum_repeat_time
			this_interaction["maximum_repeat_time"] = interaction.maximum_repeat_time
			this_interaction["block_interact"] = !interaction.allow_interaction(user_interactable, src, silent = TRUE, check_cooldown = TRUE)

			data["last_interaction"] = this_interaction
		data["repeat_last_action"] = user_interactable.repeat_last_action

	data["on_cooldown"] = !COOLDOWN_FINISHED(user_interactable, next_interaction)

	return data

/datum/component/interactable/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("interact")
			var/path = params["interaction"]
			var/datum/interaction/interaction = GLOB.interactions[text2path(path)]
			if(!interaction)
				return FALSE
			var/datum/component/interactable/user = usr.GetComponent(/datum/component/interactable)
			if(interaction.allow_interaction(user, src) && interaction.do_interaction(user, src))
				interaction.after_interaction(user, src)
			return TRUE
		if("repeat_last_action")
			var/datum/component/interactable/user = usr.GetComponent(/datum/component/interactable)
			if(user.repeat_last_action)
				STOP_PROCESSING(SSinteractables, user)
				user.repeat_last_action = null
				return TRUE
			if(!user.last_interaction_as_user || !user.last_interaction_as_user.minimum_repeat_time || !user.last_interaction_as_user.maximum_repeat_time)
				return FALSE
			user.repeat_last_action = user.last_interaction_as_user.maximum_repeat_time
			START_PROCESSING(SSinteractables, user)
			return TRUE
		if("set_repeat_last_action")
			var/datum/component/interactable/user = usr.GetComponent(/datum/component/interactable)
			if(!user.last_interaction_as_user || !user.last_interaction_as_user.minimum_repeat_time || !user.last_interaction_as_user.maximum_repeat_time)
				return FALSE
			var/wait = params["wait"]
			if(!wait || (wait == user.repeat_last_action))
				return FALSE
			user.repeat_last_action = clamp(wait, user.last_interaction_as_user.minimum_repeat_time, user.last_interaction_as_user.maximum_repeat_time)
			return TRUE

/datum/component/interactable/ui_close(mob/user)
	. = ..()
	var/datum/component/interactable/user_interactable = user.GetComponent(/datum/component/interactable)
	if(user_interactable)
		STOP_PROCESSING(SSinteractables, src)
		user_interactable.repeat_last_action = null

/datum/component/interactable/proc/mousedrop_onto(atom/dropped_atom, atom/movable/receiver, mob/user, params)
	SIGNAL_HANDLER

	//user is the atom being dropped, as well as the owner of the component
	if((user == parent) && (dropped_atom == parent))
		//(tries to) open up the UI of whoever this is
		if(SEND_SIGNAL(receiver, COMSIG_INTERACTABLE_TRY_INTERACT, user) & COMPONENT_CAN_INTERACT)
			return COMPONENT_NO_MOUSEDROP

/datum/component/interactable/proc/try_interact(atom/source, mob/living/user)
	SIGNAL_HANDLER

	//Should never happen, but to be sure
	if(!HAS_TRAIT(user, TRAIT_INTERACTABLE))
		return

	if(SEND_SIGNAL(src, COMSIG_INTERACTABLE_TRYING_INTERACT, user) & COMPONENT_NO_INTERACT)
		return COMPONENT_NO_INTERACT

	var/mob/living/carbon/human/human_user = user
	//Distance check - yes it's arbitrary
	var/max_distance = 3
	if(istype(human_user) && human_user.dna.check_mutation(/datum/mutation/human/telekinesis))
		max_distance = DEFAULT_MESSAGE_RANGE
	if(get_dist(parent, user) > max_distance)
		return
	INVOKE_ASYNC(src, PROC_REF(ui_interact), user)
	return COMPONENT_CAN_INTERACT

/datum/component/interactable/proc/clear_user_interaction()
	last_interaction_as_user = null
	last_interaction_target = null
	repeat_last_action = null

/datum/component/interactable/proc/clear_target_interaction()
	last_interaction_as_target = null

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

/datum/component/interactable/Initialize()
	if(!isatom(parent) || isarea(parent))
		return COMPONENT_INCOMPATIBLE

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

/datum/component/interactable/RegisterWithParent()
	ADD_TRAIT(parent, TRAIT_INTERACTABLE, "[type]")
	RegisterSignal(parent, COMSIG_MOUSEDROP_ONTO, PROC_REF(mousedrop_onto))
	RegisterSignal(parent, COMSIG_INTERACTABLE_TRY_INTERACT, PROC_REF(try_interact))

/datum/component/interactable/UnregisterFromParent()
	REMOVE_TRAIT(parent, TRAIT_INTERACTABLE, "[type]")
	UnregisterSignal(parent, COMSIG_MOUSEDROP_ONTO)
	UnregisterSignal(parent, COMSIG_INTERACTABLE_TRY_INTERACT)

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
			this_interaction["path"] = interaction.type
			this_interaction["desc"] = interaction.desc
			this_interaction["icon"] = interaction.icon
			//NOW we check the cooldown
			this_interaction["block_interact"] = !interaction.allow_interaction(user_interactable, src, silent = TRUE, check_cooldown = TRUE)

			this_category_interactions += list(this_interaction)

		this_category["interactions"] = this_category_interactions

		if(length(this_category_interactions))
			categories += list(this_category)

	data["categories"] = categories
	return data

/datum/component/interactable/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("interact")
			var/datum/interaction/interaction = GLOB.interactions[params["interaction"]]
			if(!interaction)
				return
			var/datum/component/interactable/user_interactable = usr.GetComponent(/datum/component/interactable)
			if(interaction.allow_interaction(user_interactable, src) && interaction.do_interaction(user_interactable, src))
				interaction.after_interact(user_interactable, src)
			return TRUE

/datum/component/interactable/proc/mousedrop_onto(atom/dropped_atom, atom/movable/receiver, mob/user, params)
	SIGNAL_HANDLER

	//user is the atom being dropped, as well as the owner of the component
	if((user == parent) && (dropped_atom == parent))
		//(tries to) open up the UI of whoever this is
		if(SEND_SIGNAL(receiver, COMSIG_INTERACTABLE_TRY_INTERACT, user) & COMPONENT_CAN_INTERACT)
			return COMPONENT_NO_MOUSEDROP

/datum/component/interactable/proc/try_interact(atom/source, mob/living/user)
	SIGNAL_HANDLER

	if(SEND_SIGNAL(src, COMSIG_INTERACTABLE_TRYING_INTERACT, user) & COMPONENT_NO_INTERACT)
		return COMPONENT_NO_INTERACT

	var/mob/living/carbon/human/human_user = user
	//Distance check, yes it's arbitrary
	var/max_distance = 3
	if(istype(human_user) && human_user.dna.check_mutation(/datum/mutation/human/telekinesis))
		max_distance = DEFAULT_MESSAGE_RANGE
	if(get_dist(parent, user) > max_distance)
		return
	//Should never happen, but to be sure
	if(!HAS_TRAIT(user, TRAIT_INTERACTABLE))
		return
	INVOKE_ASYNC(src, PROC_REF(ui_interact), user)
	return COMPONENT_CAN_INTERACT

/datum/component/interactable/proc/clear_user_interaction()
	last_interaction_as_user = null

/datum/component/interactable/proc/clear_target_interaction()
	last_interaction_as_target = null

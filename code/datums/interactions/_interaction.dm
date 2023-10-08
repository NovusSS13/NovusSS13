/datum/interaction
	/// Name of the interaction, very obvious
	var/name
	/// Description of the interaction, currently a tooltip when hovered over on the interface
	var/desc
	/// Fontawesome icon of the interaction, appears besides the name if there is one
	var/icon

	/// Category of the interaction, please use defines for these
	var/category

	/// Many flags that regulate the behavior of this interaction, such as INTERACTION_SELF, INTERACTION_OTHER
	var/interaction_flags = INTERACTION_RESPECT_COOLDOWN

	/// Message exhibited to bystanders for this interaction, can be a list
	var/message
	/// Message exhibited to the target for this interaction, can be a list
	var/target_message
	/// Message exhibited to the user for this interaction, can be a list
	var/user_message
	/// Message for well, blind bystanders (can also be DEAF message, if this is INTERACTION_AUDIBLE)
	var/blind_message
	/// Range the message gets exhibited for
	var/message_range = DEFAULT_MESSAGE_RANGE

	/// Sounds this interaction can play, simple unweighted list of files or a single sound file
	var/sounds
	/// Volume the sound plays at
	var/sound_volume = 65
	/// Extra range for the sound
	var/sound_extrarange = 0
	/// Whether or not the sound varies
	var/sound_vary = 0

	/// Cooldown applied to the user
	var/user_cooldown_duration = DEFAULT_INTERACTION_COOLDOWN
	/// Cooldown applied to the target
	var/target_cooldown_duraction = DEFAULT_INTERACTION_COOLDOWN

	/// How much time it takes to clear last_interaction_as_user
	var/user_clear_time = 30 SECONDS
	/// How much time it takes to clear last_interaction_as_target
	var/target_clear_time = 30 SECONDS

	/// Arousal applied to the user
	var/arousal_gain_user = AROUSAL_GAIN_NONE
	/// Arousal applied to the target
	var/arousal_gain_target = AROUSAL_GAIN_NONE
	/// Lust applied to the user
	var/lust_gain_user = LUST_GAIN_NONE
	/// Lust applied to the target
	var/lust_gain_target = LUST_GAIN_NONE

	/// Maximum distance this interaction can normally be used at
	var/maximum_distance = 1
	/// Maximum distance this interaction can be used at, with telekinesis
	var/maximum_tk_distance = 7

	/// Number of hands the user must have, not necessarily usable
	var/user_hands_required = 0
	/// Number of hands the target must have, not necessarily usable
	var/target_hands_required = 0

	/// Typecache of user types that can use this interaction
	var/list/user_types_allowed
	/// Typecache of target types that can use this interaction
	var/list/target_types_allowed

/datum/interaction/New()
	. = ..()
	build_user_types_allowed()
	build_target_types_allowed()

/// Overridable proc where you can set up what atoms this interaction can be used by
/datum/interaction/proc/build_user_types_allowed()
	user_types_allowed = typecacheof(/mob/living/carbon/human)

/// Overridable proc where you can set up what atoms this interaction can be used with
/datum/interaction/proc/build_target_types_allowed()
	target_types_allowed = typecacheof(/mob/living/carbon/human)

/datum/interaction/proc/allow_interaction(datum/component/interactable/user, datum/component/interactable/target, silent = TRUE, check_cooldown = TRUE)
	. = FALSE
	if(!user || !target)
		return FALSE
	if((user.parent == target.parent) && !(interaction_flags & INTERACTION_SELF))
		if(!silent)
			to_chat(user.parent, span_warning("You can only do that on other people."))
		return FALSE
	else if((user.parent != target.parent) && !(interaction_flags & INTERACTION_OTHER))
		if(!silent)
			to_chat(user.parent, span_warning("You can only do that to yourself."))
		return FALSE
	if(user != target)
		//Distance checks
		if(!distance_checks(user, target, silent, check_cooldown))
			return FALSE
		//Checks that are target specific
		if(!evaluate_target(user, target, silent, check_cooldown))
			return FALSE
	//Checks that are user specific
	if(!evaluate_user(user, target, silent))
		return FALSE
	return TRUE

/datum/interaction/proc/distance_checks(datum/component/interactable/user, datum/component/interactable/target, silent = TRUE)
	var/atom/atom_target = target.parent
	var/mob/mob_user = user.parent //currently, user must always be a mob... will be changed later if necessary
	var/mob/living/carbon/human/human_user = user.parent
	var/tk_check = istype(human_user) && human_user.dna.check_mutation(/datum/mutation/human/telekinesis) && maximum_tk_distance
	//Adjacency check
	if(!tk_check && (maximum_distance <= 1) && !mob_user.Adjacent(atom_target))
		if(!silent)
			to_chat(mob_user, span_warning("You need physical contact to do this."))
		return FALSE
	//Normal distance check
	else if(!tk_check && maximum_distance && (get_dist(atom_target, mob_user) > maximum_distance))
		if(!silent)
			to_chat(mob_user, span_warning("You need to get closer."))
		return FALSE
	else if(tk_check && (get_dist(atom_target, mob_user) > maximum_tk_distance))
		if(!silent)
			to_chat(mob_user, span_warning("You need to get closer"))
		return FALSE
	return TRUE

/datum/interaction/proc/evaluate_user(datum/component/interactable/user, datum/component/interactable/target, silent = FALSE, check_cooldown = TRUE)
	//Type check
	if(!is_type_in_typecache(user.parent.type, user_types_allowed))
		if(!silent)
			to_chat(user.parent, span_warning("Not possible with you."))
		return FALSE
	//Hand check
	var/mob/living/living_user = user.parent
	if(user_hands_required && (!istype(living_user) || (living_user.num_hands < user_hands_required)))
		if(!silent)
			to_chat(user.parent, span_warning("You don't have enough hands."))
		return FALSE
	//Cooldown checks
	if(check_cooldown)
		if((interaction_flags & INTERACTION_RESPECT_COOLDOWN) && !COOLDOWN_FINISHED(user, next_interaction))
			if(!silent)
				to_chat(user.parent, span_warning("You are on cooldown."))
			return FALSE
		if((interaction_flags & INTERACTION_RESPECT_SEX_COOLDOWN) && !COOLDOWN_FINISHED(user, next_sexual_interaction))
			if(!silent)
				to_chat(user.parent, span_warning("You can't handle any more sex right now."))
			return FALSE
	return TRUE

/datum/interaction/proc/evaluate_target(datum/component/interactable/user, datum/component/interactable/target, silent = FALSE, check_cooldown = TRUE)
	//Type check
	if(!is_type_in_list(target.parent.type, target_types_allowed))
		if(!silent)
			to_chat(user.parent, span_warning("Not possible with them."))
		return FALSE
	//Hand check
	var/mob/living/living_target = target.parent
	if(target_hands_required && !(istype(living_target) || (living_target.num_hands < target_hands_required)))
		if(!silent)
			to_chat(user.parent, span_warning("They don't have enough hands"))
		return FALSE
	//Cooldown checks
	if(check_cooldown)
		if((interaction_flags & INTERACTION_RESPECT_COOLDOWN) && !COOLDOWN_FINISHED(target, next_interaction))
			if(!silent)
				to_chat(target.parent, span_warning("They are on cooldown."))
			return FALSE
		if((interaction_flags & INTERACTION_RESPECT_SEX_COOLDOWN) && !COOLDOWN_FINISHED(target, next_sexual_interaction))
			if(!silent)
				to_chat(target.parent, span_warning("They can't handle any more sex right now."))
			return FALSE
	return TRUE

/datum/interaction/proc/do_interaction(datum/component/interactable/user, datum/component/interactable/target)
	var/mob/mob_user = user.parent
	var/message_index = 0
	if(islist(message))
		message_index = rand(1, length(message))
	var/msg
	if(message)
		if(message_index)
			msg = message[message_index]
		else
			msg = message
		msg = replacetext(msg, "%USER", "<b>[user.parent]</b>")
		msg = replacetext(msg, "%TARGET", "<b>[target.parent]</b>")
	var/target_msg
	if(target_message && ismob(target.parent))
		if(message_index)
			target_msg = target_message[message_index]
		else
			target_msg = target_message
		target_msg = replacetext(target_msg, "%USER", "<b>[user.parent]</b>")
		target_msg = replacetext(target_msg, "%TARGET", "<b>[target.parent]</b>")
	var/user_msg
	if(user_message)
		if(message_index)
			user_msg = user_message[message_index]
		else
			user_msg = user_message
		user_msg = replacetext(user_msg, "%USER", "<b>[user.parent]</b>")
		user_msg = replacetext(user_msg, "%TARGET", "<b>[target.parent]</b>")
	var/blind_msg
	if(blind_message)
		if(message_index)
			blind_msg = blind_message[message_index]
		else
			blind_msg = blind_message
		blind_msg = replacetext(blind_msg, "%USER", "<b>[user.parent]</b>")
		blind_msg = replacetext(blind_msg, "%TARGET", "<b>[target.parent]</b>")
	mob_user.face_atom(target.parent)
	if(interaction_flags & INTERACTION_AUDIBLE)
		//for some dumb reason, audible message does not in fact have an ignored_mobs argument so uh, get fucked?
		mob_user.audible_message(message = msg, \
							self_message = user_msg, \
							deaf_message = blind_msg, \
							hearing_distance = message_range)
	else
		mob_user.visible_message(message = msg, \
					self_message = user_msg, \
					blind_message = blind_msg, \
					vision_distance = message_range,
					ignored_mobs = (target_msg ? target.parent : null))
		if(target_msg)
			to_chat(target.parent, target_msg)
	if(sounds && sound_volume)
		playsound(mob_user, pick(sounds), sound_volume, sound_vary, sound_extrarange)
	return TRUE

/datum/interaction/proc/after_interact(datum/component/interactable/user, datum/component/interactable/target)
	if(user_cooldown_duration)
		COOLDOWN_START(user, next_interaction, user_cooldown_duration)
	if((user != target) && target_cooldown_duraction)
		COOLDOWN_START(target, next_interaction, target_cooldown_duraction)
	user.last_interaction_as_user = src
	user.last_interaction_as_user_time = world.time
	if(user.clear_user_interaction_timer)
		deltimer(user.clear_user_interaction_timer)
		user.clear_user_interaction_timer = null
	if(user_clear_time)
		user.clear_user_interaction_timer = addtimer(CALLBACK(user, TYPE_PROC_REF(/datum/component/interactable, clear_user_interaction), user_clear_time, TIMER_STOPPABLE))
	target.last_interaction_as_target = src
	target.last_interaction_as_target_time = world.time
	if(target.clear_target_interaction_timer)
		deltimer(target.clear_target_interaction_timer)
		target.clear_target_interaction_timer = null
	if(target_clear_time)
		target.clear_target_interaction_timer = addtimer(CALLBACK(user, TYPE_PROC_REF(/datum/component/interactable, clear_user_interaction), target_clear_time, TIMER_STOPPABLE))
	return TRUE


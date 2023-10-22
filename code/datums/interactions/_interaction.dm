/datum/interaction
	/// Name of the interaction, very obvious
	var/name
	/// Description of the interaction, currently a tooltip when hovered over on the UI
	var/desc
	/// Fontawesome icon of the interaction, appears besides the name if there is one
	var/icon
	/// Color for the button on the UI, if any
	var/color

	/// Category of the interaction, please use defines for these
	var/category

	/// Interaction usage flags, AKA whether you can use it on yourself, or others
	var/usage_flags = INTERACTION_OTHER
	/// Many flags that regulate the behavior of this interaction, such as INTERACTION_AUDIBLE and INTERACTION_COOLDOWN
	var/interaction_flags = INTERACTION_COOLDOWN

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
	var/sound_volume = 60
	/// Extra range for the sound
	var/sound_extrarange = 0
	/// Whether or not the sound varies
	var/sound_vary = 0

	/// Cooldown applied to the user
	var/user_cooldown_duration = 0.5 SECONDS
	/// Cooldown applied to the target
	var/target_cooldown_duraction = 0.5 SECONDS

	/// Minimum sex cooldown applied to the user when climaxing
	var/user_climax_cooldown_duration_min = 45 SECONDS
	/// Maximum sex cooldown applied to the user when climaxing
	var/user_climax_cooldown_duration_max = 90 SECONDS
	/// Minimum sex cooldown applied to the target when climaxing
	var/target_climax_cooldown_duration_min = 45 SECONDS
	/// Maximum sex cooldown applied to the target when climaxing
	var/target_climax_cooldown_duration_max = 90 SECONDS

	// When both minimum_repeat_time and maximum_repeat_time are 0, the interaction is not repeatable
	/// Minimum time for repeating this interaction on the interface knob
	var/minimum_repeat_time = 1 SECONDS
	/// Maximum time for repeating this interaction on the interface knob
	var/maximum_repeat_time = 10 SECONDS

	/// How much time it takes to clear last_interaction_as_user
	var/user_clear_time = 30 SECONDS
	/// How much time it takes to clear last_interaction_as_target
	var/target_clear_time = 30 SECONDS

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
	var/list/user_types_allowed = list(/mob/living/carbon/human)
	/// Typecache of target types that can use this interaction
	var/list/target_types_allowed = list(/mob/living/carbon/human)

/datum/interaction/New()
	. = ..()
	user_types_allowed = typecacheof(user_types_allowed)
	target_types_allowed = typecacheof(target_types_allowed)
	if(interaction_flags & INTERACTION_COOLDOWN)
		if(minimum_repeat_time)
			minimum_repeat_time = clamp(minimum_repeat_time, user_cooldown_duration, user_clear_time)
		if(maximum_repeat_time)
			maximum_repeat_time = clamp(maximum_repeat_time, minimum_repeat_time, user_clear_time)

/// Determines whether or not this interaction can be used by the user on the target
/datum/interaction/proc/allow_interaction(datum/component/interactable/user, datum/component/interactable/target, silent = TRUE, check_cooldown = TRUE)
	if(!user || !target)
		return FALSE
	if((user.parent == target.parent) && !(usage_flags & INTERACTION_SELF))
		if(!silent)
			to_chat(user.parent, span_warning("You can only do that to yourself."))
		return FALSE
	else if((user.parent != target.parent) && !(usage_flags & INTERACTION_OTHER))
		if(!silent)
			to_chat(user.parent, span_warning("You can only do that on other people."))
		return FALSE
	if(user != target)
		//Distance checks
		if(!distance_checks(user, target, silent, check_cooldown))
			return FALSE
		//Checks that are target specific
		if(!evaluate_target(user, target, silent, check_cooldown))
			return FALSE
	//Checks that are user specific
	if(!evaluate_user(user, target, silent, check_cooldown))
		return FALSE
	return TRUE

/// Checks if the distance between user and target is valid to perform this interaction
/datum/interaction/proc/distance_checks(datum/component/interactable/user, datum/component/interactable/target, silent = TRUE)
	var/atom/atom_target = target.parent
	var/mob/atom_user = user.parent
	var/mob/living/carbon/human/human_user = user.parent
	var/tk_check = istype(human_user) && human_user.dna.check_mutation(/datum/mutation/human/telekinesis) && maximum_tk_distance
	//Adjacency check
	if(!tk_check && (maximum_distance <= 1) && !atom_user.Adjacent(atom_target))
		if(!silent)
			to_chat(atom_user, span_warning("You need physical contact to do this."))
		return FALSE
	//Normal distance check
	else if(!tk_check && maximum_distance && (get_dist(atom_target, atom_user) > maximum_distance))
		if(!silent)
			to_chat(atom_user, span_warning("You need to get closer."))
		return FALSE
	else if(tk_check && (get_dist(atom_target, atom_user) > maximum_tk_distance))
		if(!silent)
			to_chat(atom_user, span_warning("You need to get closer"))
		return FALSE
	return TRUE

/// Checks if the user can perform this interaction on the target
/datum/interaction/proc/evaluate_user(datum/component/interactable/user, datum/component/interactable/target, silent = FALSE, check_cooldown = TRUE)
	//Type check
	if(!is_type_in_typecache(user.parent, user_types_allowed))
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
		if((interaction_flags & INTERACTION_COOLDOWN) && !COOLDOWN_FINISHED(user, next_interaction))
			if(!silent)
				to_chat(user.parent, span_warning("You are on cooldown."))
			return FALSE
		if((interaction_flags & INTERACTION_SEX_COOLDOWN) && !COOLDOWN_FINISHED(user, next_sexual_interaction))
			if(!silent)
				to_chat(user.parent, span_warning("You can't handle any more sex right now."))
			return FALSE
	return TRUE

/// Checks if the target can have this interaction performed on them
/datum/interaction/proc/evaluate_target(datum/component/interactable/user, datum/component/interactable/target, silent = FALSE, check_cooldown = TRUE)
	//Type check
	if(!is_type_in_typecache(target.parent, target_types_allowed))
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
		if((interaction_flags & INTERACTION_COOLDOWN) && !COOLDOWN_FINISHED(target, next_interaction))
			if(!silent)
				to_chat(target.parent, span_warning("They are on cooldown."))
			return FALSE
		if((interaction_flags & INTERACTION_SEX_COOLDOWN) && !COOLDOWN_FINISHED(target, next_sexual_interaction))
			if(!silent)
				to_chat(target.parent, span_warning("They can't handle any more sex right now."))
			return FALSE
	return TRUE

/datum/interaction/proc/perform_interaction(datum/component/interactable/user, datum/component/interactable/target)
	perform_interaction_animation(user, target)
	perform_interaction_message(user, target)
	perform_interaction_sound(user, target)
	return TRUE

/datum/interaction/proc/perform_interaction_animation(datum/component/interactable/user, datum/component/interactable/target)
	return TRUE

/datum/interaction/proc/perform_interaction_message(datum/component/interactable/user, datum/component/interactable/target)
	var/atom/atom_user = user.parent
	var/message_index = 0
	if(islist(message))
		message_index = rand(1, length(message))
	var/msg
	if(message)
		if(message_index)
			msg = message[message_index]
		else
			msg = message
		msg = replace_pronouns(user, target, msg)
	var/target_msg
	if(target_message && ismob(target.parent))
		if(message_index)
			target_msg = target_message[message_index]
		else
			target_msg = target_message
		target_msg = replace_pronouns(user, target, target_msg)
	var/user_msg
	if(user_message)
		if(message_index)
			user_msg = user_message[message_index]
		else
			user_msg = user_message
		user_msg = replace_pronouns(user, target, user_msg)
	var/blind_msg
	if(blind_message)
		if(message_index)
			blind_msg = blind_message[message_index]
		else
			blind_msg = blind_message
		blind_msg = replace_pronouns(user, target, blind_msg)
	if(ismob(user))
		var/mob/mob_user = user
		mob_user.face_atom(target.parent)
	if(interaction_flags & INTERACTION_AUDIBLE)
		//for some dumb reason, audible message does not in fact have an ignored_mobs argument so uh, get fucked?
		atom_user.audible_message(message = span_emote(msg), \
							self_message = span_emote(user_msg), \
							deaf_message = span_emote(blind_msg), \
							hearing_distance = message_range)
	else
		atom_user.visible_message(message = span_emote(msg), \
					self_message = span_emote(user_msg), \
					blind_message = span_emote(blind_msg), \
					vision_distance = message_range,
					ignored_mobs = (target_msg ? target.parent : null))
		if(target_msg)
			to_chat(target.parent, target_msg)

/datum/interaction/proc/perform_interaction_sound(datum/component/interactable/user, datum/component/interactable/target)
	if(!sounds || !sound_volume)
		return
	playsound(user.parent, pick(sounds), sound_volume, sound_vary, sound_extrarange)

/datum/interaction/proc/after_interaction(datum/component/interactable/user, datum/component/interactable/target)
	if(user_cooldown_duration)
		COOLDOWN_START(user, next_interaction, user_cooldown_duration)
	if(isliving(user.parent) && (interaction_flags & INTERACTION_USER_LUST))
		var/mob/living/living_user = user.parent
		if(lust_gain_user)
			living_user.adjust_lust(lust_gain_user)
		if((interaction_flags & INTERACTION_USER_CLIMAX) && (living_user.get_lust() >= LUST_CLIMAX))
			handle_user_climax(user, target)
		else
			handle_user_lust(user, target)
	if(user.repeat_last_action)
		if(!minimum_repeat_time && !maximum_repeat_time)
			STOP_PROCESSING(SSinteractables, user)
			user.repeat_last_action = null
		else
			user.repeat_last_action = clamp(user.repeat_last_action, minimum_repeat_time, maximum_repeat_time)
	user.last_interaction_as_user = src
	user.last_interaction_as_user_time = world.time
	user.last_interaction_target = WEAKREF(target)
	if(user_clear_time)
		user.clear_user_interaction_timer = addtimer(CALLBACK(user, TYPE_PROC_REF(/datum/component/interactable, clear_user_interaction)), user_clear_time, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_STOPPABLE)
	else if(user_clear_time)
		deltimer(user.clear_user_interaction_timer)
		user.clear_user_interaction_timer = null

	if(user != target)
		if(target_cooldown_duraction)
			COOLDOWN_START(target, next_interaction, target_cooldown_duraction)
		if(isliving(target.parent) && (interaction_flags & INTERACTION_TARGET_LUST))
			var/mob/living/living_target = target.parent
			if(lust_gain_target)
				living_target.adjust_lust(lust_gain_target)
			if((interaction_flags & INTERACTION_TARGET_CLIMAX) && (living_target.get_lust() >= LUST_CLIMAX))
				handle_target_climax(user, target)
			else
				handle_target_lust(user, target)
	target.last_interaction_as_target = src
	target.last_interaction_as_target_time = world.time
	if(target_clear_time)
		target.clear_target_interaction_timer = addtimer(CALLBACK(target, TYPE_PROC_REF(/datum/component/interactable, clear_target_interaction)), target_clear_time, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_STOPPABLE)
	else if(target.clear_target_interaction_timer)
		deltimer(target.clear_target_interaction_timer)
		target.clear_target_interaction_timer = null

	return TRUE

/// Generic behavior for user climax
/datum/interaction/proc/handle_user_climax(datum/component/interactable/user, datum/component/interactable/target)
	var/refractory_period = rand(user_climax_cooldown_duration_min, user_climax_cooldown_duration_max)
	COOLDOWN_START(user, next_sexual_interaction, refractory_period)
	return TRUE

/// Generic behavior for target climax
/datum/interaction/proc/handle_target_climax(datum/component/interactable/user, datum/component/interactable/target)
	var/refractory_period = rand(target_climax_cooldown_duration_min, target_climax_cooldown_duration_max)
	COOLDOWN_START(target, next_sexual_interaction, refractory_period)
	return TRUE

/// Basically handles moaning
/datum/interaction/proc/handle_user_lust(datum/component/interactable/user, datum/component/interactable/target)
	var/mob/living/living_user = user.parent
	if(!prob(living_user.get_lust()))
		return
	var/static/list/friendly_messages = list(
		span_horny("%USER shiver%USER_S in arousal."),
		span_horny("%USER moan%USER_S quietly."),
		span_horny("%USER breath%USER_ES out a soft moan."),
		span_horny("%USER gasp%USER_S."),
		span_horny("%USER shudder%USER_S softly"),
	)
	var/static/list/friendly_messages_self = list(
		span_horny("You shiver in arousal."),
		span_horny("You moan quietly."),
		span_horny("You breathe out a soft moan."),
		span_horny("You gasp."),
		span_horny("You shudder softly."),
	)
	//todo: lust messages based on combat mode, CBA to do it now, so for now you just dont moan while on combat mode
	var/message_index
	var/msg
	var/msg_self
	if(!living_user.combat_mode)
		message_index = rand(1, length(friendly_messages))
		msg = friendly_messages[message_index]
		msg_self = friendly_messages_self[message_index]
	if(msg && msg_self)
		msg = replace_pronouns(user, target, msg)
		msg_self = replace_pronouns(user, target, msg_self)
		living_user.audible_message(span_emote(msg), self_message = span_emote(msg_self))
	return TRUE

/// Basically handles moaning
/datum/interaction/proc/handle_target_lust(datum/component/interactable/user, datum/component/interactable/target)
	var/mob/living/living_target = target.parent
	if(!prob(living_target.get_lust()))
		return
	var/static/list/friendly_messages = list(
		span_horny("%TARGET shiver%TARGET_S in arousal."),
		span_horny("%TARGET moan%TARGET_S quietly."),
		span_horny("%TARGET breath%TARGET_ES out a soft moan."),
		span_horny("%TARGET gasp%TARGET_S."),
		span_horny("%TARGET shudder%TARGET_S softly"),
	)
	var/static/list/friendly_messages_self = list(
		span_horny("You shiver in arousal."),
		span_horny("You moan quietly."),
		span_horny("You breathe out a soft moan."),
		span_horny("You gasp."),
		span_horny("You shudder softly."),
	)
	//todo: lust messages based on combat mode, CBA to do it now, so for now you just dont moan while on combat mode
	var/message_index
	var/msg
	var/msg_self
	if(!living_target.combat_mode)
		message_index = rand(1, length(friendly_messages))
		msg = friendly_messages[message_index]
		msg_self = friendly_messages_self[message_index]
	if(msg && msg_self)
		msg = replace_pronouns(user, target, msg)
		msg_self = replace_pronouns(user, target, msg_self)
		living_target.audible_message(span_emote(msg), self_message =  span_emote(msg_self))
	return TRUE

/datum/interaction/proc/replace_pronouns(datum/component/interactable/user, datum/component/interactable/target, msg)
	msg = replacetext(msg, "%USER_THEY", user.parent.p_they())
	msg = replacetext(msg, "%USER_THEM", user.parent.p_them())
	msg = replacetext(msg, "%USER_THEIR", user.parent.p_their())
	msg = replacetext(msg, "%USER_ES", user.parent.p_es())
	msg = replacetext(msg, "%USER_S", user.parent.p_s())
	msg = replacetext(msg, "%USER", "<b>[user.parent]</b>")
	msg = replacetext(msg, "%TARGET_THEY", target.parent.p_they())
	msg = replacetext(msg, "%TARGET_THEM", target.parent.p_them())
	msg = replacetext(msg, "%TARGET_THEIR", target.parent.p_their())
	msg = replacetext(msg, "%TARGET_ES", target.parent.p_es())
	msg = replacetext(msg, "%TARGET_S", target.parent.p_s())
	msg = replacetext(msg, "%TARGET", "<b>[target.parent]</b>")
	return msg

/datum/action/cooldown/spell/fraternal_telepathy
	name = "Fraternal Telepathy"
	desc = "Telepathically transmits a message to your blood siblings. They must be conscious to hear it."
	button_icon = 'icons/mob/actions/actions_brother.dmi'
	button_icon_state = "transmit"
	background_icon_state = "bg_brother"
	overlay_icon_state = "bg_brother_border"

	cooldown_time = 10 SECONDS

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_MIND
	antimagic_flags = MAGIC_RESISTANCE_MIND

	/// Team that we send the message to
	var/datum/team/team

	/// The message we send to the next person via telepathy.
	var/message
	/// The span surrounding the telepathy message
	var/telepathy_span = "brother"

/datum/action/cooldown/spell/fraternal_telepathy/New(team)
	. = ..()
	if(team)
		src.team = team
		return
	CRASH("[type] created without an associated team")

/datum/action/cooldown/spell/fraternal_telepathy/Destroy()
	. = ..()
	team = null

/datum/action/cooldown/spell/fraternal_telepathy/can_cast_spell(feedback)
	. = ..()
	if(!team)
		return FALSE

/datum/action/cooldown/spell/fraternal_telepathy/before_cast(mob/living/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return

	message = tgui_input_text(owner, "What do you wish to say to [team]?", "[src]")
	if(QDELETED(src) || QDELETED(owner) || QDELETED(cast_on) || !can_cast_spell())
		return . | SPELL_CANCEL_CAST
	else if(!message)
		reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST

/datum/action/cooldown/spell/fraternal_telepathy/cast(mob/living/cast_on)
	. = ..()
	if(!message)
		return

	cast_on.log_talk(message, LOG_SAY, tag = name)
	to_chat(owner, "<span class='[telepathy_span]'><b>You transmit to [team]:</b> [message]</span>")
	var/datum/mind/caster_mind = cast_on.mind
	for(var/datum/mind/brother_mind as anything in (team.members - caster_mind))
		if(!brother_mind.current)
			continue
		var/mob/body = brother_mind.current
		if(!body.client)
			continue
		//hear no evil
		if(body.can_block_magic(antimagic_flags, charge_cost = 0))
			continue
		//must be conscious, otherwise you get complete garble
		if(body.stat >= UNCONSCIOUS)
			var/static/regex/word_boundaries = regex(@"\b[\S]+\b", "gi")
			var/list/rearranged = list()
			while(word_boundaries.Find(message))
				var/word = word_boundaries.match
				if(length(word))
					rearranged += random_string(length(word), GLOB.alphabet_upper + GLOB.alphabet)
			var/garbled = rearranged.Join(" ")
			to_chat(body, "<span class='[telepathy_span]'><b>Unknown (to [team.name]):</b> [garbled]</span>")
			continue
		to_chat(body, "<span class='[telepathy_span]'><b>[caster_mind.name] (to [team.name]):</b> [message]</span>")

	for(var/mob/dead/ghost as anything in GLOB.dead_mob_list)
		if(!isobserver(ghost))
			continue

		to_chat(ghost, "[FOLLOW_LINK(ghost, cast_on)] <span class='[telepathy_span]'><b>[caster_mind.name] (to [team.name]):</b> [message]</span>")

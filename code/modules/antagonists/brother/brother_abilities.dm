/datum/action/cooldown/spell/brother_telepathy
	name = "Brotherhood Telepathy"
	desc = "Telepathically transmits a message to your brothers."
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

/datum/action/cooldown/spell/brother_telepathy/New(team)
	. = ..()
	if(team)
		src.team = team
	else
		CRASH("[type] created without an associated team")

/datum/action/cooldown/spell/brother_telepathy/can_cast_spell(feedback)
	. = ..()
	if(!team)
		return FALSE

/datum/action/cooldown/spell/brother_telepathy/before_cast(mob/living/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return

	message = tgui_input_text(owner, "What do you wish to say to [team]?", "[src]")
	if(QDELETED(src) || QDELETED(owner) || QDELETED(cast_on) || !can_cast_spell())
		return . | SPELL_CANCEL_CAST
	else if(!message)
		reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST

/datum/action/cooldown/spell/brother_telepathy/cast(mob/living/cast_on)
	. = ..()
	cast_on.log_talk(message, LOG_SAY, tag = name)

	to_chat(owner, "<span class='[telepathy_span]'><b>You transmit to [team]:</b> [message]</span>")
	var/datum/mind/caster_mind = cast_on.mind
	for(var/datum/mind/brother as anything in (team.members - caster_mind))
		if(!brother.current)
			continue
		var/mob/body = brother.current
		if(!body.client)
			continue
		//hear no evil
		if(body.can_block_magic(antimagic_flags, charge_cost = 0))
			continue
		//brother has to be conscious to hear your message
		if(body.stat >= UNCONSCIOUS)
			continue
		to_chat(body, "<span class='[telepathy_span]'><b>[caster_mind.name] (to [team.name]):</b> [message]</span>")

	for(var/mob/dead/ghost as anything in GLOB.dead_mob_list)
		if(!isobserver(ghost))
			continue

		to_chat(ghost, "[FOLLOW_LINK(ghost, cast_on)] <span class='[telepathy_span]'><b>[caster_mind.name] (to [team.name]):</b> [message]</span>")

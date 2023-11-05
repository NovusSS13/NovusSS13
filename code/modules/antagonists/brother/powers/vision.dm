/datum/action/cooldown/spell/fraternal_vision
	name = "Fraternal Vision"
	desc = "Watch the world through the eyes of your blood sibling."
	button_icon = 'icons/mob/actions/actions_brother.dmi'
	button_icon_state = "vision"
	background_icon_state = "bg_brother"
	overlay_icon_state = "bg_brother_border"

	cooldown_time = 0

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_MIND
	antimagic_flags = MAGIC_RESISTANCE_MIND

	/// Team that we are connected to
	var/datum/team/team

	/// The brother we currently intend to spy on
	var/datum/weakref/brother_ref

/datum/action/cooldown/spell/fraternal_vision/New(team)
	. = ..()
	if(team)
		src.team = team
		return
	CRASH("[type] created without an associated team")

/datum/action/cooldown/spell/fraternal_vision/Destroy()
	. = ..()
	team = null
	brother_ref = null

/datum/action/cooldown/spell/fraternal_vision/can_cast_spell(feedback)
	. = ..()
	if(!team)
		return FALSE

/datum/action/cooldown/spell/fraternal_vision/before_cast(mob/living/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return

	//we need a client...
	if(!cast_on.client)
		return . | SPELL_CANCEL_CAST

	var/list/possible_brothers = list()
	var/datum/mind/caster_mind = cast_on.mind
	for(var/datum/mind/brother_mind as anything in (team.members - caster_mind))
		if(!isliving(brother_mind.current))
			continue
		var/mob/living/body = brother_mind.current
		//hear no evil
		if(body.can_block_magic(antimagic_flags, charge_cost = 0))
			continue
		//they must be conscious
		if(body.stat >= UNCONSCIOUS)
			continue
		//they must be able to see
		if(body.is_blind())
			continue
		possible_brothers[brother_mind.name] = brother_mind.current

	if(!length(possible_brothers))
		to_chat(cast_on, span_warning("All of your blood siblings are unconscious or blind."))
		reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST

	var/choice
	if(length(possible_brothers) > 1)
		choice = tgui_input_list(cast_on, "Choose a brother to view.", "[src]", possible_brothers)
	else
		choice = possible_brothers[1]
	var/mob/living/body = possible_brothers[choice]
	if(QDELETED(src) || QDELETED(owner) || QDELETED(cast_on) || !can_cast_spell())
		return . | SPELL_CANCEL_CAST
	else if(!choice || QDELETED(body) || (body.stat >= UNCONSCIOUS) || (body.is_blind()))
		reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST
	brother_ref = WEAKREF(body)

/datum/action/cooldown/spell/fraternal_vision/cast(mob/living/cast_on)
	. = ..()
	if(!cast_on.client)
		return
	var/mob/living/brother = brother_ref?.resolve()
	if(!brother)
		brother_ref = null
		return
	if(cast_on.client.eye != brother)
		cast_on.reset_perspective(brother)
		to_chat(cast_on, span_notice("You focus your energy on viewing the world throough the eyes of [brother.name]."))
		return
	to_chat(cast_on, span_notice("You return your vision to your own eyes."))
	cast_on.reset_perspective(null)
	brother_ref = null

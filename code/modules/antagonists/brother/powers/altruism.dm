/datum/action/cooldown/spell/fraternal_altruism
	name = "Fraternal Altruism"
	desc = "Take in the ailments of your sibling, healing them at your own expense. Only works on conscious siblings."
	button_icon = 'icons/mob/actions/actions_brother.dmi'
	button_icon_state = "altruism"
	background_icon_state = "bg_brother"
	overlay_icon_state = "bg_brother_border"

	cooldown_time = 1.5 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_MIND
	antimagic_flags = MAGIC_RESISTANCE_MIND

	/// Team that we send the message to
	var/datum/team/team

	/// The brother we currently intend to heal
	var/mob/living/brother

/datum/action/cooldown/spell/fraternal_altruism/New(team)
	. = ..()
	if(team)
		src.team = team
	else
		CRASH("[type] created without an associated team")

/datum/action/cooldown/spell/fraternal_altruism/Destroy()
	brother = null
	return ..()

/datum/action/cooldown/spell/fraternal_altruism/can_cast_spell(feedback)
	. = ..()
	if(!team)
		return FALSE

/datum/action/cooldown/spell/fraternal_altruism/before_cast(mob/living/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return

	var/list/possible_brothers = list()
	var/datum/mind/caster_mind = cast_on.mind
	for(var/datum/mind/brother as anything in (team.members - caster_mind))
		if(!isliving(brother.current))
			continue
		var/mob/living/body = brother.current
		//hear no evil
		if(body.can_block_magic(antimagic_flags, charge_cost = 0))
			continue
		//they must be conscious
		if(body.stat >= UNCONSCIOUS)
			continue
		//they must be damaged
		if(!check_ailments(body))
			continue
		possible_brothers[brother.name] = brother.current

	if(!length(possible_brothers))
		to_chat(cast_on, span_warning("All of your blood siblings either are unconscious, or have no ailments."))
		reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST

	var/choice
	if(length(possible_brothers) > 1)
		choice = tgui_input_list(cast_on, "Choose a brother to heal.", "[src]", possible_brothers)
	else
		choice = possible_brothers[1]
	brother = possible_brothers[choice]
	if(QDELETED(src) || QDELETED(owner) || QDELETED(cast_on) || !can_cast_spell())
		brother = null
		return . | SPELL_CANCEL_CAST
	else if(!choice || QDELETED(brother) || (brother.stat >= UNCONSCIOUS) || !check_ailments(brother))
		brother = null
		reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST

/datum/action/cooldown/spell/fraternal_altruism/proc/check_ailments(mob/living/hurt)
	if(hurt.getBruteLoss() || hurt.getFireLoss() || hurt.getToxLoss() || hurt.getOxyLoss() || hurt.getCloneLoss())
		return TRUE
	if(iscarbon(hurt))
		var/mob/living/carbon/carbon_hurt = hurt
		if((carbon_hurt.blood_volume < BLOOD_VOLUME_NORMAL) || LAZYLEN(carbon_hurt.get_missing_limbs()) || LAZYLEN(carbon_hurt.all_wounds))
			return TRUE
	return FALSE

/datum/action/cooldown/spell/fraternal_altruism/cast(mob/living/cast_on)
	. = ..()
	if(!brother)
		return

	if(iscarbon(brother) && iscarbon(cast_on))
		var/mob/living/carbon/carbon_caster = cast_on
		var/mob/living/carbon/carbon_brother = brother
		//gives our brother our blood
		if(carbon_brother.blood_volume < BLOOD_VOLUME_NORMAL)
			var/given_blood = carbon_caster.blood_volume - carbon_brother.blood_volume
			if(given_blood > 0)
				carbon_brother.blood_volume += given_blood
				carbon_caster.blood_volume = max(carbon_caster.blood_volume - given_blood, 0)
		//loops through every limb to accurately transfer brute and burn damage
		for(var/obj/item/bodypart/brother_part as anything in carbon_brother.bodyparts)
			var/obj/item/bodypart/caster_part = carbon_caster.get_bodypart(brother_part.body_zone)
			if(!caster_part)
				continue
			var/brute_before = caster_part.brute_dam
			var/burn_before = caster_part.burn_dam
			caster_part.receive_damage(brother_part.brute_dam, brother_part.burn_dam, wound_bonus = CANT_WOUND, updating_health = FALSE)
			brother_part.heal_damage(max(caster_part.brute_dam - brute_before, 0), max(caster_part.burn_dam - burn_before, 0), updating_health = FALSE)
			//not perfect but i tried
			for(var/datum/wound/wound as anything in brother_part.wounds)
				if(!caster_part.force_wound_upwards(wound.type, wound_source = wound.wound_source))
					continue
				wound.remove_wound()
			for(var/obj/item/embedder as anything in brother_part.embedded_objects)
				if(embedder.isEmbedHarmless())
					continue
				carbon_brother.remove_embedded_object(embedder)
				if(!QDELETED(embedder))
					embedder.tryEmbed(caster_part, forced = TRUE)
		//tries giving our brother our limbs - insane, yes
		var/static/list/unreplaceable_limbs = list(BODY_ZONE_HEAD, BODY_ZONE_CHEST)
		for(var/lost_zone in (carbon_brother.get_missing_limbs() - unreplaceable_limbs))
			var/obj/item/bodypart/caster_part = carbon_caster.get_bodypart(lost_zone)
			if(!caster_part || !caster_part.can_attach_limb(carbon_brother))
				continue
			caster_part.drop_limb()
			if(!caster_part.try_attach_limb(carbon_brother))
				caster_part.try_attach_limb(carbon_caster)
		//i also wanted to try and give the brother our organs, but i don't believe there is a reasonable way to do this
		//because organ code is much crazier than bodypart code
	else
		var/brother_brute = brother.getBruteLoss()
		if(brother_brute)
			var/damage_before = cast_on.getBruteLoss()
			cast_on.adjustBruteLoss(brother_brute)
			brother.adjustBruteLoss(min(-(cast_on.getBruteLoss() - damage_before), 0))
		var/brother_burn = brother.getBruteLoss()
		if(brother_burn)
			var/damage_before = cast_on.getFireLoss()
			cast_on.adjustFireLoss(brother_brute)
			brother.adjustFireLoss(min(-(cast_on.getFireLoss() - damage_before), 0))
	var/brother_tox = brother.getToxLoss()
	if(brother_tox)
		var/damage_before = cast_on.getToxLoss()
		cast_on.adjustToxLoss(brother_tox)
		brother.adjustToxLoss(min(-(cast_on.getToxLoss() - damage_before), 0))
	var/brother_oxy = brother.getOxyLoss()
	if(brother_oxy)
		var/damage_before = cast_on.getOxyLoss()
		cast_on.adjustOxyLoss(brother_oxy)
		brother.adjustOxyLoss(min(-(cast_on.getOxyLoss() - damage_before), 0))
	var/brother_clone = brother.getCloneLoss()
	if(brother_clone)
		var/damage_before = cast_on.getCloneLoss()
		cast_on.adjustCloneLoss(brother_clone)
		brother.adjustCloneLoss(min(-(cast_on.getCloneLoss() - damage_before), 0))

	playsound(cast_on, 'sound/magic/demon_consume.ogg', 50, TRUE)
	to_chat(cast_on, span_userdanger("You have absorbed [brother]'s ailments!"))
	playsound(brother, 'sound/magic/demon_consume.ogg', 50, TRUE)
	to_chat(brother, span_notice("[cast_on] has absorbed your ailments!"))
	cast_on.updatehealth()
	brother.updatehealth()

	brother = null

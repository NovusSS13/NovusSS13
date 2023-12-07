/datum/brain_trauma/severe/beepsky
	name = "Criminal"
	desc = "Patient seems to be a criminal."
	scan_desc = "criminal mind"
	gain_text = span_warning("Justice is coming for you.")
	lose_text = span_notice("You were absolved for your crimes.")
	random_gain = FALSE
	/// A ref to our fake beepsky image that we chase the owner with
	var/obj/effect/client_image_holder/securitron/beepsky

/datum/brain_trauma/severe/beepsky/Destroy()
	QDEL_NULL(beepsky)
	return ..()

/datum/brain_trauma/severe/beepsky/on_gain()
	create_securitron()
	return ..()

/datum/brain_trauma/severe/beepsky/proc/create_securitron()
	QDEL_NULL(beepsky)
	var/turf/where = locate(owner.x + pick(-12, 12), owner.y + pick(-12, 12), owner.z)
	beepsky = new(where, owner)

/datum/brain_trauma/severe/beepsky/on_lose()
	QDEL_NULL(beepsky)
	return ..()

/datum/brain_trauma/severe/beepsky/on_life()
	if(QDELETED(beepsky) || !beepsky.loc || beepsky.z != owner.z)
		if(prob(30))
			create_securitron()
		else
			return

	if(get_dist(owner, beepsky) >= 10 && prob(20))
		create_securitron()

	if(owner.stat != CONSCIOUS)
		if(prob(20))
			owner.playsound_local(beepsky, 'sound/voice/beepsky/iamthelaw.ogg', 50)
		return

	if(get_dist(owner, beepsky) <= 1)
		owner.playsound_local(owner, 'sound/weapons/egloves.ogg', 50)
		owner.visible_message(span_warning("[owner]'s body jerks as if it was shocked."), span_userdanger("You feel the fist of the LAW."))
		owner.adjustStaminaLoss(rand(40, 70))
		QDEL_NULL(beepsky)

	if(prob(20) && get_dist(owner, beepsky) <= 8)
		owner.playsound_local(beepsky, 'sound/voice/beepsky/criminal.ogg', 40)

/obj/effect/client_image_holder/securitron
	name = "Securitron"
	desc = "The LAW is coming."
	image_icon = 'icons/mob/silicon/aibots.dmi'
	image_state = "secbot-c"

/obj/effect/client_image_holder/securitron/Initialize(mapload)
	. = ..()
	name = pick("Officer Beepsky", "Officer Johnson", "Officer Pingsky")
	START_PROCESSING(SSfastprocess, src)

/obj/effect/client_image_holder/securitron/Destroy()
	STOP_PROCESSING(SSfastprocess,src)
	return ..()

/obj/effect/client_image_holder/securitron/process()
	if(prob(40))
		return

	var/mob/victim = pick(who_sees_us)
	forceMove(get_step_towards(src, victim))
	if(prob(5))
		var/beepskys_cry = "Level 10 infraction alert!"
		to_chat(victim, "[span_name("[name]")] exclaims, \"[span_robot("[beepskys_cry]")]")
		if(victim.client?.prefs.read_preference(/datum/preference/toggle/enable_runechat))
			victim.create_chat_message(src, raw_message = beepskys_cry, spans = list("robotic"))

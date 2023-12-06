/datum/brain_trauma/special/dreamer
	name = "Simulucidity Affliction"
	desc = "Patient believes that they are in a false reality they must escape out of."
	scan_desc = "depersonalization-derealization disorder"
	gain_text = span_userdanger("FOLLOWING my HEART shall be the WHOLE of the law.")
	lose_text = span_notice("Everything feels real again.")
	/// Object used for the funny hallucinations
	var/atom/movable/screen/fullscreen/dreamer/visions
	/// Traits given to the owner with DREAMER_TRAIT as the source
	var/static/list/dreamer_traits = list(
		TRAIT_MORBID,
		TRAIT_IGNOREDAMAGESLOWDOWN,
		TRAIT_NOSOFTCRIT,
		TRAIT_NOHARDCRIT,
		TRAIT_HARDLY_WOUNDED,
		TRAIT_BLOODLOSSIMMUNE,
		TRAIT_NOHUNGER,
		TRAIT_FEARLESS,
		TRAIT_NO_ZOMBIFY,
		TRAIT_ANTIMAGIC_NO_SELFBLOCK,
	)

/datum/brain_trauma/special/dreamer/Destroy()
	QDEL_NULL(visions)
	return ..()

/datum/brain_trauma/special/dreamer/on_gain()
	. = ..()
	if(owner.combat_mode)
		shake_thug()
	visions = owner.overlay_fullscreen("dreamer", /atom/movable/screen/fullscreen/dreamer)
	visions.alpha = 0
	owner.add_traits(dreamer_traits, DREAMER_TRAIT)
	owner.AddComponent(/datum/component/anti_magic, antimagic_flags = MAGIC_RESISTANCE_MIND) //resistance against megamind
	RegisterSignal(owner, COMSIG_LIVING_SET_COMBAT_MODE, PROC_REF(on_set_combat_mode))

/datum/brain_trauma/special/dreamer/on_lose(silent)
	. = ..()
	unshake_thug()
	visions = null
	owner.clear_fullscreen("dreamer")
	owner.remove_traits(dreamer_traits, DREAMER_TRAIT)
	qdel(owner.GetComponent(/datum/component/anti_magic))
	UnregisterSignal(owner, COMSIG_LIVING_SET_COMBAT_MODE)

/datum/brain_trauma/special/dreamer/on_life(seconds_per_tick, times_fired)
	INVOKE_ASYNC(src, PROC_REF(handle_visions), seconds_per_tick, times_fired)

/datum/brain_trauma/special/dreamer/proc/handle_visions(seconds_per_tick, times_fired)
	//Jumpscare funny
	if(SPT_PROB(1, seconds_per_tick))
		visions.jumpscare(owner)
	//Random laughter
	else if(SPT_PROB(0.5, seconds_per_tick))
		var/static/list/funnies = list(
			'sound/hallucinations/dreamer/comic1.ogg',
			'sound/hallucinations/dreamer/comic2.ogg',
			'sound/hallucinations/dreamer/comic3.ogg',
			'sound/hallucinations/dreamer/comic4.ogg',
		)
		owner.playsound_local(owner, pick(funnies), vol = 100, vary = FALSE)

/datum/brain_trauma/special/dreamer/proc/on_set_combat_mode(mob/living/source, new_mode, silent)
	SIGNAL_HANDLER

	if(new_mode)
		shake_thug()
	else
		unshake_thug()

/datum/brain_trauma/special/dreamer/proc/shake_thug()
	animate(owner?.client, pixel_y = 1, time = 1, loop = -1, flags = ANIMATION_RELATIVE)
	animate(pixel_y = -1, time = 1, flags = ANIMATION_RELATIVE)

/datum/brain_trauma/special/dreamer/proc/unshake_thug()
	animate(owner?.client)

/atom/movable/screen/fullscreen/dreamer
	name = "wake up"
	icon = 'icons/hud/visions.dmi'
	icon_state = "hall1"
	base_icon_state = "hall"
	/// Amount of hallucination icon states we have
	var/hall_amount = 10

/atom/movable/screen/fullscreen/dreamer/proc/jumpscare(mob/living/scared, silent = FALSE, fade_in = 0.2 SECONDS, duration = 0.5 SECONDS, fade_out = 1 SECONDS)
	if(!silent)
		var/static/list/spookies = list(
			'sound/hallucinations/dreamer/hall_appear1.ogg',
			'sound/hallucinations/dreamer/hall_appear2.ogg',
			'sound/hallucinations/dreamer/hall_appear3.ogg',
		)
		scared.playsound_local(scared, pick(spookies), vol = 100, vary = FALSE)
	icon_state = "[base_icon_state][rand(1, hall_amount)]"
	animate(src, alpha = 255, time = fade_in, easing = BOUNCE_EASING | EASE_IN | EASE_OUT)
	animate(time = duration, easing = LINEAR_EASING)
	animate(alpha = 0, time = fade_out, easing = LINEAR_EASING)

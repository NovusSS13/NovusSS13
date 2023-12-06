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
	handle_visions(seconds_per_tick, times_fired)
	handle_hallucinations(seconds_per_tick, times_fired)
	handle_floors(seconds_per_tick, times_fired)
	handle_walls(seconds_per_tick, times_fired)

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

/datum/brain_trauma/special/dreamer/proc/handle_hallucinations(seconds_per_tick, times_fired)
	//Crewmember radio
	if(prob(0.5))
		var/list/people = list()
		for(var/mob/living/carbon/human/human as anything in GLOB.human_list)
			if(!human.mind)
				continue
			people += human
		if(length(people))
			var/mob/living/carbon/human/person = pick(people)
			var/speech = pick_list_replacements(BRAIN_DAMAGE_FILE, "dreamer_radio")
			speech = replacetext(speech, "%OWNER", owner.real_name)
			var/message = owner.compose_message(person, owner.get_selected_language(), speech, "[FREQ_COMMON]", list(person.speech_span), visible_name = TRUE)
			to_chat(owner, message)
	//Chasing mob
	else if(prob(0.2))
		INVOKE_ASYNC(src, PROC_REF(handle_mob_hallucination), seconds_per_tick, times_fired)
	//OOC message
	else if(prob(0.1))
		if(length(GLOB.clients))
			var/client/salty = pick(GLOB.clients)
			var/speech = pick_list_replacements(BRAIN_DAMAGE_FILE, "dreamer_ooc")
			speech = replacetext(speech, "%OWNER", owner.real_name)
			var/message
			if(GLOB.OOC_COLOR)
				message = "<span class='oocplain'><font color='[GLOB.OOC_COLOR]'><b>[span_prefix("OOC:")] <EM>[salty.key]:</EM> <span class='message linkify'>[speech]</span></b></font></span>"
			else
				message = span_ooc(span_prefix("OOC:</span> <EM>[salty.key]:</EM> <span class='message linkify'>[speech]"))
			to_chat(owner, message)
	//Talking objects
	if(prob(4))
		var/list/objects = list()
		for(var/obj/object in view(owner))
			var/weight = 1
			if(isitem(object))
				weight = 3
			else if(isstructure(object))
				weight = 2
			objects[object] = weight
		objects -= owner.get_all_contents()
		if(length(objects))
			var/static/list/speech_sounds = list(
				'sound/hallucinations/dreamer/female_talk1.ogg',
				'sound/hallucinations/dreamer/female_talk2.ogg',
				'sound/hallucinations/dreamer/female_talk3.ogg',
				'sound/hallucinations/dreamer/female_talk4.ogg',
				'sound/hallucinations/dreamer/female_talk5.ogg',
				'sound/hallucinations/dreamer/male_talk1.ogg',
				'sound/hallucinations/dreamer/male_talk2.ogg',
				'sound/hallucinations/dreamer/male_talk3.ogg',
				'sound/hallucinations/dreamer/male_talk4.ogg',
				'sound/hallucinations/dreamer/male_talk5.ogg',
				'sound/hallucinations/dreamer/male_talk6.ogg',
			)
			var/obj/speaker = pick_weight(objects)
			var/speech
			if(prob(1))
				speech = "[rand(0,9)][rand(0,9)][rand(0,9)][rand(0,9)]"
			else
				speech = pick_list_replacements(BRAIN_DAMAGE_FILE, "dreamer_object")
				speech = replacetext(speech, "%OWNER", "[owner.real_name]")
			var/message = owner.compose_message(speaker, owner.get_selected_language(), speech)
			owner.playsound_local(owner, pick(speech_sounds), vol = 60, vary = FALSE)
			if(owner.client.prefs?.read_preference(/datum/preference/toggle/enable_runechat_non_mobs))
				owner.create_chat_message(speaker, owner.get_selected_language(), speech)
			to_chat(owner, message)

/datum/brain_trauma/special/dreamer/proc/handle_mob_hallucination(seconds_per_tick, times_fired)
	if(!owner.client)
		return
	var/mob_message = pick("It's mom!", "I have to HURRY UP!", "They are CLOSE!","They are NEAR!")
	var/turf/spawning_turf
	var/list/turf/spawning_turfs = list()
	for(var/turf/turf in view(owner))
		spawning_turfs += turf
	if(length(spawning_turfs))
		spawning_turf = pick(spawning_turfs)
	if(!spawning_turf)
		return
	var/mob_state = pick("mom", "shadow", "deepone")
	if(mob_message == "It's mom!")
		mob_state = "mom"
	var/image/mob_image = image('icons/mob/dreamer_mobs.dmi', spawning_turf, mob_state, FLOAT_LAYER, get_dir(spawning_turf, owner))
	SET_PLANE(mob_image, GAME_PLANE_UPPER_FOV_HIDDEN, owner)
	owner.client.images += mob_image
	to_chat(owner, span_userdanger(span_big(mob_message)))
	sleep(5)
	if(!owner?.client)
		return
	var/static/list/spookies = pick(
		'sound/hallucinations/dreamer/hall_attack1.ogg',
		'sound/hallucinations/dreamer/hall_attack2.ogg',
		'sound/hallucinations/dreamer/hall_attack3.ogg',
		'sound/hallucinations/dreamer/hall_attack4.ogg',
	)
	owner.playsound_local(owner, pick(spookies), 100)
	var/chase_tiles = 7
	var/chase_wait = rand(4,6)
	var/caught_dreamer = FALSE
	var/turf/current_turf = spawning_turf
	while(chase_tiles > 0)
		if(!owner?.client)
			return
		var/face_direction = get_dir(current_turf, owner)
		current_turf = get_step(current_turf, face_direction)
		if(!current_turf)
			break
		mob_image.dir = face_direction
		mob_image.loc = current_turf
		if(current_turf == get_turf(owner))
			caught_dreamer = TRUE
			break
		chase_tiles--
		sleep(chase_wait)
	if(!owner?.client)
		return
	if(caught_dreamer)
		owner.Paralyze(rand(2, 4) SECONDS)
		var/pain_message = pick("NO!", "THEY GOT ME!", "AGH!")
		to_chat(owner, span_userdanger(pain_message))
	sleep(chase_wait)
	if(!owner?.client)
		return
	owner.client.images -= mob_image

/datum/brain_trauma/special/dreamer/proc/handle_floors(seconds_per_tick, times_fired)
	if(!owner.client)
		return
	//Floors go crazy go stupid
	for(var/turf/open/floor in view(owner))
		if(!SPT_PROB(4, seconds_per_tick))
			continue
		INVOKE_ASYNC(src, PROC_REF(handle_floor), floor)

/datum/brain_trauma/special/dreamer/proc/handle_floor(turf/open/floor)
	var/mutable_appearance/fake_floor = image(floor.icon, floor, floor.icon_state)
	owner.client.images += fake_floor
	var/offset = pick(-3,-2, -1, 1, 2, 3)
	var/disappearfirst = rand(1 SECONDS, 3 SECONDS) * abs(offset)
	animate(fake_floor, pixel_y = offset, time = disappearfirst, flags = ANIMATION_RELATIVE)
	sleep(disappearfirst)
	var/disappearsecond = rand(1 SECONDS, 3 SECONDS) * abs(offset)
	animate(fake_floor, pixel_y = -offset, time = disappearsecond, flags = ANIMATION_RELATIVE)
	sleep(disappearsecond)
	owner.client?.images -= fake_floor

/datum/brain_trauma/special/dreamer/proc/handle_walls(seconds_per_tick, times_fired)
	if(!owner.client)
		return
	//Shit on THA walls
	for(var/turf/closed/wall in view(owner))
		if(!SPT_PROB(2, seconds_per_tick))
			continue
		INVOKE_ASYNC(src, PROC_REF(handle_wall), wall)

/datum/brain_trauma/special/dreamer/proc/handle_wall(turf/closed/wall)
	var/image/shit = image('icons/effects/shit.dmi', wall, "splat[rand(1,8)]")
	owner.client?.images += shit
	var/offset = pick(-1, 1, 2)
	var/disappearfirst = rand(2 SECONDS, 4 SECONDS)
	animate(shit, pixel_y = offset, time = disappearfirst, flags = ANIMATION_RELATIVE)
	sleep(disappearfirst)
	var/disappearsecond = rand(2 SECONDS, 4 SECONDS)
	animate(shit, pixel_y = -offset, time = disappearsecond, flags = ANIMATION_RELATIVE)
	sleep(disappearsecond)
	owner.client?.images -= shit

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
	var/hall_amount = 13

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

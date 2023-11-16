//Severe traumas, when your brain gets abused way too much.
//These range from very annoying to completely debilitating.
//They cannot be cured with chemicals, and require brain surgery to solve.

/datum/brain_trauma/severe
	resilience = TRAUMA_RESILIENCE_SURGERY

/datum/brain_trauma/severe/mute
	name = "Mutism"
	desc = "Patient is completely unable to speak."
	scan_desc = "extensive damage to the brain's speech center"
	gain_text = span_warning("You forget how to speak!")
	lose_text = span_notice("You suddenly remember how to speak.")

/datum/brain_trauma/severe/mute/on_gain()
	ADD_TRAIT(owner, TRAIT_MUTE, TRAUMA_TRAIT)
	return ..()

/datum/brain_trauma/severe/mute/on_lose()
	REMOVE_TRAIT(owner, TRAIT_MUTE, TRAUMA_TRAIT)
	return ..()

/datum/brain_trauma/severe/aphasia
	name = "Aphasia"
	desc = "Patient is unable to speak or understand any language."
	scan_desc = "extensive damage to the brain's language center"
	gain_text = span_warning("You have trouble forming words in your head...")
	lose_text = span_notice("You suddenly remember how languages work.")

/datum/brain_trauma/severe/aphasia/on_gain()
	owner.add_blocked_language(subtypesof(/datum/language) - /datum/language/aphasia, source = LANGUAGE_APHASIA)
	owner.grant_language(/datum/language/aphasia, source = LANGUAGE_APHASIA)
	return ..()

/datum/brain_trauma/severe/aphasia/on_lose()
	if(!QDELING(owner))
		owner.remove_blocked_language(subtypesof(/datum/language), source = LANGUAGE_APHASIA)
		owner.remove_language(/datum/language/aphasia, source = LANGUAGE_APHASIA)

	return ..()

/datum/brain_trauma/severe/blindness
	name = "Cerebral Blindness"
	desc = "Patient's brain is no longer connected to its eyes."
	scan_desc = "extensive damage to the brain's occipital lobe"
	gain_text = span_warning("You can't see!")
	lose_text = span_notice("Your vision returns.")

/datum/brain_trauma/severe/blindness/on_gain()
	owner.become_blind(TRAUMA_TRAIT)
	return ..()

/datum/brain_trauma/severe/blindness/on_lose()
	owner.cure_blind(TRAUMA_TRAIT)
	return ..()

/datum/brain_trauma/severe/paralysis
	name = "Paralysis"
	desc = "Patient's brain can no longer control part of its motor functions."
	scan_desc = "cerebral paralysis"
	gain_text = ""
	lose_text = ""
	var/paralysis_type
	var/list/paralysis_traits = list()
	//for descriptions

/datum/brain_trauma/severe/paralysis/New(specific_type)
	if(specific_type)
		paralysis_type = specific_type
	if(!paralysis_type)
		paralysis_type = pick("full","left","right","arms","legs","r_arm","l_arm","r_leg","l_leg")
	var/subject
	switch(paralysis_type)
		if("full")
			subject = "your body"
			paralysis_traits = list(TRAIT_PARALYSIS_L_ARM, TRAIT_PARALYSIS_R_ARM, TRAIT_PARALYSIS_L_LEG, TRAIT_PARALYSIS_R_LEG)
		if("left")
			subject = "the left side of your body"
			paralysis_traits = list(TRAIT_PARALYSIS_L_ARM, TRAIT_PARALYSIS_L_LEG)
		if("right")
			subject = "the right side of your body"
			paralysis_traits = list(TRAIT_PARALYSIS_R_ARM, TRAIT_PARALYSIS_R_LEG)
		if("arms")
			subject = "your arms"
			paralysis_traits = list(TRAIT_PARALYSIS_L_ARM, TRAIT_PARALYSIS_R_ARM)
		if("legs")
			subject = "your legs"
			paralysis_traits = list(TRAIT_PARALYSIS_L_LEG, TRAIT_PARALYSIS_R_LEG)
		if("r_arm")
			subject = "your right arm"
			paralysis_traits = list(TRAIT_PARALYSIS_R_ARM)
		if("l_arm")
			subject = "your left arm"
			paralysis_traits = list(TRAIT_PARALYSIS_L_ARM)
		if("r_leg")
			subject = "your right leg"
			paralysis_traits = list(TRAIT_PARALYSIS_R_LEG)
		if("l_leg")
			subject = "your left leg"
			paralysis_traits = list(TRAIT_PARALYSIS_L_LEG)

	gain_text = span_warning("You can't feel [subject] anymore!")
	lose_text = span_notice("You can feel [subject] again!")

/datum/brain_trauma/severe/paralysis/on_gain()
	for(var/paralysis_trait in paralysis_traits)
		ADD_TRAIT(owner, paralysis_trait, TRAUMA_TRAIT)
	return ..()

/datum/brain_trauma/severe/paralysis/on_lose()
	for(var/paralysis_trait in paralysis_traits)
		REMOVE_TRAIT(owner, paralysis_trait, TRAUMA_TRAIT)
	return ..()

/datum/brain_trauma/severe/paralysis/paraplegic
	random_gain = FALSE
	paralysis_type = "legs"
	resilience = TRAUMA_RESILIENCE_ABSOLUTE

/datum/brain_trauma/severe/paralysis/hemiplegic
	random_gain = FALSE
	resilience = TRAUMA_RESILIENCE_ABSOLUTE

/datum/brain_trauma/severe/paralysis/hemiplegic/left
	paralysis_type = "left"

/datum/brain_trauma/severe/paralysis/hemiplegic/right
	paralysis_type = "right"

/datum/brain_trauma/severe/narcolepsy
	name = "Narcolepsy"
	desc = "Patient may involuntarily fall asleep during normal activities."
	scan_desc = "traumatic narcolepsy"
	gain_text = span_warning("You have a constant feeling of drowsiness...")
	lose_text = span_notice("You feel awake and aware again.")

/datum/brain_trauma/severe/narcolepsy/on_life(seconds_per_tick, times_fired)
	if(owner.IsSleeping())
		return

	var/sleep_chance = 1
	var/drowsy = !!owner.has_status_effect(/datum/status_effect/drowsiness)
	if(owner.m_intent == MOVE_INTENT_RUN)
		sleep_chance += 2
	if(drowsy)
		sleep_chance += 3

	if(SPT_PROB(0.5 * sleep_chance, seconds_per_tick))
		to_chat(owner, span_warning("You fall asleep."))
		owner.Sleeping(6 SECONDS)

	else if(!drowsy && SPT_PROB(sleep_chance, seconds_per_tick))
		to_chat(owner, span_warning("You feel tired..."))
		owner.adjust_drowsiness(20 SECONDS)

/datum/brain_trauma/severe/monophobia
	name = "Monophobia"
	desc = "Patient feels sick and distressed when not around other people, leading to potentially lethal levels of stress."
	scan_desc = "monophobia"
	gain_text = ""
	lose_text = span_notice("You feel like you could be safe on your own.")
	var/stress = 0

/datum/brain_trauma/severe/monophobia/on_gain()
	. = ..()
	if(check_alone())
		to_chat(owner, span_warning("You feel really lonely..."))
	else
		to_chat(owner, span_notice("You feel safe, as long as you have people around you."))

/datum/brain_trauma/severe/monophobia/on_life(seconds_per_tick, times_fired)
	. = ..()
	if(check_alone())
		stress = min(stress + 0.5, 100)
		if(stress > 10 && SPT_PROB(2.5, seconds_per_tick))
			stress_reaction()
	else
		stress = max(stress - (2 * seconds_per_tick), 0)

/datum/brain_trauma/severe/monophobia/proc/check_alone()
	var/check_radius = 7
	if(owner.is_blind())
		check_radius = 1
	for(var/mob/M in view(owner, check_radius))
		if((M == owner) || !isliving(M)) //ghosts ain't people
			continue
		if(istype(M, /mob/living/simple_animal/pet) || istype(M, /mob/living/basic/pet) || M.ckey)
			return FALSE
	return TRUE

/datum/brain_trauma/severe/monophobia/proc/stress_reaction()
	if(owner.stat != CONSCIOUS)
		return

	var/high_stress = (stress > 60) //things get psychosomatic from here on
	switch(rand(1, 6))
		if(1)
			if(high_stress)
				to_chat(owner, span_warning("You feel really sick at the thought of being alone!"))
			else
				to_chat(owner, span_warning("You feel sick..."))
			addtimer(CALLBACK(owner, TYPE_PROC_REF(/mob/living/carbon, vomit), high_stress), 50) //blood vomit if high stress
		if(2)
			if(high_stress)
				to_chat(owner, span_warning("You feel weak and scared! If only you weren't alone..."))
				owner.adjustStaminaLoss(50)
			else
				to_chat(owner, span_warning("You can't stop shaking..."))

			owner.adjust_dizzy(40 SECONDS)
			owner.adjust_confusion(20 SECONDS)
			owner.set_jitter_if_lower(40 SECONDS)

		if(3, 4)
			if(high_stress)
				to_chat(owner, span_warning("You're going mad with loneliness!"))
				owner.adjust_hallucinations(60 SECONDS)
			else
				to_chat(owner, span_warning("You feel really lonely..."))

		if(5)
			if(high_stress)
				if(prob(15) && ishuman(owner))
					var/mob/living/carbon/human/H = owner
					H.set_heartattack(TRUE)
					to_chat(H, span_userdanger("You feel a stabbing pain in your heart!"))
				else
					to_chat(owner, span_userdanger("You feel your heart lurching in your chest..."))
					owner.adjustOxyLoss(8)
			else
				to_chat(owner, span_warning("Your heart skips a beat."))
				owner.adjustOxyLoss(8)

		else
			//No effect
			return

/datum/brain_trauma/severe/discoordination
	name = "Discoordination"
	desc = "Patient is unable to use complex tools or machinery."
	scan_desc = "extreme discoordination"
	gain_text = span_warning("You can barely control your hands!")
	lose_text = span_notice("You feel in control of your hands again.")

/datum/brain_trauma/severe/discoordination/on_gain()
	. = ..()
	owner.apply_status_effect(/datum/status_effect/discoordinated)

/datum/brain_trauma/severe/discoordination/on_lose()
	owner.remove_status_effect(/datum/status_effect/discoordinated)
	return ..()

/datum/brain_trauma/severe/pacifism
	name = "Traumatic Non-Violence"
	desc = "Patient is extremely unwilling to harm others in violent ways."
	scan_desc = "pacific syndrome"
	gain_text = span_notice("You feel oddly peaceful.")
	lose_text = span_notice("You no longer feel compelled to not harm.")

/datum/brain_trauma/severe/pacifism/on_gain()
	ADD_TRAIT(owner, TRAIT_PACIFISM, TRAUMA_TRAIT)
	return ..()

/datum/brain_trauma/severe/pacifism/on_lose()
	REMOVE_TRAIT(owner, TRAIT_PACIFISM, TRAUMA_TRAIT)
	return ..()

/datum/brain_trauma/severe/hypnotic_stupor
	name = "Hypnotic Stupor"
	desc = "Patient is prone to episodes of extreme stupor that leaves them extremely suggestible."
	scan_desc = "oneiric feedback loop"
	gain_text = span_warning("You feel somewhat dazed.")
	lose_text = span_notice("You feel like a fog was lifted from your mind.")

/datum/brain_trauma/severe/hypnotic_stupor/on_lose() //hypnosis must be cleared separately, but brain surgery should get rid of both anyway
	. = ..()
	owner.remove_status_effect(/datum/status_effect/trance)

/datum/brain_trauma/severe/hypnotic_stupor/on_life(seconds_per_tick, times_fired)
	. = ..()
	if(SPT_PROB(0.5, seconds_per_tick) && !owner.has_status_effect(/datum/status_effect/trance))
		owner.apply_status_effect(/datum/status_effect/trance, rand(100,300), FALSE)

/datum/brain_trauma/severe/hypnotic_trigger
	name = "Hypnotic Trigger"
	desc = "Patient has a trigger phrase set in their subconscious that will trigger a suggestible trance-like state."
	scan_desc = "oneiric feedback loop"
	gain_text = span_warning("You feel odd, like you just forgot something important.")
	lose_text = span_notice("You feel like a weight was lifted from your mind.")
	random_gain = FALSE
	var/trigger_phrase = "Nanotrasen"

/datum/brain_trauma/severe/hypnotic_trigger/New(phrase)
	. = ..()
	if(phrase)
		trigger_phrase = phrase

/datum/brain_trauma/severe/hypnotic_trigger/on_lose() //hypnosis must be cleared separately, but brain surgery should get rid of both anyway
	. = ..()
	owner.remove_status_effect(/datum/status_effect/trance)

/datum/brain_trauma/severe/hypnotic_trigger/handle_hearing(datum/source, list/hearing_args)
	if(!owner.can_hear() || owner == hearing_args[HEARING_SPEAKER])
		return

	var/regex/reg = new("(\\b[REGEX_QUOTE(trigger_phrase)]\\b)","ig")

	if(findtext(hearing_args[HEARING_RAW_MESSAGE], reg))
		addtimer(CALLBACK(src, PROC_REF(hypnotrigger)), 1 SECONDS) //to react AFTER the chat message
		hearing_args[HEARING_RAW_MESSAGE] = reg.Replace(hearing_args[HEARING_RAW_MESSAGE], span_hypnophrase("*********"))

/datum/brain_trauma/severe/hypnotic_trigger/proc/hypnotrigger()
	to_chat(owner, span_warning("The words trigger something deep within you, and you feel your consciousness slipping away..."))
	owner.apply_status_effect(/datum/status_effect/trance, rand(100,300), FALSE)

/datum/brain_trauma/severe/dyslexia
	name = "Dyslexia"
	desc = "Patient is unable to read or write."
	scan_desc = "dyslexia"
	gain_text = span_warning("You have trouble reading or writing...")
	lose_text = span_notice("You suddenly remember how to read and write.")

/datum/brain_trauma/severe/dyslexia/on_gain()
	ADD_TRAIT(owner, TRAIT_ILLITERATE, TRAUMA_TRAIT)
	return ..()

/datum/brain_trauma/severe/dyslexia/on_lose()
	REMOVE_TRAIT(owner, TRAIT_ILLITERATE, TRAUMA_TRAIT)
	return ..()

/datum/brain_trauma/severe/stroke
	name = "Hemorrhagic Stroke"
	desc = "An artery has burst in the patient's brain, the ensuing edema is causing worsening brain damage over time."
	scan_desc = "hemorrhagic stroke"
	gain_text = span_warning("Your head hurts really badly and your face feels numb!")
	lose_text = span_notice("Your head no longer hurts and you can feel your whole face.")
	/// Amount of organ damage caused per second
	var/brain_damage = 0.2 //as bad as the brain tumor quirk
	/// Sometimes the patient gets a limb paralyzed, we need to know that
	var/list/paralysis_traits

/datum/brain_trauma/severe/stroke/on_gain()
	ADD_TRAIT(owner, TRAIT_STROKE, TRAUMA_TRAIT)
	brain.flash_stroke_screen(owner)
	return ..()

/datum/brain_trauma/severe/stroke/on_lose()
	REMOVE_TRAIT(owner, TRAIT_STROKE, TRAUMA_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_ILLITERATE, STROKE_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_UNINTELLIGIBLE_SPEECH, STROKE_TRAIT)
	owner.remove_traits(list(TRAIT_PARALYSIS_R_ARM, TRAIT_PARALYSIS_L_ARM, TRAIT_PARALYSIS_R_LEG, TRAIT_PARALYSIS_L_LEG), TRAIT_STROKE)
	return ..()

/datum/brain_trauma/severe/stroke/on_life(seconds_per_tick, times_fired)
	. = ..()
	//no this is not a tumor, but lets give the user a break if he is tumor suppressed
	if(HAS_TRAIT(owner, TRAIT_TUMOR_SUPPRESSED))
		return
	brain?.apply_organ_damage(brain_damage * seconds_per_tick)
	if(SPT_PROB(5, seconds_per_tick))
		owner.set_slurring_if_lower(10 SECONDS)
	if(SPT_PROB(2.5, seconds_per_tick))
		switch(rand(1,13))
			if(1)
				owner.vomit(blood = TRUE, stun = TRUE)
				owner.adjust_disgust_effect(35)
			if(2,3)
				owner.adjust_dizzy(10 SECONDS)
			if(4,5)
				var/obj/item/organ/ears/ears = owner.get_organ_slot(ORGAN_SLOT_EARS)
				if(ears)
					ears.adjustEarDamage(ddeaf = 10)
			if(6,7)
				owner.adjust_temp_blindness(10 SECONDS)
				owner.set_eye_blur_if_lower(20 SECONDS)
			if(8,9)
				owner.adjust_confusion(10 SECONDS)
				owner.set_eye_blur_if_lower(20 SECONDS)
			if(10)
				var/list/possible_paralysis = list(
					TRAIT_PARALYSIS_R_ARM,
					TRAIT_PARALYSIS_L_ARM,
					TRAIT_PARALYSIS_R_LEG,
					TRAIT_PARALYSIS_L_LEG,
				)
				possible_paralysis -= paralysis_traits
				if(!length(possible_paralysis))
					return
				var/paralyzed_trait = pick(possible_paralysis)
				paralyze(owner, paralyzed_trait, 20 SECONDS)
			if(11)
				if(HAS_TRAIT(owner, TRAIT_NOBREATH))
					return
				owner.losebreath += 4
				owner.adjustOxyLoss(rand(20, 30))
				INVOKE_ASYNC(owner, TYPE_PROC_REF(/mob,emote), "gasp")
				to_chat(owner, span_warning("You struggle to breathe!"))
			if(12)
				var/funny_trait = pick(TRAIT_UNINTELLIGIBLE_SPEECH, TRAIT_ILLITERATE)
				if(funny_trait == TRAIT_UNINTELLIGIBLE_SPEECH)
					if(!HAS_TRAIT(owner, TRAIT_UNINTELLIGIBLE_SPEECH))
						to_chat(owner, span_warning("You can't seem to speak properly."))
				else
					if(!HAS_TRAIT(owner, TRAIT_ILLITERATE))
						to_chat(owner, span_warning("You lose your grasp on the written word."))
				ADD_TRAIT(owner, funny_trait, STROKE_TRAIT)
				addtimer(CALLBACK(src, PROC_REF(remove_funny_trait), owner, funny_trait), 20 SECONDS)
			if(13)
				to_chat(owner, span_warning("You faint."))
				owner.Unconscious(80)

/datum/brain_trauma/severe/stroke/proc/paralyze(mob/living/carbon/victim, list/paralysis, duration = 20 SECONDS)
	if(!islist(paralysis))
		paralysis = list(paralysis)
	LAZYINITLIST(paralysis_traits)
	for(var/paralysis_type in paralysis)
		paralysis_traits |= paralysis_type
		ADD_TRAIT(victim, paralysis_type, STROKE_TRAIT)
	if(duration)
		addtimer(CALLBACK(src, PROC_REF(unparalyze), victim, paralysis), duration)

/datum/brain_trauma/severe/stroke/proc/unparalyze(mob/living/carbon/victim, list/paralysis)
	if(QDELETED(victim) || QDELETED(src))
		return
	for(var/paralysis_type in paralysis)
		paralysis_traits -= paralysis_type
		REMOVE_TRAIT(victim, paralysis_type, STROKE_TRAIT)
	if(!length(paralysis_traits))
		paralysis_traits = null

/datum/brain_trauma/severe/stroke/proc/remove_funny_trait(mob/living/carbon/victim, funny_trait)
	if(QDELETED(victim) || QDELETED(src))
		return
	REMOVE_TRAIT(victim, funny_trait, STROKE_TRAIT)
	if(funny_trait == TRAIT_UNINTELLIGIBLE_SPEECH)
		if(!HAS_TRAIT(victim, TRAIT_UNINTELLIGIBLE_SPEECH))
			to_chat(owner, span_notice("You can speak properly again."))
	else
		if(!HAS_TRAIT(victim, TRAIT_ILLITERATE))
			to_chat(owner, span_notice("You regain your grasp on the written word."))

//blood brother version of stroke trauma, only gets cured once all brothers are revived
/datum/brain_trauma/severe/stroke/brother
	random_gain = FALSE
	resilience = TRAUMA_RESILIENCE_ABSOLUTE
	brain_damage = 0.3 //50% worse than a brain tumor, revive your brother ASAP!

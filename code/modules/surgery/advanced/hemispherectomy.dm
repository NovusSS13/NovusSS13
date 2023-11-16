GLOBAL_LIST_EMPTY(hemispherectomy_victims)

/datum/surgery/advanced/hemispherectomy
	name = "Hemispherectomy"
	desc = "A highly invasive and unethical surgical procedure, capable of curing not just brain traumas, but also anti-social personality traits. \
			This surgery has been commonly used to \"treat\" high-risk prisoners and psychotic patients, \
			even though it is known to cause horrifying side effects."
	surgery_flags = SURGERY_REQUIRE_RESTING | SURGERY_REQUIRE_LIMB | SURGERY_MORBID_CURIOSITY
	possible_locs = list(BODY_ZONE_HEAD)
	requires_bodypart_type = NONE
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/hemispherectomize,
		/datum/surgery_step/close,
	)

/datum/surgery/advanced/hemispherectomy/can_start(mob/user, mob/living/carbon/target)
	. = ..()
	if(!.)
		return FALSE
	var/obj/item/organ/brain/target_brain = target.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(!target_brain || HAS_TRAIT(target_brain, TRAIT_HEMISPHERECTOMITE) || HAS_TRAIT(target_brain, TRAIT_HEMISPHEREADDECTOMITE))
		return FALSE
	return TRUE

/datum/surgery_step/hemispherectomize
	name = "perform hemispherectomy (scalpel)"
	implements = list(
		TOOL_SCALPEL = 80,
		/obj/item/melee/energy/sword = 45,
		/obj/item/knife = 30,
		/obj/item = 20,
	)
	time = 100
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/scalpel2.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/hemispherectomize/tool_check(mob/user, obj/item/tool)
	if(implement_type == /obj/item && !(tool.get_sharpness() & SHARP_EDGED))
		return FALSE
	return TRUE

/datum/surgery_step/hemispherectomize/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("You begin to perform a hemispherectomy on [target]'s brain..."),
		span_notice("[user] begins to perform a hemispherectomy on [target]'s brain."),
		span_notice("[user] begins to perform surgery on [target]'s brain."),
	)
	display_pain(target, "Your head pounds with unimaginable pain!")

/datum/surgery_step/hemispherectomize/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(
		user,
		target,
		span_notice("You succeed in hemispherectomizing [target]."),
		span_notice("[user] successfully hemispherectomizes [target]!"),
		span_notice("[user] completes the surgery on [target]'s brain."),
	)
	var/obj/item/organ/brain/target_brain = target.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(target_brain)
		target_brain.hemispherectomize(user, trait_source = EXPERIMENTAL_SURGERY_TRAIT)
	target.cure_all_traumas(TRAUMA_RESILIENCE_LOBOTOMY)
	if(target.mind)
		var/list/antagonist_names = list()
		for(var/datum/antagonist/antagonist as anything in target.mind.antag_datums)
			if(!(antagonist.antag_flags & FLAG_ANTAG_HEMISPHERECTOMIZABLE))
				continue
			antagonist_names += antagonist.name
			target.mind.remove_antag_datum(antagonist)
		GLOB.hemispherectomy_victims[target.mind.name] = antagonist_names
		target.mind.wipe_memory()
	if(target.client)
		target.client.nuke_chat()

	var/static/list/confusion = list(
		"WHO AM I?",
		"WHAT AM I?",
		"WHERE AM I?",
		"GOD IS REAL!",
		"GOD IS DEAD!",
		"GOD IS COMING!",
		"BORN AGAIN!?",
		"TORN IN TWAIN!",
		"HOPE ERADICATED.",
		"God is not a man, that he should lie, nor a son of man, that he should change his mind.",
		"If your hand causes you to stumble, cut it off; it is better for you to enter life crippled, than, \
		having your two hands, to go into hell, into the unquenchable fire.",
		"All its land is brimstone and salt, a burning waste, unsown and unproductive, and no grass grows in it, \
		like the overthrow of Sodom and Gomorrah, Admah and Zeboiim, which the Lord overthrew in His anger and in His wrath.",
	)
	display_pain(target, pick(confusion)) //ensure confusion gets displayed after chat nuke

	var/traumatic_events = 1
	if(!HAS_MIND_TRAIT(target, TRAIT_SPECIAL_TRAUMA_BOOST))
		traumatic_events = rand(1, 2)
	for(var/i in 1 to traumatic_events)
		if(prob(80)) // Half of your brain is gone, let's see what kind of crippling brain damage you got as a gift!
			if(HAS_MIND_TRAIT(target, TRAIT_SPECIAL_TRAUMA_BOOST) && prob(50))
				target.gain_trauma_type(BRAIN_TRAUMA_SPECIAL, TRAUMA_RESILIENCE_MAGIC)
			else
				target.gain_trauma_type(BRAIN_TRAUMA_SEVERE, TRAUMA_RESILIENCE_MAGIC)
	if(target_brain)
		target_brain.flash_stroke_screen(target)
	return ..()

/datum/surgery_step/hemispherectomize/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/organ/brain/target_brain = target.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(target_brain)
		display_results(
			user,
			target,
			span_warning("You remove the wrong part, causing more damage!"),
			span_notice("[user] tears [target]'s brain apart!"),
			span_notice("[user] completes the surgery on [target]'s brain."),
		)
		display_pain(target, "The pain in your head is PURE AGONY!")
		target_brain.apply_organ_damage(80)
		switch(rand(1,3))
			if(1)
				target.gain_trauma_type(BRAIN_TRAUMA_MILD, TRAUMA_RESILIENCE_MAGIC)
			if(2)
				if(HAS_MIND_TRAIT(target, TRAIT_SPECIAL_TRAUMA_BOOST) && prob(50))
					target.gain_trauma_type(BRAIN_TRAUMA_SPECIAL, TRAUMA_RESILIENCE_MAGIC)
				else
					target.gain_trauma_type(BRAIN_TRAUMA_SEVERE, TRAUMA_RESILIENCE_MAGIC)
			if(3)
				target.gain_trauma_type(BRAIN_TRAUMA_SPECIAL, TRAUMA_RESILIENCE_MAGIC)
		target_brain.flash_stroke_screen(target)
	else
		user.visible_message(span_warning("[user] suddenly notices that the brain [user.p_they()] [user.p_were()] working on is not there anymore."), span_warning("You suddenly notice that the brain you were working on is not there anymore."))
	return FALSE

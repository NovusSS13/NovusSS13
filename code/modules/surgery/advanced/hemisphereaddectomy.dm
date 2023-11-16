/datum/surgery/advanced/hemisphereaddectomy
	name = "Hemisphereaddectomy"
	desc = "This surgery is the complete opposite of a hemispherectomy. \
			Unlike hemispherectomies, it has absolutely no therapeutic value and is only done for the sake of... \"Science\"."
	surgery_flags = SURGERY_REQUIRE_RESTING | SURGERY_REQUIRE_LIMB | SURGERY_MORBID_CURIOSITY
	possible_locs = list(BODY_ZONE_HEAD)
	requires_bodypart_type = NONE
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/hemisphereaddectomize,
		/datum/surgery_step/close,
	)

/datum/surgery/advanced/hemisphereaddectomy/can_start(mob/user, mob/living/carbon/target)
	. = ..()
	if(!.)
		return FALSE
	var/obj/item/organ/brain/target_brain = target.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(!target_brain || target_brain.hemispherectomized) //hemispherectomy is a one way street
		return FALSE
	return TRUE

/datum/surgery_step/hemisphereaddectomize
	name = "perform hemisphereaddectomy (brain hemisphere)"
	implements = list(
		/obj/item/hemisphere = 80,
	)
	time = 100
	repeatable = TRUE
	preop_sound = 'sound/surgery/organ2.ogg'
	success_sound = 'sound/surgery/organ1.ogg'

/datum/surgery_step/hemisphereaddectomize/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("You begin to graft [tool] onto [target]'s brain..."),
		span_notice("[user] begins to graft [tool] onto [target]'s brain."),
		span_notice("[user] begins to insert something into [target]'s brain."),
	)
	display_pain(target, "Your head pounds with unimaginable pain!")

/datum/surgery_step/hemisphereaddectomize/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(
		user,
		target,
		span_notice("You succeed in hemisphereaddectomizing [target]'s brain."),
		span_notice("[user] successfully hemisphereaddectomizes [target]'s brain!"),
		span_notice("[user] inserts something into [target]'s brain."),
	)
	display_pain(target, "You feel... agonizingly smart!")
	var/obj/item/organ/brain/target_brain = target.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(target_brain)
		target_brain.hemisphereaddectomize(user, tool)
		target_brain.flash_stroke_screen(target)
		//if there is no mind inhabiting the target, offer it to ghosts
		//or 10% chance for a ghost to take over entirely regardless, fuck you
		if((!target.key && !target.mind) || prob(10))
			if(target.key)
				to_chat(target, span_userdanger("You no longer feel like yourself!"))
				target.ghostize(FALSE)
			target.AddComponent(\
				/datum/component/ghost_direct_control, \
				poll_candidates = TRUE,\
				poll_length = 30 SECONDS,\
				role_name = "Hemisphereaddectomy Victim ([target])",\
				assumed_control_message = "You are a hemisphereaddectomy victim, suddenly given sentience through a frankensteinian surgical procedure.",\
				poll_ignore_key = POLL_IGNORE_HEMISPHEREADDECTOMY,\
			)
		//otherwise, small chance to give you split personality, this is half of someone's brain after all!
		else if(prob(20))
			target_brain.gain_trauma(/datum/brain_trauma/severe/split_personality, TRAUMA_RESILIENCE_HEMISPHERECTOMY)
	return ..()

/datum/surgery_step/hemisphereaddectomize/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/organ/brain/target_brain = target.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(target_brain)
		display_results(
			user,
			target,
			span_warning("You graft [tool] in the wrong place, causing more damage!"),
			span_notice("[user] successfully hemisphereaddectomizes [target]'s brain!"),
			span_notice("[user] completes the surgery on [target]'s brain."),
		)
		display_pain(target, "The pain in your head is PURE AGONY!")
		target_brain.apply_organ_damage(80)
		switch(rand(1,3))
			if(1)
				target.gain_trauma_type(BRAIN_TRAUMA_MILD, TRAUMA_RESILIENCE_LOBOTOMY)
			if(2)
				if(HAS_MIND_TRAIT(target, TRAIT_SPECIAL_TRAUMA_BOOST) && prob(50))
					target.gain_trauma_type(BRAIN_TRAUMA_SPECIAL, TRAUMA_RESILIENCE_LOBOTOMY)
				else
					target.gain_trauma_type(BRAIN_TRAUMA_SEVERE, TRAUMA_RESILIENCE_LOBOTOMY)
			if(3)
				target.gain_trauma_type(BRAIN_TRAUMA_SPECIAL, TRAUMA_RESILIENCE_LOBOTOMY)
		target_brain.flash_stroke_screen(target)
	else
		user.visible_message(span_warning("[user] suddenly notices that the brain [user.p_they()] [user.p_were()] working on is not there anymore."), span_warning("You suddenly notice that the brain you were working on is not there anymore."))
	return FALSE

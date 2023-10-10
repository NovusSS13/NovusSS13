/datum/interaction/romance
	icon = "heart"
	category = INTERACTION_CATEGORY_ROMANTIC
	interaction_flags = INTERACTION_COOLDOWN | INTERACTION_USER_LUST | INTERACTION_TARGET_LUST

/datum/interaction/romance/handholding
	name = "Handholding"
	desc = "Hold their hands. How lovely!"
	icon = "hands-helping"
	message = span_love("%USER holds %TARGET's hand.")
	user_message = span_love("You hold %TARGET's hand.")
	target_message = span_love("%USER holds your hand.")

/datum/interaction/romance/kisscheeks
	name = "Kiss Cheeks"
	desc = "Kiss them. On the cheek."
	icon = "kiss-beam"
	message = span_horny("%USER kisses %TARGET's cheek.")
	user_message = span_horny("You kiss %TARGET's cheek.")
	target_message = span_horny("%USER kisses your cheek.")

/datum/interaction/romance/kisscheeks/evaluate_user(datum/component/interactable/user, datum/component/interactable/target, silent)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/human_target = target.parent
	if(istype(human_target) && !human_target.get_bodypart(BODY_ZONE_HEAD))
		if(!silent)
			to_chat(user, span_warning("They have no head!"))
		return FALSE

/datum/interaction/romance/kisscheeks/evaluate_target(datum/component/interactable/user, datum/component/interactable/target, silent)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/human_target = target.parent
	if(istype(human_target) && !human_target.get_bodypart(BODY_ZONE_HEAD))
		if(!silent)
			to_chat(user, span_warning("They have no head!"))
		return FALSE

/datum/interaction/romance/kiss
	name = "Kiss"
	desc = "Kiss them. On their hot mouth."
	icon = "kiss-wink-heart"
	message = span_horny("%USER kisses %TARGET's lips.")
	user_message = span_horny("You kiss %TARGET's lips.")
	target_message = span_horny("%USER kisses your lips.")

/datum/interaction/romance/kiss/evaluate_user(datum/component/interactable/user, datum/component/interactable/target, silent)
	. = ..()
	if(!.)
		return
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/human_user = target.parent
	if(istype(human_user))
		if(!human_user.get_bodypart(BODY_ZONE_HEAD))
			if(!silent)
				to_chat(user, span_warning("You have no head!"))
			return FALSE
		if(human_user.is_mouth_covered())
			if(!silent)
				to_chat(user, span_warning("Your mouth is covered!"))
			return FALSE

/datum/interaction/romance/kiss/evaluate_target(datum/component/interactable/user, datum/component/interactable/target, silent)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/human_target = target.parent
	if(istype(human_target))
		if(!human_target.get_bodypart(BODY_ZONE_HEAD))
			if(!silent)
				to_chat(user, span_warning("They have no head!"))
			return FALSE
		if(human_target.is_mouth_covered())
			if(!silent)
				to_chat(user, span_warning("Their mouth is covered!"))
			return FALSE

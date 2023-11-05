/datum/interaction/friendly
	icon = "handshake"
	color = "good"
	category = INTERACTION_CATEGORY_FRIENDLY

/datum/interaction/friendly/handshake
	name = "Handshake"
	desc = "Shake their hands."
	icon = "handshake"
	message = span_notice("%USER shake%USER_S %TARGET's hand.")
	user_message = span_notice("You shake %TARGET's hand.")
	target_message = span_notice("%USER shake%USER_S your hand.")
	user_hands_required = 1
	target_hands_required = 1
	sounds = 'sound/weapons/thudswoosh.ogg'
	sound_vary = TRUE
	sound_extrarange = -1

/datum/interaction/friendly/hug
	name = "Hug"
	desc = "Give them a hug! How nice."
	icon = "grin-beam"
	message = span_notice("%USER hug%USER_S %TARGET.")
	user_message = span_notice("You hug %TARGET.")
	target_message = span_notice("%USER hug%USER_S you.")
	user_hands_required = 1
	sounds = 'sound/weapons/thudswoosh.ogg'
	sound_vary = TRUE
	sound_extrarange = -1

/*
/datum/interaction/friendly/hug/do_interaction(datum/component/interactable/user, datum/component/interactable/target)
	var/mob/living/carbon/human/human_target = target.parent
	human_target.hug_act(user.parent)
*/

/datum/interaction/friendly/headpat
	name = "Headpat"
	desc = "Pat their head! How nice."
	icon = "hand-paper"
	message = span_notice("%USER pat%USER_S %TARGET's head.")
	user_message = span_notice("You pat %TARGET's head.")
	target_message = span_notice("%USER pat%USER_S your head.")
	user_hands_required = 1
	sounds = 'sound/weapons/thudswoosh.ogg'
	sound_vary = TRUE
	sound_extrarange = -1

/datum/interaction/friendly/headpat/evaluate_target(datum/component/interactable/user, datum/component/interactable/target, silent = FALSE)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/human_target = target.parent
	if(istype(human_target) && !human_target.get_bodypart(BODY_ZONE_HEAD))
		if(!silent)
			to_chat(user, span_warning("[human_target.p_They()] have no head!"))
		return FALSE

/*
/datum/interaction/friendly/headpat/do_interaction(datum/component/interactable/user, datum/component/interactable/target)
	var/mob/living/carbon/human/human_target = target.parent
	human_target.headpat_act(user.parent)
*/

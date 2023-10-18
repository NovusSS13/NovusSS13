/datum/interaction/saygex/jerkoff
	name = "Jerk Off"
	desc = "Jerk your soldier off."
	icon = "fist-raised"
	usage_flags = INTERACTION_SELF
	message = list(
		span_love("%USER jerk%USER_S off."),
		span_love("%USER stroke%USER_S %USER_THEIR cock."),
		span_love("%USER caress%USER_ES %USER_THEIR penis."),
	)
	user_message = list(
		span_userlove("You jerk off."),
		span_userlove("You stroke your cock."),
		span_userlove("You caress your penis."),
	)
	sounds = list(
		'sound/saygex/handjob1.ogg',
		'sound/saygex/handjob2.ogg',
		'sound/saygex/handjob3.ogg',
		'sound/saygex/handjob4.ogg',
		'sound/saygex/handjob5.ogg',
		'sound/saygex/handjob6.ogg',
		'sound/saygex/handjob7.ogg',
		'sound/saygex/handjob8.ogg',
		'sound/saygex/handjob9.ogg',
		'sound/saygex/handjob10.ogg',
		'sound/saygex/handjob11.ogg',
		'sound/saygex/handjob12.ogg',
	)
	user_hands_required = 1

/datum/interaction/saygex/jerkoff/evaluate_user(datum/component/interactable/user, datum/component/interactable/target, silent = FALSE, check_cooldown = TRUE)
	. = ..()
	var/mob/living/carbon/human/human_user = user.parent
	var/obj/item/organ/genital/penis/penis = human_user.get_organ_slot(ORGAN_SLOT_PENIS)
	if(!penis?.bodypart_overlay?.can_draw_on_body(human_user.get_bodypart(penis.slot), human_user))
		return FALSE

/datum/interaction/saygex/jerkoff/perform_interaction_animation(datum/component/interactable/user, datum/component/interactable/target)
	. = ..()
	do_fucking_animation(user.parent)

/datum/interaction/saygex/jerkoff/handle_user_climax(datum/component/interactable/user, datum/component/interactable/target)
	var/mob/living/carbon/human/human_user = user.parent
	human_user.visible_message(span_love("<b>[human_user]</b> cum[human_user.p_s()] on [human_user.p_their()] hands!"), \
							span_userlove("I cum on my hands!"))
	var/cum_receiver = human_user
	if(human_user.gloves)
		cum_receiver = human_user.gloves
	for(var/obj/item/organ/genital/genital in human_user.organs)
		if(genital.can_climax)
			genital.handle_climax(cum_receiver, TOUCH, spill = TRUE)
	human_user.set_lust(0)
	return ..()

/datum/interaction/saygex/finger_self_vagina
	name = "Finger Your Vagina"
	desc = "Diddle your clit."
	icon = "hand-scissors"
	usage_flags = INTERACTION_SELF
	message = list(
		span_love("%USER stroke%USER_S %USER_THEIR clit."),
		span_love("%USER finger%USER_S %USER_THEIR vagina."),
		span_love("%USER caress%USER_ES %USER_THEIR pussy."),
	)
	user_message = list(
		span_userlove("You stroke your clit."),
		span_userlove("You finger your vagina."),
		span_userlove("You caress your pussy."),
	)
	sounds = list(
		'sound/saygex/handjob1.ogg',
		'sound/saygex/handjob2.ogg',
		'sound/saygex/handjob3.ogg',
		'sound/saygex/handjob4.ogg',
		'sound/saygex/handjob5.ogg',
		'sound/saygex/handjob6.ogg',
		'sound/saygex/handjob7.ogg',
		'sound/saygex/handjob8.ogg',
		'sound/saygex/handjob9.ogg',
		'sound/saygex/handjob10.ogg',
		'sound/saygex/handjob11.ogg',
		'sound/saygex/handjob12.ogg',
	)
	user_hands_required = 1

/datum/interaction/saygex/finger_self_vagina/evaluate_user(datum/component/interactable/user, datum/component/interactable/target, silent = FALSE, check_cooldown = TRUE)
	. = ..()
	var/mob/living/carbon/human/human_user = user.parent
	var/obj/item/organ/genital/vagina/vagina = human_user.get_organ_slot(ORGAN_SLOT_VAGINA)
	if(!vagina?.bodypart_overlay?.can_draw_on_body(human_user.get_bodypart(vagina.slot), human_user))
		return FALSE

/datum/interaction/saygex/finger_self_vagina/perform_interaction_animation(datum/component/interactable/user, datum/component/interactable/target)
	. = ..()
	do_fucking_animation(user.parent)

/datum/interaction/saygex/finger_self_vagina/handle_user_climax(datum/component/interactable/user, datum/component/interactable/target)
	var/mob/living/carbon/human/human_user = user.parent
	human_user.visible_message(span_love("<b>[human_user]</b> squirt[human_user.p_s()] on [human_user.p_their()] hands!"), \
							span_userlove("I squirt on my hands!"))
	var/cum_receiver = human_user
	if(human_user.gloves)
		cum_receiver = human_user.gloves
	for(var/obj/item/organ/genital/genital in human_user.organs)
		if(genital.can_climax)
			genital.handle_climax(cum_receiver, TOUCH, spill = TRUE)
	human_user.set_lust(0)
	return ..()

/datum/interaction/saygex/finger_self_anus
	name = "Finger Your Anus"
	desc = "Diddle your anus."
	icon = "hand-point-up"
	usage_flags = INTERACTION_SELF
	message = list(
		span_love("%USER finger%USER_S %USER_THEIR asshole."),
		span_love("%USER stroke%USER_S %USER_THEIR asshole."),
	)
	user_message = list(
		span_userlove("You finger your asshole."),
		span_userlove("You stroke your asshole."),
	)
	sounds = list(
		'sound/saygex/handjob1.ogg',
		'sound/saygex/handjob2.ogg',
		'sound/saygex/handjob3.ogg',
		'sound/saygex/handjob4.ogg',
		'sound/saygex/handjob5.ogg',
		'sound/saygex/handjob6.ogg',
		'sound/saygex/handjob7.ogg',
		'sound/saygex/handjob8.ogg',
		'sound/saygex/handjob9.ogg',
		'sound/saygex/handjob10.ogg',
		'sound/saygex/handjob11.ogg',
		'sound/saygex/handjob12.ogg',
	)
	user_hands_required = 1

/datum/interaction/saygex/finger_self_anus/evaluate_user(datum/component/interactable/user, datum/component/interactable/target, silent = FALSE, check_cooldown = TRUE)
	. = ..()
	var/mob/living/carbon/human/human_user = user.parent
	var/obj/item/organ/genital/anus/anus = human_user.get_organ_slot(ORGAN_SLOT_ANUS)
	if(!anus?.bodypart_overlay?.can_draw_on_body(human_user.get_bodypart(anus.slot), human_user))
		return FALSE

/datum/interaction/saygex/finger_self_anus/perform_interaction_animation(datum/component/interactable/user, datum/component/interactable/target)
	. = ..()
	do_fucking_animation(user.parent)

/datum/interaction/saygex/finger_self_anus/handle_user_climax(datum/component/interactable/user, datum/component/interactable/target)
	//whatever, generic climax handling
	var/mob/living/living_user = user.parent
	living_user.handle_climax()
	return ..()

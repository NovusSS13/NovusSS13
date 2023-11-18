/obj/item/organ/brain/psyker
	name = "psyker brain"
	desc = "This brain is blue and has immense psychic powers. What kind of monstrosity would use that?"
	icon_state = "brain-psyker"
	maxHealth = BRAIN_DAMAGE_DEATH * 1.5
	low_threshold = BRAIN_DAMAGE_DEATH * 1.5 * 0.225
	high_threshold = BRAIN_DAMAGE_DEATH * 1.5 * 0.6
	w_class = WEIGHT_CLASS_NORMAL
	actions_types = list(
		/datum/action/cooldown/spell/pointed/psychic_projection,
		/datum/action/cooldown/spell/charged/psychic_booster,
		/datum/action/cooldown/spell/forcewall/psychic_wall,
	)
	organ_traits = list(
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_LITERATE,
		TRAIT_CAN_STRIP,
		TRAIT_SPECIAL_TRAUMA_BOOST,
		TRAIT_MEGAMIND,
		TRAIT_ANTIMAGIC_NO_SELFBLOCK,
		TRAIT_BALD,
		TRAIT_SHAVED,
	)
	hemispherectomy_overlay = null
	megamind = TRUE

/obj/item/organ/brain/psyker/on_insert(mob/living/carbon/organ_owner, special = FALSE)
	. = ..()
	organ_owner.AddComponent(/datum/component/echolocation, blocking_trait = TRAIT_DUMB, echo_group = "psyker", echo_icon = "psyker", color_path = /datum/client_colour/psyker)
	organ_owner.AddComponent(/datum/component/anti_magic, antimagic_flags = MAGIC_RESISTANCE_MIND)

/obj/item/organ/brain/psyker/on_remove(mob/living/carbon/organ_owner, special = FALSE)
	. = ..()
	qdel(organ_owner.GetComponent(/datum/component/echolocation))
	qdel(organ_owner.GetComponent(/datum/component/anti_magic))

/obj/item/organ/brain/psyker/on_life(seconds_per_tick, times_fired)
	. = ..()
	if(HAS_TRAIT(owner, TRAIT_BIG_SKULL))
		return
	if(!SPT_PROB(2, seconds_per_tick))
		return
	var/head_name = "head"
	var/obj/item/bodypart/head = owner.get_bodypart(BODY_ZONE_HEAD)
	if(head)
		head_name = head.name
	to_chat(owner, span_userdanger("Your [head_name] hurts... It can't fit your [src]!"))
	owner.adjust_disgust_effect(5 * seconds_per_tick)
	apply_organ_damage(5 * seconds_per_tick, 199)

/obj/item/bodypart/head/psyker
	limb_id = BODYPART_ID_PSYKER
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	bodypart_traits = list(TRAIT_DISFIGURED, TRAIT_BIG_SKULL)
	biological_state = BIO_INORGANIC
	head_flags = HEAD_LIPS|HEAD_DEBRAIN

/// flavorful variant of psykerizing that deals damage and sends messages before calling psykerize()
/mob/living/carbon/human/proc/slow_psykerize()
	if(stat == DEAD || !get_bodypart(BODY_ZONE_HEAD) || istype(get_bodypart(BODY_ZONE_HEAD), /obj/item/bodypart/head/psyker))
		return
	to_chat(src, span_userdanger("You feel unwell..."))
	sleep(5 SECONDS)
	if(stat == DEAD || !get_bodypart(BODY_ZONE_HEAD))
		return
	to_chat(src, span_userdanger("You feel your skin ripping off!"))
	emote("scream")
	apply_damage(30, BRUTE, BODY_ZONE_HEAD)
	sleep(5 SECONDS)
	if(!psykerize())
		to_chat(src, span_warning("The transformation subsides..."))
		return
	var/obj/item/bodypart/head/psyker_head = get_bodypart(BODY_ZONE_HEAD)
	psyker_head.receive_damage(brute = 50)
	to_chat(src, span_userdanger("Your head splits open! Your brain mutates!"))
	new /obj/effect/gibspawner/generic(drop_location(), src)
	emote("scream")

/// Proc with no side effects that turns someone into a psyker. returns FALSE if it could not psykerize.
/mob/living/carbon/human/proc/psykerize()
	var/obj/item/bodypart/head/old_head = get_bodypart(BODY_ZONE_HEAD)
	var/obj/item/organ/brain/old_brain = get_organ_slot(ORGAN_SLOT_BRAIN)
	var/obj/item/organ/old_eyes = get_organ_slot(ORGAN_SLOT_EYES)
	if(stat == DEAD || !old_head || !old_brain)
		return FALSE
	var/obj/item/bodypart/head/psyker/psyker_head = new()
	if(!psyker_head.replace_limb(src, special = TRUE))
		return FALSE
	var/obj/item/organ/brain/psyker/psyker_brain = new()
	psyker_brain.replace_into(src, drop_if_replaced = FALSE)
	if(old_eyes)
		var/atom/Tsec = drop_location()
		old_eyes.Remove(src, special = FALSE)
		old_eyes.forceMove(Tsec)
		old_eyes.fly_away(Tsec)
	qdel(old_head)
	return TRUE

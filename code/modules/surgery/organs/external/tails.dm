///Tail parent, it doesn't do very much.
/obj/item/organ/tail
	name = "tail"
	desc = "A severed tail. What did you cut this off of?"
	icon = 'icons/obj/medical/organs/external_organs.dmi'
	icon_state = "tail"

	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_EXTERNAL_TAIL

	visual = TRUE
	process_life = FALSE
	process_death = FALSE

	dna_block = DNA_TAIL_BLOCK
	restyle_flags = EXTERNAL_RESTYLE_FLESH
	bodypart_overlay = /datum/bodypart_overlay/mutant/tail

	/// Does this tail have a wagging sprite, and is it currently wagging?
	var/wag_flags = NONE
	/// The original owner of this tail
	var/original_owner //Yay, snowflake code!
	/// A reference to the paired_spines, since for some fucking reason tail spines are tied to the spines themselves.
	var/obj/item/organ/spines/paired_spines

/obj/item/organ/tail/Insert(mob/living/carbon/receiver, special, drop_if_replaced)
	. = ..()
	if(.)
		RegisterSignal(receiver, COMSIG_ORGAN_WAG_TAIL, PROC_REF(wag))
		original_owner ||= WEAKREF(receiver)

		receiver.clear_mood_event("tail_lost")
		receiver.clear_mood_event("tail_balance_lost")

		if(IS_WEAKREF_OF(receiver, original_owner))
			receiver.clear_mood_event("wrong_tail_regained")
		else if(receiver.dna.species.cosmetic_organs && (receiver.dna.species.cosmetic_organs[type] != SPRITE_ACCESSORY_NONE))
			receiver.add_mood_event("wrong_tail_regained", /datum/mood_event/tail_regained_wrong)

		paired_spines = receiver.get_organ_slot(ORGAN_SLOT_EXTERNAL_SPINES)
		RegisterSignal(receiver, COMSIG_CARBON_GAIN_ORGAN, PROC_REF(check_for_spines))
		RegisterSignal(receiver, COMSIG_CARBON_LOSE_ORGAN, PROC_REF(check_for_spines_loss))

/obj/item/organ/tail/Remove(mob/living/carbon/organ_owner, special, moving)
	if(wag_flags & WAG_WAGGING)
		wag(FALSE)
	. = ..()
	if(paired_spines)
		paired_spines = null
	UnregisterSignal(organ_owner, COMSIG_ORGAN_WAG_TAIL)
	UnregisterSignal(organ_owner, COMSIG_CARBON_GAIN_ORGAN)
	UnregisterSignal(organ_owner, COMSIG_CARBON_LOSE_ORGAN)
	if(organ_owner.dna.species.cosmetic_organs[type] && (organ_owner.dna.species.cosmetic_organs[type] != SPRITE_ACCESSORY_NONE))
		organ_owner.add_mood_event("tail_lost", /datum/mood_event/tail_lost)
		organ_owner.add_mood_event("tail_balance_lost", /datum/mood_event/tail_balance_lost)

/// Checks if the tail gained spines so we can pair!
/obj/item/organ/tail/proc/check_for_spines(mob/living/carbon/source, obj/item/organ/organ)
	SIGNAL_HANDLER

	if(!istype(organ, /obj/item/organ/tail))
		return
	paired_spines = organ

/// Checks if the tail LOST the spines!
/obj/item/organ/tail/proc/check_for_spines_loss(mob/living/carbon/source, obj/item/organ/organ)
	SIGNAL_HANDLER

	if(paired_spines == organ)
		paired_spines = null

/obj/item/organ/tail/proc/wag(mob/user, start = TRUE, stop_after = 0)
	if(!(wag_flags & WAG_ABLE))
		return

	if(start)
		start_wag()
		if(stop_after)
			addtimer(CALLBACK(src, PROC_REF(wag), FALSE), stop_after, TIMER_STOPPABLE|TIMER_DELETE_ME)
	else
		stop_wag()
	owner.update_body_parts()

/// We need some special behaviour for accessories, wrapped here so we can easily add more interactions later
/obj/item/organ/tail/proc/start_wag()
	var/datum/bodypart_overlay/mutant/tail/accessory = bodypart_overlay
	wag_flags |= WAG_WAGGING
	accessory.wagging = TRUE
	if(paired_spines)
		var/datum/bodypart_overlay/mutant/spines/spines_accessory = paired_spines.bodypart_overlay
		spines_accessory.wagging = TRUE

/// We need some special behaviour for accessories, wrapped here so we can easily add more interactions later
/obj/item/organ/tail/proc/stop_wag()
	var/datum/bodypart_overlay/mutant/tail/accessory = bodypart_overlay
	wag_flags &= ~WAG_WAGGING
	accessory.wagging = FALSE
	if(paired_spines)
		var/datum/bodypart_overlay/mutant/spines/spines_accessory = paired_spines.bodypart_overlay
		spines_accessory.wagging = FALSE

/// Tail parent type (which is MONKEEEEEEEEEEE by default), with wagging functionality
/datum/bodypart_overlay/mutant/tail
	layers = EXTERNAL_FRONT | EXTERNAL_BEHIND
	color_source = ORGAN_COLOR_DNA
	feature_key = "tail"
	feature_color_key = "tail_color"
	/// Whether or not the tail is wagging
	var/wagging = FALSE

/datum/bodypart_overlay/mutant/tail/get_global_feature_list()
	return GLOB.tails_list

/datum/bodypart_overlay/mutant/tail/get_base_icon_state()
	var/datum/sprite_accessory/tails/wagger = sprite_datum
	return ((wagging && wagger.can_wag) ? "wagging_" : "") + sprite_datum.icon_state //add the wagging tag if we be wagging

/datum/bodypart_overlay/mutant/tail/can_draw_on_body(obj/item/bodypart/ownerlimb, mob/living/carbon/human/owner)
	if(owner.wear_suit?.flags_inv & HIDEJUMPSUIT)
		return FALSE

	return TRUE

/obj/item/organ/tail/mutant
	name = "mutant tail"
	icon_state = "tail-furry"

	bodypart_overlay = /datum/bodypart_overlay/mutant/tail/mutant

/datum/bodypart_overlay/mutant/tail/mutant

/obj/item/organ/tail/cat
	name = "cat tail"
	desc = "A severed cat tail. It doesn't seem to come from an actual cat..."

	bodypart_overlay = /datum/bodypart_overlay/mutant/tail/cat
	wag_flags = WAG_ABLE

/// Cat tail bodypart overlay
/datum/bodypart_overlay/mutant/tail/cat

/datum/bodypart_overlay/mutant/tail/cat/get_global_feature_list()
	return GLOB.tails_list_human

/obj/item/organ/tail/monkey
	name = "monkey tail"
	desc = "A severed monkey tail. Animal cruelty is a serious crime, you know."

	bodypart_overlay = /datum/bodypart_overlay/mutant/tail/monkey
	sprite_accessory_override = /datum/sprite_accessory/tails/monkey/default

/// Monkey tail bodypart overlay
/datum/bodypart_overlay/mutant/tail/monkey

/datum/bodypart_overlay/mutant/tail/monkey/get_base_icon_state() // WE DON'T HAVE ONE MOTHERFUCKER
	return

/datum/bodypart_overlay/mutant/tail/monkey/get_global_feature_list()
	return GLOB.tails_list_monkey

/obj/item/organ/tail/lizard
	name = "lizard tail"
	desc = "A severed lizard tail. Somewhere, no doubt, a lizard hater is very pleased with themselves."

	bodypart_overlay = /datum/bodypart_overlay/mutant/tail/lizard
	wag_flags = WAG_ABLE

/// Lizard tail bodypart overlay datum
/datum/bodypart_overlay/mutant/tail/lizard

/datum/bodypart_overlay/mutant/tail/lizard/get_global_feature_list()
	return GLOB.tails_list_lizard

/obj/item/organ/tail/lizard/fake
	name = "fabricated lizard tail"
	desc = "A fabricated severed lizard tail. This one's made of synthflesh. Probably not usable for lizard wine."

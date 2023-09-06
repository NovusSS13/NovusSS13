/// Spines (those things on a lizard's back), but also including tail spines (gasp)
/obj/item/organ/spines
	name = "spines"
	desc = "Not THE spine, spines."
	gender = PLURAL
	icon_state = "spines"

	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_EXTERNAL_SPINES

	visual = TRUE
	process_life = FALSE
	process_death = FALSE

	preference = "feature_lizard_spines"
	dna_block = DNA_SPINES_BLOCK
	restyle_flags = EXTERNAL_RESTYLE_FLESH
	bodypart_overlay = /datum/bodypart_overlay/mutant/spines

	///A two-way reference between the tail and the spines because of wagging sprites. Bruh.
	var/obj/item/organ/tail/lizard/paired_tail

/obj/item/organ/spines/Insert(mob/living/carbon/receiver, special, drop_if_replaced)
	. = ..()
	if(.)
		paired_tail = receiver.get_organ_slot(ORGAN_SLOT_EXTERNAL_TAIL)
		RegisterSignal(receiver, COMSIG_CARBON_GAIN_ORGAN, PROC_REF(check_for_tail))
		RegisterSignal(receiver, COMSIG_CARBON_LOSE_ORGAN, PROC_REF(check_for_tail_loss))

/obj/item/organ/spines/Remove(mob/living/carbon/organ_owner, special, moving)
	. = ..()
	var/datum/bodypart_overlay/mutant/spines/accessory = bodypart_overlay
	accessory.wagging = FALSE
	if(paired_tail)
		paired_tail = null
	UnregisterSignal(organ_owner, COMSIG_CARBON_GAIN_ORGAN)
	UnregisterSignal(organ_owner, COMSIG_CARBON_LOSE_ORGAN)

/// Checks if the spines gained a tail so we can pair!
/obj/item/organ/spines/proc/check_for_tail(mob/living/carbon/source, obj/item/organ/organ)
	SIGNAL_HANDLER

	if(!istype(organ, /obj/item/organ/tail))
		return
	paired_tail = organ
	paired_tail.paired_spines = src

/// Checks if the spines LOST the tail!
/obj/item/organ/spines/proc/check_for_tail_loss(mob/living/carbon/source, obj/item/organ/organ)
	SIGNAL_HANDLER

	if(paired_tail == organ)
		var/datum/bodypart_overlay/mutant/spines/accessory = bodypart_overlay
		accessory.wagging = FALSE
		paired_tail.paired_spines = null
		paired_tail = null

/// Bodypart overlay for spines (wagging gets updated by tail)
/datum/bodypart_overlay/mutant/spines
	layers = EXTERNAL_ADJACENT|EXTERNAL_BEHIND
	color_source = ORGAN_COLOR_DNA
	feature_key = "spines"
	feature_color_key = "spines_color"
	/// Spines wag with the tail, so track it
	var/wagging = FALSE

/datum/bodypart_overlay/mutant/spines/get_global_feature_list()
	return GLOB.spines_list

/datum/bodypart_overlay/mutant/spines/get_base_icon_state()
	return (wagging ? "wagging" : "") + sprite_datum.icon_state //add the wagging tag if we be wagging

/datum/bodypart_overlay/mutant/spines/can_draw_on_bodypart(mob/living/carbon/human/human)
	. = ..()
	if(human.wear_suit && (human.wear_suit.flags_inv & HIDEJUMPSUIT))
		return FALSE

/// Subtype used exclusively by lizards
/obj/item/organ/spines/lizard
	name = "lizard spines"

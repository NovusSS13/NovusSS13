/// A snout
/obj/item/organ/snout
	name = "snout"
	desc = "Take a closer look at that snout!"
	icon_state = "snout"

	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_SNOUT

	visual = TRUE
	process_life = FALSE
	process_death = FALSE

	external_bodytypes = BODYTYPE_SNOUTED
	dna_block = DNA_SNOUT_BLOCK
	restyle_flags = EXTERNAL_RESTYLE_FLESH

	bodypart_overlay = /datum/bodypart_overlay/mutant/snout

/datum/bodypart_overlay/mutant/snout
	layers = EXTERNAL_ADJACENT
	color_source = ORGAN_COLOR_DNA
	feature_key = "snout"
	feature_color_key = "snout_color"

/datum/bodypart_overlay/mutant/snout/can_draw_on_bodypart(mob/living/carbon/human/human)
	if((human.wear_mask?.flags_inv & HIDESNOUT) || (human.head?.flags_inv & HIDESNOUT))
		return FALSE

	return TRUE

/datum/bodypart_overlay/mutant/snout/get_global_feature_list()
	return GLOB.snouts_list

/// A lizard's snout
/obj/item/organ/snout/lizard
	name = "lizard snout"
	preference = "feature_lizard_snout"

	bodypart_overlay = /datum/bodypart_overlay/mutant/snout

/datum/bodypart_overlay/mutant/snout

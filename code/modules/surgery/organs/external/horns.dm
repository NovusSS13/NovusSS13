/// Generic horns
/obj/item/organ/horns
	name = "horns"
	desc = "Someone was a little too horny."
	icon_state = "horns"

	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_HORNS

	visual = TRUE
	process_life = FALSE
	process_death = FALSE

	preference = "feature_lizard_horns"
	dna_block = DNA_HORNS_BLOCK
	restyle_flags = EXTERNAL_RESTYLE_ENAMEL

	bodypart_overlay = /datum/bodypart_overlay/mutant/horns

/datum/bodypart_overlay/mutant/horns
	layers = EXTERNAL_ADJACENT
	color_source = ORGAN_COLOR_DNA
	feature_key = "horns"
	feature_color_key = "horns_color"

/datum/bodypart_overlay/mutant/horns/can_draw_on_bodypart(mob/living/carbon/human/human)
	if((human.head?.flags_inv & HIDEHAIR) || (human.wear_mask?.flags_inv & HIDEHAIR))
		return FALSE

	return TRUE

/datum/bodypart_overlay/mutant/horns/get_global_feature_list()
	return GLOB.horns_list

/// The horns of a lizard
/obj/item/organ/horns/lizard
	name = "lizard horns"
	desc = "Why do lizards even have horns? Well, this one obviously doesn't."
	bodypart_overlay = /datum/bodypart_overlay/mutant/horns/lizard

/datum/bodypart_overlay/mutant/horns/lizard

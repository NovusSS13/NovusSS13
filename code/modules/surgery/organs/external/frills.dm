/// The frills of a lizard (like weird fin ears)
/obj/item/organ/frills
	name = "frills"
	desc = "Ear-like external organs often seen on aquatic reptillians."
	icon_state = "frills"

	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_FRILLS

	visual = TRUE
	process_life = FALSE
	process_death = FALSE

	preference = "feature_lizard_frills"
	dna_block = DNA_FRILLS_BLOCK
	restyle_flags = EXTERNAL_RESTYLE_FLESH

	bodypart_overlay = /datum/bodypart_overlay/mutant/frills

/datum/bodypart_overlay/mutant/frills
	layers = EXTERNAL_ADJACENT
	color_source = ORGAN_COLOR_DNA
	feature_key = "frills"
	feature_color_key = "frills_color"

/datum/bodypart_overlay/mutant/frills/can_draw_on_body(obj/item/bodypart/ownerlimb, mob/living/carbon/human/owner)
	if(!(owner.head?.flags_inv & HIDEEARS))
		return TRUE

	return FALSE

/datum/bodypart_overlay/mutant/frills/get_global_feature_list()
	return GLOB.frills_list

/// Actual subtype used by lizards
/obj/item/organ/frills/lizard
	bodypart_overlay = /datum/bodypart_overlay/mutant/frills/lizard

/datum/bodypart_overlay/mutant/frills/lizard

/datum/bodypart_overlay/mutant/frills/lizard/get_global_feature_list()
	return GLOB.frills_list_lizard

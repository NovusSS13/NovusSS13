/// The frills of a lizard (like weird fin ears)
/obj/item/organ/frills
	name = "frills"
	desc = "Ear-like external organs often seen on aquatic reptillians."
	icon = 'icons/obj/medical/organs/external_organs.dmi'
	icon_state = "frills"

	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_FRILLS

	visual = TRUE
	process_life = FALSE
	process_death = FALSE

	dna_block = DNA_FRILLS_BLOCK
	restyle_flags = EXTERNAL_RESTYLE_FLESH

	inherit_color = TRUE
	bodypart_overlay = /datum/bodypart_overlay/mutant/frills

/datum/bodypart_overlay/mutant/frills
	layers = EXTERNAL_FRONT
	color_source = ORGAN_COLOR_DNA
	feature_key = "frills"
	feature_color_key = "frills_color"

/datum/bodypart_overlay/mutant/frills/can_draw_on_body(obj/item/bodypart/ownerlimb, mob/living/carbon/human/owner)
	if((owner.head?.flags_inv & HIDEEARS) || (owner.wear_mask?.flags_inv & HIDEEARS))
		return FALSE

	return TRUE

/datum/bodypart_overlay/mutant/frills/get_global_feature_list()
	return GLOB.frills_list

/obj/item/organ/frills/mutant
	name = "mutant frills"

	bodypart_overlay = /datum/bodypart_overlay/mutant/frills/mutant

/datum/bodypart_overlay/mutant/frills/mutant

/// Actual subtype used by lizards
/obj/item/organ/frills/lizard
	name = "lizard frills"

	bodypart_overlay = /datum/bodypart_overlay/mutant/frills/lizard

/datum/bodypart_overlay/mutant/frills/lizard

/datum/bodypart_overlay/mutant/frills/lizard/get_global_feature_list()
	return GLOB.frills_list_lizard

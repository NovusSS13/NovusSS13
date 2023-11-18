///Wing base type. doesn't really do anything
/obj/item/organ/wings
	name = "wings"
	desc = "Spread your wings and FLLLLLLLLYYYYY!"
	gender = PLURAL

	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_EXTERNAL_WINGS

	visual = TRUE
	process_life = FALSE
	process_death = FALSE

	use_mob_sprite_as_obj_sprite = TRUE
	bodypart_overlay = /datum/bodypart_overlay/mutant/wings

///Checks if the wings can soften short falls
/obj/item/organ/wings/proc/can_soften_fall()
	return TRUE

///Bodypart overlay of default wings. Does not have any wing functionality
/datum/bodypart_overlay/mutant/wings
	layers = EXTERNAL_BEHIND | EXTERNAL_ADJACENT | EXTERNAL_FRONT
	feature_key = "wings"

/datum/bodypart_overlay/mutant/wings/get_global_feature_list()
	return GLOB.wings_list

/datum/bodypart_overlay/mutant/wings/can_draw_on_body(obj/item/bodypart/ownerlimb, mob/living/carbon/human/owner)
	if(owner.wear_suit)
		if(!(owner.wear_suit.flags_inv & HIDEJUMPSUIT))
			return TRUE
		else if(owner.wear_suit.species_exception && is_type_in_list(src, owner.wear_suit.species_exception))
			return TRUE
		else
			return FALSE
	return TRUE



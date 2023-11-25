/// A moth's antennae
/obj/item/organ/antennae
	name = "moth antennae"
	desc = "A moths antennae. What is it telling them? What are they sensing?"
	icon = 'icons/obj/medical/organs/external_organs.dmi'
	icon_state = "antennae"

	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_ANTENNAE

	visual = TRUE
	process_life = FALSE
	process_death = FALSE

	dna_block = DNA_MOTH_ANTENNAE_BLOCK
	restyle_flags = EXTERNAL_RESTYLE_FLESH

	bodypart_overlay = /datum/bodypart_overlay/mutant/antennae

	organ_traits = list(TRAIT_ANTENNAE)

	///Are we burned?
	var/burnt = FALSE
	///Store our old datum here for if our antennae are healed
	var/original_sprite_datum

/obj/item/organ/antennae/Insert(mob/living/carbon/receiver, special, drop_if_replaced)
	. = ..()
	if(!.)
		return
	RegisterSignal(receiver, COMSIG_HUMAN_BURNING, PROC_REF(try_burn_antennae))
	RegisterSignal(receiver, COMSIG_LIVING_POST_FULLY_HEAL, PROC_REF(heal_antennae))

/obj/item/organ/antennae/Remove(mob/living/carbon/organ_owner, special, moving)
	. = ..()
	UnregisterSignal(organ_owner, list(COMSIG_HUMAN_BURNING, COMSIG_LIVING_POST_FULLY_HEAL))

/// check if our antennae can burn off ;_;
/obj/item/organ/antennae/proc/try_burn_antennae(mob/living/carbon/human/human)
	SIGNAL_HANDLER

	if(!burnt && human.bodytemperature >= 800 && human.fire_stacks > 0) //do not go into the extremely hot light. you will not survive
		to_chat(human, span_danger("Your precious antennae burn to a crisp!"))

		burn_antennae()
		human.update_body_parts()

/// Burn our antennae off ;_;
/obj/item/organ/antennae/proc/burn_antennae()
	var/datum/bodypart_overlay/mutant/antennae/antennae = bodypart_overlay
	antennae.burnt = TRUE
	burnt = TRUE

/// heal our antennae back up!!
/obj/item/organ/antennae/proc/heal_antennae(datum/source, heal_flags)
	SIGNAL_HANDLER

	if(!burnt)
		return

	if(heal_flags & (HEAL_LIMBS|HEAL_ORGANS))
		var/datum/bodypart_overlay/mutant/antennae/antennae = bodypart_overlay
		antennae.burnt = FALSE
		burnt = FALSE

/// Moth antennae datum, with full burning functionality
/datum/bodypart_overlay/mutant/antennae
	layers = EXTERNAL_FRONT | EXTERNAL_BEHIND
	feature_key = "moth_antennae"
	/// Accessory datum of the burn sprite
	var/datum/sprite_accessory/burn_datum = /datum/sprite_accessory/moth_antennae/burnt_off
	/// Are we burned? If so we draw differently
	var/burnt = FALSE

/datum/bodypart_overlay/mutant/antennae/New()
	. = ..()
	burn_datum = fetch_sprite_datum(burn_datum) //turn the path into the singleton instance

/datum/bodypart_overlay/mutant/antennae/get_global_feature_list()
	return GLOB.moth_antennae_list

/datum/bodypart_overlay/mutant/antennae/get_base_icon_state()
	return burnt ? burn_datum.icon_state : sprite_datum.icon_state

/// The leafy hair of a podperson
/obj/item/organ/pod_hair
	name = "podperson hair"
	desc = "Base for many salads."

	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_POD_HAIR

	visual = TRUE
	process_life = FALSE
	process_death = FALSE

	dna_block = DNA_POD_HAIR_BLOCK
	restyle_flags = EXTERNAL_RESTYLE_PLANT

	use_mob_sprite_as_obj_sprite = TRUE
	bodypart_overlay = /datum/bodypart_overlay/mutant/pod_hair

	organ_traits = list(TRAIT_PLANT_SAFE)

/// Podperson bodypart overlay, with special coloring functionality to render the flowers in the inverse color
/datum/bodypart_overlay/mutant/pod_hair
	layers = EXTERNAL_ADJACENT | EXTERNAL_FRONT
	feature_key = "pod_hair"

	/// This layer will be colored differently than the rest of the organ. So we can get differently colored flowers or something
	var/color_swapped_layer = EXTERNAL_FRONT
	/// The individual rgb colors are subtracted from this to get the color shifted layer
	var/color_inverse_base = 255

/datum/bodypart_overlay/mutant/pod_hair/get_global_feature_list()
	return GLOB.pod_hair_list

/datum/bodypart_overlay/mutant/pod_hair/color_image(list/overlays, layer, obj/item/bodypart/limb)
	if(layer != external_bitflag_to_layer(color_swapped_layer))
		return ..()

	var/sane_draw_color
	if(islist(draw_color))
		sane_draw_color = sanitize_hexcolor(draw_color[length(draw_color)], DEFAULT_HEX_COLOR_LEN, TRUE, "#FFFFFF")
	else
		sane_draw_color = draw_color
	for(var/image/overlay in overlays)
		if(draw_color)
			var/list/rgb_list = rgb2num(sane_draw_color)
			overlay.color = rgb(color_inverse_base - rgb_list[1], color_inverse_base - rgb_list[2], color_inverse_base - rgb_list[3]) //inversa da color
		else
			overlay.color = null

/datum/bodypart_overlay/mutant/pod_hair/can_draw_on_body(obj/item/bodypart/ownerlimb, mob/living/carbon/human/owner)
	if((owner.head?.flags_inv & HIDEHAIR) || (owner.wear_mask?.flags_inv & HIDEHAIR))
		return FALSE

	return TRUE

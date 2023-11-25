/obj/item/bodypart/head
	name = BODY_ZONE_HEAD
	desc = "Didn't make sense not to live for fun, your brain gets smart but your head gets dumb."
	icon = 'icons/mob/species/human/bodyparts.dmi'
	icon_state = "default_human_head"
	max_damage = 200
	body_zone = BODY_ZONE_HEAD
	body_part = HEAD
	plaintext_zone = "head"
	w_class = WEIGHT_CLASS_BULKY //Quite a hefty load
	slowdown = 1 //Balancing measure
	throw_range = 2 //No head bowling
	px_x = 0
	px_y = -8
	wound_resistance = 5
	maxdamage_wound_penalty = 25
	scars_covered_by_clothes = FALSE
	grind_results = null
	is_dimorphic = TRUE
	unarmed_attack_verb = "bite"
	unarmed_attack_effect = ATTACK_EFFECT_BITE
	unarmed_attack_sound = 'sound/weapons/bite.ogg'
	unarmed_miss_sound = 'sound/weapons/bite.ogg'
	unarmed_damage_low = 1 // Yeah, biteing is pretty weak, blame the monkey super-nerf
	unarmed_damage_high = 3
	unarmed_stun_threshold = 4
	bodypart_trait_source = HEAD_TRAIT

	var/mob/living/brain/brainmob //The current occupant.
	var/obj/item/organ/brain/brain //The brain organ
	var/obj/item/organ/eyes/eyes
	var/obj/item/organ/ears/ears
	var/obj/item/organ/tongue/tongue

	/// Do we show the information about missing organs upon being examined? Defaults to TRUE, useful for Dullahan heads.
	var/show_organs_on_examine = TRUE

	//Limb appearance info:
	/// Replacement name
	var/real_name = ""
	/// Flags related to appearance, such as hair, lips, etc
	var/head_flags = HEAD_ALL_FLAGS

	/// Custom icon for the eyes overlay.
	var/custom_eyes_icon = null

	/// Hair style
	var/hairstyle = "Bald"
	/// Hair colour and style
	var/hair_color = "#000000"
	/// Hair alpha
	var/hair_alpha = 255
	/// Is the hair currently hidden by something?
	var/hair_hidden = FALSE

	///Facial hair style
	var/facial_hairstyle = "Shaved"
	///Facial hair color
	var/facial_hair_color = "#000000"
	///Is the facial hair currently hidden by something?
	var/facial_hair_hidden = FALSE

	/// Gradient styles, if any
	var/list/gradient_styles = null
	/// Gradient colors, if any
	var/list/gradient_colors = null

	/// An override color that can be cleared later, affects both hair and facial hair
	var/override_hair_color = null
	/// An override that cannot be cleared under any circumstances, affects both hair and facial hair
	var/fixed_hair_color = null

	///Type of lipstick being used, basically
	var/lip_style
	///Lipstick color
	var/lip_color
	///Current lipstick trait, if any (such as TRAIT_KISS_OF_DEATH)
	var/stored_lipstick_trait

	/// Draw this head as "debrained"
	VAR_PROTECTED/show_debrained = FALSE
	/// Draw this head as missing eyes
	VAR_PROTECTED/show_eyeless = FALSE

	/// Offset to apply to equipment worn on the ears
	var/datum/worn_feature_offset/worn_ears_offset
	/// Offset to apply to equipment worn on the eyes
	var/datum/worn_feature_offset/worn_glasses_offset
	/// Offset to apply to equipment worn on the mouth
	var/datum/worn_feature_offset/worn_mask_offset
	/// Offset to apply to equipment worn on the head
	var/datum/worn_feature_offset/worn_head_offset
	/// Offset to apply to overlays placed on the face
	var/datum/worn_feature_offset/worn_face_offset

/obj/item/bodypart/head/Destroy()
	QDEL_NULL(brainmob) //order is sensitive, see warning in handle_atom_del() below
	QDEL_NULL(brain)
	QDEL_NULL(eyes)
	QDEL_NULL(ears)
	QDEL_NULL(tongue)

	QDEL_NULL(worn_ears_offset)
	QDEL_NULL(worn_glasses_offset)
	QDEL_NULL(worn_mask_offset)
	QDEL_NULL(worn_head_offset)
	QDEL_NULL(worn_face_offset)
	return ..()

/obj/item/bodypart/head/handle_atom_del(atom/head_atom)
	if(head_atom == brain)
		brain = null
		update_icon_dropped()
		if(!QDELETED(brainmob)) //this shouldn't happen without badminnery.
			message_admins("Brainmob: ([ADMIN_LOOKUPFLW(brainmob)]) was left stranded in [src] at [ADMIN_VERBOSEJMP(src)] without a brain!")
			brainmob.log_message(", brainmob, was left stranded in [src] without a brain", LOG_GAME)
	if(head_atom == brainmob)
		brainmob = null
	if(head_atom == eyes)
		eyes = null
		update_icon_dropped()
	if(head_atom == ears)
		ears = null
	if(head_atom == tongue)
		tongue = null
	return ..()

/obj/item/bodypart/head/examine(mob/user)
	. = ..()
	if(!show_organs_on_examine)
		return
	if(!brain)
		. += span_deadsay("The brain has been removed from [src].")
	else if(brain.suicided || (brainmob && HAS_TRAIT(brainmob, TRAIT_SUICIDED)))
		. += span_warning("There's a miserable expression on [real_name]'s face; they must have really hated life. There's no hope of recovery.")
	else if(brainmob?.health <= HEALTH_THRESHOLD_DEAD)
		. += span_warning("It's leaking some kind of... clear fluid? The brain inside must be in pretty bad shape.")
	else if(brainmob)
		if(brainmob.key || brainmob.get_ghost(FALSE, TRUE))
			. += span_notice("Its muscles are twitching slightly... It seems to have some life still in it.")
		else
			. += span_deadsay("It's completely lifeless. Perhaps there'll be a chance for them later.")
	else if(brain?.decoy_override)
		. += span_deadsay("It's completely lifeless. Perhaps there'll be a chance for them later.")
	else
		. += span_deadsay("It's completely lifeless.")

	if(!eyes)
		. += span_deadsay("[real_name]'s eyes have been removed.")

	if(!ears)
		. += span_deadsay("[real_name]'s ears have been removed.")

	if(!tongue)
		. += span_deadsay("[real_name]'s tongue has been removed.")

/obj/item/bodypart/head/try_attach_limb(mob/living/carbon/new_head_owner, special = FALSE)
	// These are stored before calling super. This is so that if the head is from a different body, it persists its appearance.
	var/old_real_name = src.real_name
	. = ..()
	if(!.)
		return

	if(old_real_name)
		new_head_owner.real_name = old_real_name
	real_name = new_head_owner.real_name

	//Handle dental implants
	for(var/obj/item/reagent_containers/pill/pill in src)
		for(var/datum/action/item_action/hands_free/activate_pill/pill_action in pill.actions)
			pill.forceMove(new_head_owner)
			pill_action.Grant(new_head_owner)
			break

	///Transfer existing hair properties to the new human.
	if(!special && ishuman(new_head_owner))
		var/mob/living/carbon/human/sexy_chad = new_head_owner
		sexy_chad.hairstyle = hairstyle
		sexy_chad.hair_color = hair_color
		sexy_chad.facial_hairstyle = facial_hairstyle
		sexy_chad.facial_hair_color = facial_hair_color
		sexy_chad.grad_style = gradient_styles?.Copy()
		sexy_chad.grad_color = gradient_colors?.Copy()
		sexy_chad.lip_style = lip_style
		sexy_chad.lip_color = lip_color

	new_head_owner.updatehealth()
	new_head_owner.update_body()
	new_head_owner.update_damage_overlays()

/obj/item/bodypart/head/drop_limb(special, dismembered)
	var/mob/living/carbon/head_owner = owner
	if(head_owner)
		// Update the name of the head to reflect the owner's real name
		name = "[owner.real_name]'s head"
	. = ..()
	if(special || !head_owner)
		return

	// Handle dental implants
	for(var/datum/action/item_action/hands_free/activate_pill/pill_action in head_owner.actions)
		pill_action.Remove(head_owner)
		var/obj/pill = pill_action.target
		if(pill)
			pill.forceMove(src)

	// Drop all worn head items
	for(var/obj/item/head_item in list(head_owner.glasses, head_owner.ears, head_owner.wear_mask, head_owner.head))
		head_owner.dropItemToGround(head_item, force = TRUE)

//heads are special snowflakes because instakills aren't fun
/obj/item/bodypart/head/can_dismember(damage_source)
	if(owner.stat < HARD_CRIT)
		return FALSE
	return ..()

/obj/item/bodypart/head/drop_organs(mob/user, violent_removal = FALSE)
	. = ..()
	if(brain)
		if(user)
			user.visible_message(span_warning("[user] saws [src] open and pulls out a brain!"), \
								span_notice("You saw [src] open and pull out a brain."))
		if(brainmob)
			brainmob.container = null
			brainmob.forceMove(brain)
			brain.brainmob = brainmob
			brainmob = null
		if(violent_removal && prob(80)) //ghetto surgery will likely damage the brain.
			if(user)
				to_chat(user, span_warning("\The [brain] was damaged in the process!"))
			brain.set_organ_damage(brain.maxHealth)
		brain = null
	eyes = null
	ears = null
	tongue = null

/obj/item/bodypart/head/update_limb(dropping_limb, is_creating)
	. = ..()
	if(owner)
		if(HAS_TRAIT(owner, TRAIT_HUSK))
			real_name = "Unknown"
		else
			real_name = owner.real_name
	update_hair_and_lips(dropping_limb, is_creating)

/obj/item/bodypart/head/generate_icon_key()
	. = ..()
	if(lip_style)
		. += "-[lip_style]"
		. += "-[lip_color]"

	if(facial_hair_hidden)
		. += "-facial_hair_hidden"
	else
		. += "-[facial_hairstyle]"
		. += "-[override_hair_color || fixed_hair_color || facial_hair_color]"
		. += "-[hair_alpha]"
		if(gradient_styles?[GRADIENT_FACIAL_HAIR_KEY])
			. += "-[gradient_styles[GRADIENT_FACIAL_HAIR_KEY]]"
			. += "-[gradient_colors[GRADIENT_FACIAL_HAIR_KEY]]"

	if(hair_hidden)
		. += "-hair_hidden"
	else
		. += "-[hairstyle]"
		. += "-[override_hair_color || fixed_hair_color || hair_color]"
		. += "-[hair_alpha]"
		if(gradient_styles?[GRADIENT_HAIR_KEY])
			. += "-[gradient_styles[GRADIENT_HAIR_KEY]]"
			. += "-[gradient_colors[GRADIENT_HAIR_KEY]]"

	if(show_eyeless)
		. += "-show_eyeless"
	else
		var/obj/item/organ/eyes/eyeballs = owner ? owner.get_organ_slot(ORGAN_SLOT_EYES) : src.eyes
		if(eyeballs)
			. += "-[eyeballs.eye_icon_state]"
			. += "-[eyeballs.eye_color_left]"
			. += "-[eyeballs.eye_color_right]"
			. += "-[eyeballs.overlay_ignore_lighting]"

	if(show_debrained)
		. += "-show_debrained"

	return .

/obj/item/bodypart/head/get_limb_icon(dropped)
	. = ..()
	. += get_hair_and_lips_icon(dropped)
	if(HAS_TRAIT(src, TRAIT_MEGAMIND))
		for(var/image/overlay in .)
			overlay.transform = overlay.transform.Scale(1.1)
	return .

/obj/item/bodypart/head/talk_into(mob/holder, message, channel, spans, datum/language/language, list/message_mods)
	var/mob/headholder = holder
	if(istype(headholder))
		headholder.log_talk(message, LOG_SAY, tag = "beheaded talk")

	say(message, language, sanitize = FALSE)
	return NOPASS

/obj/item/bodypart/head/GetVoice()
	return "The head of [real_name]"

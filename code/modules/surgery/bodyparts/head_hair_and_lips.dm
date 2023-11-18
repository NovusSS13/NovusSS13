#define SET_OVERLAY_VALUE(overlay,variable,value) if(overlay) overlay.variable = value

/// Part of `update_limb()`, basically does all the head specific icon stuff.
/obj/item/bodypart/head/proc/update_hair_and_lips(dropping_limb, is_creating)
	//needs an owner to be done, no way to avoid it
	if(!owner)
		return
	var/mob/living/carbon/human/human_head_owner = owner
	var/datum/species/owner_species = human_head_owner?.dna.species

	//HIDDEN CHECKS START
	hair_hidden = FALSE
	facial_hair_hidden = FALSE
	if(owner)
		if(HAS_TRAIT(owner, TRAIT_INVISIBLE_MAN) || HAS_TRAIT(human_head_owner, TRAIT_HUSK))
			hair_hidden = TRUE
			facial_hair_hidden = TRUE
		if(HAS_TRAIT(owner, TRAIT_BALD))
			hair_hidden = TRUE
		if(HAS_TRAIT(owner, TRAIT_SHAVED))
			facial_hair_hidden = TRUE
		if(istype(human_head_owner))
			if(human_head_owner.head)
				var/obj/item/hat = human_head_owner.head
				if(hat.flags_inv & HIDEHAIR)
					hair_hidden = TRUE
				if(hat.flags_inv & HIDEFACIALHAIR)
					facial_hair_hidden = TRUE

			if(human_head_owner.wear_mask)
				var/obj/item/mask = human_head_owner.wear_mask
				if(mask.flags_inv & HIDEHAIR)
					hair_hidden = TRUE
				if(mask.flags_inv & HIDEFACIALHAIR)
					facial_hair_hidden = TRUE

			if(human_head_owner.w_uniform)
				var/obj/item/item_uniform = human_head_owner.w_uniform
				if(item_uniform.flags_inv & HIDEHAIR)
					hair_hidden = TRUE
				if(item_uniform.flags_inv & HIDEFACIALHAIR)
					facial_hair_hidden = TRUE
	if(is_husked || is_invisible)
		hair_hidden = TRUE
		facial_hair_hidden = TRUE
	//HIDDEN CHECKS END

	if(owner)
		if(!hair_hidden && !owner.get_organ_slot(ORGAN_SLOT_BRAIN) && !HAS_TRAIT(owner, TRAIT_NO_DEBRAIN_OVERLAY))
			show_debrained = TRUE
		else
			show_debrained = FALSE

		if(!owner.get_organ_slot(ORGAN_SLOT_EYES))
			show_eyeless = TRUE
		else
			show_eyeless = FALSE
	else
		if(!hair_hidden && !brain)
			show_debrained = TRUE
		else
			show_debrained = FALSE

		if(!eyes)
			show_eyeless = TRUE
		else
			show_eyeless = FALSE

	if(!is_creating || !istype(human_head_owner))
		return

	lip_style = human_head_owner.lip_style
	lip_color = human_head_owner.lip_color
	hairstyle = human_head_owner.hairstyle
	hair_color = human_head_owner.hair_color
	facial_hairstyle = human_head_owner.facial_hairstyle
	facial_hair_color = human_head_owner.facial_hair_color
	fixed_hair_color = owner_species.hair_color //Can be null
	switch(owner_species.hair_color)
		if(ORGAN_COLOR_MUTANT)
			if(HAS_TRAIT(human_head_owner, TRAIT_FIXED_MUTANT_COLORS) && owner_species.fixed_mut_color)
				fixed_hair_color = tricolor_to_hex(owner_species.fixed_mut_color)
			else
				fixed_hair_color = tricolor_to_hex(human_head_owner.dna.features["mcolor"])
		else
			fixed_hair_color = owner_species.hair_color
	hair_alpha = owner_species.hair_alpha
	gradient_styles = human_head_owner.grad_style?.Copy()
	gradient_colors = human_head_owner.grad_color?.Copy()

/obj/item/bodypart/head/proc/get_hair_and_lips_icon(dropped)
	SHOULD_CALL_PARENT(TRUE)
	RETURN_TYPE(/list)
	. = list()
	if(!(bodytype & (BODYTYPE_HUMANOID|BODYTYPE_AVALI)) || is_invisible)
		return .

	var/atom/location = loc || owner || src
	var/image_dir = (dropped ? SOUTH : NONE)

	var/datum/sprite_accessory/sprite_accessory

	var/image/lip_overlay
	if(!is_husked && lip_style && (head_flags & HEAD_LIPS))
		//not a sprite accessory, don't ask
		//Overlay
		lip_overlay = image('icons/mob/species/sprite_accessory/human_face.dmi', "lips_[lip_style]", -BODY_LAYER)
		lip_overlay.color = lip_color
		lip_overlay.dir = image_dir
		//Offsets
		worn_face_offset?.apply_offset(lip_overlay)
		. += lip_overlay
		//Emissive blocker
		if(blocks_emissive)
			var/image/lip_blocker = emissive_blocker(lip_overlay.icon, lip_overlay.icon_state, location)
			lip_blocker.dir = image_dir
			worn_face_offset?.apply_offset(lip_blocker)
			. += lip_blocker

	var/image/facial_hair_overlay
	if(!facial_hair_hidden && facial_hairstyle && (head_flags & HEAD_FACIAL_HAIR))
		sprite_accessory = GLOB.facial_hairstyles_list[facial_hairstyle]
		if(sprite_accessory)
			//Overlay
			facial_hair_overlay = image(sprite_accessory.icon, sprite_accessory.icon_state, -HAIR_LAYER)
			facial_hair_overlay.alpha = hair_alpha
			facial_hair_overlay.dir = image_dir
			//Offsets
			worn_face_offset?.apply_offset(facial_hair_overlay)
			. += facial_hair_overlay
			//Gradients
			var/facial_hair_gradient_style = LAZYACCESS(gradient_styles, GRADIENT_FACIAL_HAIR_KEY)
			if(facial_hair_gradient_style)
				var/facial_hair_gradient_color = LAZYACCESS(gradient_colors, GRADIENT_FACIAL_HAIR_KEY)
				var/image/facial_hair_gradient_overlay = get_gradient_overlay(sprite_accessory.icon, sprite_accessory.icon_state, -HAIR_LAYER, GLOB.facial_hair_gradients_list[facial_hair_gradient_style], facial_hair_gradient_color)
				facial_hair_gradient_overlay.dir = image_dir
				. += facial_hair_gradient_overlay
			//Emissive blocker
			if(blocks_emissive)
				var/image/facial_blocker = emissive_blocker(facial_hair_overlay.icon, facial_hair_overlay.icon_state, location)
				facial_blocker.dir = image_dir
				worn_face_offset?.apply_offset(facial_hair_overlay)
				. += facial_blocker

	var/image/hair_overlay
	if(!(show_debrained && (head_flags & HEAD_DEBRAIN)) && !hair_hidden && hairstyle && (head_flags & HEAD_HAIR))
		sprite_accessory = GLOB.hairstyles_list[hairstyle]
		if(sprite_accessory)
			//Overlay
			hair_overlay = image(sprite_accessory.icon, sprite_accessory.icon_state, -HAIR_LAYER)
			hair_overlay.alpha = hair_alpha
			hair_overlay.dir = image_dir
			//Offsets
			worn_face_offset?.apply_offset(hair_overlay)
			. += hair_overlay
			//Gradients
			var/hair_gradient_style = LAZYACCESS(gradient_styles, GRADIENT_HAIR_KEY)
			if(hair_gradient_style)
				var/hair_gradient_color = LAZYACCESS(gradient_colors, GRADIENT_HAIR_KEY)
				var/image/hair_gradient_overlay = get_gradient_overlay(sprite_accessory.icon, sprite_accessory.icon_state, -HAIR_LAYER, GLOB.hair_gradients_list[hair_gradient_style], hair_gradient_color)
				hair_gradient_overlay.dir = image_dir
				. += hair_gradient_overlay
			//Emissive blocker
			if(blocks_emissive)
				var/image/hair_blocker = emissive_blocker(hair_overlay.icon, hair_overlay.icon_state, location)
				hair_blocker.dir = image_dir
				worn_face_offset?.apply_offset(hair_blocker)
				. += hair_blocker

	if(show_debrained && (head_flags & HEAD_DEBRAIN))
		. += get_debrain_overlay(can_rotate = !dropped)

	if(show_eyeless && (head_flags & HEAD_EYEHOLES))
		. += get_eyeless_overlay(can_rotate = !dropped)
	else if(!is_husked && (head_flags & HEAD_EYESPRITES) && (owner?.get_organ_slot(ORGAN_SLOT_EYES) || eyes))
		. += get_eyes_overlays(can_rotate = !dropped)

	//HAIR COLOR START
	if(override_hair_color)
		SET_OVERLAY_VALUE(hair_overlay, color, override_hair_color)
		SET_OVERLAY_VALUE(facial_hair_overlay, color, override_hair_color)
	else if(fixed_hair_color)
		SET_OVERLAY_VALUE(hair_overlay, color, fixed_hair_color)
		SET_OVERLAY_VALUE(facial_hair_overlay, color, fixed_hair_color)
	else
		SET_OVERLAY_VALUE(hair_overlay, color, hair_color)
		SET_OVERLAY_VALUE(facial_hair_overlay, color, facial_hair_color)
	//HAIR COLOR END

	return .

#undef SET_OVERLAY_VALUE

/// Returns an appropriate eyes overlay
/obj/item/bodypart/head/proc/get_eyes_overlays(can_rotate = TRUE)
	RETURN_TYPE(/list)
	. = list()
	var/obj/item/organ/eyes/eyeballs = owner ? owner.get_organ_slot(ORGAN_SLOT_EYES) : src.eyes
	if(!eyeballs)
		CRASH("[type] called get_eyes_overlays() while having no eyes!")

	custom_eyes_icon ||= 'icons/mob/species/sprite_accessory/eyes.dmi'

	var/image/left_eye
	var/image/right_eye
	if(can_rotate)
		left_eye = mutable_appearance(custom_eyes_icon, "[eyeballs.eye_icon_state]_l", -BODY_LAYER)
		right_eye = mutable_appearance(custom_eyes_icon, "[eyeballs.eye_icon_state]_r", -BODY_LAYER)
	else
		left_eye = image(custom_eyes_icon, "[eyeballs.eye_icon_state]_l", -BODY_LAYER, SOUTH)
		right_eye = image(custom_eyes_icon, "[eyeballs.eye_icon_state]_r", -BODY_LAYER, SOUTH)

	if(head_flags & HEAD_EYECOLOR)
		left_eye.color = eyeballs.eye_color_left
		right_eye.color = eyeballs.eye_color_right
	. += left_eye
	. += right_eye
	var/atom/location = loc || owner || src
	var/image/left_blocker
	var/image/right_blocker
	if(blocks_emissive)
		left_blocker = emissive_blocker(left_eye.icon, left_eye.icon_state, location)
		right_blocker = emissive_blocker(right_eye.icon, right_eye.icon_state, location)
		. += left_blocker
		. += right_blocker
	var/image/left_emissive
	var/image/right_emissive
	if(eyeballs.overlay_ignore_lighting)
		left_emissive = emissive_appearance(left_eye.icon, left_eye.icon_state, location, alpha = left_eye.alpha)
		right_emissive = emissive_appearance(right_eye.icon, right_eye.icon_state, location, alpha = right_eye.alpha)
		. += left_emissive
		. += right_emissive
	if(worn_face_offset)
		for(var/image/eye_image in .)
			worn_face_offset.apply_offset(eye_image)

/// Returns an appropriate missing eyes overlay
/obj/item/bodypart/head/proc/get_eyeless_overlay(can_rotate = TRUE)
	RETURN_TYPE(/image)
	var/eyeless_icon = (custom_eyes_icon ||= 'icons/mob/species/sprite_accessory/human_face.dmi')
	var/eyeless_icon_state = "eyes_missing"

	var/image/eyeless_overlay
	if(can_rotate)
		eyeless_overlay = mutable_appearance(eyeless_icon, eyeless_icon_state, -HAIR_LAYER)
	else
		eyeless_overlay = image(eyeless_icon, eyeless_icon_state, -HAIR_LAYER, SOUTH)
	worn_face_offset?.apply_offset(eyeless_overlay)
	return eyeless_overlay

/// Returns an appropriate debrained overlay
/obj/item/bodypart/head/proc/get_debrain_overlay(can_rotate = TRUE)
	RETURN_TYPE(/image)
	var/debrain_icon = 'icons/mob/species/sprite_accessory/human_face.dmi'
	var/debrain_icon_state = "debrained"
	if(bodytype & BODYTYPE_ALIEN)
		debrain_icon = 'icons/mob/species/alien/bodyparts.dmi'
		debrain_icon_state = "debrained_alien"
	else if(bodytype & BODYTYPE_LARVA)
		debrain_icon = 'icons/mob/species/alien/bodyparts.dmi'
		debrain_icon_state = "debrained_larva"
	else if(bodytype & BODYTYPE_GOLEM)
		debrain_icon = 'icons/mob/species/golem/golems.dmi'

	var/image/debrain_overlay
	if(can_rotate)
		debrain_overlay = mutable_appearance(debrain_icon, debrain_icon_state, -HAIR_LAYER)
	else
		debrain_overlay = image(debrain_icon, debrain_icon_state, -HAIR_LAYER, SOUTH)
	worn_face_offset?.apply_offset(debrain_overlay)
	return debrain_overlay

/// Returns an appropriate hair/facial hair gradient overlay
/obj/item/bodypart/head/proc/get_gradient_overlay(file, icon, layer, datum/sprite_accessory/gradient, grad_color)
	RETURN_TYPE(/image)

	var/mutable_appearance/gradient_overlay = mutable_appearance(layer = layer)
	var/icon/temp = icon(gradient.icon, gradient.icon_state)
	var/icon/temp_hair = icon(file, icon)
	temp.Blend(temp_hair, ICON_ADD)
	gradient_overlay.icon = temp
	gradient_overlay.color = grad_color
	worn_face_offset?.apply_offset(gradient_overlay)
	return gradient_overlay

/**
 * Used to update the makeup on a human and apply/remove lipstick traits, then store/unstore them on the head object in case it gets severed
 **/
/mob/living/proc/update_lips(new_style, new_color, apply_trait, update = TRUE)
	return

/mob/living/carbon/human/update_lips(new_style, new_color, apply_trait, update = TRUE)
	lip_style = new_style
	lip_color = new_color

	var/obj/item/bodypart/head/hopefully_a_head = get_bodypart(BODY_ZONE_HEAD)
	REMOVE_TRAITS_IN(src, LIPSTICK_TRAIT)
	if(hopefully_a_head)
		hopefully_a_head.stored_lipstick_trait = null
		hopefully_a_head.lip_style = new_style
		hopefully_a_head.lip_color = new_color
	if(new_style && apply_trait)
		ADD_TRAIT(src, apply_trait, LIPSTICK_TRAIT)
		hopefully_a_head?.stored_lipstick_trait = apply_trait

	if(update)
		update_body_parts()

/**
 * A wrapper for [mob/living/carbon/human/proc/update_lips] that sets the lip style and color to null.
 **/
/mob/living/proc/clean_lips()
	return

/mob/living/carbon/human/clean_lips()
	if(!lip_style)
		return FALSE
	update_lips(null, null, update = TRUE)
	return TRUE

/**
 * Set the hair style of a human.
 * Update calls update_body_parts().
 **/
/mob/living/proc/set_hairstyle(new_style, update = TRUE)
	return

/mob/living/carbon/human/set_hairstyle(new_style, update = TRUE)
	var/obj/item/bodypart/head/my_head = get_bodypart(BODY_ZONE_HEAD)

	hairstyle = new_style
	my_head?.hairstyle = new_style

	if(update)
		update_body_parts()

/**
 * Set the hair color of a human.
 * Override instead sets the override value, it will not be changed away from the override value until override is set to null.
 * Update calls update_body_parts().
 **/
/mob/living/proc/set_haircolor(hex_string, override, update = TRUE)
	return

/mob/living/carbon/human/set_haircolor(hex_string, override, update = TRUE)
	var/obj/item/bodypart/head/my_head = get_bodypart(BODY_ZONE_HEAD)

	if(override)
		// aight, no head? tough luck
		my_head?.override_hair_color = hex_string
	else
		hair_color = hex_string
		my_head?.hair_color = hex_string

	if(update)
		update_body_parts()

/**
 * Set the hair gradient style of a human.
 * Update calls update_body_parts().
 **/
/mob/living/proc/set_hair_gradient_style(new_style, update = TRUE)
	return

/mob/living/carbon/human/set_hair_gradient_style(new_style, update = TRUE)
	var/obj/item/bodypart/head/my_head = get_bodypart(BODY_ZONE_HEAD)

	LAZYSETLEN(grad_style, GRADIENTS_LEN)
	LAZYSETLEN(grad_color, GRADIENTS_LEN)
	grad_style[GRADIENT_HAIR_KEY] = new_style
	if(my_head)
		LAZYSETLEN(my_head.gradient_styles, GRADIENTS_LEN)
		LAZYSETLEN(my_head.gradient_colors, GRADIENTS_LEN)
		my_head.gradient_styles[GRADIENT_HAIR_KEY] = new_style

	if(update)
		update_body_parts()

/**
 * Set the hair gradient color of a human.
 * Update calls update_body_parts().
 **/
/mob/living/proc/set_hair_gradient_color(new_color, update = TRUE)
	return

/mob/living/carbon/human/set_hair_gradient_color(new_color, update = TRUE)
	var/obj/item/bodypart/head/my_head = get_bodypart(BODY_ZONE_HEAD)


	LAZYSETLEN(grad_style, GRADIENTS_LEN)
	LAZYSETLEN(grad_color, GRADIENTS_LEN)
	grad_color[GRADIENT_HAIR_KEY] = new_color
	if(my_head)
		LAZYSETLEN(my_head.gradient_styles, GRADIENTS_LEN)
		LAZYSETLEN(my_head.gradient_colors, GRADIENTS_LEN)
		my_head.gradient_colors[GRADIENT_HAIR_KEY] = new_color

	if(update)
		update_body_parts()

/**
 * Set the facial hair style of a human.
 * Update calls update_body_parts().
 **/
/mob/living/proc/set_facial_hairstyle(new_style, update = TRUE)
	return

/mob/living/carbon/human/set_facial_hairstyle(new_style, update = TRUE)
	var/obj/item/bodypart/head/my_head = get_bodypart(BODY_ZONE_HEAD)

	facial_hairstyle = new_style
	my_head?.facial_hairstyle = new_style

	if(update)
		update_body_parts()

/**
 * Set the facial hair color of a human.
 * Override instead sets the override value, it will not be changed away from the override value until override is set to null.
 * Update calls update_body_parts().
 **/
/mob/living/proc/set_facial_haircolor(hex_string, override, update = TRUE)
	return

/mob/living/carbon/human/set_facial_haircolor(hex_string, override, update = TRUE)
	var/obj/item/bodypart/head/my_head = get_bodypart(BODY_ZONE_HEAD)

	if(override)
		// so no head? tough luck
		my_head?.override_hair_color = hex_string
	else
		facial_hair_color = hex_string
		my_head?.facial_hair_color = hex_string

	if(update)
		update_body_parts()

/**
 * Set the facial hair gradient style of a human.
 * Update calls update_body_parts().
 **/
/mob/living/proc/set_facial_hair_gradient_style(new_style, update = TRUE)
	return

/mob/living/carbon/human/set_facial_hair_gradient_style(new_style, update = TRUE)
	var/obj/item/bodypart/head/my_head = get_bodypart(BODY_ZONE_HEAD)

	LAZYSETLEN(grad_style, GRADIENTS_LEN)
	LAZYSETLEN(grad_color, GRADIENTS_LEN)
	grad_style[GRADIENT_FACIAL_HAIR_KEY] = new_style
	if(my_head)
		LAZYSETLEN(my_head.gradient_styles, GRADIENTS_LEN)
		LAZYSETLEN(my_head.gradient_colors, GRADIENTS_LEN)
		my_head.gradient_styles[GRADIENT_FACIAL_HAIR_KEY] = new_style

	if(update)
		update_body_parts()

/**
 * Set the facial hair gradient color of a human.
 * Update calls update_body_parts().
 **/
/mob/living/proc/set_facial_hair_gradient_color(new_color, update = TRUE)
	return

/mob/living/carbon/human/set_facial_hair_gradient_color(new_color, update = TRUE)
	var/obj/item/bodypart/head/my_head = get_bodypart(BODY_ZONE_HEAD)

	LAZYSETLEN(grad_style, GRADIENTS_LEN)
	LAZYSETLEN(grad_color, GRADIENTS_LEN)
	grad_color[GRADIENT_FACIAL_HAIR_KEY] = new_color
	if(my_head)
		LAZYSETLEN(my_head.gradient_styles, GRADIENTS_LEN)
		LAZYSETLEN(my_head.gradient_colors, GRADIENTS_LEN)
		my_head.gradient_colors[GRADIENT_FACIAL_HAIR_KEY] = new_color

	if(update)
		update_body_parts()

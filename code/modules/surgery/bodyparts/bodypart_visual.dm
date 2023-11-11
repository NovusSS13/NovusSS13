/obj/item/bodypart
	icon = 'icons/mob/species/human/bodyparts.dmi'
	icon_state = "" //Leave this blank! Bodyparts are built using overlays
	/// The icon for limbs using greyscale
	VAR_PROTECTED/icon_greyscale = DEFAULT_BODYPART_ICON_ORGANIC
	/// The icon for non-greyscale limbs
	VAR_PROTECTED/icon_static = 'icons/mob/species/human/bodyparts.dmi'
	/// The icon for husked limbs
	VAR_PROTECTED/icon_husk = 'icons/mob/species/human/bodyparts.dmi'
	/// The icon for invisible limbs
	VAR_PROTECTED/icon_invisible = 'icons/mob/species/human/bodyparts.dmi'

	layer = BELOW_MOB_LAYER //so it isn't hidden behind objects when on the floor

	// States used in determining overlays for limb damage states. As the mob receives more burn/brute damage, their limbs update to reflect.
	/// Current brute damage state, from 0 (intact) to 3 (max damage)
	var/brutestate = 0
	/// Current burn damage state, from 0 (intact) to 3 (max damage)
	var/burnstate = 0

/**
 * Updates a bodypart's external_bodytypes variable, matching it to the organs it has.
 */
/obj/item/bodypart/proc/synchronize_bodytypes()
	var/final_bodytype = NONE
	for(var/obj/item/organ/organ as anything in organs)
		final_bodytype |= organ.external_bodytypes
	external_bodytypes = final_bodytype
	return final_bodytype

/**
 * Updates a bodypart's brute/burn states for use by update_damage_overlays()
 * Returns TRUE if we need to update overlays. FALSE otherwise.
 */
/obj/item/bodypart/proc/update_bodypart_damage_state()
	SHOULD_CALL_PARENT(TRUE)

	var/tbrute = round( (brute_dam/max_damage)*3, 1 )
	var/tburn = round( (burn_dam/max_damage)*3, 1 )
	if((tbrute != brutestate) || (tburn != burnstate))
		brutestate = tbrute
		burnstate = tburn
		return TRUE
	return FALSE

/**
 * Updates the bodypart's various visual features based on the owner.
 * Set is_creating to true if you want to change the appearance of the limb outside of mutation changes or forced changes.
 */
/obj/item/bodypart/proc/update_limb(dropping_limb = FALSE, is_creating = FALSE)
	SHOULD_CALL_PARENT(TRUE)

	if(IS_ORGANIC_LIMB(src))
		if(owner && HAS_TRAIT(owner, TRAIT_HUSK))
			dmg_overlay_type = "" //no damage overlay shown when husked
			is_husked = TRUE
		else if(owner && HAS_TRAIT(owner, TRAIT_INVISIBLE_MAN))
			dmg_overlay_type = "" //no damage overlay shown when invisible since the wounds themselves are invisible.
			is_invisible = TRUE
		else
			dmg_overlay_type = initial(dmg_overlay_type)
			is_husked = FALSE
			is_invisible = FALSE

	draw_color = variable_color
	if(should_draw_greyscale) //Should the limb be colored?
		draw_color ||= species_color || (skin_tone ? skintone2hex(skin_tone) : null)

	if(!is_creating || !owner)
		return

	// There should technically to be an ishuman(owner) check here, but it is absent because no basetype carbons use bodyparts
	// No, xenos don't actually use bodyparts. Don't ask.
	var/mob/living/carbon/human/human_owner = owner
	var/datum/species/owner_species = human_owner.dna.species
	limb_gender = (HAS_TRAIT(human_owner, TRAIT_AGENDER) || (human_owner.physique != FEMALE)) ? "m" : "f"

	if(HAS_TRAIT(human_owner, TRAIT_USES_SKINTONES))
		skin_tone = human_owner.skin_tone
	else if(HAS_TRAIT(human_owner, TRAIT_MUTANT_COLORS))
		skin_tone = ""
		if(HAS_TRAIT(human_owner, TRAIT_FIXED_MUTANT_COLORS) && owner_species.fixed_mut_color)
			species_color = tricolor_to_hex(owner_species.fixed_mut_color)
		else
			species_color = tricolor_to_hex(human_owner.dna.features["mcolor"])
	else
		skin_tone = ""
		species_color = ""

	draw_color = variable_color
	if(should_draw_greyscale) //Should the limb be colored?
		draw_color ||= species_color || (skin_tone ? skintone2hex(skin_tone) : null)

	recolor_mutant_overlays(force = TRUE)
	return TRUE

/// Updates the bodypart's icon when not attached to a mob
/obj/item/bodypart/proc/update_icon_dropped()
	SHOULD_CALL_PARENT(TRUE)

	cut_overlays()
	var/list/standing = get_limb_icon(TRUE)
	if(!standing.len)
		icon_state = initial(icon_state)//no overlays found, we default back to initial icon.
		return
	for(var/image/image in standing)
		image.pixel_x = px_x
		image.pixel_y = px_y
	add_overlay(standing)

/// Generates an /image for the limb to be used as an overlay
/obj/item/bodypart/proc/get_limb_icon(dropped)
	SHOULD_CALL_PARENT(TRUE)
	RETURN_TYPE(/list)

	icon_state = "" //to erase the default sprite, we're building the visual aspects of the bodypart through overlays alone.

	. = list()

	var/image_dir = NONE
	if(dropped)
		image_dir = SOUTH
		if(dmg_overlay_type && (bodytype & BODYTYPE_HUMANOID))
			if(brutestate)
				. += image('icons/mob/effects/dam_mob.dmi', "[dmg_overlay_type]_[body_zone]_[brutestate]0", -DAMAGE_LAYER, image_dir)
				if(aux_zone)
					. += image('icons/mob/effects/dam_mob.dmi', "[dmg_overlay_type]_[aux_zone]_[brutestate]0", -DAMAGE_HIGH_LAYER, image_dir)
			if(burnstate)
				. += image('icons/mob/effects/dam_mob.dmi', "[dmg_overlay_type]_[body_zone]_0[burnstate]", -DAMAGE_LAYER, image_dir)
				if(aux_zone)
					. += image('icons/mob/effects/dam_mob.dmi', "[dmg_overlay_type]_[aux_zone]_0[burnstate]", -DAMAGE_HIGH_LAYER, image_dir)

	var/image/limb = image(layer = -BODYPARTS_LAYER, dir = image_dir)
	var/image/aux

	// Handles invisibility (not alpha or actual invisibility but invisibility)
	if(is_invisible)
		limb.icon = icon_invisible
		limb.icon_state = "invisible_[body_zone]"
		. += limb
		if(aux_zone) //Hand shit
			aux = image(limb.icon, "invisible_[aux_zone]", -BODYPARTS_HIGH_LAYER, image_dir)
			. += aux
	// Handles making bodyparts look husked
	else if(is_husked)
		limb.icon = icon_husk
		limb.icon_state = "[husk_type]_husk_[body_zone]"
		icon_exists(limb.icon, limb.icon_state, scream = TRUE) //Prints a stack trace on the first failure of a given iconstate.
		. += limb
		if(aux_zone) //Hand shit
			aux = image(limb.icon, "[husk_type]_husk_[aux_zone]", -BODYPARTS_HIGH_LAYER, image_dir)
			icon_exists(aux.icon, aux.icon_state, scream = TRUE) //Prints a stack trace on the first failure of a given iconstate.
			. += aux
	// Normal non-husk handling
	else
		// This is the MEAT of limb icon code
		var/effective_limb_id = limb_id
		if((bodytype & BODYTYPE_DIGITIGRADE) && !(bodytype & BODYTYPE_COMPRESSED)) //this is a bit evil imma be real bro
			effective_limb_id += "_digitigrade"
		limb.icon = icon_greyscale
		if(!should_draw_greyscale || !icon_greyscale)
			limb.icon = icon_static

		if(is_dimorphic) //Does this type of limb have sexual dimorphism?
			limb.icon_state = "[effective_limb_id]_[body_zone]_[limb_gender]"
		else
			limb.icon_state = "[effective_limb_id]_[body_zone]"

		icon_exists(limb.icon, limb.icon_state, scream = TRUE) //Prints a stack trace on the first failure of a given iconstate.

		. += limb

		if(aux_zone) //Hand shit
			aux = image(limb.icon, "[effective_limb_id]_[aux_zone]", -BODYPARTS_HIGH_LAYER, image_dir)
			. += aux

		draw_color = variable_color
		if(should_draw_greyscale) //Should the limb be colored outside of a forced color?
			draw_color ||= (species_color) || (skin_tone && skintone2hex(skin_tone))

		if(draw_color)
			limb.color = "[draw_color]"
			if(aux_zone)
				aux.color = "[draw_color]"

	//EMISSIVE CODE START
	// For some reason this was applied as an overlay on the aux image and limb image before.
	// I am very sure that this is unnecessary, and i need to treat it as part of the return list
	// to be able to mask it proper in case this limb is a leg.
	if(blocks_emissive)
		var/atom/location = loc || owner || src
		var/mutable_appearance/limb_em_block = emissive_blocker(limb.icon, limb.icon_state, location, layer = limb.layer, alpha = limb.alpha)
		limb_em_block.dir = image_dir
		. += limb_em_block
		if(aux_zone)
			var/mutable_appearance/aux_em_block = emissive_blocker(aux.icon, aux.icon_state, location, layer = aux.layer, alpha = aux.alpha)
			aux_em_block.dir = image_dir
			. += aux_em_block
	//EMISSIVE CODE END

	//No need to handle leg layering if dropped, we only face south anyways
	if(!dropped && ((body_zone == BODY_ZONE_R_LEG) || (body_zone == BODY_ZONE_L_LEG)))
		//Legs are a bit goofy in regards to layering, and we will need two images instead of one to fix that
		var/obj/item/bodypart/leg/leg_source = src
		for(var/image/limb_image in .) //yes we do need to typecheck for images
			//remove the old, unmasked image
			. -= limb_image
			//add two masked images based on the old one
			. += leg_source.generate_masked_leg(limb_image, image_dir)

	// And finally put bodypart_overlays on if not husked nor invisible
	if(!is_husked && !is_invisible)
		//Draw external organs like horns and frills
		for(var/datum/bodypart_overlay/bodypart_overlay as anything in bodypart_overlays)
			if(!bodypart_overlay.can_draw_on_bodypart(src) || (!dropped && !bodypart_overlay.can_draw_on_body(src, owner)))
				continue
			//Some externals have multiple layers for background, foreground and between
			for(var/external_layer in GLOB.external_layer_bitflags)
				if(!(bodypart_overlay.layers & external_layer))
					continue
				for(var/image/overlay in bodypart_overlay.get_overlays(external_layer, src))
					if(dropped)
						overlay.dir = SOUTH
					. += overlay

	return .

/// Add a bodypart overlay and call the appropriate update procs
/obj/item/bodypart/proc/add_bodypart_overlay(datum/bodypart_overlay/overlay)
	LAZYADD(bodypart_overlays, overlay)
	overlay.added_to_limb(src)

/// Remove a bodypart overlay and call the appropriate update procs
/obj/item/bodypart/proc/remove_bodypart_overlay(datum/bodypart_overlay/overlay)
	LAZYREMOVE(bodypart_overlays, overlay)
	overlay.removed_from_limb(src)

/// Applies the current top_offset of the owner to a given list of overlays if necessary, and returns the modified list
/obj/item/bodypart/proc/apply_top_offset(list/overlays)
	var/applied_top_offset = get_applicable_top_offset()
	for(var/image/overlay as anything in overlays)
		overlay.pixel_y += applied_top_offset
	return overlays

/// Returns the top_offset we should apply to our overlays after get_limb_icon(), useless if we don't have an owner
/obj/item/bodypart/proc/get_applicable_top_offset()
	var/top_offset = 0
	if(ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		top_offset = human_owner.get_top_offset()
	return top_offset

// how much blood the limb needs to be losing per tick (not counting laying down/self grasping modifiers) to get the different bleed icons
#define BLEED_OVERLAY_LOW 0.5
#define BLEED_OVERLAY_MED 1.5
#define BLEED_OVERLAY_GUSH 3.25

/obj/item/bodypart/proc/update_part_wound_overlay()
	if(!owner)
		return FALSE
	if(HAS_TRAIT(owner, TRAIT_NOBLOOD) || !IS_ORGANIC_LIMB(src))
		if(bleed_overlay_icon)
			bleed_overlay_icon = null
			owner.update_wound_overlays()
		return FALSE

	var/bleed_rate = cached_bleed_rate
	var/new_bleed_icon = null

	switch(bleed_rate)
		if(-INFINITY to BLEED_OVERLAY_LOW)
			new_bleed_icon = null
		if(BLEED_OVERLAY_LOW to BLEED_OVERLAY_MED)
			new_bleed_icon = "[body_zone]_1"
		if(BLEED_OVERLAY_MED to BLEED_OVERLAY_GUSH)
			if(owner.body_position == LYING_DOWN || IS_IN_STASIS(owner) || owner.stat == DEAD)
				new_bleed_icon = "[body_zone]_2s"
			else
				new_bleed_icon = "[body_zone]_2"
		if(BLEED_OVERLAY_GUSH to INFINITY)
			if(IS_IN_STASIS(owner) || owner.stat == DEAD)
				new_bleed_icon = "[body_zone]_2s"
			else
				new_bleed_icon = "[body_zone]_3"

	if(new_bleed_icon != bleed_overlay_icon)
		bleed_overlay_icon = new_bleed_icon
		owner.update_wound_overlays()

#undef BLEED_OVERLAY_LOW
#undef BLEED_OVERLAY_MED
#undef BLEED_OVERLAY_GUSH

/// Loops through all of the bodypart's mutant overlays and updates their colors
/obj/item/bodypart/proc/recolor_mutant_overlays(force = FALSE)
	for(var/datum/bodypart_overlay/mutant/overlay in bodypart_overlays)
		overlay.inherit_color(src, force)

/// A multi-purpose setter for all things immediately important to the icon and iconstate of the limb.
/obj/item/bodypart/proc/change_appearance(icon, id, greyscale, dimorphic, update = TRUE)
	var/icon_holder
	if(greyscale)
		icon_greyscale = icon
		icon_holder = icon
		should_draw_greyscale = TRUE
	else
		icon_static = icon
		icon_holder = icon
		should_draw_greyscale = FALSE

	if(id) //limb_id should never be falsey
		limb_id = id

	if(!isnull(dimorphic))
		is_dimorphic = dimorphic

	// This foot gun needs a safety
	if(!icon_exists(icon_holder, "[limb_id]_[body_zone][is_dimorphic ? "_[limb_gender]" : ""]"))
		reset_appearance(update)
		stack_trace("change_appearance([icon], [id], [greyscale], [dimorphic]) generated null icon")
	else if(update)
		if(owner)
			owner.update_body_parts()
		else
			update_icon_dropped()

/// Resets the base appearance of a limb to it's default values.
/obj/item/bodypart/proc/reset_appearance(update = TRUE)
	icon_static = initial(icon_static)
	icon_greyscale = initial(icon_greyscale)
	limb_id = initial(limb_id)
	is_dimorphic = initial(is_dimorphic)
	should_draw_greyscale = initial(should_draw_greyscale)

	if(update)
		if(owner)
			owner.update_body_parts()
		else
			update_icon_dropped()

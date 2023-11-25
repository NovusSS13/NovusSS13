/**
 * System for drawing organs with overlays.
 * These overlays are drawn directly on the bodypart, attached to a person or not.
 * Works in tandem with the /datum/sprite_accessory and /datum/bodypart_overlay/mutant datums to generate sprites.
 */
/obj/item/organ
	/// In case we have a detail overlay
	/// The overlay datum that actually draws stuff on the limb
	var/datum/bodypart_overlay/mutant/bodypart_overlay
	/// If not null, overrides the appearance with this sprite accessory datum
	var/sprite_accessory_override

	/// With what DNA block do we mutate in mutate_feature() ? For genetics
	var/dna_block

	/// Set to true if for some reason you want to inherit the color from the bodypart overlay
	var/inherit_color = FALSE
	/**
	 * Set to TRUE if you want to draw the bodypart overlays as the object sprite.
	 * FALSE to use your own.
	 * This will not work if it doesn't have a limb to generate it's icon with, yes that is scuffed.
	 */
	var/use_mob_sprite_as_obj_sprite = FALSE
	/// In case we have a detail overlay, this is the icon_state for it
	var/detail_overlay
	/// Whether or not the detail overlay should be colored according to the bodypart overlay's color
	var/inherit_detail_color = FALSE
	/// Does this organ have any bodytypes to pass to it's ownerlimb?
	var/external_bodytypes = NONE
	/// Which flags does a 'modification tool' need to have to restyle us, if it all possible (located in code/_DEFINES/mobs)
	var/restyle_flags = NONE

/obj/item/organ/update_overlays()
	. = ..()
	if(!bodypart_overlay)
		return

	if(inherit_color)
		color = tricolor_to_hex(bodypart_overlay.draw_color)

	if(detail_overlay)
		var/mutable_appearance/detail = mutable_appearance(icon, detail_overlay)
		if(inherit_detail_color)
			detail.color = tricolor_to_hex(bodypart_overlay.draw_color)
		. += detail

	if(!use_mob_sprite_as_obj_sprite)
		return

	// Build the mob sprite and use it as our overlay
	for(var/external_layer in GLOB.external_layer_bitflags)
		if(bodypart_overlay.layers & external_layer)
			//yes, absolutely no checks whatsoever
			. += bodypart_overlay.get_overlays(external_layer, ownerlimb)

/obj/item/organ/setDir(newdir)
	if(use_mob_sprite_as_obj_sprite)
		return //always face south
	return ..()

/// Initializes visual elements of an organ
/obj/item/organ/proc/initialize_visuals()
	//we don't need to initialize shit if we don't have a bodypart_overlay path
	if(!bodypart_overlay)
		return

	bodypart_overlay = new bodypart_overlay()
	if(sprite_accessory_override)
		bodypart_overlay.set_appearance(sprite_accessory_override)
		bodypart_overlay.imprint_on_next_insertion = FALSE
	else
		bodypart_overlay.randomize_appearance()
		//jank, but only imprint next insert if we are created in nullspace
		if(!loc)
			bodypart_overlay.imprint_on_next_insertion = TRUE
		else
			bodypart_overlay.imprint_on_next_insertion = FALSE

	update_appearance()

/// Returns an examine list about the visual elements of this organ.
/obj/item/organ/proc/visuals_examine(mob/user)
	RETURN_TYPE(/list)
	. = list()
	if(!HAS_MIND_TRAIT(user, TRAIT_ENTRAILS_READER) && !isobserver(user))
		return .

	if(bodypart_overlay)
		if(bodypart_overlay.imprint_on_next_insertion)
			. += span_info("Interesting... This organ has many ready stem cells, and will adapt to a new owner's DNA.")
		if(bodypart_overlay.sprite_datum?.name)
			. += span_info("This organ has a <em>\"[bodypart_overlay.sprite_datum.name]\"</em> style.")

	if(restyle_flags)
		var/list/restyle_tools = list()
		if(restyle_flags & EXTERNAL_RESTYLE_PLANT)
			restyle_tools += "secateurs"
		if(restyle_flags & EXTERNAL_RESTYLE_FLESH)
			restyle_tools += "surgical tools"
		if(restyle_flags & EXTERNAL_RESTYLE_ENAMEL)
			restyle_tools += "files"
		if(length(restyle_tools))
			. += span_info("This organ can be restyled with <em>[english_list(restyle_tools)]</em>.")

/// Update our appearance after something changed dna features (if we have an attached DNA block)
/obj/item/organ/proc/mutate_features(list/features, mob/living/carbon/human/human)
	if(!dna_block || sprite_accessory_override)
		return FALSE

	var/feature_name = features[bodypart_overlay.feature_key]
	if(feature_name && (feature_name != SPRITE_ACCESSORY_NONE))
		bodypart_overlay.set_appearance_from_name(feature_name)
	bodypart_overlay.inherit_color(ownerlimb, force = TRUE)
	return TRUE

/**
 * Proc used to change the organ to match the DNA of the owner, IF POSSIBLE.
 */
/obj/item/organ/proc/imprint_dna(mob/living/carbon/receiver, obj/item/bodypart/owner_limb)
	var/say_my_name = receiver.dna.features[bodypart_overlay.feature_key] //for reasons i don't want to know, this CAN be null!
	if(say_my_name && (say_my_name != SPRITE_ACCESSORY_NONE))
		bodypart_overlay.set_appearance_from_name(receiver.dna.features[bodypart_overlay.feature_key])
	bodypart_overlay.inherit_color(owner_limb, force = TRUE)
	bodypart_overlay.imprint_on_next_insertion = FALSE

/**
 * If you need to change an organ's visuals for simple one-offs, use this.
 * Pass the accessory type : /datum/accessory/something
 */
/obj/item/organ/proc/simple_change_sprite(accessory_type)
	var/datum/sprite_accessory/typed_accessory = accessory_type //we only take types for maintainability

	bodypart_overlay.set_appearance(typed_accessory)

	if(owner) //are we in a person?
		owner.update_body_parts()
	else if(ownerlimb) //are we in a limb?
		ownerlimb.update_icon_dropped()
	else //are we out in the world, unprotected by flesh?
		update_appearance()

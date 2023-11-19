///Variant of bodypart_overlay meant to work synchronously with external organs. Gets imprinted upon Insert in on_species_gain
/datum/bodypart_overlay/mutant
	///Sprite datum we use to draw on the bodypart
	var/datum/sprite_accessory/sprite_datum

	///Defines what kind of 'organ' we're looking at. Sprites have names like 'm_mothwings_firemoth_ADJ'. 'mothwings' would then be feature_key
	var/feature_key = ""
	///Feature key for the color of the organ, if color_source is ORGAN_COLOR_DNA
	var/feature_color_key = ""

	///The color this organ draws with. Updated by bodypart/inherit_color()
	var/draw_color
	///Where does this organ inherit it's color from?
	var/color_source = ORGAN_COLOR_LIMB
	///Take on the dna/preference from whoever we're gonna be inserted in
	var/imprint_on_next_insertion = TRUE

///Can't draw shit without a sprite accessory
/datum/bodypart_overlay/mutant/can_draw_on_bodypart(obj/item/bodypart/ownerlimb)
	return sprite_datum && ..()

///Completely random image and color generation (obeys what a player can choose from)
/datum/bodypart_overlay/mutant/proc/randomize_appearance()
	randomize_sprite()
	draw_color = "#[random_color()]"

///Grab a random sprite
/datum/bodypart_overlay/mutant/proc/randomize_sprite()
	sprite_datum = get_random_sprite_accessory()

///Grab a random sprite accessory datum (that is not locked)
/datum/bodypart_overlay/mutant/proc/get_random_sprite_accessory()
	var/list/valid_restyles = list()
	var/list/feature_list = get_global_feature_list()
	for(var/accessory in feature_list)
		var/datum/sprite_accessory/accessory_datum = feature_list[accessory]
		//locked is for stuff that shouldn't appear here
		//nameless sprite accessories are not valid for mutant bodypart overlays
		//SPRITE_ACCESSORY_NONE is not valid for mutant bodypart overlays
		if(initial(accessory_datum.locked) || \
			!initial(accessory_datum.name) || \
			(initial(accessory_datum.name) == SPRITE_ACCESSORY_NONE))
			continue
		valid_restyles += accessory_datum
	//no restyles? this is fucked
	if(!length(valid_restyles))
		CRASH("[type] had no available valid appearances on get_random_sprite_accessory()!")
	return pick(valid_restyles)

///Returns a list of strings that gets used to build the icon_state for the image on get_image()
/datum/bodypart_overlay/mutant/proc/get_icon_state(layer, obj/item/bodypart/limb)
	RETURN_TYPE(/list)
	var/list/icon_state_builder = list()
	var/gender = limb?.limb_gender || "m"
	icon_state_builder += (sprite_datum.gender_specific && limb.is_dimorphic) ? gender : "m" //Male is default because sprite accessories are so ancient they predate the concept of not hardcoding gender
	var/actual_feature_key = get_icon_feature_key()
	if(actual_feature_key)
		icon_state_builder += actual_feature_key
		if(sprite_datum.feature_suffix)
			icon_state_builder += sprite_datum.feature_suffix
	var/base_icon_state = get_base_icon_state() //MONKEYS. GOD DAMN MONKEYS.
	if(base_icon_state)
		icon_state_builder += base_icon_state
	icon_state_builder += mutant_bodyparts_layertext(layer)
	return icon_state_builder

///Returns the feature_key we actually want to use for rendering the icon
/datum/bodypart_overlay/mutant/proc/get_icon_feature_key()
	return feature_key

///Return the BASE icon state of the sprite datum for use in get_icon_state (so no gender, layer nor feature_key)
/datum/bodypart_overlay/mutant/proc/get_base_icon_state()
	return sprite_datum.icon_state

///Get the image we need to draw on the person. Called from get_overlays() which is called from _bodyparts.dm. Limb can be null
/datum/bodypart_overlay/mutant/get_image(layer, obj/item/bodypart/limb)
	if(!sprite_datum)
		CRASH("Trying to call get_image() on [type] while it didn't have a sprite_datum. This shouldn't happen, report it as soon as possible.")

	var/list/icon_state_builder = get_icon_state(layer, limb)
	var/finished_icon_state = icon_state_builder.Join("_")

	var/list/appearances = list()
	///here comes some truly bullshit coloring code
	if(sprite_datum.color_amount <= 1)
		var/mutable_appearance/final_appearance = mutable_appearance(sprite_datum.icon, finished_icon_state, layer)
		if(sprite_datum.center)
			center_image(final_appearance, sprite_datum.dimension_x, sprite_datum.dimension_y)
		appearances += final_appearance
	else
		for(var/index in 1 to sprite_datum.color_amount)
			var/suffix = LAZYACCESS(GLOB.external_color_suffixes, index)
			if(!suffix)
				stack_trace("[sprite_datum.type] had a color amount bigger than GLOB.external_color_suffixes! ([sprite_datum.color_amount])]")
				break
			var/mutable_appearance/overlay = mutable_appearance(sprite_datum.icon, "[finished_icon_state]_[suffix]", layer)
			if(sprite_datum.center)
				center_image(overlay, sprite_datum.dimension_x, sprite_datum.dimension_y)
			appearances += overlay

	return appearances

/datum/bodypart_overlay/mutant/color_image(image/overlay, layer, obj/item/bodypart/limb)
	//nothing to be colored
	if(!draw_color || !sprite_datum.color_amount)
		return
	//its a list of images
	var/list/sane_draw_color = list()
	var/default
	if(islist(draw_color))
		default = sanitize_hexcolor(draw_color[length(draw_color)], DEFAULT_HEX_COLOR_LEN, TRUE, "#FFFFFF")
		sane_draw_color = draw_color
	else
		default = sanitize_hexcolor(draw_color, DEFAULT_HEX_COLOR_LEN, TRUE, "#FFFFFF")
		sane_draw_color = list(draw_color)
	sane_draw_color = sanitize_hexcolor_list(sane_draw_color, DEFAULT_HEX_COLOR_LEN, 3, TRUE, default)
	for(var/index in 1 to min(sprite_datum.color_amount, length(overlay)))
		var/image/appearance = overlay[index]
		appearance.color = sane_draw_color[index]

/datum/bodypart_overlay/mutant/added_to_limb(obj/item/bodypart/limb)
	inherit_color(limb)

///Change our accessory sprite, using the accesssory type. If you need to change the sprite for something, use simple_change_sprite()
/datum/bodypart_overlay/mutant/set_appearance(accessory_type)
	var/valid_sprite_datum = fetch_sprite_datum(accessory_type)
	if(!valid_sprite_datum)
		return FALSE
	sprite_datum = valid_sprite_datum
	if(draw_color)
		draw_color = validate_color(draw_color)
	return TRUE

///In a lot of cases, appearances are stored in DNA as the Name, instead of the path. Use set_appearance instead of possible
/datum/bodypart_overlay/mutant/proc/set_appearance_from_name(accessory_name)
	var/valid_sprite_datum = fetch_sprite_datum_from_name(accessory_name)
	if(!valid_sprite_datum)
		return FALSE
	sprite_datum = valid_sprite_datum
	if(draw_color)
		draw_color = validate_color(draw_color)
	return TRUE

///Generate a unique key based on our sprites. So that if we've aleady drawn these sprites, they can be found in the cache and wont have to be drawn again (blessing and curse, but mostly curse)
/datum/bodypart_overlay/mutant/generate_icon_cache()
	. = list()
	if(feature_key)
		. += "[feature_key]"
		if(sprite_datum.feature_suffix)
			. += "[sprite_datum.feature_suffix]"
	var/base_icon_state = get_base_icon_state()
	if(base_icon_state)
		. += "[base_icon_state]"
	if(sprite_datum.color_amount > 0)
		if(islist(draw_color))
			for(var/subcolor in draw_color)
				. += "[subcolor]"
		else
			. += "[draw_color]"
	return .

///Return a dumb glob list for this specific feature (called from parse_sprite)
/datum/bodypart_overlay/mutant/proc/get_global_feature_list()
	CRASH("[type] has no feature list, it will render invisible")

///Give the organ its color. Force will override the existing one.
/datum/bodypart_overlay/mutant/proc/inherit_color(obj/item/bodypart/ownerlimb, force = FALSE)
	if(isnull(ownerlimb))
		return FALSE

	if(draw_color && !force)
		return FALSE

	switch(color_source)
		if(ORGAN_COLOR_NONE)
			draw_color = null
		if(ORGAN_COLOR_LIMB)
			draw_color = ownerlimb.draw_color
		if(ORGAN_COLOR_OVERRIDE)
			draw_color = override_color(ownerlimb.draw_color)
		if(ORGAN_COLOR_DNA)
			if(!ishuman(ownerlimb.owner))
				return FALSE
			//In some cases we just straight take the limb color
			if(HAS_TRAIT(ownerlimb.owner, TRAIT_HULK) || HAS_TRAIT(ownerlimb.owner, TRAIT_MEGAMIND))
				draw_color = ownerlimb.draw_color
				return
			var/dna_color = LAZYACCESS(ownerlimb.owner.dna.features, feature_color_key)
			//DNA didn't really give us an answer? Try the DNA's mcolor!
			if(!dna_color)
				dna_color = LAZYACCESS(ownerlimb.owner.dna.features, "mcolor")
				//DNA still didn't give us an answer SOMEHOW? Use the drawcolor...
				if(!dna_color)
					draw_color = ownerlimb.draw_color
				else
					draw_color = dna_color
			//otherwise, we are cool
			else
				draw_color = dna_color
		if(ORGAN_COLOR_MUTANT)
			if(!ishuman(ownerlimb.owner))
				return FALSE
			var/dna_color = LAZYACCESS(ownerlimb.owner.dna.features, "mcolor")
			//DNA still didn't give us an answer SOMEHOW? Use the drawcolor...
			if(!dna_color)
				draw_color = ownerlimb.draw_color
			//otherwise, we are cool
			else
				draw_color = dna_color
		if(ORGAN_COLOR_HAIR)
			if(!ishuman(ownerlimb.owner))
				return FALSE
			var/mob/living/carbon/human/human_owner = ownerlimb.owner
			var/obj/item/bodypart/head/my_head = human_owner.get_bodypart(BODY_ZONE_HEAD) //not always the same as ownerlimb
			//head hair color takes priority, owner hair color is a backup if we lack a head or something
			if(my_head)
				draw_color = my_head.override_hair_color || my_head.fixed_hair_color || my_head.hair_color
			else
				draw_color = human_owner.hair_color
		if(ORGAN_COLOR_FACIAL_HAIR)
			if(!ishuman(ownerlimb.owner))
				return FALSE
			var/mob/living/carbon/human/human_owner = ownerlimb.owner
			var/obj/item/bodypart/head/my_head = human_owner.get_bodypart(BODY_ZONE_HEAD) //not always the same as ownerlimb
			//head facial hair color takes priority, owner facial hair color is a backup if we lack a head or something
			if(my_head)
				draw_color = my_head.override_hair_color || my_head.fixed_hair_color || my_head.facial_hair_color
			else
				draw_color = human_owner.facial_hair_color
		if(ORGAN_COLOR_EYE)
			if(!ishuman(ownerlimb.owner))
				return FALSE
			var/mob/living/carbon/human/human_owner = ownerlimb.owner
			var/obj/item/organ/eyes/eyes = human_owner.get_organ_slot(ORGAN_SLOT_EYES)
			//if we have eyes, source the eye color from them, use owner's eyecolor var as a backup
			if(eyes)
				draw_color = eyes.eye_color_left
			else
				draw_color = human_owner.eye_color_left
		else
			CRASH("[type] had an invalid color_source! ([color_source])")
	//convert to a matrix color (or deconverts) if necessary
	draw_color = validate_color(draw_color)
	return TRUE

///Returns a validated version of the given color in accordance with the sprite accessory in use
/datum/bodypart_overlay/mutant/proc/validate_color(given_color)
	//well, keep it null if it is null or if the sprite_datum has no color amount
	if(isnull(given_color) || !sprite_datum.color_amount)
		return null
	//return a list if the sprite datum wants matrixed colors
	if(sprite_datum.color_amount > 1)
		//sanitize normally if it's already a matrix color
		if(islist(given_color))
			var/list/validated_color = given_color
			validated_color = validated_color.Copy()
			var/last_color_element = sanitize_hexcolor(validated_color[length(validated_color)], DEFAULT_HEX_COLOR_LEN, TRUE, "#FFFFFF")
			return sanitize_hexcolor_list(validated_color, DEFAULT_HEX_COLOR_LEN, 3, TRUE, last_color_element)
		//repeat the same color as needed otherwise
		var/sanitized_color = sanitize_hexcolor(given_color, DEFAULT_HEX_COLOR_LEN, TRUE, "#FFFFFF")
		var/list/sanitized_colors = list()
		for(var/color in 1 to sprite_datum.color_amount)
			sanitized_colors += sanitized_color
		return sanitized_colors
	//return a string otherwise
	//take and sanitize only the first color if it's a matrix
	if(islist(given_color))
		return sanitize_hexcolor(given_color[1], DEFAULT_HEX_COLOR_LEN, TRUE, "#FFFFFF")
	//just sanitize normally otherwise
	return sanitize_hexcolor(given_color, DEFAULT_HEX_COLOR_LEN, TRUE, "#FFFFFF")

///Sprite accessories are singletons, stored list("Big Snout" = instance of /datum/sprite_accessory/snout/big), so here we get that singleton
/datum/bodypart_overlay/mutant/proc/fetch_sprite_datum(datum/sprite_accessory/accessory_path)
	var/list/feature_list = get_global_feature_list()
	return feature_list[initial(accessory_path.name)]

///Get the singleton from the sprite name
/datum/bodypart_overlay/mutant/proc/fetch_sprite_datum_from_name(accessory_name)
	var/list/feature_list = get_global_feature_list()
	return feature_list[accessory_name]

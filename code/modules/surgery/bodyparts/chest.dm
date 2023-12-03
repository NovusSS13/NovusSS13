/obj/item/bodypart/chest
	name = BODY_ZONE_CHEST
	desc = "It's impolite to stare at a person's chest."
	icon_state = "default_human_chest"
	max_damage = 200
	body_zone = BODY_ZONE_CHEST
	body_part = CHEST
	plaintext_zone = "chest"
	is_dimorphic = TRUE
	px_x = 0
	px_y = 0
	grind_results = null
	wound_resistance = 10

	/// The bodytype(s) allowed to attach to this chest.
	var/acceptable_bodytype = BODYTYPE_HUMANOID

	/// Fire overlay to apply when the owner is on fire
	var/fire_overlay = "human"

	/// Ass image that gets printed when the owner scans their ass on a printer - Will use the default if null
	var/ass_image

	/// Item inserted in the cavity of this chest, if any.
	var/obj/item/cavity_item

	/// Offset to apply to equipment worn as a uniform
	var/datum/worn_feature_offset/worn_uniform_offset
	/// Offset to apply to equipment worn on the id slot
	var/datum/worn_feature_offset/worn_id_offset
	/// Offset to apply to equipment worn in the suit slot
	var/datum/worn_feature_offset/worn_suit_storage_offset
	/// Offset to apply to equipment worn on the hips
	var/datum/worn_feature_offset/worn_belt_offset
	/// Offset to apply to overlays placed on the back
	var/datum/worn_feature_offset/worn_back_offset
	/// Offset to apply to equipment worn as a suit
	var/datum/worn_feature_offset/worn_suit_offset
	/// Offset to apply to equipment worn on the neck
	var/datum/worn_feature_offset/worn_neck_offset
	/// Offset to apply to accessories
	var/datum/worn_feature_offset/worn_accessory_offset

/obj/item/bodypart/chest/Destroy()
	QDEL_NULL(cavity_item)
	QDEL_NULL(worn_uniform_offset)
	QDEL_NULL(worn_id_offset)
	QDEL_NULL(worn_suit_storage_offset)
	QDEL_NULL(worn_belt_offset)
	QDEL_NULL(worn_back_offset)
	QDEL_NULL(worn_suit_offset)
	QDEL_NULL(worn_neck_offset)
	QDEL_NULL(worn_accessory_offset)
	return ..()

//chests are special snowflakes because instakills aren't fun
/obj/item/bodypart/chest/can_dismember(damage_source)
	if(owner.stat < HARD_CRIT || !LAZYLEN(organs))
		return FALSE
	return ..()

/obj/item/bodypart/chest/drop_limb(special, dismembered)
	//if this is not a special drop, this is a mistake
	if(!special)
		return FALSE
	return ..()

/obj/item/bodypart/chest/drop_organs(mob/user, violent_removal)
	. = ..()
	cavity_item = null

/obj/item/bodypart/chest/generate_icon_key()
	. = ..()
	if(is_invisible || is_husked || !ishuman(owner))
		return .

	var/mob/living/carbon/human/human_owner = owner
	if(human_owner.underwear && !HAS_TRAIT(human_owner, TRAIT_NO_UNDERWEAR))
		. += "-[human_owner.underwear]"
		. += "-[human_owner.underwear_color]"
	if(human_owner.undershirt && !HAS_TRAIT(human_owner, TRAIT_NO_UNDERSHIRT))
		. += "-[human_owner.undershirt]"
	//handling socks here is not ideal and this should be moved to be handled by legs somehow, but that's for later i guess
	var/obj/item/bodypart/leg/left_leg = human_owner.get_bodypart(BODY_ZONE_L_LEG)
	var/obj/item/bodypart/leg/right_leg = human_owner.get_bodypart(BODY_ZONE_R_LEG)
	if(human_owner.socks && !HAS_TRAIT(human_owner, TRAIT_NO_SOCKS) \
		&& left_leg && (left_leg.bodytype & BODYTYPE_HUMANOID) && !(left_leg.bodytype & BODYTYPE_DIGITIGRADE)  \
		&& right_leg && (right_leg.bodytype & BODYTYPE_HUMANOID) && !(right_leg.bodytype & BODYTYPE_DIGITIGRADE))
		. += "-[human_owner.socks]"

	return .

/obj/item/bodypart/chest/get_limb_icon(dropped)
	. = ..()
	. += get_underwear_icon(dropped)
	return .

/obj/item/bodypart/chest/proc/get_underwear_icon(dropped)
	SHOULD_CALL_PARENT(TRUE)
	RETURN_TYPE(/list)
	. = list()
	if(is_invisible || is_husked || !ishuman(owner))
		return .

	var/mob/living/carbon/human/human_owner = owner

	var/atom/location = loc || owner || src
	var/image_dir = (dropped ? SOUTH : NONE)

	if(human_owner.underwear && !HAS_TRAIT(owner, TRAIT_NO_UNDERWEAR) && (bodytype & BODYTYPE_HUMANOID))
		var/datum/sprite_accessory/underwear/underwear = GLOB.underwear_list[human_owner.underwear]
		if(underwear)
			var/mutable_appearance/underwear_overlay
			if(is_dimorphic && limb_gender == "f" && (underwear.gender == MALE))
				underwear_overlay = wear_female_version(underwear.icon_state, underwear.icon, BODY_LAYER, FEMALE_UNIFORM_FULL)
			else
				underwear_overlay = mutable_appearance(underwear.icon, underwear.icon_state, -BODY_LAYER)
			if(!underwear.use_static)
				underwear_overlay.color = human_owner.underwear_color
			underwear_overlay.dir = image_dir
			worn_uniform_offset?.apply_offset(underwear_overlay)
			. += underwear_overlay
			//Emissive blocker
			if(blocks_emissive)
				var/image/blocker = emissive_blocker(underwear_overlay.icon, underwear_overlay.icon_state, location)
				blocker.dir = image_dir
				worn_uniform_offset?.apply_offset(blocker)
				. += blocker

	if(human_owner.undershirt && !HAS_TRAIT(owner, TRAIT_NO_UNDERSHIRT) && (bodytype & BODYTYPE_HUMANOID))
		var/datum/sprite_accessory/undershirt/undershirt = GLOB.undershirt_list[human_owner.undershirt]
		if(undershirt)
			var/mutable_appearance/shirt_overlay
			if(is_dimorphic && limb_gender == "f")
				shirt_overlay = wear_female_version(undershirt.icon_state, undershirt.icon, BODY_LAYER)
			else
				shirt_overlay = mutable_appearance(undershirt.icon, undershirt.icon_state, -BODY_LAYER)
			shirt_overlay.dir = image_dir
			worn_uniform_offset?.apply_offset(shirt_overlay)
			. += shirt_overlay
			//Emissive blocker
			if(blocks_emissive)
				var/image/blocker = emissive_blocker(shirt_overlay.icon, shirt_overlay.icon_state, location)
				blocker.dir = image_dir
				worn_uniform_offset?.apply_offset(blocker)
				. += blocker

	//handling socks here is not ideal and this should be moved to be handled by legs somehow, but that's for later i guess
	var/obj/item/bodypart/leg/left_leg = human_owner.get_bodypart(BODY_ZONE_L_LEG)
	var/obj/item/bodypart/leg/right_leg = human_owner.get_bodypart(BODY_ZONE_R_LEG)
	if(human_owner.socks && !HAS_TRAIT(human_owner, TRAIT_NO_SOCKS) \
		&& left_leg && (left_leg.bodytype & BODYTYPE_HUMANOID) && !(left_leg.bodytype & BODYTYPE_DIGITIGRADE)  \
		&& right_leg && (right_leg.bodytype & BODYTYPE_HUMANOID) && !(right_leg.bodytype & BODYTYPE_DIGITIGRADE))
		var/datum/sprite_accessory/socks/socks = GLOB.socks_list[human_owner.socks]
		if(socks)
			var/mutable_appearance/socks_overlay = mutable_appearance(socks.icon, socks.icon_state, -BODY_LAYER)
			socks_overlay.dir = image_dir
			worn_uniform_offset?.apply_offset(socks_overlay)
			. += socks_overlay
			//Emissive blocker
			if(blocks_emissive)
				var/image/blocker = emissive_blocker(socks_overlay.icon, socks_overlay.icon_state, location)
				blocker.dir = image_dir
				worn_uniform_offset?.apply_offset(blocker)
				. += blocker

	return .

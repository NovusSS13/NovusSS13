/obj/item/bodypart/head/golem
	icon = 'icons/mob/species/golem/golems.dmi'
	icon_static = 'icons/mob/species/golem/golems.dmi'
	icon_state = "golem_head"
	biological_state = BIO_INORGANIC
	bodytype = BODYTYPE_GOLEM | BODYTYPE_ORGANIC
	limb_id = SPECIES_GOLEM
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	dmg_overlay_type = null
	head_flags = NONE

/obj/item/bodypart/head/golem/Initialize(mapload)
	worn_ears_offset = new(
		attached_part = src,
		feature_key = OFFSET_EARS,
		offset_x = list("north" = 1, "south" = -1, "east" = 1, "west" = -1),
		offset_y = list("south" = 1),
	)
	worn_glasses_offset = new(
		attached_part = src,
		feature_key = OFFSET_GLASSES,
		offset_x = list("north" = 1, "south" = -1, "east" = 1, "west" = -1),
	)
	worn_head_offset = new(
		attached_part = src,
		feature_key = OFFSET_HEAD,
		offset_x = list("north" = 1, "south" = -1, "east" = 1, "west" = -1),
		offset_y = list("south" = 1),
	)
	worn_face_offset = new(
		attached_part = src,
		feature_key = OFFSET_FACE,
		offset_x = list("north" = 1, "south" = -1, "east" = 1, "west" = -1),
	)
	return ..()

/obj/item/bodypart/chest/golem
	icon = 'icons/mob/species/golem/golems.dmi'
	icon_static = 'icons/mob/species/golem/golems.dmi'
	icon_state = "golem_chest"
	biological_state = BIO_INORGANIC
	acceptable_bodytype = BODYTYPE_GOLEM
	bodytype = BODYTYPE_GOLEM | BODYTYPE_ORGANIC
	limb_id = SPECIES_GOLEM
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	dmg_overlay_type = null
	bodypart_traits = list(
		TRAIT_NO_UNDERWEAR,
		TRAIT_NO_UNDERSHIRT,
		TRAIT_NO_SOCKS,
		TRAIT_NO_JUMPSUIT,
		TRAIT_NOBLOOD,
		TRAIT_NODISMEMBER,
		TRAIT_NOFIRE,
		TRAIT_NO_DNA_COPY,
		TRAIT_NO_TRANSFORMATION_STING,
	)

/obj/item/bodypart/chest/golem/Initialize(mapload)
	worn_belt_offset = new(
		attached_part = src,
		feature_key = OFFSET_BELT,
		offset_x = list("north" = 1, "south" = -1, "east" = 1, "west" = -1),
	)
	return ..()

/obj/item/bodypart/arm/left/golem
	icon = 'icons/mob/species/golem/golems.dmi'
	icon_static = 'icons/mob/species/golem/golems.dmi'
	icon_state = "golem_l_arm"
	biological_state = BIO_INORGANIC
	bodytype = BODYTYPE_GOLEM | BODYTYPE_ORGANIC
	limb_id = SPECIES_GOLEM
	should_draw_greyscale = FALSE
	dmg_overlay_type = null
	unarmed_damage_low = 5
	unarmed_damage_high = 14
	unarmed_stun_threshold = 11
	hand_traits = list(
		TRAIT_CHUNKYFINGERS,
		TRAIT_FIST_MINING,
	)

/obj/item/bodypart/arm/left/golem/Initialize(mapload)
	held_hand_offset =  new(
		attached_part = src,
		feature_key = OFFSET_HELD,
		offset_x = list("north" = -1, "south" = 2, "east" = 0, "west" = -3),
		offset_y = list("south" = -2),
	)
	return ..()

/obj/item/bodypart/arm/left/golem/on_active_hand(mob/living/carbon/source)
	. = ..()
	source.AddComponentFrom(REF(src), /datum/component/shovel_hands)

/obj/item/bodypart/arm/left/golem/on_inactive_hand(mob/living/carbon/source)
	. = ..()
	source.RemoveComponentSource(REF(src), /datum/component/shovel_hands)

/obj/item/bodypart/arm/right/golem
	icon = 'icons/mob/species/golem/golems.dmi'
	icon_static = 'icons/mob/species/golem/golems.dmi'
	icon_state = "golem_r_arm"
	biological_state = BIO_INORGANIC
	bodytype = BODYTYPE_GOLEM | BODYTYPE_ORGANIC
	limb_id = SPECIES_GOLEM
	should_draw_greyscale = FALSE
	dmg_overlay_type = null
	unarmed_damage_low = 5
	unarmed_damage_high = 14
	unarmed_stun_threshold = 11
	hand_traits = list(
		TRAIT_CHUNKYFINGERS,
		TRAIT_FIST_MINING,
	)

/obj/item/bodypart/arm/right/golem/Initialize(mapload)
	held_hand_offset =  new(
		attached_part = src,
		feature_key = OFFSET_HELD,
		offset_x = list("north" = 2, "south" = -2, "east" = 3, "west" = 0),
		offset_y = list("south" = -2),
	)
	return ..()

/obj/item/bodypart/arm/right/golem/on_active_hand(mob/living/carbon/source)
	. = ..()
	source.AddComponentFrom(REF(src), /datum/component/shovel_hands)

/obj/item/bodypart/arm/right/golem/on_inactive_hand(mob/living/carbon/source)
	. = ..()
	source.RemoveComponentSource(REF(src), /datum/component/shovel_hands)

/obj/item/bodypart/leg/left/golem
	icon = 'icons/mob/species/golem/golems.dmi'
	icon_static = 'icons/mob/species/golem/golems.dmi'
	icon_state = "golem_l_leg"
	biological_state = BIO_INORGANIC
	bodytype = BODYTYPE_GOLEM | BODYTYPE_ORGANIC
	limb_id = SPECIES_GOLEM
	should_draw_greyscale = FALSE
	dmg_overlay_type = null
	unarmed_damage_low = 7
	unarmed_damage_high = 21
	unarmed_stun_threshold = 11

/obj/item/bodypart/leg/right/golem
	icon = 'icons/mob/species/golem/golems.dmi'
	icon_static = 'icons/mob/species/golem/golems.dmi'
	icon_state = "golem_r_leg"
	biological_state = BIO_INORGANIC
	bodytype = BODYTYPE_GOLEM | BODYTYPE_ORGANIC
	limb_id = SPECIES_GOLEM
	should_draw_greyscale = FALSE
	dmg_overlay_type = null
	unarmed_damage_low = 7
	unarmed_damage_high = 21
	unarmed_stun_threshold = 11

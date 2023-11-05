#define AVALI_PUNCH_LOW 2 // Lower bound punch damage
#define AVALI_PUNCH_HIGH 6
#define AVALI_BURN_MODIFIER 1.25 // They take more damage from practically everything
#define AVALI_BRUTE_MODIFIER 1.2

/obj/item/bodypart/head/avali
	custom_eyes_icon = 'icons/mob/species/avali/avali_eyes.dmi'
	icon_greyscale = 'icons/mob/species/avali/bodyparts_greyscale.dmi'
	bodytype = BODYTYPE_ORGANIC | BODYTYPE_AVALI
	head_flags = HEAD_EYESPRITES | HEAD_EYECOLOR | HEAD_EYEHOLES | HEAD_DEBRAIN
	limb_id = SPECIES_AVALI
	brute_modifier = AVALI_BRUTE_MODIFIER
	burn_modifier = AVALI_BURN_MODIFIER

/obj/item/bodypart/head/avali/Initialize(mapload)
	worn_ears_offset = new(
		attached_part = src,
		feature_key = OFFSET_EARS,
		offset_y = list("north" = -4, "south" = -4, "east" = -4, "west" = -4),
	)
	worn_head_offset = new(
		attached_part = src,
		feature_key = OFFSET_HEAD,
		offset_x = list("north" = 1, "south" = 1, "east" = 1, "west" = -1),
		offset_y = list("north" = -4, "south" = -4, "east" = -4, "west" = -4),
	)
	worn_mask_offset = new(
		attached_part = src,
		feature_key = OFFSET_FACEMASK,
		offset_y = list("north" = -5, "south" = -5, "east" = -5, "west" = -5),
	)
	return ..()


/obj/item/bodypart/chest/avali
	icon_greyscale = 'icons/mob/species/avali/bodyparts_greyscale.dmi'
	bodytype = BODYTYPE_ORGANIC | BODYTYPE_AVALI
	limb_id = SPECIES_AVALI
	brute_modifier = AVALI_BRUTE_MODIFIER
	burn_modifier = AVALI_BURN_MODIFIER
	acceptable_bodytype = BODYTYPE_AVALI

/obj/item/bodypart/chest/avali/Initialize(mapload)
	worn_back_offset = new(
		attached_part = src,
		feature_key = OFFSET_BACK,
		offset_y = list("north" = -4, "south" = -4, "east" = -4, "west" = -4),
	)
	worn_accessory_offset = new(
		attached_part = src,
		feature_key = OFFSET_ACCESSORY,
		offset_y = list("north" = -4, "south" = -4, "east" = -4, "west" = -4),
	)
	return ..()


/obj/item/bodypart/arm/left/avali
	icon_greyscale = 'icons/mob/species/avali/bodyparts_greyscale.dmi'
	bodytype = BODYTYPE_ORGANIC | BODYTYPE_AVALI
	limb_id = SPECIES_AVALI
	brute_modifier = AVALI_BRUTE_MODIFIER
	burn_modifier = AVALI_BURN_MODIFIER
	unarmed_damage_high = AVALI_PUNCH_HIGH
	unarmed_damage_low = AVALI_PUNCH_LOW

/obj/item/bodypart/arm/right/avali
	icon_greyscale = 'icons/mob/species/avali/bodyparts_greyscale.dmi'
	bodytype = BODYTYPE_ORGANIC | BODYTYPE_AVALI
	limb_id = SPECIES_AVALI
	brute_modifier = AVALI_BRUTE_MODIFIER
	burn_modifier = AVALI_BURN_MODIFIER
	unarmed_damage_low = AVALI_PUNCH_LOW
	unarmed_damage_high = AVALI_PUNCH_HIGH


/obj/item/bodypart/leg/left/avali
	icon_greyscale = 'icons/mob/species/avali/bodyparts_greyscale.dmi'
	bodytype = BODYTYPE_ORGANIC | BODYTYPE_AVALI
	limb_id = SPECIES_AVALI
	brute_modifier = AVALI_BRUTE_MODIFIER
	burn_modifier = AVALI_BURN_MODIFIER
	speed_modifier = -0.2

/obj/item/bodypart/leg/right/avali
	icon_greyscale = 'icons/mob/species/avali/bodyparts_greyscale.dmi'
	bodytype = BODYTYPE_ORGANIC | BODYTYPE_AVALI
	limb_id = SPECIES_AVALI
	brute_modifier = AVALI_BRUTE_MODIFIER
	burn_modifier = AVALI_BURN_MODIFIER
	speed_modifier = -0.2

#undef AVALI_PUNCH_LOW
#undef AVALI_PUNCH_HIGH
#undef AVALI_BURN_MODIFIER
#undef AVALI_BRUTE_MODIFIER

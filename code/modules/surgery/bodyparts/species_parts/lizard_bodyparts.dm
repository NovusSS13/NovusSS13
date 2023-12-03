//NORMAL LIZARD
/obj/item/bodypart/head/lizard
	icon_greyscale = 'icons/mob/species/lizard/bodyparts.dmi'
	limb_id = SPECIES_LIZARD
	is_dimorphic = FALSE

/obj/item/bodypart/chest/lizard
	icon_greyscale = 'icons/mob/species/lizard/bodyparts.dmi'
	limb_id = SPECIES_LIZARD
	is_dimorphic = TRUE
	ass_image = 'icons/ass/asslizard.png'
	bodypart_traits = list(TRAIT_TACKLING_TAILED_DEFENDER)

/obj/item/bodypart/arm/left/lizard
	icon_greyscale = 'icons/mob/species/lizard/bodyparts.dmi'
	limb_id = SPECIES_LIZARD
	unarmed_attack_verb = "slash"
	unarmed_attack_effect = ATTACK_EFFECT_CLAW
	unarmed_attack_sound = 'sound/weapons/slash.ogg'
	unarmed_miss_sound = 'sound/weapons/slashmiss.ogg'

/obj/item/bodypart/arm/right/lizard
	icon_greyscale = 'icons/mob/species/lizard/bodyparts.dmi'
	limb_id = SPECIES_LIZARD
	unarmed_attack_verb = "slash"
	unarmed_attack_effect = ATTACK_EFFECT_CLAW
	unarmed_attack_sound = 'sound/weapons/slash.ogg'
	unarmed_miss_sound = 'sound/weapons/slashmiss.ogg'

/obj/item/bodypart/leg/left/lizard
	icon_greyscale = 'icons/mob/species/lizard/bodyparts.dmi'
	limb_id = SPECIES_LIZARD

/obj/item/bodypart/leg/right/lizard
	icon_greyscale = 'icons/mob/species/lizard/bodyparts.dmi'
	limb_id = SPECIES_LIZARD

//ASHWALKER
/obj/item/bodypart/head/lizard/ashwalker
	head_flags = HEAD_ALL_FLAGS & ~(HEAD_HAIR|HEAD_FACIAL_HAIR)

/obj/item/bodypart/chest/lizard/ashwalker
	bodypart_traits = list(TRAIT_TACKLING_TAILED_DEFENDER, TRAIT_VIRUSIMMUNE)

/obj/item/bodypart/arm/left/lizard/ashwalker
	hand_traits = list(TRAIT_CHUNKYFINGERS)

/obj/item/bodypart/arm/right/lizard/ashwalker
	hand_traits = list(TRAIT_CHUNKYFINGERS)

/obj/item/bodypart/leg/left/lizard/ashwalker

/obj/item/bodypart/leg/right/lizard/ashwalker

//SILVERSCALE
/obj/item/bodypart/head/lizard/silverscale
	head_flags = HEAD_ALL_FLAGS & ~(HEAD_HAIR|HEAD_FACIAL_HAIR)
	bodypart_traits = list(TRAIT_HOLY)

/obj/item/bodypart/chest/lizard/silverscale
	bodypart_traits = list(TRAIT_TACKLING_TAILED_DEFENDER, TRAIT_VIRUSIMMUNE)

/obj/item/bodypart/arm/left/lizard/silverscale

/obj/item/bodypart/arm/right/lizard/silverscale

/obj/item/bodypart/leg/left/lizard/silverscale

/obj/item/bodypart/leg/right/lizard/silverscale

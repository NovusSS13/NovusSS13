/datum/species/android
	name = "Android"
	id = SPECIES_ANDROID
	examine_limb_id = SPECIES_HUMAN
	chat_color = COLOR_SILVER
	inherent_traits = list(
		TRAIT_CAN_USE_FLIGHT_POTION,
		TRAIT_GENELESS,
		TRAIT_NOBREATH,
		TRAIT_NOCLONELOSS,
		TRAIT_TOXIMMUNE,
		TRAIT_NOHUNGER,
		TRAIT_LIVERLESS_METABOLISM,
		TRAIT_PIERCEIMMUNE,
		TRAIT_RESISTCOLD,
		TRAIT_RESISTHEAT,
		TRAIT_RESISTLOWPRESSURE,
		TRAIT_RESISTHIGHPRESSURE,
	)

	inherent_biotypes = MOB_ROBOTIC|MOB_HUMANOID
	meat = null
	mutanttongue = /obj/item/organ/tongue/cybernetic
	mutantstomach = null
	mutantappendix = null
	mutantheart = null
	mutantliver = null
	mutantlungs = null
	mutanteyes = /obj/item/organ/eyes/cybernetic
	mutantears = /obj/item/organ/ears/cybernetic
	species_language_holder = /datum/language_holder/synthetic
	wing_types = list(/obj/item/organ/wings/functional/cybernetic)
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT

	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/robot/android,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/robot/android,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/robot/android,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/robot/android,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/robot/android,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/robot/android,
	)

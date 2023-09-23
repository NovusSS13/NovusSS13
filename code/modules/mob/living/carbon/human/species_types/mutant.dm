/datum/species/mutant
	name = "\improper Custom"
	plural_form = "Custom" //there is no plural i guess? i can't call them customers can i //honestly that'd be p funny
	id = SPECIES_MUTANT
	examine_limb_id = SPECIES_MUTANT
	inherent_traits = list(
		TRAIT_MUTANT_COLORS,
		TRAIT_CAN_USE_FLIGHT_POTION,
		TRAIT_TACKLING_TAILED_DEFENDER,
	)
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID
	mutantears = /obj/item/organ/ears/mutant
	cosmetic_organs = list(
		/obj/item/organ/horns/mutant = SPRITE_ACCESSORY_NONE,
		/obj/item/organ/frills/mutant = SPRITE_ACCESSORY_NONE,
		/obj/item/organ/ears/mutant = SPRITE_ACCESSORY_NONE,
		/obj/item/organ/snout/mutant = SPRITE_ACCESSORY_NONE,
		/obj/item/organ/spines/mutant = SPRITE_ACCESSORY_NONE,
		/obj/item/organ/tail/mutant = SPRITE_ACCESSORY_NONE,

		/obj/item/organ/genital/penis = SPRITE_ACCESSORY_NONE,
		/obj/item/organ/genital/testicles = SPRITE_ACCESSORY_NONE,
		/obj/item/organ/genital/breasts = SPRITE_ACCESSORY_NONE,
		/obj/item/organ/genital/vagina = SPRITE_ACCESSORY_NONE,
	)
	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/mutant,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/mutant,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/mutant,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/mutant,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/mutant,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/mutant,
	)
	custom_bodyparts = TRUE // of course the stupid "custom" species gets this
	digitigrade_customization = DIGITIGRADE_OPTIONAL
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	payday_modifier = 0.75

	ass_image = 'icons/ass/assmutant.png'

/datum/species/mutant/get_species_description()
	return "Some kind of beast in anthropomorphic form."

/datum/species/mutant/get_species_lore()
	return list(
		"Genetic engineering has been a staple of technological society for centuries at this point, \
		and as such many freaks with a barely recognizable genome walk among the crew of the station.",

		"Some of them are human derived, others are alien derived, and some are a mix of both.",
	)

/datum/species/mutant/randomize_features(mob/living/carbon/human/human_mob)
	. = ..()
	randomize_cosmetic_organs(human_mob)
	randomize_markings(human_mob)

/datum/species/mutant/prepare_human_for_preview(mob/living/carbon/human/human)
	human.dna.features["mcolor"] = COLOR_ORANGE
	human.dna.features["ears"] = "Big Wolf (Alt)"
	human.dna.features["snout"] = "Mammal, Short"
	human.hairstyle = "Bedhead"
	human.set_haircolor(COLOR_RED, update = FALSE)
	human.update_body(is_creating = TRUE)

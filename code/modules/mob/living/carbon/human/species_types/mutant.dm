/datum/species/mutant
	name = "\improper Custom"
	plural_form = "Custom" //there is no plural i guess? i can't call them customers can i //honestly that'd be p funny
	id = SPECIES_MUTANT
	examine_limb_id = SPECIES_MUTANT
	chat_color = "#64ff8b"
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
		/obj/item/organ/genital/anus = SPRITE_ACCESSORY_NONE,
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

	ass_image = 'icons/ass/assmutant.png'
	voice_pack = /datum/voice/mutant

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
	human.gender = FEMALE
	human.physique = FEMALE
	human.set_haircolor("#291420", update = FALSE)
	human.set_hairstyle("Long Bedhead", update = FALSE)
	human.dna.features["mcolor"] = "#AF67AF"
	human.dna.features["tail"] = "Smooth"
	human.dna.features["tail_color"] = "#AF67AF"
	human.dna.features["spines"] = SPRITE_ACCESSORY_NONE
	human.dna.features["spines_color"] = "#AF67AF"
	human.dna.features["snout"] = "Round"
	human.dna.features["snout_color"] = "#AF67AF"
	human.dna.features["horns"] = SPRITE_ACCESSORY_NONE
	human.dna.features["horns_color"] = COLOR_WHITE
	human.dna.features["frills"] = SPRITE_ACCESSORY_NONE
	human.dna.features["frills_color"] = "#AF67AF"
	human.dna.features["ears"] = SPRITE_ACCESSORY_NONE
	human.dna.features["ears_color"] = "#AF67AF"
	human.dna.features["legs"] = LEGS_NORMAL
	human.update_body(is_creating = TRUE)

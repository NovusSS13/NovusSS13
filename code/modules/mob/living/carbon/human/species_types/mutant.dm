/datum/species/mutant
	name = "Mutant"
	id = SPECIES_MUTANT
	inherent_traits = list(
		TRAIT_MUTANT_COLORS,
		TRAIT_CAN_USE_FLIGHT_POTION,
		TRAIT_TACKLING_TAILED_DEFENDER,
	)
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID
	cosmetic_organs = list(
		/obj/item/organ/genital/penis = SPRITE_ACCESSORY_NONE,
		/obj/item/organ/genital/testicles = SPRITE_ACCESSORY_NONE,
		/obj/item/organ/genital/breasts = SPRITE_ACCESSORY_NONE,
		/obj/item/organ/genital/vagina = SPRITE_ACCESSORY_NONE,
	)
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	payday_modifier = 0.75
	examine_limb_id = SPECIES_MUTANT

/datum/species/mutant/get_species_description()
	return "Some kind of beast in anthropomorphic form."

/datum/species/mutant/get_species_lore()
	return list(
		"Genetic engineering has been a staple of technological society for centuries at this point, \
		and as such many freaks with a barely recognizable genome walk among the crew of the station."

		"Some of them are human derived, others are alien derived, and some are a mix of both.",
	)

/datum/species/mutant/prepare_human_for_preview(mob/living/carbon/human/human)
	human.dna.features["mcolor"] = COLOR_LIME
	human.hairstyle = "Bedhead"
	human.set_haircolor(COLOR_RED, update = FALSE)
	human.update_body(TRUE)

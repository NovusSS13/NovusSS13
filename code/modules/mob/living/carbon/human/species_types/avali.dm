#define AVALI_TEMP_OFFSET -30 // K, added to comfort/damage limit etc
#define AVALI_HEATMOD 1.3
#define AVALI_COLDMOD 0.67 // Except cold.

/datum/species/avali
	name = "\improper Avali"
	plural_form = "Avali"
	id = SPECIES_AVALI
	inherent_traits = list(
		TRAIT_MUTANT_COLORS,

		TRAIT_EASILY_GRABBED,
		TRAIT_EASILY_WOUNDED,
	)
	cosmetic_organs = list(
		/obj/item/organ/ears/avali = "Avali Feathers Upright",
		/obj/item/organ/tail/avali = "Avali (Default)",

		/obj/item/organ/genital/penis = SPRITE_ACCESSORY_NONE,
		/obj/item/organ/genital/testicles = SPRITE_ACCESSORY_NONE,
		/obj/item/organ/genital/breasts = SPRITE_ACCESSORY_NONE,
		/obj/item/organ/genital/vagina = SPRITE_ACCESSORY_NONE,
	)

	chat_color = "#c0965f"

	exotic_blood = /datum/reagent/ammonia
	digitigrade_customization = DIGITIGRADE_NEVER
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	mutanttongue = /obj/item/organ/tongue/avali
	mutantears = /obj/item/organ/ears/avali
	meat = /obj/item/food/meat/slab/chicken

	coldmod = AVALI_COLDMOD
	heatmod = AVALI_HEATMOD
	bodytemp_normal = BODYTEMP_NORMAL + AVALI_TEMP_OFFSET
	bodytemp_heat_damage_limit = (BODYTEMP_HEAT_DAMAGE_LIMIT + AVALI_TEMP_OFFSET)
	bodytemp_cold_damage_limit = (BODYTEMP_COLD_DAMAGE_LIMIT + AVALI_TEMP_OFFSET)
	species_language_holder = /datum/language_holder/avali
	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/avali,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/avali,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/avali,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/avali,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/avali,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/avali,
	)
	fire_overlay = "generic" //standard one looks bad

/datum/species/avali/get_species_description()
	return "From the icy moon of Avalon, come Avali; the nomadic chickens with ammonia-based biology \
	and a heavy aversion towards any sanely-heated places."

/datum/species/avali/get_species_lore()
	return list("WIP")


/datum/species/avali/random_name(gender, unique, lastname)
	if(unique)
		return random_unique_avali_name()

	return avali_name()

/datum/species/avali/prepare_human_for_preview(mob/living/carbon/human/avali)
	var/base_color = "#c0965f"
	var/ear_color = "#e4c49b"

	avali.dna.features["mcolor"] = base_color
	avali.dna.features["ears"] = "Avali Feathers Upright"
	avali.dna.features["ears_color"] = ear_color

	avali.dna.features["tail"] = "Avali (Default)"
	avali.dna.features["tail_color"] = list(base_color, base_color, ear_color)

	regenerate_organs(avali, src, visual_only = TRUE)
	avali.update_body(TRUE)

#undef AVALI_TEMP_OFFSET
#undef AVALI_HEATMOD
#undef AVALI_COLDMOD

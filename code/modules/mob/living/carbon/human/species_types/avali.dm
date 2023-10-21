#define AVALI_TEMP_OFFSET -30 // K, added to comfort/damage limit etc
#define AVALI_HEATMOD 1.3
#define AVALI_COLDMOD 0.67 // Except cold.

/datum/species/avali
	name = "Avali"
	id = SPECIES_AVALI
	inherent_traits = list(
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_CAN_STRIP,
		TRAIT_LITERATE,
		TRAIT_MUTANT_COLORS,
		TRAIT_NO_UNDERWEAR,
		TRAIT_HAS_MARKINGS,

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


	exotic_blood = /datum/reagent/ammonia
	digitigrade_customization = DIGITIGRADE_NEVER
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	payday_modifier = 0.75
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

/datum/species/avali/get_species_description()
	return "From the icy moon of Avalon, come Avali; the nomadic chickens with ammonia-based biology\
	and a heavy aversion towards any sanely-heated places."

/datum/species/avali/get_species_lore()
	return list("uhhh idk")


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

/datum/species/avali/get_custom_worn_icon(obj/item/item, item_slot)
	// do we have a specific icon/generated something already?
	if(item.worn_icon_avali)
		return item.worn_icon_avali

	var/default_worn_icon = item.worn_icon || item.icon
	var/default_worn_icon_state = item.worn_icon_state || item.icon_state

	// allright, do we have a greyscale config we can use instead?
	var/used_config = item.greyscale_config_worn_avali || item.greyscale_config_worn_avali_fallback
	if(used_config)
		var/expected_color_amount = SSgreyscale.configurations["[used_config]"].expected_colors
		var/list/used_colors = SSgreyscale.ParseColorString(item.greyscale_colors)
		if(length(used_colors) >= expected_color_amount)
			used_colors.len = expected_color_amount // GAGS errors if we overshoot
			return item.worn_icon_avali = SSgreyscale.GetColoredIconByType(used_config, used_colors.Join(""))

		// not enough colors, gotta guess the rest
		var/icon/final_human_icon = icon(default_worn_icon, default_worn_icon_state)
		if(item.clothing_color_coords_key)
			var/list/sampling_coords = GLOB.clothing_color_sample_coords[item.clothing_color_coords_key]
			if(length(sampling_coords) * 0.5 < expected_color_amount) // someone didnt set the config properly
				stack_trace("get_custom_worn_icon: sampling_coords length less than expected_color_amount!")
				sampling_coords.len = expected_color_amount * 2 //this is BAD, mkay?

			for(var/iter in (length(used_colors) + 1) to expected_color_amount)
				var/index = ((iter - 1) * 2) + 1
				used_colors += final_human_icon.GetPixel(sampling_coords[index], sampling_coords[index + 1]) || COLOR_DARK

		else // why must you make this difficult
			for(var/i in (length(used_colors) + 1) to expected_color_amount)
				used_colors += COLOR_DARK

		item.worn_icon_avali = SSgreyscale.GetColoredIconByType(used_config, used_colors.Join(""))
		return item.worn_icon_avali

	// fuck it, we bail
	return null

#undef AVALI_TEMP_OFFSET
#undef AVALI_HEATMOD
#undef AVALI_COLDMOD

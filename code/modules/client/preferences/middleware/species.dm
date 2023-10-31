/// Handles the assets for species icons
/datum/preference_middleware/species

/datum/preference_middleware/species/get_ui_assets()
	return list(
		get_asset_datum(/datum/asset/spritesheet/species),
	)

/datum/asset/spritesheet/species
	name = "species"
	early = TRUE
	cross_round_cachable = TRUE

/datum/asset/spritesheet/species/create_spritesheets()
	var/list/to_insert = list()

	GLOB.species_examine_icons["Unknown"] = icon('icons/effects/random_spawners.dmi', "questionmark")
	for (var/species_id in get_selectable_species())
		var/datum/species/species_type = GLOB.species_list[species_id]

		var/mob/living/carbon/human/dummy/consistent/dummy = new
		var/datum/species/new_species = new species_type
		new_species.prepare_human_for_preview(dummy)
		dummy.set_species(new_species)

		var/icon/dummy_icon = getFlatIcon(dummy)
		GLOB.species_examine_icons[initial(species_type.name)] = icon(dummy_icon)

		dummy.equipOutfit(/datum/outfit/job/assistant/consistent, visualsOnly = TRUE)
		dummy_icon = getFlatIcon(dummy)
		dummy_icon.Scale(64, 64)
		dummy_icon.Crop(15, 64, 15 + 31, 64 - 31)
		dummy_icon.Scale(64, 64)
		to_insert[sanitize_css_class_name(initial(species_type.name))] = dummy_icon

		SSatoms.prepare_deletion(dummy)

	for (var/spritesheet_key in to_insert)
		Insert(spritesheet_key, to_insert[spritesheet_key])

/// Species preference
/datum/preference/choiced/species
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "species"
	priority = PREFERENCE_PRIORITY_SPECIES
	//randomize_by_default = FALSE

/datum/preference/choiced/species/deserialize(input, datum/preferences/preferences)
	var/datum/offstation_customization/ghost_role_data = GLOB.offstation_customization_by_save_key[preferences.current_char_key]
	var/datum/species/species_type = ghost_role_data?.forced_species
	if(species_type)
		return GLOB.species_list[initial(species_type.id)]

	return GLOB.species_list[sanitize_inlist(input, get_choices_serialized(), SPECIES_HUMAN)]

/datum/preference/choiced/species/serialize(input)
	var/datum/species/species = input
	return initial(species.id)

/datum/preference/choiced/species/create_default_value(datum/preferences/preferences)
	if(preferences)
		var/datum/offstation_customization/ghost_role_data = GLOB.offstation_customization_by_save_key[preferences.current_char_key]
		if(ghost_role_data?.forced_species)
			return ghost_role_data.forced_species

	return ..()


/datum/preference/choiced/species/is_valid(value)
	for(var/slot in GLOB.offstation_customization_by_save_key)
		var/datum/offstation_customization/ghost_role_data = GLOB.offstation_customization_by_save_key[slot]
		if(ghost_role_data.forced_species && ghost_role_data.forced_species == value)
			return TRUE //this sucks ass, i hate it, but its late and im tired.
	return ..()

/datum/preference/choiced/species/init_possible_values()
	var/list/values = list()

	for (var/species_id in get_selectable_species())
		values += GLOB.species_list[species_id]

	return values

/datum/preference/choiced/species/apply_to_human(mob/living/carbon/human/target, value)
	target.set_species(value, icon_update = FALSE, pref_load = TRUE)

/datum/preference/choiced/species/compile_constant_data()
	var/list/data = list()

	var/list/selectable_species = get_selectable_species()
	for(var/ghost_role_key as anything in GLOB.offstation_customization_by_save_key)
		var/datum/offstation_customization/ghost_role_data = GLOB.offstation_customization_by_save_key[ghost_role_key]
		if(ghost_role_data.forced_species)
			selectable_species[initial(ghost_role_data.forced_species.id)] = TRUE

	for (var/species_id in selectable_species)
		var/species_type = GLOB.species_list[species_id]
		var/datum/species/species = new species_type()

		data[species_id] = list()
		data[species_id]["name"] = species.name
		if(selectable_species[species_id]) // ghost role ones set the assoc to true
			data[species_id]["desc"] = "Ermm.. how are you seeing this?"
			data[species_id]["lore"] = "File a bug report or something."
			data[species_id]["is_selectable"] = FALSE
		else
			data[species_id]["desc"] = species.get_species_description()
			data[species_id]["lore"] = species.get_species_lore()
			data[species_id]["is_selectable"] = TRUE

		var/list/all_traits = species.get_all_traits()
		data[species_id]["icon"] = sanitize_css_class_name(species.name)
		data[species_id]["sexes"] = !(TRAIT_AGENDER in all_traits)
		data[species_id]["use_skintones"] = (TRAIT_USES_SKINTONES in all_traits)
		data[species_id]["enabled_features"] = species.get_features()
		data[species_id]["perks"] = species.get_species_perks()
		data[species_id]["diet"] =  species.get_species_diet()

		qdel(species)

	return data

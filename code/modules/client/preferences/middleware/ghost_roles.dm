/datum/preference_middleware/ghost_role_customization
	key = "ghost_role_data"

/datum/preference_middleware/ghost_role_customization/get_constant_data()
	var/list/data = list()
	for(var/key as anything in GLOB.offstation_customization_by_save_key)
		var/datum/offstation_customization/ghost_role = GLOB.offstation_customization_by_save_key[key]
		var/list/role_data = list()
		role_data["slot_name"] = ghost_role.slot_name
		role_data["forced_species"] = ghost_role.forced_species

		data[key] = role_data

	return data

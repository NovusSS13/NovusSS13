/datum/unit_test/avali_sanity

/datum/unit_test/avali_sanity/Run()
	var/list/broken_icons = list()
	var/list/no_fallback = list()

	for(var/obj/item/path as anything in (subtypesof(/obj/item) - typesof(/obj/item/mod)))
		var/cached_slot_flags = initial(path.slot_flags)
		if(!cached_slot_flags || (cached_slot_flags & ITEM_SLOT_POCKETS) || initial(path.item_flags) & ABSTRACT)
			continue

		var/icon = initial(path.worn_icon_avali)
		var/icon_state = initial(path.worn_icon_state) || initial(path.icon_state)

		if(!icon_state) // ???
			continue

		//if we set that var, that means we already should have everything set up
		if(icon)
			if(!icon_exists(icon, icon_state)) //so scream if we dont
				broken_icons += path
			continue

		var/specified_gags = initial(path.greyscale_config_worn_avali)
		if(specified_gags) //works for us
			continue

		if(ispath(path, /obj/item/clothing/mask) || ispath(path, /obj/item/clothing/head))
			continue //we dont care about these

		var/fallback = initial(path.greyscale_config_worn_avali_fallback)
		if(isnull(fallback) && ispath(path, /obj/item/clothing)) //regular items we can excuse but clothing more often than not looks absolutely fucked on avali
			no_fallback += path

	if(length(broken_icons))
		var/fail_string = "[length(broken_icons)] icons with invalid worn_icon_state:"
		for(var/obj/item/path as anything in broken_icons)
			fail_string += "\n[path] ([initial(path.worn_icon_state) || initial(path.icon_state)], [initial(path.icon)])"
		TEST_FAIL(fail_string)

	if(length(no_fallback))
		var/fail_string = "[length(no_fallback)] items with neither worn_icon_avali, greyscale_config_worn_avali, nor greyscale_config_worn_avali_fallback:"
		for(var/obj/item/path as anything in no_fallback)
			fail_string += "\n[path]"
		TEST_FAIL(fail_string)

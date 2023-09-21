/*
	Hello and welcome to sprite_accessories: For sprite accessories, such as hair,
	facial hair, and possibly tattoos and stuff somewhere along the line. This file is
	intended to be friendly for people with little to no actual coding experience.
	The process of adding in new hairstyles has been made pain-free and easy to do.
	Enjoy! - Doohl

	Notice: This all gets automatically compiled in a list in dna.dm, so you do not
	have to define any UI values for sprite accessories manually for hair and facial
	hair. Just add in new hair types and the game will naturally adapt.
*/
/proc/init_sprite_accessory_subtypes(prototype, list/L, list/male, list/female, add_blank)//Roundstart argument builds a specific list for roundstart parts where some parts may be locked
	if(!istype(L))
		L = list()
	if(!istype(male))
		male = list()
	if(!istype(female))
		female = list()

	//fuck you add_blank, FUCK YOU!
	if(add_blank)
		var/blank = new /datum/sprite_accessory/blank
		L[SPRITE_ACCESSORY_NONE] = blank
		male[SPRITE_ACCESSORY_NONE] = blank
		female[SPRITE_ACCESSORY_NONE] = blank

	for(var/path in subtypesof(prototype))
		var/datum/sprite_accessory/D = new path()

		//valid accessories require a name
		if(!D.name)
			continue

		if(D.icon_state)
			L[D.name] = D
		else if(D.name)
			L += D.name

		switch(D.gender)
			if(MALE)
				male += D.name
			if(FEMALE)
				female += D.name
			else
				male += D.name
				female += D.name

	return L

/datum/sprite_accessory
	/// The preview name of the accessory.
	var/name
	/// The icon file the accessory is located in.
	var/icon
	/// The icon_state of the accessory.
	var/icon_state
	/// Dumb shit, a suffix for the feature key that should be appended when building the icon
	var/feature_suffix
	/// Determines if the accessory will be skipped or included in random hair generations.
	var/gender = NEUTER
	/// Something that can be worn by either gender, but looks different on each.
	var/gender_specific
	/// Determines if the accessory will be skipped by color preferences.
	var/use_static
	/// Amount of colors we use actually use for coloring, from 0 to 3
	var/color_amount = 1
	/// Decides if this sprite has an "inner" part, such as the fleshy parts on ears.
	var/hasinner = FALSE
	/// Is this part locked from roundstart selection? Used for parts that apply effects.
	var/locked = FALSE
	/// Should we center the sprite?
	var/center = FALSE
	/// The width of the sprite in pixels. Used to center it if necessary.
	var/dimension_x = 32
	/// The height of the sprite in pixels. Used to center it if necessary.
	var/dimension_y = 32

/datum/sprite_accessory/blank
	name = SPRITE_ACCESSORY_NONE
	icon_state = "none"
	color_amount = 0

/proc/mix_color_from_reagents(list/reagent_list)
	if(!istype(reagent_list))
		return

	var/mixcolor
	var/vol_counter = 0
	var/vol_temp

	for(var/datum/reagent/R in reagent_list)
		vol_temp = R.volume
		vol_counter += vol_temp

		if(!mixcolor)
			mixcolor = R.color

		else if (length(mixcolor) >= length(R.color))
			mixcolor = BlendRGB(mixcolor, R.color, vol_temp/vol_counter)
		else
			mixcolor = BlendRGB(R.color, mixcolor, vol_temp/vol_counter)

	return mixcolor

//same as above, except takes an assoc list of reagent type (not instance) to amount. thanks azarak, very ckrungus documentatino
/proc/mix_color_from_reagent_list(list/reagent_list)
	var/mixcolor
	var/vol_counter = 0
	var/vol_temp
	var/cached_color
	var/datum/reagent/raw_reagent

	for(var/reagent_type in reagent_list)
		vol_temp = reagent_list[reagent_type]
		vol_counter += vol_temp
		raw_reagent = reagent_type //Not initialized
		cached_color = initial(raw_reagent.color)

		if(!mixcolor)
			mixcolor = cached_color
		else if (length(mixcolor) >= length(cached_color))
			mixcolor = BlendRGB(mixcolor, cached_color, vol_temp/vol_counter)
		else
			mixcolor = BlendRGB(cached_color, mixcolor, vol_temp/vol_counter)

	return mixcolor

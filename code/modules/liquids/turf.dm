
/turf/proc/convert_immutable_liquids()
	if(!liquids || !liquids.immutable)
		return
	var/datum/reagents/tempr = liquids.take_reagents_flat(liquids.total_reagents)
	var/cached_height = liquids.height
	liquids.remove_turf(src)
	liquids = new(src)
	liquids.height = cached_height //Prevent height effects
	add_liquid_from_reagents(tempr)
	qdel(tempr)

/turf/proc/reassess_liquids()
	if(!liquids)
		return
	if(lgroup)
		lgroup.remove_from_group(src)
	SSliquids.add_active_turf(src)

/atom/movable/turf_liquid/proc/liquid_simple_delete_flat(flat_amount)
	if(flat_amount >= total_reagents)
		qdel(src, TRUE)
		return
	var/fraction = flat_amount/total_reagents
	for(var/reagent_type in reagent_list)
		var/amount = fraction * reagent_list[reagent_type]
		reagent_list[reagent_type] -= amount
		total_reagents -= amount
	has_cached_share = FALSE
	if(!my_turf.lgroup)
		calculate_height()

/turf/proc/liquid_fraction_delete(fraction)
	for(var/r_type in liquids.reagent_list)
		var/volume_change = liquids.reagent_list[r_type] * fraction
		liquids.reagent_list[r_type] -= volume_change
		liquids.total_reagents -= volume_change

/turf/proc/liquid_fraction_share(turf/shared_turf, fraction)
	if(!liquids)
		return
	if(fraction > 1)
		CRASH("Fraction share more than 100%")
	for(var/reagent_type in liquids.reagent_list)
		var/volume_change = liquids.reagent_list[reagent_type] * fraction
		liquids.reagent_list[reagent_type] -= volume_change
		liquids.total_reagents -= volume_change
		shared_turf.add_liquid(reagent_type, volume_change, TRUE, liquids.temperature)

	liquids.has_cached_share = FALSE

/turf/proc/liquid_update_turf()
	if(liquids && liquids.immutable)
		SSliquids.active_immutables[src] = TRUE
		return
	//Check atmos adjacency to cut off any disconnected groups
	if(lgroup)
		var/assoc_atmos_turfs = list()
		for(var/turf/adj_turf in get_atmos_adjacent_turfs())
			assoc_atmos_turfs[adj_turf] = TRUE

		//Check any cardinals that may have a matching group
		for(var/direction in GLOB.cardinals)
			var/turf/adj_turf = get_step(src, direction)
			//Same group of which we do not share atmos adjacency
			if(!assoc_atmos_turfs[adj_turf] && adj_turf.lgroup && adj_turf.lgroup == lgroup)
				adj_turf.lgroup.check_adjacency(adj_turf)

	SSliquids.add_active_turf(src)

/turf/proc/add_liquid_from_reagents(datum/reagents/giver, no_react = FALSE)
	var/list/compiled_list = list()
	for(var/datum/reagent/reagent as anything in giver.reagent_list)
		compiled_list[reagent.type] = reagent.volume

	add_liquid_list(compiled_list, no_react, giver.chem_temp)

//More efficient than add_liquid for multiples
/turf/proc/add_liquid_list(reagent_list, no_react = FALSE, chem_temp = 300)
	if(!liquids)
		liquids = new(src)
	if(liquids.immutable)
		return

	var/prev_total_reagents = liquids.total_reagents
	var/prev_thermal_energy = prev_total_reagents * liquids.temperature

	for(var/reagent in reagent_list)
		if(!liquids.reagent_list[reagent])
			liquids.reagent_list[reagent] = 0
		liquids.reagent_list[reagent] += reagent_list[reagent]
		liquids.total_reagents += reagent_list[reagent]

	var/recieved_thermal_energy = (liquids.total_reagents - prev_total_reagents) * chem_temp
	liquids.temperature = (recieved_thermal_energy + prev_thermal_energy) / liquids.total_reagents

	if(!no_react)
		//We do react so, make a simulation
		create_reagents(10000) //Reagents are on turf level, should they be on liquids instead?
		reagents.add_reagent_list(liquids.reagent_list, no_react = TRUE)
		reagents.chem_temp = liquids.temperature
		if(reagents.handle_reactions())//Any reactions happened, so re-calculate our reagents
			liquids.reagent_list = list()
			liquids.total_reagents = 0
			for(var/r in reagents.reagent_list)
				var/datum/reagent/R = r
				liquids.reagent_list[R.type] = R.volume
				liquids.total_reagents += R.volume

			liquids.temperature = reagents.chem_temp
			if(!liquids.total_reagents) //Our reaction exerted all of our reagents, remove self
				qdel(reagents)
				qdel(liquids)
				return
		qdel(reagents)
		//Expose turf
		liquids.ExposeMyTurf()

	liquids.calculate_height()
	liquids.set_reagent_color_for_liquid()
	liquids.has_cached_share = FALSE
	SSliquids.add_active_turf(src)
	if(lgroup)
		lgroup.dirty = TRUE

/turf/proc/add_liquid(reagent, amount, no_react = FALSE, chem_temp = 300)
	if(!liquids)
		liquids = new(src)
	if(liquids.immutable)
		return

	var/prev_thermal_energy = liquids.total_reagents * liquids.temperature

	if(!liquids.reagent_list[reagent])
		liquids.reagent_list[reagent] = 0
	liquids.reagent_list[reagent] += amount
	liquids.total_reagents += amount

	liquids.temperature = ((amount * chem_temp) + prev_thermal_energy) / liquids.total_reagents

	if(!no_react)
		//We do react so, make a simulation
		create_reagents(10000)
		reagents.add_reagent_list(liquids.reagent_list, no_react = TRUE)
		if(reagents.handle_reactions())//Any reactions happened, so re-calculate our reagents
			liquids.reagent_list = list()
			liquids.total_reagents = 0
			for(var/datum/reagent/stored_reagent in reagents.reagent_list)
				liquids.reagent_list[stored_reagent.type] = stored_reagent.volume
				liquids.total_reagents += stored_reagent.volume
			liquids.temperature = reagents.chem_temp

		qdel(reagents)
		//Expose turf
		liquids.ExposeMyTurf()

	liquids.calculate_height()
	liquids.set_reagent_color_for_liquid()
	liquids.has_cached_share = FALSE
	SSliquids.add_active_turf(src)
	if(lgroup)
		lgroup.dirty = TRUE

/obj/effect/temp_visual/liquid_splash
	icon = 'icons/effects/liquid.dmi'
	icon_state = "splash"
	layer = FLY_LAYER
	randomdir = FALSE

/***************************************************/
/********************PROPER GROUPING**************/

/turf
	var/datum/liquid_group/lgroup

/turf/proc/can_share_liquids_with(turf/shared_turf)
	if(shared_turf.z != z) //No Z here handling currently
		return FALSE
	/*
	if(T.lgroup && T.lgroup != lgroup) //TEMPORARY@!!!!!!!!
		return FALSE
	*/
	if(shared_turf.liquids && shared_turf.liquids.immutable)
		return FALSE

	var/my_liquid_height = liquids ? liquids.height : 0
	if(my_liquid_height < 1)
		return FALSE
	var/target_height = shared_turf.liquids ? shared_turf.liquids.height : 0

	//Varied heights handling:
	if(liquid_height != shared_turf.liquid_height)
		if((my_liquid_height + liquid_height) < (target_height + shared_turf.liquid_height + 1))
			return FALSE
		else
			return TRUE

	var/difference = abs(target_height - my_liquid_height)
	//The: sand effect or "piling" Very good for performance
	if(difference > 1) //SHOULD BE >= 1 or > 1? '>= 1' can lead into a lot of unnessecary processes, while ' > 1' will lead to a "piling" phenomena
		return TRUE
	return FALSE

/turf/proc/process_liquid_cell()
	if(!liquids)
		if(lgroup)
			SSliquids.remove_active_turf(src)
			return
		for(var/turf/adj_turf as anything in get_atmos_adjacent_turfs())
			if(!adj_turf.liquids)
				continue
			if(adj_turf.liquids.immutable)
				SSliquids.active_immutables[adj_turf] = TRUE
				continue
			if(!adj_turf.can_share_liquids_with(src))
				continue
			if(adj_turf.lgroup)
				lgroup = new(liquid_height)
				lgroup.add_to_group(src)
			SSliquids.add_active_turf(adj_turf)
			SSliquids.remove_active_turf(src)
			break
		SSliquids.remove_active_turf(src)
		return

	if(!lgroup)
		lgroup = new(liquid_height)
		lgroup.add_to_group(src)
	var/shared = lgroup.process_cell(src)
	if(QDELETED(liquids)) //Liquids may be deleted in process cell
		SSliquids.remove_active_turf(src)
		return
	if(!shared)
		liquids.attrition++
	if(liquids.attrition >= LIQUID_ATTRITION_TO_STOP_ACTIVITY)
		SSliquids.remove_active_turf(src)

/***************************************************/

/turf/proc/process_immutable_liquid()
	var/any_share = FALSE
	for(var/tur in get_atmos_adjacent_turfs())
		var/turf/T = tur
		if(can_share_liquids_with(T))
			//Move this elsewhere sometime later?
			if(T.liquids && T.liquids.height > liquids.height)
				continue

			any_share = TRUE
			T.add_liquid_list(liquids.reagent_list, TRUE, liquids.temperature)
	if(!any_share)
		SSliquids.active_immutables -= src


/client/proc/toggle_liquid_debug()
	set category = "Debug"
	set name = "Liquid Groups Color Debug"
	set desc = "Liquid Groups Color Debug."
	if(!holder)
		return
	GLOB.liquid_debug_colors = !GLOB.liquid_debug_colors

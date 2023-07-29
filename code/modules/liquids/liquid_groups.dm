/***************************************************/
/********************PROPER GROUPING**************/

//Whenever you add a liquid cell add its contents to the group, have the group hold the reference to total reagents for processing sake
//Have the liquid turfs point to a partial liquids reference in the group for any interactions
//Have the liquid group handle the total reagents datum, and reactions too (apply fraction?)

GLOBAL_VAR_INIT(liquid_debug_colors, FALSE)

/datum/liquid_group
	var/list/members = list()
	var/color
	var/next_share = 0
	var/dirty = TRUE
	var/amount_of_active_turfs = 0
	var/decay_counter = 0
	var/expected_turf_height = 0
	var/cached_color
	var/list/last_cached_fraction_share
	var/last_cached_total_volume = 0
	var/last_cached_thermal = 0
	var/last_cached_overlay_state = LIQUID_STATE_PUDDLE

/datum/liquid_group/proc/add_to_group(turf/added_turf)
	members[added_turf] = TRUE
	added_turf.lgroup = src
	if(SSliquids.active_turfs[added_turf])
		amount_of_active_turfs++

	added_turf.liquids?.has_cached_share = FALSE

/datum/liquid_group/proc/remove_from_group(turf/removed_turf)
	members -= removed_turf
	removed_turf.lgroup = null
	if(SSliquids.active_turfs[removed_turf])
		amount_of_active_turfs--
	if(!members.len)
		qdel(src)

/datum/liquid_group/New(height)
	SSliquids.active_groups[src] = TRUE
	color = "#[random_short_color()]"
	expected_turf_height = height

/datum/liquid_group/proc/can_merge_group(datum/liquid_group/otherg)
	if(expected_turf_height == otherg.expected_turf_height)
		return TRUE
	return FALSE

/datum/liquid_group/proc/merge_group(datum/liquid_group/otherg)
	amount_of_active_turfs += otherg.amount_of_active_turfs
	for(var/turf/turf in otherg.members)
		turf.lgroup = src
		members[turf] = TRUE
		turf.liquids?.has_cached_share = FALSE

	otherg.members = list()
	qdel(otherg)
	share()

/datum/liquid_group/proc/break_group()
	//Flag puddles to the evaporation queue
	for(var/turf/turf as anything in members)
		if(turf.liquids?.liquid_state >= LIQUID_STATE_PUDDLE)
			SSliquids.evaporation_queue[turf] = TRUE

	share(TRUE)
	qdel(src)

/datum/liquid_group/Destroy()
	SSliquids.active_groups -= src
	for(var/turf/turf as anything in members)
		turf.lgroup = null

	members = null
	return ..()

/datum/liquid_group/proc/check_adjacency(turf/checked_turf)
	var/list/recursive_adjacent = list()
	var/list/current_adjacent = list()
	current_adjacent[checked_turf] = TRUE
	recursive_adjacent[checked_turf] = TRUE
	var/getting_new_turfs = TRUE
	var/indef_loop_safety = 0

	while(getting_new_turfs && indef_loop_safety < LIQUID_RECURSIVE_LOOP_SAFETY)
		indef_loop_safety++
		getting_new_turfs = FALSE
		var/list/new_adjacent = list()
		for(var/turf/adj_turf as anything in current_adjacent)
			for(var/turf/adj_adj_turf in adj_turf.get_atmos_adjacent_turfs())
				if(recursive_adjacent[adj_adj_turf])
					continue

				recursive_adjacent[adj_adj_turf] = TRUE
				new_adjacent[adj_adj_turf] = TRUE
				getting_new_turfs = TRUE

		current_adjacent = new_adjacent

	//All adjacent, somehow
	if(recursive_adjacent.len == members.len)
		return

	var/datum/liquid_group/new_group = new(expected_turf_height)
	for(var/turf/turf as anything in members)
		if(!recursive_adjacent[turf])
			remove_from_group(turf)
			new_group.add_to_group(turf)

/datum/liquid_group/proc/share(use_liquids_color = FALSE)
	var/any_share = FALSE
	var/cached_shares = 0
	var/list/cached_add = list()
	var/cached_volume = 0
	var/cached_thermal = 0

	var/atom/movable/turf_liquid/cached_liquids
	for(var/turf/turf as anything in members)
		if(!turf.liquids)
			continue

		any_share = TRUE
		cached_liquids = turf.liquids

		if(cached_liquids.has_cached_share && last_cached_fraction_share)
			cached_shares++
			continue

		for(var/reagent_type in cached_liquids.reagent_list)
			if(!cached_add[reagent_type])
				cached_add[reagent_type] = 0
			cached_add[reagent_type] += cached_liquids.reagent_list[reagent_type]

		cached_volume += cached_liquids.total_reagents
		cached_thermal += cached_liquids.total_reagents * cached_liquids.temperature

	if(!any_share)
		return

	decay_counter = 0

	if(cached_shares)
		for(var/reagent_type in last_cached_fraction_share)
			if(!cached_add[reagent_type])
				cached_add[reagent_type] = 0
			cached_add[reagent_type] += last_cached_fraction_share[reagent_type] * cached_shares
		cached_volume += last_cached_total_volume * cached_shares
		cached_thermal += cached_shares * last_cached_thermal

	for(var/reagent_type in cached_add)
		cached_add[reagent_type] = cached_add[reagent_type] / members.len
	cached_volume = cached_volume / members.len
	cached_thermal = cached_thermal / members.len
	var/temp_to_set = cached_thermal / cached_volume
	last_cached_thermal = cached_thermal
	last_cached_fraction_share = cached_add
	last_cached_total_volume = cached_volume
	var/mixed_color = use_liquids_color ? mix_color_from_reagent_list(cached_add) : color
	if(use_liquids_color)
		mixed_color = mix_color_from_reagent_list(cached_add)
	else if (GLOB.liquid_debug_colors)
		mixed_color = color
	else
		if(!cached_color)
			cached_color = mix_color_from_reagent_list(cached_add)
		mixed_color = cached_color

	var/height = CEILING(cached_volume/LIQUID_HEIGHT_DIVISOR, 1)

	var/determined_new_state
	var/state_height = height
	if(expected_turf_height > 0)
		state_height += expected_turf_height
	switch(state_height)
		if(0 to LIQUID_ANKLES_LEVEL_HEIGHT-1)
			determined_new_state = LIQUID_STATE_PUDDLE
		if(LIQUID_ANKLES_LEVEL_HEIGHT to LIQUID_WAIST_LEVEL_HEIGHT-1)
			determined_new_state = LIQUID_STATE_ANKLES
		if(LIQUID_WAIST_LEVEL_HEIGHT to LIQUID_SHOULDERS_LEVEL_HEIGHT-1)
			determined_new_state = LIQUID_STATE_WAIST
		if(LIQUID_SHOULDERS_LEVEL_HEIGHT to LIQUID_FULLTILE_LEVEL_HEIGHT-1)
			determined_new_state = LIQUID_STATE_SHOULDERS
		if(LIQUID_FULLTILE_LEVEL_HEIGHT to INFINITY)
			determined_new_state = LIQUID_STATE_FULLTILE

	var/new_liquids = FALSE
	for(var/turf/turf in members)
		new_liquids = FALSE
		if(!turf.liquids)
			new_liquids = TRUE
			turf.liquids = new(turf)
		cached_liquids = turf.liquids

		cached_liquids.reagent_list = cached_add.Copy()
		cached_liquids.total_reagents = cached_volume
		cached_liquids.temperature = temp_to_set

		cached_liquids.has_cached_share = TRUE
		cached_liquids.attrition = 0

		cached_liquids.color = mixed_color
		cached_liquids.set_height(height)

		if(determined_new_state != cached_liquids.liquid_state)
			cached_liquids.set_new_liquid_state(determined_new_state)

		//Only simulate a turf exposure when we had to create a new liquid tile
		if(new_liquids)
			cached_liquids.ExposeMyTurf()

/datum/liquid_group/proc/process_cell(turf/processed_turf)
	if(processed_turf.liquids.height <= 1) //Causes a bug when the liquid hangs in the air and is supposed to fall down a level
		return FALSE

	for(var/turf/adj_turf as anything in processed_turf.get_atmos_adjacent_turfs())
		//Immutable check thing
		if(adj_turf.liquids?.immutable)
			if(processed_turf.z != adj_turf.z)
				var/turf/Z_turf_below = GET_TURF_BELOW(processed_turf)
				if(adj_turf != Z_turf_below)
					continue
				qdel(processed_turf.liquids, TRUE)
				return

			//CHECK DIFFERENT TURF HEIGHT THING
			if(processed_turf.liquid_height != adj_turf.liquid_height)
				var/my_liquid_height = processed_turf.liquid_height + processed_turf.liquids.height
				var/target_liquid_height = adj_turf.liquid_height + adj_turf.liquids.height
				if(my_liquid_height - target_liquid_height > 2)
					var/coeff = (processed_turf.liquids.height / (processed_turf.liquids.height + abs(processed_turf.liquid_height)))
					var/height_diff = min(0.4, abs((target_liquid_height / my_liquid_height) - 1) * coeff)
					processed_turf.liquid_fraction_delete(height_diff)
					. = TRUE
				continue

			if(adj_turf.liquids.height > processed_turf.liquids.height + 1)
				SSliquids.active_immutables[adj_turf] = TRUE
				. = TRUE
				continue
		//END OF IMMUTABLE MADNESS

		if(processed_turf.z != adj_turf.z)
			var/turf/Z_turf_below = GET_TURF_BELOW(processed_turf)
			if(adj_turf == Z_turf_below)
				if(!(adj_turf.liquids && adj_turf.liquids.height + adj_turf.liquid_height >= LIQUID_HEIGHT_CONSIDER_FULL_TILE))
					processed_turf.liquid_fraction_share(adj_turf, 1)
					qdel(processed_turf.liquids, TRUE)
					. = TRUE
			continue
		//CHECK DIFFERENT TURF HEIGHT THING
		if(processed_turf.liquid_height != adj_turf.liquid_height)
			var/my_liquid_height = processed_turf.liquid_height + processed_turf.liquids.height
			var/target_liquid_height = adj_turf.liquid_height + (adj_turf.liquids ? adj_turf.liquids.height : 0)
			if(my_liquid_height > target_liquid_height+1)
				var/coeff = (processed_turf.liquids.height / (processed_turf.liquids.height + abs(processed_turf.liquid_height)))
				var/height_diff = min(0.4,abs((target_liquid_height / my_liquid_height)-1)*coeff)
				processed_turf.liquid_fraction_share(adj_turf, height_diff)
				. = TRUE
			continue
		//END OF TURF HEIGHT
		if(!processed_turf.can_share_liquids_with(adj_turf))
			continue
		if(!adj_turf.lgroup)
			add_to_group(adj_turf)
		//Try merge groups if possible
		else if(adj_turf.lgroup != processed_turf.lgroup && processed_turf.lgroup.can_merge_group(adj_turf.lgroup))
			processed_turf.lgroup.merge_group(adj_turf.lgroup)
		. = TRUE
		SSliquids.add_active_turf(adj_turf)
	if(.)
		dirty = TRUE
			//return //Do we want it to spread once per process or many times?
	//Make sure to handle up/down z levels on adjacency properly

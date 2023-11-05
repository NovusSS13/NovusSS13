/atom/movable/turf_liquid
	name = "liquid"
	icon = 'icons/effects/liquid.dmi'
	icon_state = "water-0"
	base_icon_state = "water"
	anchored = TRUE
	plane = FLOOR_PLANE
	color = "#DDDDFF"

	//For being on fire
	light_range = 0
	light_power = 1
	light_color = LIGHT_COLOR_FIRE

	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_WATER
	canSmoothWith = SMOOTH_GROUP_WATER + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS

	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	/// Turf that owns us, should always be kept up to date
	var/turf/my_turf

	var/height = 1
	var/liquid_state = LIQUID_STATE_PUDDLE
	var/has_cached_share = FALSE

	var/attrition = 0

	var/immutable = FALSE

	var/list/reagent_list = list()
	var/total_reagents = 0
	var/temperature = T20C

	var/fire_state = LIQUID_FIRE_STATE_NONE

	/// If true, we won't display any visual effects
	var/no_effects = FALSE

	/// State-specific message chunks for examine_turf()
	var/static/list/liquid_state_messages = list(
		"[LIQUID_STATE_PUDDLE]" = "a puddle of %LIQUID",
		"[LIQUID_STATE_ANKLES]" = "%LIQUID going [span_warning("up to your ankles")]",
		"[LIQUID_STATE_WAIST]" = "%LIQUID going [span_warning("up to your waist")]",
		"[LIQUID_STATE_SHOULDERS]" = "%LIQUID going [span_warning("up to your shoulders")]",
		"[LIQUID_STATE_FULLTILE]" = "%LIQUID going [span_danger("over your head")]",
	)

/atom/movable/turf_liquid/onShuttleMove(turf/newT, turf/oldT, list/movement_force, move_dir, obj/docking_port/stationary/old_dock, obj/docking_port/mobile/moving_dock)
	return

/atom/movable/turf_liquid/proc/set_new_liquid_state(new_state)
	liquid_state = new_state
	if(no_effects)
		return

	update_appearance(UPDATE_ICON)

/atom/movable/turf_liquid/proc/check_fire(hotspotted = FALSE)
	var/my_burn_power = get_burn_power(hotspotted)
	if(!my_burn_power)
		if(fire_state)
			//Set state to 0
			set_fire_state(LIQUID_FIRE_STATE_NONE)
		return FALSE
	//Calculate appropriate state
	var/new_state = LIQUID_FIRE_STATE_SMALL
	switch(my_burn_power)
		if(0 to 7)
			new_state = LIQUID_FIRE_STATE_SMALL
		if(7 to 8)
			new_state = LIQUID_FIRE_STATE_MILD
		if(8 to 9)
			new_state = LIQUID_FIRE_STATE_MEDIUM
		if(9 to 10)
			new_state = LIQUID_FIRE_STATE_HUGE
		if(10 to INFINITY)
			new_state = LIQUID_FIRE_STATE_INFERNO

	if(fire_state != new_state)
		set_fire_state(new_state)

	return TRUE

/atom/movable/turf_liquid/proc/set_fire_state(new_state)
	fire_state = new_state
	switch(fire_state)
		if(LIQUID_FIRE_STATE_NONE)
			set_light_range(0)
		if(LIQUID_FIRE_STATE_SMALL)
			set_light_range(LIGHT_RANGE_FIRE)
		if(LIQUID_FIRE_STATE_MILD)
			set_light_range(LIGHT_RANGE_FIRE)
		if(LIQUID_FIRE_STATE_MEDIUM)
			set_light_range(LIGHT_RANGE_FIRE)
		if(LIQUID_FIRE_STATE_HUGE)
			set_light_range(LIGHT_RANGE_FIRE)
		if(LIQUID_FIRE_STATE_INFERNO)
			set_light_range(LIGHT_RANGE_FIRE)
	update_light()
	update_appearance(UPDATE_ICON)

/atom/movable/turf_liquid/proc/get_burn_power(hotspotted = FALSE)
	//We are not on fire and werent ignited by a hotspot exposure, no fire pls
	if(!hotspotted && !fire_state)
		return FALSE
	var/has_oxygen = FALSE
	if(isopenturf(my_turf))
		var/turf/open/open_turf = my_turf
		var/datum/gas_mixture/air = open_turf.return_air()
		if(air?.gases[GAS_O2] > 0)
			has_oxygen = TRUE
	var/total_burn_power = 0
	for(var/datum/reagent/reagent_type as anything in reagent_list)
		var/burn_power = initial(reagent_type.liquid_fire_power)
		if(burn_power && (has_oxygen || !initial(reagent_type.liquid_fire_needs_oxygen)))
			total_burn_power += burn_power * reagent_list[reagent_type]
	if(!total_burn_power)
		return FALSE
	total_burn_power /= total_reagents //We get burn power per unit.
	if(total_burn_power <= REQUIRED_FIRE_POWER_PER_UNIT)
		return FALSE
	//Finally, we burn
	return total_burn_power

/atom/movable/turf_liquid/extinguish()
	. = ..()
	if(fire_state)
		set_fire_state(LIQUID_FIRE_STATE_NONE)

/atom/movable/turf_liquid/proc/process_fire()
	if(!fire_state)
		SSliquids.processing_fire -= my_turf
	var/old_state = fire_state
	if(!check_fire())
		SSliquids.processing_fire -= my_turf
	//Try spreading
	if(fire_state == old_state) //If an extinguisher made our fire smaller, dont spread, else it's too hard to put out
		for(var/turf/adj_turf as anything in my_turf.atmos_adjacent_turfs)
			if(adj_turf.liquids && !adj_turf.liquids.fire_state && adj_turf.liquids.check_fire(TRUE))
				SSliquids.processing_fire[adj_turf] = TRUE
	//Burn our resources
	var/burn_rate
	//casted as reagent bcuz of initial
	for(var/datum/reagent/reagent_type as anything in reagent_list)
		burn_rate = initial(reagent_type.liquid_fire_burn_rate)
		if(burn_rate)
			var/amt = reagent_list[reagent_type]
			if(burn_rate >= amt)
				reagent_list -= reagent_type
				total_reagents -= amt
			else
				reagent_list[reagent_type] -= burn_rate
				total_reagents -= burn_rate

	my_turf.hotspot_expose((T20C + 50) + (50 * fire_state), 125)
	for(var/atom/movable/movable as anything in my_turf)
		if(QDELETED(movable))
			continue

		movable.fire_act((T20C + 50) + (50 * fire_state), 125)

	if(!LAZYLEN(reagent_list))
		qdel(src, TRUE)
		return

	has_cached_share = FALSE
	if(!my_turf.lgroup)
		calculate_height()
		set_reagent_color_for_liquid()

/atom/movable/turf_liquid/proc/process_evaporation()
	if(immutable)
		SSliquids.evaporation_queue -= my_turf
		return
	//We're in a group. dont try and evaporate
	if(my_turf.lgroup)
		SSliquids.evaporation_queue -= my_turf
		return
	if(liquid_state != LIQUID_STATE_PUDDLE)
		SSliquids.evaporation_queue -= my_turf
		return

	//See if any of our reagents evaporated
	var/any_change = FALSE
	//cast as reagent bcuz initial
	for(var/datum/reagent/reagent_type as anything in reagent_list)
		var/evaporation_rate = initial(reagent_type.liquid_evaporation_rate)
		if(!evaporation_rate)
			continue
		//We evaporate - bye bye
		var/evaporated = min(evaporation_rate, reagent_list[reagent_type])
		total_reagents -= evaporated
		reagent_list[reagent_type] -= evaporated
		if(reagent_list[reagent_type] <= 0)
			reagent_list -= reagent_type
		any_change = TRUE

	if(!any_change)
		SSliquids.evaporation_queue -= my_turf
		return

	//No total reagents. Commit death
	if(!LAZYLEN(reagent_list))
		qdel(src, TRUE)
		return

	//Reagents still left. Recalculte height and color and remove us from the queue
	has_cached_share = FALSE
	SSliquids.evaporation_queue -= my_turf
	calculate_height()
	set_reagent_color_for_liquid()

/atom/movable/turf_liquid/forceMove(atom/destination, forced = FALSE)
	if(forced)
		return ..()
	return

/atom/movable/turf_liquid/update_overlays()
	. = ..()
	if(no_effects)
		return

	if(liquid_state <= LIQUID_STATE_PUDDLE)
		var/mutable_appearance/shine = mutable_appearance('icons/effects/liquid_overlays.dmi', "shine", alpha = 32, appearance_flags = RESET_COLOR|RESET_ALPHA)
		shine.blend_mode = BLEND_ADD
		. += shine
	else
		. += mutable_appearance('icons/effects/liquid_overlays.dmi', "stage[liquid_state - 1]_bottom", ABOVE_MOB_LAYER, offset_spokesman = src, plane = GAME_PLANE_UPPER)
		if(liquid_state < LIQUID_STATE_FULLTILE)
			. += mutable_appearance('icons/effects/liquid_overlays.dmi', "stage[liquid_state - 1]_top", GATEWAY_UNDERLAY_LAYER, offset_spokesman = src, plane = GAME_PLANE)

	//Add a fire overlay lastly, if necessary
	if(fire_state < LIQUID_FIRE_STATE_SMALL)
		return

	var/mutable_appearance/liquid_fire = mutable_appearance('icons/effects/liquid_overlays.dmi', BELOW_MOB_LAYER, offset_spokesman = src, plane = GAME_PLANE, appearance_flags = RESET_COLOR|RESET_ALPHA)
	switch(fire_state)
		if(LIQUID_FIRE_STATE_SMALL, LIQUID_FIRE_STATE_MILD)
			liquid_fire.icon_state = "fire_small"
		if(LIQUID_FIRE_STATE_MEDIUM)
			liquid_fire.icon_state = "fire_medium"
		if(LIQUID_FIRE_STATE_HUGE, LIQUID_FIRE_STATE_INFERNO)
			liquid_fire.icon_state = "fire_big"
	. += liquid_fire
	. += emissive_appearance(liquid_fire.icon, liquid_fire.icon_state, offset_spokesman = src)

//Takes a flat of our reagents and returns it, possibly qdeling our liquids
/atom/movable/turf_liquid/proc/take_reagents_flat(flat_amount)
	var/datum/reagents/temp_reagents = new(10000)
	if(flat_amount >= total_reagents)
		temp_reagents.add_reagent_list(reagent_list, no_react = TRUE)
		qdel(src, TRUE)
	else
		var/fraction = flat_amount/total_reagents
		var/passed_list = list()
		for(var/reagent_type in reagent_list)
			var/amount = fraction * reagent_list[reagent_type]
			reagent_list[reagent_type] -= amount
			total_reagents -= amount
			passed_list[reagent_type] = amount
		temp_reagents.add_reagent_list(passed_list, no_react = TRUE)
		has_cached_share = FALSE

	temp_reagents.chem_temp = temperature
	return temp_reagents

/atom/movable/turf_liquid/immutable/take_reagents_flat(flat_amount)
	return simulate_reagents_flat(flat_amount)

//Returns a reagents holder with all the reagents with a higher volume than the threshold
/atom/movable/turf_liquid/proc/simulate_reagents_threshold(amount_threshold)
	var/datum/reagents/temp_reagents = new(10000)
	var/passed_list = list()
	for(var/reagent_type in reagent_list)
		var/amount = reagent_list[reagent_type]
		if(amount_threshold && amount < amount_threshold)
			continue
		passed_list[reagent_type] = amount

	temp_reagents.add_reagent_list(passed_list, no_react = TRUE)
	temp_reagents.chem_temp = temperature
	return temp_reagents

//Returns a flat of our reagents without any effects on the liquids
/atom/movable/turf_liquid/proc/simulate_reagents_flat(flat_amount)
	var/datum/reagents/temp_reagents = new(10000)
	if(flat_amount >= total_reagents)
		temp_reagents.add_reagent_list(reagent_list, no_react = TRUE)
		temp_reagents.chem_temp = temperature
		return temp_reagents

	var/fraction = flat_amount/total_reagents
	var/passed_list = list()
	for(var/reagent_type in reagent_list)
		var/amount = fraction * reagent_list[reagent_type]
		passed_list[reagent_type] = amount

	temp_reagents.add_reagent_list(passed_list, no_react = TRUE)
	temp_reagents.chem_temp = temperature
	return temp_reagents

/atom/movable/turf_liquid/fire_act(temperature, volume)
	. = ..()
	if(fire_state)
		return

	if(check_fire(hotspotted = TRUE))
		SSliquids.processing_fire[my_turf] = TRUE

/atom/movable/turf_liquid/proc/set_reagent_color_for_liquid()
	color = mix_color_from_reagent_list(reagent_list)

/atom/movable/turf_liquid/proc/calculate_height()
	var/new_height = CEILING(total_reagents, 1)/LIQUID_HEIGHT_DIVISOR
	var/determined_new_state

	set_height(new_height)
	switch(new_height)
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

	if(determined_new_state != liquid_state)
		set_new_liquid_state(determined_new_state)

/atom/movable/turf_liquid/proc/set_height(new_height)
	var/prev_height = height
	height = new_height
	if(abs(height - prev_height) <= WATER_HEIGH_DIFFERENCE_DELTA_SPLASH)
		return //nothing to do

	//Splash
	if(prob(WATER_HEIGH_DIFFERENCE_SOUND_CHANCE))
		var/sound_to_play = pick(
			'sound/effects/water_wade1.ogg',
			'sound/effects/water_wade2.ogg',
			'sound/effects/water_wade3.ogg',
			'sound/effects/water_wade4.ogg',
		)
		playsound(my_turf, sound_to_play, 60, 0)

	var/obj/effect/temp_visual/liquid_splash/splashy = new(my_turf)
	splashy.color = color
	if(height < LIQUID_WAIST_LEVEL_HEIGHT)
		return

	//Push things into some direction, like space wind
	var/turf/dest_turf
	var/last_height = height
	for(var/turf/adj_turf as anything in my_turf.atmos_adjacent_turfs)
		if(adj_turf.z != my_turf.z)
			continue
		if(!adj_turf.liquids) //Automatic winner
			dest_turf = adj_turf
			break
		if(adj_turf.liquids.height < last_height)
			dest_turf = adj_turf
			last_height = adj_turf.liquids.height

	if(!dest_turf)
		return

	var/dir = get_dir(my_turf, dest_turf)
	for(var/atom/movable/movable as anything in my_turf)
		if(movable.anchored || movable.pulledby || isobserver(movable) || (movable.move_resist >= INFINITY))
			continue

		if(!iscarbon(movable))
			step(movable, dir)
			continue

		var/mob/living/carbon/carbon_mob = movable
		if(HAS_TRAIT(carbon_mob, TRAIT_NEGATES_GRAVITY))
			continue

		step(carbon_mob, dir)
		if(prob(60) && (carbon_mob.body_position != LYING_DOWN))
			to_chat(carbon_mob, span_userdanger("The current knocks you down!"))
			carbon_mob.Paralyze(2 SECONDS)
			carbon_mob.Knockdown(6 SECONDS)

/atom/movable/turf_liquid/immutable/set_height(new_height)
	height = new_height

/atom/movable/turf_liquid/proc/movable_entered(turf/source_turf, atom/movable/movable)
	SIGNAL_HANDLER
	if(isobserver(movable) || iscameramob(movable))
		return //ghosts, camera eyes, etc. don't make water splashy splashy

	if(liquid_state >= LIQUID_STATE_ANKLES)
		if(prob(30))
			var/sound_to_play = pick(
				'sound/effects/water_wade1.ogg',
				'sound/effects/water_wade2.ogg',
				'sound/effects/water_wade3.ogg',
				'sound/effects/water_wade4.ogg',
			)
			playsound(source_turf, sound_to_play, 50, 0)

		if(iscarbon(movable))
			var/mob/living/carbon/carbon_mob = movable
			carbon_mob.apply_status_effect(/datum/status_effect/water_affected)

	else if(isliving(movable))
		var/mob/living/living_mob = movable
		if(prob(7) && !(living_mob.movement_type & FLYING))
			living_mob.slip(60, source_turf, NO_SLIP_WHEN_WALKING, 20, TRUE)

	if(fire_state)
		movable.fire_act((T20C + 50) + (50 * fire_state), 125)

/atom/movable/turf_liquid/proc/mob_fall(datum/source, list/falling_movables, levels)
	var/turf/turf = source
	if(!istype(turf)) //what
		return NONE

	if(levels > 3) //you remember how they tell you to never land in water
		return NONE //yeah

	if(liquid_state < LIQUID_STATE_ANKLES || !turf.has_gravity(turf))
		return NONE

	for(var/atom/movable/movable as anything in falling_movables)
		playsound(turf, 'sound/effects/bigsplash.ogg', 50, 0) //earrape intended
		if(!iscarbon(movable))
			to_chat(movable, span_userdanger("You fall in the water!"))
			continue

		var/mob/living/carbon/fallen_mob = movable
		if(fallen_mob.wear_mask?.flags_cover & MASKCOVERSMOUTH)
			to_chat(fallen_mob, span_userdanger("You fall in the water!"))
			continue

		var/datum/reagents/turf_reagents = take_reagents_flat(CHOKE_REAGENTS_INGEST_ON_FALL_AMOUNT)
		turf_reagents.trans_to(fallen_mob, turf_reagents.total_volume, methods = INGEST)
		qdel(turf_reagents)

		fallen_mob.adjustOxyLoss(5)
		fallen_mob.emote("cough")
		to_chat(fallen_mob, span_userdanger("You fall in and swallow some water!"))

/atom/movable/turf_liquid/Initialize(mapload)
	. = ..()
	if(isspaceturf(my_turf))
		return INITIALIZE_HINT_QDEL
	if(!SSliquids)
		CRASH("Liquid Turf created with the liquids sybsystem not yet initialized!")
	if(!immutable)
		my_turf = loc
		RegisterSignal(my_turf, COMSIG_ATOM_ENTERED, PROC_REF(movable_entered))
		RegisterSignal(my_turf, COMSIG_ATOM_INTERCEPT_Z_FALL, PROC_REF(mob_fall))
		RegisterSignal(my_turf, COMSIG_ATOM_EXAMINE, PROC_REF(examine_turf))
		SSliquids.add_active_turf(my_turf)

		SEND_SIGNAL(my_turf, COMSIG_TURF_LIQUIDS_CREATION, src)

	update_appearance()
	QUEUE_SMOOTH(src)
	QUEUE_SMOOTH_NEIGHBORS(src)

/atom/movable/turf_liquid/Destroy(force)
	if(my_turf)
		UnregisterSignal(my_turf, list(COMSIG_ATOM_ENTERED, COMSIG_ATOM_INTERCEPT_Z_FALL, COMSIG_ATOM_EXAMINE))
		if(my_turf.lgroup)
			my_turf.lgroup.remove_from_group(my_turf)
		if(SSliquids.evaporation_queue[my_turf])
			SSliquids.evaporation_queue -= my_turf
		if(SSliquids.processing_fire[my_turf])
			SSliquids.processing_fire -= my_turf
		//Is added because it could invoke a change to neighboring liquids
		SSliquids.add_active_turf(my_turf)
		my_turf.liquids = null
		my_turf = null
		QUEUE_SMOOTH_NEIGHBORS(src)
	return ..()

/atom/movable/turf_liquid/immutable/Destroy(force)
	if(force)
		stack_trace("Something tried to hard destroy an immutable liquid.")
	return ..()

//Exposes my turf with simulated reagents
/atom/movable/turf_liquid/proc/ExposeMyTurf()
	var/datum/reagents/tempr = simulate_reagents_threshold(LIQUID_REAGENT_THRESHOLD_TURF_EXPOSURE)
	tempr.expose(my_turf, TOUCH, tempr.total_volume)
	qdel(tempr)

/atom/movable/turf_liquid/proc/ChangeToNewTurf(turf/NewT)
	if(NewT.liquids)
		stack_trace("Liquids tried to change to a new turf, that already had liquids on it!")

	UnregisterSignal(my_turf, list(COMSIG_ATOM_ENTERED, COMSIG_ATOM_INTERCEPT_Z_FALL))
	if(SSliquids.active_turfs[my_turf])
		SSliquids.active_turfs -= my_turf
		SSliquids.active_turfs[NewT] = TRUE
	if(SSliquids.evaporation_queue[my_turf])
		SSliquids.evaporation_queue -= my_turf
		SSliquids.evaporation_queue[NewT] = TRUE
	if(SSliquids.processing_fire[my_turf])
		SSliquids.processing_fire -= my_turf
		SSliquids.processing_fire[NewT] = TRUE
	my_turf.liquids = null
	my_turf = NewT
	NewT.liquids = src
	loc = NewT
	RegisterSignal(my_turf, COMSIG_ATOM_ENTERED, PROC_REF(movable_entered))
	RegisterSignal(my_turf, COMSIG_ATOM_INTERCEPT_Z_FALL, PROC_REF(mob_fall))

/**
 * Handles COMSIG_ATOM_EXAMINE for the turf.
 *
 * Adds reagent info to examine text.
 * Arguments:
 * * source - the turf we're peekin at
 * * examiner - the user
 * * examine_text - the examine list
 *  */
/atom/movable/turf_liquid/proc/examine_turf(turf/source, mob/examiner, list/examine_list)
	SIGNAL_HANDLER

	// This should always have reagents if this effect object exists, but as a sanity check...
	if(!length(reagent_list))
		return

	var/liquid_state_template = liquid_state_messages["[liquid_state]"]
	// Show the liquid state
	examine_list += span_notice("There is [replacetext(liquid_state_template, "%LIQUID", "liquid")] here.")

	// Showing specific reagents if possible
	if(!examiner.can_see_reagents())
		return

	if(length(reagent_list) == 1)
		// Single reagent text
		var/datum/reagent/reagent_type = reagent_list[1]
		var/reagent_name = initial(reagent_type.name)
		var/volume = round(reagent_list[reagent_type], 0.01)
		examine_list += span_info("There is [replacetext(liquid_state_template, "%LIQUID", "[volume] units of [reagent_name]")] here.")
	else
		// Show each individual reagent
		var/volume = round(total_reagents, 0.01)
		examine_list += span_info("There is [replacetext(liquid_state_template, "%LIQUID", "[volume] units of the following")] here:")
		for(var/datum/reagent/reagent_type as anything in reagent_list)
			var/reagent_name = initial(reagent_type.name)
			volume = round(reagent_list[reagent_type], 0.01)
			examine_list += span_info("&bull; [volume] units of [reagent_name]")
	examine_list += span_info("The solution has a temperature of [temperature]K.")

/obj/effect/temp_visual/liquid_splash
	icon = 'icons/effects/liquid.dmi'
	icon_state = "splash"
	layer = FLY_LAYER
	randomdir = FALSE

/atom/movable/turf_liquid/immutable
	immutable = TRUE
	var/list/starting_mixture = list(/datum/reagent/water = 600)
	var/starting_temp = T20C

//STRICTLY FOR IMMUTABLES DESPITE NOT BEING /immutable
/atom/movable/turf_liquid/proc/add_turf(turf/added_turf)
	added_turf.liquids = src
	added_turf.vis_contents += src
	SSliquids.active_immutables[added_turf] = TRUE
	RegisterSignal(added_turf, COMSIG_ATOM_ENTERED, PROC_REF(movable_entered))
	RegisterSignal(added_turf, COMSIG_ATOM_INTERCEPT_Z_FALL, PROC_REF(mob_fall))

/atom/movable/turf_liquid/proc/remove_turf(turf/removed_turf)
	SSliquids.active_immutables -= removed_turf
	removed_turf.liquids = null
	removed_turf.vis_contents -= src
	UnregisterSignal(removed_turf, list(COMSIG_ATOM_ENTERED, COMSIG_ATOM_INTERCEPT_Z_FALL))

/atom/movable/turf_liquid/immutable/ocean
	smoothing_flags = NONE
	icon_state = "ocean"
	base_icon_state = "ocean"
	plane = DEFAULT_PLANE //Same as weather, etc.
	layer = ABOVE_MOB_LAYER
	starting_temp = T20C-150
	no_effects = TRUE
	vis_flags = NONE

/atom/movable/turf_liquid/immutable/ocean/warm
	starting_temp = T20C+20

/atom/movable/turf_liquid/immutable/Initialize(mapload)
	. = ..()
	reagent_list = starting_mixture.Copy()
	total_reagents = 0
	for(var/key in reagent_list)
		total_reagents += reagent_list[key]
	temperature = starting_temp
	calculate_height()
	set_reagent_color_for_liquid()

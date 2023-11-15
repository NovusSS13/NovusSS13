/turf/open
	plane = FLOOR_PLANE
	///negative for faster, positive for slower
	var/slowdown = 0

	var/footstep = null
	var/barefootstep = null
	var/clawfootstep = null
	var/heavyfootstep = null

	/// Determines the type of damage overlay that will be used for the tile
	var/damaged_dmi = null
	var/broken = FALSE
	var/burnt = FALSE

/turf/open/attackby(obj/item/attacking_item, mob/user, params)
	. = ..()
	var/obj/item/reagent_containers/container = attacking_item
	if(!istype(container) || isnull(liquids) || !(container.reagent_flags & REFILLABLE))
		return

	if(liquids.fire_state) //Use an extinguisher first
		to_chat(user, span_warning("You can't scoop up anything while it's on fire!"))
		return TRUE

	if(liquids.height == 1)
		to_chat(user, span_warning("The puddle is too shallow to scoop anything up!"))
		return TRUE

	var/free_space = round(container.reagents.maximum_volume - container.reagents.total_volume, CHEMICAL_VOLUME_ROUNDING)
	if(free_space <= 0)
		to_chat(user, span_warning("You can't fit any more liquids inside [src]!"))
		return TRUE

	var/desired_transfer = min(container.amount_per_transfer_from_this, free_space, liquids.total_reagents)
	var/datum/reagents/turf_reagents = liquids.take_reagents_flat(desired_transfer)
	turf_reagents.trans_to(container.reagents, turf_reagents.total_volume)
	qdel(turf_reagents)
	to_chat(user, span_notice("You scoop up around [CEILING(desired_transfer, 1)] units of liquids with [src]."))
	user.changeNext_move(CLICK_CD_MELEE)
	return TRUE


/turf/open/CanPass(atom/movable/mover, border_dir)
	if(isliving(mover))
		var/turf/AT = get_turf(mover)
		if(AT && AT.turf_height - turf_height <= -TURF_HEIGHT_BLOCK_THRESHOLD)
			return FALSE
	return ..()

/turf/open/Exit(atom/movable/mover, atom/newloc)
	. = ..()
	if(. && isliving(mover) && mover.has_gravity() && isturf(newloc))
		var/mob/living/L = mover
		var/turf/T = get_turf(newloc)
		if(T && T.turf_height - turf_height <= -TURF_HEIGHT_BLOCK_THRESHOLD)
			L.on_fall()
			L.onZImpact(T, 1)

/turf/open/MouseDrop_T(mob/living/M, mob/living/user)
	if(!isliving(M) || !isliving(user) || !M.has_gravity() || !Adjacent(user) || !M.Adjacent(user) || !(user.stat == CONSCIOUS) || user.body_position == LYING_DOWN)
		return
	if(!M.has_gravity())
		return
	var/turf/T = get_turf(M)
	if(!T)
		return
	if(T.turf_height - turf_height <= -TURF_HEIGHT_BLOCK_THRESHOLD)
		//Climb up
		if(user == M)
			M.visible_message(
				span_notice("[user] starts climbing onto [src].."),
				span_notice("You start climbing onto [src].")
			)
		else
			M.visible_message(
				span_notice("[user] starts pulling [M] onto [src].."),
				span_notice("You start pulling [M] onto [src]..")
			)

		if(do_after(user, 2 SECONDS, M))
			M.forceMove(src)
		return
	if(turf_height - T.turf_height <= -TURF_HEIGHT_BLOCK_THRESHOLD)
		//Climb down
		if(user == M)
			M.visible_message(
				span_notice("[user] starts lowering down to [src].."),
				span_notice("You start lowering yourself to [src]..")
			)
		else
			M.visible_message(
				span_notice("[user] starts lowering [M] down to [src].."),
				span_notice("You start lowering [M] down to [src]..")
			)
		if(do_after(user, 2 SECONDS, M))
			M.forceMove(src)
		return

/// Returns a list of every turf state considered "broken".
/// Will be randomly chosen if a turf breaks at runtime.
/turf/open/proc/broken_states()
	return list()

/// Returns a list of every turf state considered "burnt".
/// Will be randomly chosen if a turf is burnt at runtime.
/turf/open/proc/burnt_states()
	return list()

/turf/open/break_tile()
	if(isnull(damaged_dmi) || broken)
		return FALSE
	broken = TRUE
	update_appearance()
	return TRUE

/turf/open/burn_tile()
	if(isnull(damaged_dmi) || burnt)
		return FALSE
	burnt = TRUE
	update_appearance()
	return TRUE

/turf/open/update_overlays()
	if(isnull(damaged_dmi))
		return ..()
	. = ..()
	if(broken)
		. += mutable_appearance(damaged_dmi, pick(broken_states()))
	else if(burnt)
		var/list/burnt_states = burnt_states()
		if(burnt_states.len)
			. += mutable_appearance(damaged_dmi, pick(burnt_states))
		else
			. += mutable_appearance(damaged_dmi, pick(broken_states()))

//direction is direction of travel of A
/turf/open/zPassIn(atom/movable/A, direction, turf/source)
	if(direction == DOWN)
		for(var/obj/O in contents)
			if(O.obj_flags & BLOCK_Z_IN_DOWN)
				return FALSE
		return TRUE
	return FALSE

//direction is direction of travel of A
/turf/open/zPassOut(atom/movable/A, direction, turf/destination, allow_anchored_movement)
	if(direction == UP)
		for(var/obj/O in contents)
			if(O.obj_flags & BLOCK_Z_OUT_UP)
				return FALSE
		return TRUE
	return FALSE

//direction is direction of travel of air
/turf/open/zAirIn(direction, turf/source)
	return (direction == DOWN)

//direction is direction of travel of air
/turf/open/zAirOut(direction, turf/source)
	return (direction == UP)

/turf/open/update_icon()
	. = ..()
	update_visuals()

/**
 * Replace an open turf with another open turf while avoiding the pitfall of replacing plating with a floor tile, leaving a hole underneath.
 * This replaces the current turf if it is plating and is passed plating, is tile and is passed tile.
 * It places the new turf on top of itself if it is plating and is passed a tile.
 * It also replaces the turf if it is tile and is passed plating, essentially destroying the over turf.
 * Flags argument is passed directly to ChangeTurf or PlaceOnTop
 */
/turf/open/proc/replace_floor(turf/open/new_floor_path, flags)
	if (!overfloor_placed && initial(new_floor_path.overfloor_placed))
		PlaceOnTop(new_floor_path, flags = flags)
		return
	ChangeTurf(new_floor_path, flags = flags)

/turf/open/Initalize_Atmos(time)
	excited = FALSE
	update_visuals()

	current_cycle = time
	init_immediate_calculate_adjacent_turfs()

/turf/open/GetHeatCapacity()
	. = air.heat_capacity()

/turf/open/GetTemperature()
	. = air.temperature

/turf/open/TakeTemperature(temp)
	air.temperature += temp
	air_update_turf(FALSE, FALSE)

/turf/open/proc/freeze_turf()
	for(var/obj/I in contents)
		if(!HAS_TRAIT(I, TRAIT_FROZEN) && !(I.resistance_flags & FREEZE_PROOF))
			I.AddElement(/datum/element/frozen)

	for(var/mob/living/L in contents)
		if(L.bodytemperature <= 50)
			L.apply_status_effect(/datum/status_effect/freon)
	MakeSlippery(TURF_WET_PERMAFROST, 50)
	return TRUE

/turf/open/proc/water_vapor_gas_act()
	MakeSlippery(TURF_WET_WATER, min_wet_time = 100, wet_time_to_add = 50)

	for(var/mob/living/simple_animal/slime/M in src)
		M.apply_water()

	wash(CLEAN_WASH)
	for(var/atom/movable/movable_content as anything in src)
		if(ismopable(movable_content)) // Will have already been washed by the wash call above at this point.
			continue
		movable_content.wash(CLEAN_WASH)
	return TRUE

/turf/open/handle_slip(mob/living/carbon/slipper, knockdown_amount, obj/slippable, lube, paralyze_amount, force_drop)
	if(slipper.movement_type & (FLYING | FLOATING))
		return FALSE
	if(!has_gravity(src))
		return FALSE

	var/slide_distance = 4
	if(lube & SLIDE_ICE)
		// Ice slides only go 1 tile, this is so you will slip across ice until you reach a non-slip tile
		slide_distance = 1
	else if(HAS_TRAIT(slipper, TRAIT_CURSED))
		// When cursed, all slips send you flying
		lube |= SLIDE
		slide_distance = rand(5, 9)
	else if(HAS_TRAIT(slipper, TRAIT_NO_SLIP_SLIDE))
		// Stops sliding
		slide_distance = 0

	var/obj/buckled_obj
	if(slipper.buckled)
		if(!(lube & GALOSHES_DONT_HELP)) //can't slip while buckled unless it's lube.
			return FALSE
		buckled_obj = slipper.buckled
	else
		if(!(lube & SLIP_WHEN_CRAWLING) && (slipper.body_position == LYING_DOWN || !(slipper.status_flags & CANKNOCKDOWN))) // can't slip unbuckled mob if they're lying or can't fall.
			return FALSE
		if(slipper.m_intent == MOVE_INTENT_WALK && (lube & NO_SLIP_WHEN_WALKING))
			return FALSE

	if(!(lube & SLIDE_ICE))
		// Ice slides are intended to be combo'd so don't give the feedback
		to_chat(slipper, span_notice("You slipped[ slippable ? " on the [slippable.name]" : ""]!"))
		playsound(slipper.loc, 'sound/misc/slip.ogg', 50, TRUE, -3)

	SEND_SIGNAL(slipper, COMSIG_ON_CARBON_SLIP)
	slipper.add_mood_event("slipped", /datum/mood_event/slipped)
	if(force_drop)
		for(var/obj/item/item in slipper.held_items)
			slipper.accident(item)

	var/olddir = slipper.dir
	slipper.moving_diagonally = 0 //If this was part of diagonal move slipping will stop it.
	if(lube & SLIDE_ICE)
		// They need to be kept upright to maintain the combo effect (So don't knockdown)
		slipper.Immobilize(1 SECONDS)
		slipper.incapacitate(1 SECONDS)
	else
		slipper.Knockdown(knockdown_amount)
		slipper.Paralyze(paralyze_amount)
		slipper.stop_pulling()

	if(buckled_obj)
		buckled_obj.unbuckle_mob(slipper)
		// This is added onto the end so they slip "out of their chair" (one tile)
		lube |= SLIDE_ICE
		slide_distance = 1

	if(slide_distance)
		var/turf/target = get_ranged_target_turf(slipper, olddir, slide_distance)
		if(lube & SLIDE)
			slipper.AddComponent(/datum/component/force_move, target, TRUE)
		else if(lube & SLIDE_ICE)
			slipper.AddComponent(/datum/component/force_move, target, FALSE)//spinning would be bad for ice, fucks up the next dir
	return TRUE

/turf/open/proc/MakeSlippery(wet_setting = TURF_WET_WATER, min_wet_time = 0, wet_time_to_add = 0, max_wet_time = MAXIMUM_WET_TIME, permanent)
	AddComponent(/datum/component/wet_floor, wet_setting, min_wet_time, wet_time_to_add, max_wet_time, permanent)

/turf/open/proc/MakeDry(wet_setting = TURF_WET_WATER, immediate = FALSE, amount = INFINITY)
	SEND_SIGNAL(src, COMSIG_TURF_MAKE_DRY, wet_setting, immediate, amount)

/turf/open/get_dumping_location()
	return src

/turf/open/proc/ClearWet()//Nuclear option of immediately removing slipperyness from the tile instead of the natural drying over time
	qdel(GetComponent(/datum/component/wet_floor))

/// Builds with rods. This doesn't exist to be overriden, just to remove duplicate logic for turfs that want
/// To support floor tile creation
/// I'd make it a component, but one of these things is space. So no.
/turf/open/proc/build_with_rods(obj/item/stack/rods/used_rods, mob/user)
	var/obj/structure/lattice/catwalk_bait = locate(/obj/structure/lattice, src)
	var/obj/structure/lattice/catwalk/existing_catwalk = locate(/obj/structure/lattice/catwalk, src)
	if(existing_catwalk)
		to_chat(user, span_warning("There is already a catwalk here!"))
		return

	if(catwalk_bait)
		if(used_rods.use(1))
			qdel(catwalk_bait)
			to_chat(user, span_notice("You construct a catwalk."))
			playsound(src, 'sound/weapons/genhit.ogg', 50, TRUE)
			new /obj/structure/lattice/catwalk(src)
		else
			to_chat(user, span_warning("You need two rods to build a catwalk!"))
		return

	if(used_rods.use(1))
		to_chat(user, span_notice("You construct a lattice."))
		playsound(src, 'sound/weapons/genhit.ogg', 50, TRUE)
		new /obj/structure/lattice(src)
	else
		to_chat(user, span_warning("You need one rod to build a lattice."))

/// Very similar to build_with_rods, this exists to allow consistent behavior between different types in terms of how
/// Building floors works
/turf/open/proc/build_with_floor_tiles(obj/item/stack/tile/iron/used_tiles, user)
	var/obj/structure/lattice/lattice = locate(/obj/structure/lattice, src)
	if(!has_valid_support() && !lattice)
		balloon_alert(user, "needs support, place rods!")
		return
	if(!used_tiles.use(1))
		balloon_alert(user, "need a floor tile to build!")
		return

	playsound(src, 'sound/weapons/genhit.ogg', 50, TRUE)
	var/turf/open/floor/plating/new_plating = PlaceOnTop(/turf/open/floor/plating, flags = CHANGETURF_INHERIT_AIR)
	if(lattice)
		qdel(lattice)
	else
		new_plating.lattice_underneath = FALSE

/turf/open/proc/has_valid_support()
	for (var/direction in GLOB.cardinals)
		if(istype(get_step(src, direction), /turf/open/floor))
			return TRUE
	return FALSE

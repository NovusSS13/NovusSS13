/**
 * This object exists because sadly, there is no support for displacement filters changing direction according to owner atom.
 *
 * Just use a filter if you don't care about having a matching dir. Please.
 */
/obj/effect/abstract/displacement_map
	name = "displacement map"
	icon = 'icons/effects/displacement/distort.dmi'
	//read up on _onclick/hud/render/plane_master.dm to know why this is necessary
	plane = DISPLACEMENT_MAP_PLANE
	//needs KEEP_APART because humans are quirky doe hehe!
	//RESET_COLOR and RESET_ALPHA are pretty obvious on why they're necessary
	appearance_flags = TILE_BOUND|PIXEL_SCALE|LONG_GLIDE|KEEP_APART|RESET_COLOR|RESET_ALPHA
	vis_flags = VIS_INHERIT_DIR
	anchored = TRUE
	density = FALSE
	opacity = FALSE
	blocks_emissive = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	/// Atom we are currently applying the displacement filter on
	var/atom/movable/owner
	/// X of the filter
	var/displacement_x = 0
	/// Y of the filter
	var/displacement_y = 0
	/// Size of the filter
	var/displacement_size = 1
	/// Name of the filter
	var/filter_name = "displacement map"
	/// Priority of the filter, completely arbitrary value
	var/filter_priority = 15

/obj/effect/abstract/displacement_map/Initialize(mapload, atom/movable/new_owner)
	. = ..()
	/// Displacement maps are of no use if you don't apply them to an atom
	if(!istype(new_owner))
		return INITIALIZE_HINT_QDEL
	// Going inside the atom's contents creates issues so we go to nullspace
	moveToNullspace()
	render_target = "[REF(src)]"
	set_owner(new_owner)

/obj/effect/abstract/displacement_map/Destroy(force)
	. = ..()
	if(owner)
		set_owner(null)

/obj/effect/abstract/displacement_map/proc/set_owner(atom/movable/new_owner)
	if(owner)
		LAZYREMOVE(owner.displacement_maps, type)
		remove_displacement(owner)
		owner.vis_contents -= src
		owner = null
	if(!new_owner)
		return
	owner = new_owner
	LAZYSET(owner.displacement_maps, type, src)
	/// We need to be inside owner's vis_contents due to the way render_source and render_target work
	/// (they only work if the render_source is in view)
	owner.vis_contents += src
	apply_displacement(owner)

/obj/effect/abstract/displacement_map/proc/apply_displacement(atom/movable/applied)
	applied.add_filter(filter_name, filter_priority, displacement_map_filter(render_source = render_target, x = displacement_x, y = displacement_y, size = displacement_size))

/obj/effect/abstract/displacement_map/proc/remove_displacement(atom/movable/removed)
	if(!removed)
		return
	removed.remove_filter(filter_name)

/obj/effect/abstract/displacement_map/proc/get_displacement_filter()
	return displacement_map_filter(render_source = render_target, x = displacement_x, y = displacement_y, size = displacement_size)

/// Subtype for use in humans, kinda like the height filter
/obj/effect/abstract/displacement_map/human
	name = "human displacement map"

/obj/effect/abstract/displacement_map/human/proc/get_applicable_layers()
	RETURN_TYPE(/list)
	return list()

/obj/effect/abstract/displacement_map/human/proc/apply_filters(mutable_appearance/appearance)
	appearance.remove_filter(filter_name)
	appearance.add_filter(filter_name, filter_priority, get_displacement_filter())

/obj/effect/abstract/displacement_map/human/apply_displacement(atom/movable/applied)
	return

/obj/effect/abstract/displacement_map/human/remove_displacement(atom/movable/removed)
	return

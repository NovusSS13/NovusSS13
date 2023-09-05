/obj/item/stack/tile/iron/elevated
	name = "elevated floor tile"
	singular_name = "elevated floor tile"
	turf_type = /turf/open/floor/iron/elevated

/obj/item/stack/tile/iron/lowered
	name = "lowered floor tile"
	singular_name = "lowered floor tile"
	turf_type = /turf/open/floor/iron/lowered

/obj/item/stack/tile/iron/pool
	name = "pool floor tile"
	singular_name = "pool floor tile"
	turf_type = /turf/open/floor/iron/pool

/turf/open/floor/iron/pool
	name = "pool floor"
	icon_state = "pool_tile"
	base_icon_state = "pool_tile"
	floor_tile = /obj/item/stack/tile/iron/pool
	liquid_height = -30
	turf_height = -30

/turf/open/floor/iron/pool/broken_states()
	return list("pool_tile")

/turf/open/floor/iron/pool/burnt_states()
	return list("pool_tile")

/turf/open/floor/iron/pool/rust_heretic_act()
	return

/turf/open/floor/iron/elevated
	name = "elevated floor"
	floor_tile = /obj/item/stack/tile/iron/elevated
	icon = 'icons/turf/floors/elevated_plasteel.dmi'
	icon_state = "elevated_plasteel-0"
	base_icon_state = "elevated_plasteel"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_WALLS + SMOOTH_GROUP_ELEVATED_PLASTEEL + SMOOTH_GROUP_CLOSED_TURFS
	canSmoothWith = SMOOTH_GROUP_WALLS + SMOOTH_GROUP_ELEVATED_PLASTEEL
	liquid_height = 30
	turf_height = 30

/turf/open/floor/iron/elevated/broken_states()
	return list("elevated_plasteel")

/turf/open/floor/iron/elevated/burnt_states()
	return list("elevated_plasteel")

/turf/open/floor/iron/elevated/rust_heretic_act()
	return

/turf/open/floor/iron/lowered
	name = "lowered floor"
	floor_tile = /obj/item/stack/tile/iron/lowered
	icon = 'icons/turf/floors/lowered_plasteel.dmi'
	icon_state = "lowered_plasteel-0"
	base_icon_state = "lowered_plasteel"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_WALLS + SMOOTH_GROUP_LOWERED_PLASTEEL + SMOOTH_GROUP_CLOSED_TURFS
	canSmoothWith = SMOOTH_GROUP_LOWERED_PLASTEEL
	liquid_height = -30
	turf_height = -30

/turf/open/floor/iron/lowered/broken_states()
	return list("lowered_plasteel")

/turf/open/floor/iron/lowered/burnt_states()
	return list("lowered_plasteel")

/turf/open/floor/iron/lowered/rust_heretic_act()
	return

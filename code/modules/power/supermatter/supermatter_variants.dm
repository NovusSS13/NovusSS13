/// Normal SM with it's processing disabled.
/obj/machinery/power/supermatter_crystal/hugbox
	disable_damage = TRUE
	disable_gas =  TRUE
	disable_power_change = TRUE
	disable_process = SM_PROCESS_DISABLED

/// Normal SM designated as main engine.
/obj/machinery/power/supermatter_crystal/engine
	is_main_engine = TRUE

/// Shard SM.
/obj/machinery/power/supermatter_crystal/shard
	name = "supermatter shard"
	desc = "A strangely translucent and iridescent crystal that looks like it used to be part of a larger structure."
	base_icon_state = "sm_shard"
	icon_state = "sm_shard"
	anchored = FALSE
	absorption_ratio = 0.125
	explosion_power = 12
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	moveable = TRUE

/// Shard SM with it's processing disabled.
/obj/machinery/power/supermatter_crystal/shard/hugbox
	name = "anchored supermatter shard"
	disable_damage = TRUE
	disable_gas =  TRUE
	disable_power_change = TRUE
	disable_process = SM_PROCESS_DISABLED
	moveable = FALSE
	anchored = TRUE

/// Shard SM designated as the main engine.
/obj/machinery/power/supermatter_crystal/shard/engine
	name = "anchored supermatter shard"
	is_main_engine = TRUE
	anchored = TRUE
	moveable = FALSE

/atom/movable/warp_effect/supermatter
	appearance_flags = PIXEL_SCALE // no tile bound so you can see it around corners and so

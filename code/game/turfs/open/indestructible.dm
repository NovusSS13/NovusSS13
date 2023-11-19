/turf/open/indestructible
	name = "floor"
	desc = "The floor you walk on. It looks near-impervious to damage."
	icon = 'icons/turf/floors.dmi'
	icon_state = "floor"
	footstep = FOOTSTEP_FLOOR
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = TRUE

/turf/open/indestructible/Melt()
	to_be_destroyed = FALSE
	return src

/turf/open/indestructible/singularity_act()
	return

/turf/open/indestructible/TerraformTurf(path, new_baseturf, flags, defer_change = FALSE, ignore_air = FALSE)
	return


/turf/open/indestructible/white
	icon_state = "white"

/turf/open/indestructible/dark
	icon_state = "darkfull"

/turf/open/indestructible/light
	icon_state = "light_on-1"

/turf/open/indestructible/permalube
	icon_state = "darkfull"

/turf/open/indestructible/permalube/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/wet_floor, TURF_WET_LUBE, INFINITY, 0, INFINITY, TRUE)

/turf/open/indestructible/honk
	name = "bananium floor"
	icon_state = "bananium"
	footstep = null
	barefootstep = null
	clawfootstep = null
	heavyfootstep = null
	var/sound = 'sound/effects/footstep/clownstep1.ogg'

/turf/open/indestructible/honk/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/wet_floor, TURF_WET_SUPERLUBE, INFINITY, 0, INFINITY, TRUE)

/turf/open/indestructible/honk/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	if(ismob(arrived))
		playsound(src, sound, 50, TRUE)

/turf/open/indestructible/necropolis
	name = "necropolis floor"
	desc = "It's regarding you suspiciously."
	icon = 'icons/turf/floors.dmi'
	icon_state = "necro1"
	baseturfs = /turf/open/indestructible/necropolis
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS
	footstep = FOOTSTEP_LAVA
	barefootstep = FOOTSTEP_LAVA
	clawfootstep = FOOTSTEP_LAVA
	heavyfootstep = FOOTSTEP_LAVA
	tiled_dirt = FALSE

/turf/open/indestructible/necropolis/Initialize(mapload)
	. = ..()
	if(prob(12))
		icon_state = "necro[rand(2,3)]"

/turf/open/indestructible/necropolis/air
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS

/turf/open/indestructible/boss //you put stone tiles on this and use it as a base
	name = "necropolis floor"
	icon = 'icons/turf/boss_floors.dmi'
	icon_state = "boss"
	baseturfs = /turf/open/indestructible/boss
	planetary_atmos = TRUE
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS

/turf/open/indestructible/boss/air
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS

/turf/open/indestructible/hierophant
	icon = 'icons/turf/floors/hierophant_floor.dmi'
	planetary_atmos = TRUE
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS
	baseturfs = /turf/open/indestructible/hierophant
	smoothing_flags = SMOOTH_CORNERS
	tiled_dirt = FALSE

/turf/open/indestructible/hierophant/two

/turf/open/indestructible/hierophant/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	return FALSE

/turf/open/indestructible/paper
	name = "notebook floor"
	desc = "A floor made of invulnerable notebook paper."
	icon_state = "paperfloor"
	footstep = null
	barefootstep = null
	clawfootstep = null
	heavyfootstep = null
	tiled_dirt = FALSE

/turf/open/indestructible/binary
	name = "tear in the fabric of reality"
	can_atmos_pass = ATMOS_PASS_NO
	baseturfs = /turf/open/indestructible/binary
	icon_state = "binary"
	footstep = null
	barefootstep = null
	clawfootstep = null
	heavyfootstep = null

/turf/open/indestructible/airblock
	icon_state = "bluespace"
	blocks_air = TRUE
	init_air = FALSE
	baseturfs = /turf/open/indestructible/airblock

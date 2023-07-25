#define SAUNA_H2O_TEMP (T20C + 20)
#define SAUNA_MAXIMUM_FUEL 3000
#define SAUNA_WATER_PER_WATER_UNIT 5

/obj/structure/sauna_oven
	name = "sauna oven"
	desc = "A modest sauna oven with rocks. Add some fuel, pour some water and enjoy the moment."
	icon = 'icons/obj/structures/sauna_oven.dmi'
	icon_state = "sauna_oven_on"
	density = TRUE
	anchored = TRUE
	resistance_flags = FIRE_PROOF
	var/static/list/fuel_amounts = list(
		/obj/item/grown/log = 200, // just for the effort
		/obj/item/stack/sheet/mineral/wood = 150,
		/obj/item/paper = 5,
		/obj/item/paper_bin = 5
	)
	var/lit = FALSE
	var/stored_fuel = 0

/obj/structure/sauna_oven/Initialize(mapload)
	. = ..()
	reagents = new()

/obj/structure/sauna_oven/Destroy()
	STOP_PROCESSING(SSobj, src)
	QDEL_NULL(particles)
	return ..()

/obj/structure/sauna_oven/examine(mob/user)
	. = ..()
	. += span_notice("The rocks are [reagents.total_volume ? "moist" : "dry"].")
	. += span_notice("There's [stored_fuel ? "some fuel" : "no fuel"] in the oven.")

/obj/structure/sauna_oven/attack_hand(mob/user)
	. = ..()
	if(.)
		return

	if(lit)
		lit = FALSE
		STOP_PROCESSING(SSobj, src)
		user.visible_message(span_notice("[user] turns off \the [src]."), span_notice("You turn off \the [src]."))
	else if(stored_fuel)
		lit = TRUE
		START_PROCESSING(SSobj, src)
		user.visible_message(span_notice("[user] turns on \the [src]."), span_notice("You turn on \the [src]."))
	update_icon()

/obj/structure/sauna_oven/update_overlays()
	. = ..()
	if(lit)
		. += "sauna_oven_on_overlay"

/obj/structure/sauna_oven/update_icon()
	..()
	icon_state = "sauna_oven[lit ? "_on" : "_off"]"

/obj/structure/sauna_oven/attackby(obj/item/used_item, mob/living/user)
	if(user.combat_mode)
		return ..()

	if(used_item.tool_behaviour == TOOL_WRENCH)
		balloon_alert(user, "deconstructing...")
		if(used_item.use_tool(src, user, 60, volume = 50))
			balloon_alert(user, "deconstructed")
			new /obj/item/stack/sheet/mineral/wood(get_turf(src), 30)
			qdel(src)
		return

	if(used_item.reagents?.flags & DRAINABLE)
		if(!used_item.reagents.has_reagent(/datum/reagent/water))
			balloon_alert(user, "no water!")
			return

		used_item.reagents.trans_to(/datum/reagent/water, 5)
		user.visible_message(
			span_notice("[user] pours some water into [src]."),
			span_notice("You pour some water to [src].")
		)
		return

	for(var/fuel_type in fuel_amounts)
		if(!istype(used_item, fuel_type))
			continue

		if(stored_fuel > SAUNA_MAXIMUM_FUEL)
			balloon_alert(user, "it's full!")
			return

		var/added_fuel = fuel_amounts[fuel_type]
		if(fuel_type == /obj/item/paper_bin) //stupid snowflake
			var/obj/item/paper_bin/paper_bin = used_item
			added_fuel += fuel_amounts[/obj/item/paper] * paper_bin.total_paper

		stored_fuel = min(stored_fuel + added_fuel, SAUNA_MAXIMUM_FUEL)
		if(istype(used_item, /obj/item/stack))
			var/obj/item/stack/stack = used_item
			user.visible_message(
				span_notice("[user] tosses some [stack.singular_name]\s into \the [src]."),
				span_notice("You add some fuel to \the [src].")
			)
			stack.use(1)
		else
			user.visible_message(
				span_notice("[user] tosses \the [used_item] into \the [src]."),
				span_notice("You toss \the [used_item] into \the [src].")
			)
			qdel(used_item)
		return

	return ..()

/obj/structure/sauna_oven/process()
	if(reagents.total_volume)
		reagents.remove_all(0.2) //adjust as needed
		update_steam_particles()
		var/turf/open/pos = get_turf(src)
		if(istype(pos) && pos.air.return_pressure() < 2*ONE_ATMOSPHERE)
			pos.atmos_spawn_air("water_vapor=10;TEMP=[SAUNA_H2O_TEMP]")

	stored_fuel--
	if(stored_fuel <= 0)
		lit = FALSE
		update_steam_particles()
		STOP_PROCESSING(SSobj, src)
		update_icon()

/obj/structure/sauna_oven/proc/update_steam_particles()
	if(lit && reagents.total_volume)
		if(particles)
			return
		particles = new /particles/smoke/steam/mild
		particles.position = list(0, 6, 0)
		return

	QDEL_NULL(particles)
	return

#undef SAUNA_H2O_TEMP
#undef SAUNA_MAXIMUM_FUEL
#undef SAUNA_WATER_PER_WATER_UNIT

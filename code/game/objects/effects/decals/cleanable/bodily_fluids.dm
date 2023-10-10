/// Lovely copypasta from blood, because making this a subtype would FUCK SHIT UP
/obj/effect/decal/cleanable/cum
	name = "cum"
	desc = "Someone had fun."
	icon = 'icons/effects/cum.dmi'
	icon_state = "floor1"
	random_icon_states = list("floor1", "floor2", "floor3")
	color = COLOR_CUM
	blood_state = BLOOD_STATE_CUM
	bloodiness = BLOOD_AMOUNT_PER_DECAL
	beauty = -100
	clean_type = CLEAN_TYPE_BLOOD
	var/should_dry = TRUE
	var/dryname = "dry cum" //when the blood lasts long enough, it becomes dry and gets a new name
	var/drydesc = "Someone had fun, a long time ago..." //as above
	var/drytime = 0

/obj/effect/decal/cleanable/cum/Initialize(mapload)
	. = ..()
	if(!should_dry)
		return
	if(bloodiness)
		start_drying()
	else
		dry()

/obj/effect/decal/cleanable/cum/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/decal/cleanable/cum/process()
	if(world.time > drytime)
		dry()

/obj/effect/decal/cleanable/cum/proc/get_timer()
	drytime = world.time + 3 MINUTES

/obj/effect/decal/cleanable/cum/proc/start_drying()
	get_timer()
	START_PROCESSING(SSobj, src)

/// This is what actually "dries" the blood. Returns true if it's all out of blood to dry, and false otherwise
/obj/effect/decal/cleanable/cum/proc/dry()
	if(bloodiness > 20)
		bloodiness -= BLOOD_AMOUNT_PER_DECAL
		get_timer()
		return FALSE
	else
		name = dryname
		desc = drydesc
		bloodiness = 0
		STOP_PROCESSING(SSobj, src)
		return TRUE

/obj/effect/decal/cleanable/cum/replace_decal(obj/effect/decal/cleanable/blood/C)
	C.add_blood_DNA(GET_ATOM_BLOOD_DNA(src))
	if (bloodiness)
		C.bloodiness = min((C.bloodiness + bloodiness), BLOOD_AMOUNT_PER_DECAL)
	return ..()

// FOOTPRINTS
/obj/effect/decal/cleanable/cum/footprints
	name = "cum footprints"
	desc = "WHOSE FOOTPRINTS ARE THESE?"
	icon = 'icons/effects/cum_footprints.dmi'
	icon_state = "cum1"
	random_icon_states = null
	blood_state = BLOOD_STATE_CUM //the icon state to load images from
	var/entered_dirs = 0
	var/exited_dirs = 0

	/// List of shoe or other clothing that covers feet types that have made footprints here.
	var/list/shoe_types = list()

	/// List of species that have made footprints here.
	var/list/species_types = list()

	dryname = "dried cum footprints"
	drydesc = "HMM... SOMEONE WAS HERE!"

/obj/effect/decal/cleanable/cum/footprints/Initialize(mapload)
	. = ..()
	icon_state = "" //All of the footprint visuals come from overlays
	if(mapload)
		entered_dirs |= dir //Keep the same appearance as in the map editor
		update_appearance()

//Rotate all of the footprint directions too
/obj/effect/decal/cleanable/cum/footprints/setDir(newdir)
	if(dir == newdir)
		return ..()

	var/ang_change = dir2angle(newdir) - dir2angle(dir)
	var/old_entered_dirs = entered_dirs
	var/old_exited_dirs = exited_dirs
	entered_dirs = 0
	exited_dirs = 0

	for(var/Ddir in GLOB.cardinals)
		if(old_entered_dirs & Ddir)
			entered_dirs |= angle2dir_cardinal(dir2angle(Ddir) + ang_change)
		if(old_exited_dirs & Ddir)
			exited_dirs |= angle2dir_cardinal(dir2angle(Ddir) + ang_change)

	update_appearance()
	return ..()

/obj/effect/decal/cleanable/cum/footprints/update_icon()
	. = ..()
	alpha = min(BLOODY_FOOTPRINT_BASE_ALPHA + (255 - BLOODY_FOOTPRINT_BASE_ALPHA) * bloodiness / (BLOOD_ITEM_MAX / 2), 255)

/obj/effect/decal/cleanable/cum/footprints/update_overlays()
	. = ..()
	for(var/Ddir in GLOB.cardinals)
		if(entered_dirs & Ddir)
			var/image/bloodstep_overlay = GLOB.bloody_footprints_cache["[icon]-entered-[blood_state]-[Ddir]"]
			if(!bloodstep_overlay)
				GLOB.bloody_footprints_cache["[icon]-entered-[blood_state]-[Ddir]"] = bloodstep_overlay = image(icon, "[blood_state]1", dir = Ddir)
			. += bloodstep_overlay

		if(exited_dirs & Ddir)
			var/image/bloodstep_overlay = GLOB.bloody_footprints_cache["[icon]-exited-[blood_state]-[Ddir]"]
			if(!bloodstep_overlay)
				GLOB.bloody_footprints_cache["[icon]-exited-[blood_state]-[Ddir]"] = bloodstep_overlay = image(icon, "[blood_state]2", dir = Ddir)
			. += bloodstep_overlay


/obj/effect/decal/cleanable/cum/footprints/examine(mob/user)
	. = ..()
	if((shoe_types.len + species_types.len) > 0)
		. += "You recognise the footprints as belonging to:"
		for(var/sole in shoe_types)
			var/obj/item/clothing/item = sole
			var/article = initial(item.gender) == PLURAL ? "Some" : "A"
			. += "[icon2html(initial(item.icon), user, initial(item.icon_state))] [article] <B>[initial(item.name)]</B>."
		for(var/species in species_types)
			// god help me
			if(species == "unknown")
				. += "Some <B>feet</B>."
			else if(species == SPECIES_MONKEY)
				. += "[icon2html('icons/mob/species/human/human.dmi', user, "monkey")] Some <B>monkey feet</B>."
			else if(species == SPECIES_HUMAN)
				. += "[icon2html('icons/mob/species/human/bodyparts.dmi', user, "default_human_l_leg")] Some <B>human feet</B>."
			else
				. += "[icon2html('icons/mob/species/human/bodyparts.dmi', user, "[species]_l_leg")] Some <B>[species] feet</B>."

/obj/effect/decal/cleanable/cum/footprints/replace_decal(obj/effect/decal/cleanable/C)
	if(blood_state != C.blood_state) //We only replace footprints of the same type as us
		return FALSE
	return ..()

/obj/effect/decal/cleanable/cum/footprints/can_bloodcrawl_in()
	if((blood_state != BLOOD_STATE_OIL) && (blood_state != BLOOD_STATE_NOT_BLOODY))
		return TRUE
	return FALSE

/// Femcum subtype
/obj/effect/decal/cleanable/cum/femcum
	name = "squirt"
	dryname = "dried squirt footprints"
	icon = 'icons/effects/femcum.dmi'
	color = COLOR_FEMCUM
	blood_state = BLOOD_STATE_FEMCUM

/obj/effect/decal/cleanable/cum/footprints/femcum
	name = "squirt footprints"
	dryname = "dried squirt footprints"
	icon = 'icons/effects/femcum_footprints.dmi'
	icon_state = "femcum1"
	color = COLOR_FEMCUM
	blood_state = BLOOD_STATE_FEMCUM

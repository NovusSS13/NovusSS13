/// Lovely copypasta from blood, because making this a subtype of blood could cause issues
/obj/effect/decal/cleanable/blood/cum
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
	dryname = "dry cum"
	drydesc = "Someone had fun, a long time ago..."

/obj/effect/decal/cleanable/blood/footprints/cum
	name = "cum footprints"
	desc = "WHOSE FOOTPRINTS ARE THESE?"
	icon_state = "cum1"
	random_icon_states = null
	color = COLOR_CUM
	blood_state = BLOOD_STATE_CUM //the icon state to load images from
	dryname = "dried cum footprints"
	drydesc = "HMM... SOMEONE WAS HERE!"

/// Femcum subtype
/obj/effect/decal/cleanable/blood/cum/femcum
	name = "squirt"
	dryname = "dried squirt footprints"
	icon = 'icons/effects/femcum.dmi'
	color = COLOR_FEMCUM
	blood_state = BLOOD_STATE_FEMCUM

/obj/effect/decal/cleanable/blood/footprints/cum/femcum
	name = "squirt footprints"
	dryname = "dried squirt footprints"
	icon_state = "femcum1"
	color = COLOR_FEMCUM
	blood_state = BLOOD_STATE_FEMCUM

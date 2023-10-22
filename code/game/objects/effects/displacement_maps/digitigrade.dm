/obj/effect/abstract/displacement_map/human/digitigrade
	name = "digitigrade"
	icon = 'icons/effects/displacement/digitigrade.dmi'
	// DON'T fucking change this, it will break everything, the map is fucking pixel perfect you fucking swine
	displacement_size = 4
	filter_name = "digitigrade"
	filter_priority = 1 //comes before height

/obj/effect/abstract/displacement_map/human/digitigrade/body
	name = "digitigrade body"
	icon_state = "body"

/obj/effect/abstract/displacement_map/human/digitigrade/body/get_applicable_layers()
	var/static/list/applicable_layers = list(
		DAMAGE_LAYER,
	)
	return applicable_layers

/obj/effect/abstract/displacement_map/human/digitigrade/clothes
	name = "digitigrade clothes"
	icon_state = "clothes"

/obj/effect/abstract/displacement_map/human/digitigrade/clothes/get_applicable_layers()
	var/static/list/applicable_layers = list(
		LEGCUFF_LAYER,
	)
	return applicable_layers

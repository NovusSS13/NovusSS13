/obj/item/organ/ears/fox
	name = "fox ears"
	icon = 'icons/obj/medical/organs/external_organs.dmi'
	icon_state = "ears-fluffy"
	damage_multiplier = 2

	visual = TRUE
	dna_block = DNA_EARS_BLOCK
	bodypart_overlay = /datum/bodypart_overlay/mutant/ears/mutant
	sprite_accessory_override = /datum/sprite_accessory/ears/mutant/fox

/obj/item/organ/tail/fox
	name = "fox tail"
	desc = "A severed fox tail. It doesn't seem to come from an actual fox..."
	icon_state = "tail-fluffy"

	detail_overlay = "tail-fluffy-detail"
	inherit_detail_color = TRUE
	bodypart_overlay = /datum/bodypart_overlay/mutant/tail/cat
	sprite_accessory_override = /datum/sprite_accessory/tails/mutant/wagging/fox
	wag_flags = WAG_ABLE

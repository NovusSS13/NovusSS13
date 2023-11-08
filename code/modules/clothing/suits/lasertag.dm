/obj/item/clothing/suit/bluetag
	name = "blue laser tag armor"
	desc = "A piece of plastic armor. It has sensors that react to red light." //Lasers are concentrated light
	icon = 'icons/obj/clothing/suits/costume.dmi'
	icon_state = "bluetag"
	inhand_icon_state = null
	worn_icon = 'icons/mob/clothing/suits/costume.dmi'
	worn_icon_avali = null
	blood_overlay_type = "armor"
	body_parts_covered = CHEST
	allowed = list (/obj/item/gun/energy/laser/bluetag)
	resistance_flags = NONE

/obj/item/clothing/suit/redtag
	name = "red laser tag armor"
	desc = "A piece of plastic armor. It has sensors that react to blue light."
	icon = 'icons/obj/clothing/suits/costume.dmi'
	icon_state = "redtag"
	inhand_icon_state = null
	worn_icon = 'icons/mob/clothing/suits/costume.dmi'
	worn_icon_avali = null
	blood_overlay_type = "armor"
	body_parts_covered = CHEST
	allowed = list (/obj/item/gun/energy/laser/redtag)
	resistance_flags = NONE

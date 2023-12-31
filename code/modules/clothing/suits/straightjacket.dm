/obj/item/clothing/suit/jacket/straight_jacket
	name = "straight jacket"
	desc = "A suit that completely restrains the wearer. Manufactured by Antyphun Corp." //Straight jacket is antifun
	icon_state = "straight_jacket"
	inhand_icon_state = "straight_jacket"
	worn_icon_avali = null
	body_parts_covered = CHEST|GROIN|LEGS|ARMS|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	equip_delay_self = 50
	strip_delay = 60
	breakouttime = 5 MINUTES

/obj/item/clothing/suit/jacket/straight_jacket/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_DANGEROUS_OBJECT, INNATE_TRAIT)

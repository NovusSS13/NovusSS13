/obj/item/clothing/suit
	name = "suit"
	icon = 'icons/obj/clothing/suits/default.dmi'
	worn_icon_avali = 'icons/mob/species/avali/clothing/suit.dmi'
	lefthand_file = 'icons/mob/inhands/clothing/suits_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/clothing/suits_righthand.dmi'
	allowed = list(
		/obj/item/tank/internals/emergency_oxygen,
		/obj/item/tank/internals/plasmaman,
		/obj/item/tank/jetpack/oxygen/captain,
		)
	armor_type = /datum/armor/none
	drop_sound = 'sound/items/handling/cloth_drop.ogg'
	pickup_sound = 'sound/items/handling/cloth_pickup.ogg'
	slot_flags = ITEM_SLOT_OCLOTHING
	limb_integrity = 0 // disabled for most exo-suits

	greyscale_config_worn_avali_fallback = /datum/greyscale_config/avali/coat
	clothing_color_coords_key = "suit"

	var/blood_overlay_type = "suit"
	var/fire_resist = T0C+100

/obj/item/clothing/suit/Initialize(mapload)
	. = ..()
	setup_shielding()

/obj/item/clothing/suit/worn_overlays(mutable_appearance/standing, isinhands = FALSE)
	. = ..()
	if(isinhands)
		return

	if(damaged_clothes)
		. += mutable_appearance('icons/effects/item_damage.dmi', "damaged[blood_overlay_type]")
	if(HAS_TRAIT(src, TRAIT_COVERED_IN_FEMCUM))
		var/mutable_appearance/femcum = mutable_appearance('icons/effects/femcum.dmi', "[blood_overlay_type]cum")
		femcum.color = COLOR_FEMCUM
		. += femcum
	if(HAS_TRAIT(src, TRAIT_COVERED_IN_CUM))
		var/mutable_appearance/cum = mutable_appearance('icons/effects/cum.dmi', "[blood_overlay_type]cum")
		cum.color = COLOR_CUM
		. += cum
	if(HAS_TRAIT(src, TRAIT_COVERED_IN_BLOOD))
		. += mutable_appearance('icons/effects/blood.dmi', "[blood_overlay_type]blood")

	var/mob/living/carbon/human/M = loc
	if(!ishuman(M) || !M.w_uniform)
		return
	var/obj/item/clothing/under/U = M.w_uniform
	if(istype(U) && U.attached_accessory)
		var/obj/item/clothing/accessory/A = U.attached_accessory
		if(A.above_suit)
			. += U.accessory_overlay

/obj/item/clothing/suit/update_clothes_damaged_state(damaged_state = CLOTHING_DAMAGED)
	..()
	if(ismob(loc))
		var/mob/M = loc
		M.update_worn_oversuit()

/**
 * Wrapper proc to apply shielding through AddComponent().
 * Called in /obj/item/clothing/Initialize().
 * Override with an AddComponent(/datum/component/shielded, args) call containing the desired shield statistics.
 * See /datum/component/shielded documentation for a description of the arguments
 **/
/obj/item/clothing/suit/proc/setup_shielding()
	return

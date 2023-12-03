/obj/item/organ/heart/vampire
	name = "vampire heart"
	color = "#1C1C1C"
	organ_traits = list(TRAIT_NOHUNGER, TRAIT_NOBREATH)

/obj/item/organ/heart/vampire/on_insert(mob/living/carbon/organ_owner, special)
	. = ..()
	RegisterSignal(organ_owner, COMSIG_MOB_GET_STATUS_TAB_ITEMS, PROC_REF(get_status_tab_item))

/obj/item/organ/heart/vampire/on_remove(mob/living/carbon/organ_owner, special)
	. = ..()
	UnregisterSignal(organ_owner, COMSIG_MOB_GET_STATUS_TAB_ITEMS)

/obj/item/organ/heart/vampire/on_life(seconds_per_tick, times_fired)
	. = ..()
	if(istype(owner.loc, /obj/structure/closet/crate/coffin))
		owner.heal_overall_damage(brute = 2 * seconds_per_tick, burn = 2 * seconds_per_tick, required_bodytype = BODYTYPE_ORGANIC)
		owner.adjustToxLoss(-2 * seconds_per_tick)
		owner.adjustOxyLoss(-2 * seconds_per_tick)
		owner.adjustCloneLoss(-2 * seconds_per_tick)
		return
	owner.blood_volume -= 0.125 * seconds_per_tick
	if(owner.blood_volume <= BLOOD_VOLUME_SURVIVE)
		to_chat(owner, span_userdanger("You ran out of blood!"))
		owner.investigate_log("has been dusted by a lack of blood (vampire heart).", INVESTIGATE_DEATHS)
		owner.dust()
	var/area/holy_area = get_area(owner)
	if(istype(holy_area, /area/station/service/chapel))
		to_chat(owner, span_userdanger("You don't belong here!"))
		owner.adjustFireLoss(10 * seconds_per_tick)
		owner.adjust_fire_stacks(3 * seconds_per_tick)
		owner.ignite_mob()

/obj/item/organ/heart/vampire/proc/get_status_tab_item(mob/living/carbon/source, list/items)
	SIGNAL_HANDLER
	items += "Blood Level: [source.blood_volume]/[BLOOD_VOLUME_MAXIMUM]"

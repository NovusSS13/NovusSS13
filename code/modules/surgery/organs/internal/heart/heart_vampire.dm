/obj/item/organ/heart/vampire
	name = "vampire heart"
	color = "#1C1C1C"

/obj/item/organ/heart/vampire/on_insert(mob/living/carbon/organ_owner, special)
	. = ..()
	RegisterSignal(organ_owner, COMSIG_MOB_GET_STATUS_TAB_ITEMS, PROC_REF(get_status_tab_item))

/obj/item/organ/heart/vampire/on_remove(mob/living/carbon/organ_owner, special)
	. = ..()
	UnregisterSignal(organ_owner, COMSIG_MOB_GET_STATUS_TAB_ITEMS)

/obj/item/organ/heart/vampire/proc/get_status_tab_item(mob/living/carbon/source, list/items)
	SIGNAL_HANDLER
	items += "Blood Level: [source.blood_volume]/[BLOOD_VOLUME_MAXIMUM]"

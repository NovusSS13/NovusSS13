/obj/machinery/computer/cryopod
	name = "cryogenic oversight console"
	desc = "An interface between crew and the cryogenic storage oversight systems."
	icon = 'icons/obj/machines/cryogenics.dmi'
	icon_state = "cellconsole_1"
	base_icon_state = "cellconsole"
	icon_keyboard = null
	icon_screen = null
	use_power = IDLE_POWER_USE
	density = FALSE
	req_one_access = list(ACCESS_COMMAND, ACCESS_ARMORY) // Heads of staff or the warden can go here to claim recover items from their department that people went were cryodormed with.
	verb_say = "coldly states"
	verb_ask = "queries"
	verb_exclaim = "alarms"

	/// Used for logging people entering cryosleep and important items they are carrying. Structure: list(name:rank)
	var/list/frozen_crew = list()
	/// The items currently stored in the cryopod control panel.
	var/list/stored_items = list()

	/// Console ID for the cryopods to link with. Set in map editors. Only matters on mapload.
	var/console_id = null

	/// This is what the announcement system uses to make announcements. Make sure to set a radio that has the channel you want to broadcast on.
	var/obj/item/radio/headset/radio = /obj/item/radio/headset/silicon/pai
	/// The channel to be broadcast on, valid values are the values of any of the "RADIO_CHANNEL_" defines.
	var/announcement_channel = null // RADIO_CHANNEL_COMMON doesn't work here.

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/computer/cryopod, 32)

/obj/machinery/computer/cryopod/Initialize(mapload)
	. = ..()
	radio = new radio(src)
	GLOB.cryopod_consoles += src

/obj/machinery/computer/cryopod/Destroy()
	QDEL_NULL(radio)
	GLOB.cryopod_consoles -= src
	return ..()

/obj/machinery/computer/cryopod/update_icon_state()
	icon_state = base_icon_state
	if(!(machine_stat & (NOPOWER|BROKEN)))
		icon_state += "_1"
	return ..()

/obj/machinery/computer/cryopod/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	if(machine_stat & (NOPOWER|BROKEN))
		return

	add_fingerprint(user)

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CryopodConsole", name)
		ui.open()

/obj/machinery/computer/cryopod/ui_data(mob/user)
	var/list/data = list()
	for(var/name in frozen_crew)
		LAZYADD(data["frozen_crew"], list(list(
			"name" = name,
			"rank" = frozen_crew[name]
		)))

	for(var/obj/item/item as anything in stored_items)
		LAZYADDASSOC(data["item_refs"], REF(item), item.name)

	// Check Access for item dropping.
	data["item_retrieval_allowed"] = allowed(user)

	if(isliving(user))
		var/mob/living/card_owner = user
		var/obj/item/card/id/id_card = card_owner.get_idcard()
		data["account_name"] = id_card?.registered_name

	return data

/obj/machinery/computer/cryopod/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	switch(action)
		if("get_item")
			var/obj/item/item = locate(params["item_ref"]) in contents
			if(!item)
				return FALSE

			item.forceMove(drop_location())
			visible_message("[src] dispenses \the [item].")
			return TRUE


/obj/machinery/computer/cryopod/proc/announce_cryo(mob/living/occupant, occupant_rank)
	ASSERT(istype(occupant))

	var/occupant_name = occupant.real_name
	radio.talk_into(src, "[occupant_name][occupant_rank ? ", [occupant_rank]" : ""] has been moved into cryo storage.", announcement_channel)

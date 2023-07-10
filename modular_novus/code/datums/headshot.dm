/datum/examine_panel

	var/mob/living/owner
	/// maptext rendering geyness screen obj
	var/atom/movable/screen/map_view/examine_panel_screen

	var/flavor_text
	var/naked_flavor_text //mmm very sechs
	var/temporary_flavor_text
	var/cyborg_flavor_text
	var/ai_flavor_text
	var/custom_species_name //you might ask "null u stupid why are you storing all this when read_preference() exists"
	var/custom_species_desc //see, besides temp flavor text, i dont want people changing these mid-round
	var/ooc_notes //also ooc notes will be an epic meme
	var/headshot_link

/datum/examine_panel/New(mob/living/_owner, datum/preferences/prefs)
	if(isnull(_owner))
		stack_trace("/datum/examine_panel got initialized without an owner.")
		qdel(src)
		return

	owner = _owner
	flavor_text = prefs.read_preference(/datum/preference/text/flavor_text)
	naked_flavor_text = prefs.read_preference(/datum/preference/text/naked_flavor_text)
	cyborg_flavor_text = prefs.read_preference(/datum/preference/text/cyborg_flavor_text)
	ai_flavor_text = prefs.read_preference(/datum/preference/text/ai_flavor_text)
	custom_species_name = prefs.read_preference(/datum/preference/text/custom_species_name)
	custom_species_desc = prefs.read_preference(/datum/preference/text/custom_species_desc)
	ooc_notes = prefs.read_preference(/datum/preference/text/ooc_notes)
	headshot_link = prefs.read_preference(/datum/preference/text/headshot_link)

	RegisterSignal(owner, COMSIG_QDELETING, PROC_REF(on_qdel))
	RegisterSignal(owner, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))

/datum/examine_panel/Destroy(force, ...)
	owner = null
	return ..()

/datum/examine_panel/Topic(href, href_list)
	if(href_list["open_examine_panel"])
		ui_interact(usr)
	return ..()

/datum/examine_panel/ui_host(mob/user, datum/ui_state/state)
	return owner

/datum/examine_panel/ui_state()
	return GLOB.physical_state

/datum/examine_panel/ui_data(mob/user)
	. = list()
	//temp flavor text doesnt care for if the user can tell what the species are
	//dont be dumb kids
	.["temporary_flavor_text"] = temporary_flavor_text || null
	.["character_name"] = owner.get_visible_name()
	.["assigned_map"] = examine_panel_screen.assigned_map
	.["unobscured"] = TRUE

	if(ishuman(owner))
		.["mob_type"] = "human"
		if(!owner.is_face_visible())
			.["unobscured"] = FALSE
			return

		var/mob/living/carbon/human/human = owner
		.["flavor_text"] = flavor_text || null
		.["headshot_link"] = headshot_link || null //yes, this does mean headshots are only for humans. i dont want to bother about the "human headshot bleeding into borg" edge case
		.["custom_species_name"] = custom_species_name || human.dna.species.name //also no custom species for cyborgs. ew.
		.["custom_species_desc"] = custom_species_desc || (!custom_species_name && jointext(human.dna.species.get_species_lore(), "\n\n"))

		if((human.get_all_covered_flags() & (GROIN|CHEST)) == (GROIN|CHEST)) //is naked check. arbitrary but w/e
			.["naked_flavor_text"] = naked_flavor_text || null

	else if(iscyborg(owner))
		.["mob_type"] = "cyborg"
		.["flavor_text"] = cyborg_flavor_text || null

	else if(isAI(owner))
		.["mob_type"] = "ai"
		.["flavor_text"] = ai_flavor_text || null

	else
		.["mob_type"] = "other"

	.["ooc_notes"] = ooc_notes


/datum/examine_panel/ui_interact(mob/user, datum/tgui/ui)
	//shamelessly ripped from skee
	//idrc to reimplement this
	if(!examine_panel_screen)
		examine_panel_screen = new
		examine_panel_screen.assigned_map = "examine_panel_[REF(owner)]_map"
		examine_panel_screen.del_on_map_removal = FALSE
		examine_panel_screen.screen_loc = "[examine_panel_screen.assigned_map]:1,1"

	var/mutable_appearance/current_mob_appearance = new(owner)
	current_mob_appearance.setDir(SOUTH)
	current_mob_appearance.transform = matrix()

	current_mob_appearance.pixel_x = 0
	current_mob_appearance.pixel_y = 0

	examine_panel_screen.cut_overlays()
	examine_panel_screen.add_overlay(current_mob_appearance)

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		examine_panel_screen.display_to(user)
		user.client.register_map_obj(examine_panel_screen)
		ui = new(user, src, "HeadshotPanel")
		ui.open()

/datum/examine_panel/proc/on_qdel()
	SIGNAL_HANDLER

	qdel(src)

/datum/examine_panel/proc/on_examine(atom/movable/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	if(temporary_flavor_text)
		examine_list += span_info(temporary_flavor_text)

	examine_list += "<a class='info bold' href='?src=[REF(src)];open_examine_panel=1'>You could probably take a closer look..</a>"


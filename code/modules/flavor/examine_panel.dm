/datum/examine_panel
	/// Guy that actually owns us
	var/mob/living/owner
	/// Mapview for rendering the character in the UI
	var/atom/movable/screen/map_view/examine_panel_screen
	/// Temporary flavor text comes here, i don't think it should be global
	var/temporary_flavor_text

/datum/examine_panel/New(mob/living/owner, datum/preferences/prefs)
	. = ..()
	if(isnull(owner))
		stack_trace("[type] got initialized without an owner.")
		qdel(src)
		return

	src.owner = owner

	RegisterSignal(owner, COMSIG_QDELETING, PROC_REF(on_qdel))
	RegisterSignal(owner, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))

/datum/examine_panel/Destroy(force)
	. = ..()
	if(owner)
		UnregisterSignal(owner, COMSIG_QDELETING)
		UnregisterSignal(owner, COMSIG_ATOM_EXAMINE)
		owner = null

/datum/examine_panel/Topic(href, href_list)
	if(href_list["open_examine_panel"])
		ui_interact(usr)
	return ..()

/datum/examine_panel/ui_host(mob/user, datum/ui_state/state)
	return owner

/datum/examine_panel/ui_state()
	return GLOB.always_state

/datum/examine_panel/ui_static_data(mob/user)
	. = list()
	var/character_name = owner.name
	.["character_name"] = character_name
	.["assigned_map"] = examine_panel_screen.assigned_map
	//temp flavor text doesnt care for if the user can tell what the species are
	//dont be dumb kids
	.["temporary_flavor_text"] = temporary_flavor_text
	.["unobscured"] = TRUE

	//get the flavor holder that matches the current owner
	var/datum/flavor_holder/flavor_holder = GLOB.flavor_holders[character_name]

	if(ishuman(owner))
		.["mob_type"] = "human"
		if(!owner.is_face_visible() || !owner.get_visible_name(""))
			.["unobscured"] = FALSE
			return

		var/mob/living/carbon/human/human = owner
		if(flavor_holder)
			.["headshot_link"] = flavor_holder.headshot_link //yes, this does mean headshots are only for humans. i dont want to bother about the "human headshot bleeding into borg" edge case
			.["flavor_text"] = flavor_holder.flavor_text
			if(!(human.get_all_covered_flags() & (GROIN|CHEST))) //is naked check. arbitrary but w/e
				.["naked_flavor_text"] = flavor_holder.naked_flavor_text
		.["custom_species_name"] = flavor_holder?.custom_species_name || human.dna.species.name //also no custom species for cyborgs. ew.
		.["custom_species_desc"] = flavor_holder?.custom_species_desc || (!flavor_holder?.custom_species_name && jointext(human.dna.species.get_species_lore(), "\n\n"))

	else if(iscyborg(owner))
		.["mob_type"] = "cyborg"
		.["flavor_text"] = flavor_holder?.cyborg_flavor_text

	else if(isAI(owner))
		.["mob_type"] = "ai"
		.["flavor_text"] = flavor_holder?.ai_flavor_text

	else
		.["mob_type"] = "other"

	.["ooc_notes"] = flavor_holder?.ooc_notes

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
		ui = new(user, src, "ExaminePanel")
		ui.open()

/datum/examine_panel/proc/on_qdel()
	SIGNAL_HANDLER

	qdel(src)

/datum/examine_panel/proc/on_examine(atom/movable/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	if(temporary_flavor_text)
		examine_list += span_info("<i>[temporary_flavor_text]</i>")

	//get the flavor holder that matches the current visible name
	var/datum/flavor_holder/flavor_holder = GLOB.flavor_holders[source.name]
	if(!flavor_holder)
		return

	examine_list += span_info(span_bold("<a href='?src=[REF(src)];open_examine_panel=1'><i>You could probably take a closer look...</i></a>"))

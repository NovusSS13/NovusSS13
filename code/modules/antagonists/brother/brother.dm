/datum/antagonist/brother
	name = "\improper Brother"
	antagpanel_category = "Brother"
	job_rank = ROLE_BROTHER
	antag_hud_name = "brother"
	hijack_speed = 0.5
	ui_name = "AntagInfoBrother"
	suicide_cry = "FOR MY BROTHER!!"
	antag_moodlet = /datum/mood_event/brotherhoood
	/// Brotherhood this antag belongs to
	var/datum/team/brother_team/team
	/// Telepathy spell for communicating with your bros
	var/datum/action/cooldown/spell/brother_telepathy/telepathy

/datum/antagonist/brother/create_team(datum/team/brother_team/new_team)
	if(!new_team)
		return
	if(!istype(new_team))
		stack_trace("Wrong team type passed to [type] initialization.")
	team = new_team
	return team

/datum/antagonist/brother/get_team()
	return team

/datum/antagonist/brother/on_gain()
	objectives += team.objectives
	owner.special_role = job_rank
	finalize_brother()
	return ..()

/datum/antagonist/brother/apply_innate_effects(mob/living/mob_override)
	var/mob/living/living_mob = mob_override || owner.current
	telepathy = new(team)
	telepathy.Grant(living_mob)
	RegisterSignal(living_mob, COMSIG_LIVING_DEATH, PROC_REF(on_death))
	RegisterSignal(living_mob, COMSIG_LIVING_REVIVE, PROC_REF(on_revive))
	if(iscarbon(living_mob))
		RegisterSignal(living_mob, COMSIG_CARBON_GAIN_TRAUMA, PROC_REF(on_gain_trauma))
		RegisterSignal(living_mob, COMSIG_CARBON_LOSE_TRAUMA, PROC_REF(on_lose_trauma))

/datum/antagonist/brother/remove_innate_effects(mob/living/mob_override)
	var/mob/living/living_mob = mob_override || owner.current
	telepathy?.Remove(living_mob)
	UnregisterSignal(living_mob, list(COMSIG_LIVING_DEATH, COMSIG_LIVING_REVIVE))
	if(iscarbon(living_mob))
		UnregisterSignal(living_mob, list(COMSIG_CARBON_GAIN_TRAUMA, COMSIG_CARBON_LOSE_TRAUMA))

/datum/antagonist/brother/on_removal()
	owner.special_role = null
	return ..()

/datum/antagonist/brother/antag_panel_data()
	return "Conspirators: [get_brother_names()]"

/datum/antagonist/brother/get_preview_icon()
	var/mob/living/carbon/human/dummy/consistent/brother1 = new
	var/mob/living/carbon/human/dummy/consistent/brother2 = new

	brother1.dna.features["ethcolor"] = GLOB.color_list_ethereal["Faint Red"]
	brother1.set_species(/datum/species/ethereal)

	brother2.dna.features["moth_antennae"] = "Plain"
	brother2.dna.features["moth_wings"] = "Plain"
	brother2.set_species(/datum/species/moth)

	var/icon/brother1_icon = render_preview_outfit(/datum/outfit/job/quartermaster, brother1)
	brother1_icon.Blend(icon('icons/effects/blood.dmi', "maskblood"), ICON_OVERLAY)
	brother1_icon.Shift(WEST, 8)

	var/icon/brother2_icon = render_preview_outfit(/datum/outfit/job/scientist/consistent, brother2)
	brother2_icon.Blend(icon('icons/effects/blood.dmi', "uniformblood"), ICON_OVERLAY)
	brother2_icon.Shift(EAST, 8)

	var/icon/final_icon = brother1_icon
	final_icon.Blend(brother2_icon, ICON_OVERLAY)

	qdel(brother1)
	qdel(brother2)

	return finish_preview_icon(final_icon)

/datum/antagonist/brother/proc/get_brother_names()
	var/list/brothers = team.members - owner
	var/list/brother_names = list()
	for(var/datum/mind/bro as anything in brothers)
		brother_names += bro.name
	return english_list(brother_names)

/datum/antagonist/brother/greet()
	var/brother_text = get_brother_names()
	to_chat(owner.current, span_alertsyndie("You are the [owner.special_role] of [brother_text]."))
	to_chat(owner.current, "Brains united as one, you know that you are more capable than the rest of the crew. Complete your objectives to ensure the eventual takeover of the station by the brotherhood.")
	owner.announce_objectives()

/datum/antagonist/brother/proc/finalize_brother()
	team.update_name()
	owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/antag/brotheralert.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)

/datum/antagonist/brother/admin_add(datum/mind/new_owner,mob/admin)
	//show list of possible brothers
	var/list/candidates = list()
	for(var/mob/living/L in GLOB.alive_mob_list)
		if(!L.mind || L.mind == new_owner || !can_be_owned(L.mind))
			continue
		candidates[L.mind.name] = L.mind

	var/choice = input(admin, "Choose the blood brother.", "Brother") as null|anything in sort_names(candidates)
	if(!choice)
		return
	var/datum/mind/bro = candidates[choice]
	var/datum/team/brother_team/team = new
	team.add_member(new_owner)
	team.add_member(bro)
	team.forge_brother_objectives()
	new_owner.add_antag_datum(/datum/antagonist/brother,team)
	bro.add_antag_datum(/datum/antagonist/brother, team)
	message_admins("[key_name_admin(admin)] made [key_name_admin(new_owner)] and [key_name_admin(bro)] into blood brothers.")
	log_admin("[key_name(admin)] made [key_name(new_owner)] and [key_name(bro)] into blood brothers.")

/datum/antagonist/brother/ui_static_data(mob/user)
	var/list/data = list()
	data["antag_name"] = name
	data["objectives"] = get_objectives()
	data["brothers"] = get_brother_names()
	return data

/datum/antagonist/brother/proc/on_death(mob/living/source, gibbed)
	SIGNAL_HANDLER

	for(var/datum/mind/brother_mind as anything in team.members)
		if((brother_mind == owner) || !brother_mind.current)
			continue
		var/mob/living/brother = brother_mind.current
		to_chat(brother, span_userdanger("MY BROTHER! [uppertext(source.name)] HAS DIED!"))
		INVOKE_ASYNC(brother, TYPE_PROC_REF(/mob, emote), "scream")
		if(iscarbon(brother))
			var/mob/living/carbon/traumatized = brother
			if(!(locate(/datum/brain_trauma/severe/stroke/brother) in traumatized.get_traumas()))
				traumatized.gain_trauma(/datum/brain_trauma/severe/stroke/brother)

/datum/antagonist/brother/proc/on_revive(mob/living/source, full_heal_flags)
	SIGNAL_HANDLER

	var/no_dead_brothers = FALSE
	for(var/datum/mind/brother_mind as anything in team.members)
		if((brother_mind == owner) || !brother_mind.current)
			continue
		var/mob/living/brother = brother_mind.current
		to_chat(brother, span_boldnicegreen("[source] is alive again!"))
		if(brother.stat >= DEAD)
			no_dead_brothers = FALSE

	if(!no_dead_brothers)
		return

	for(var/datum/mind/brother_mind as anything in team.members)
		if(!brother_mind.current || !iscarbon(brother_mind.current))
			continue
		var/mob/living/carbon/traumatized = brother_mind.current
		for(var/datum/brain_trauma/trauma in traumatized.get_traumas())
			if(istype(trauma, /datum/brain_trauma/severe/stroke/brother))
				qdel(trauma)
				break

/datum/antagonist/brother/proc/on_gain_trauma(mob/living/carbon/source, datum/brain_trauma/trauma, resilience, list/arguments)
	SIGNAL_HANDLER

	for(var/datum/mind/brother_mind as anything in team.members)
		if((brother_mind == owner) || !iscarbon(brother_mind.current))
			continue
		var/mob/living/carbon/traumatized = brother_mind.current
		traumatized.gain_trauma(trauma.type, resilience, arguments)

/datum/antagonist/brother/proc/on_lose_trauma(mob/living/carbon/source, datum/brain_trauma/trauma)
	SIGNAL_HANDLER

	for(var/datum/mind/brother_mind as anything in team.members)
		if((brother_mind == owner) || !iscarbon(brother_mind.current))
			continue
		var/mob/living/carbon/traumatized = brother_mind.current
		for(var/datum/brain_trauma/other_trauma in traumatized.get_traumas())
			if(other_trauma.type != trauma.type)
				continue
			qdel(other_trauma)

/datum/team/brother_team
	name = "\improper Brotherhood"
	member_name = "blood brother"

/datum/team/brother_team/proc/update_name()
	var/list/last_names = list()
	for(var/datum/mind/team_minds as anything in members)
		var/list/split_name = splittext(team_minds.name," ")
		last_names += split_name[split_name.len]

	name = "[initial(name)] of " + last_names.Join(" & ")

/datum/team/brother_team/proc/forge_brother_objectives()
	objectives = list()
	var/is_hijacker = prob(10)
	for(var/i = 1 to max(1, CONFIG_GET(number/brother_objectives_amount) + (members.len > 2) - is_hijacker))
		forge_single_objective()
	if(is_hijacker)
		if(!locate(/datum/objective/hijack) in objectives)
			add_objective(new /datum/objective/hijack)
	else if(!locate(/datum/objective/escape) in objectives)
		add_objective(new /datum/objective/escape)

/datum/team/brother_team/proc/forge_single_objective()
	if(prob(50))
		if(LAZYLEN(active_ais()) && prob(100/GLOB.joined_player_list.len))
			add_objective(new /datum/objective/destroy, needs_target = TRUE)
		else if(prob(30))
			add_objective(new /datum/objective/maroon, needs_target = TRUE)
		else if(prob(20)) //small chance to debrain due to new brother lore
			add_objective(new /datum/objective/debrain, needs_target = TRUE)
		else
			add_objective(new /datum/objective/assassinate, needs_target = TRUE)
	else
		add_objective(new /datum/objective/steal, needs_target = TRUE)

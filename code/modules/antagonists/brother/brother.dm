/datum/antagonist/brother
	name = "\improper Blood Brother"
	antagpanel_category = "Brother"
	job_rank = ROLE_BROTHER
	antag_hud_name = "brother"
	hijack_speed = 0.5
	ui_name = "AntagInfoBrother"
	suicide_cry = "FOR MY BROTHERS AND SISTERS!!"
	antag_moodlet = /datum/mood_event/brotherhoood
	/// Brotherhood this antag belongs to
	var/datum/team/brother_team/team
	/// Telepathy spell for communicating with your bros
	var/datum/action/cooldown/spell/fraternal_telepathy/telepathy
	/// Altruism spell for healing your bros
	var/datum/action/cooldown/spell/fraternal_altruism/altruism

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
	altruism = new(team)
	altruism.Grant(living_mob)
	RegisterSignal(living_mob, COMSIG_LIVING_DEATH, PROC_REF(on_death))
	RegisterSignal(living_mob, COMSIG_LIVING_REVIVE, PROC_REF(on_revive))
	if(iscarbon(living_mob))
		RegisterSignal(living_mob, COMSIG_CARBON_CHECK_SELF_FOR_INJURIES, PROC_REF(on_check_self_for_injuries))
		RegisterSignal(living_mob, COMSIG_CARBON_GAIN_TRAUMA, PROC_REF(on_gain_trauma))
		RegisterSignal(living_mob, COMSIG_CARBON_LOSE_TRAUMA, PROC_REF(on_lose_trauma))
		RegisterSignal(living_mob, COMSIG_CARBON_PRINT_MOOD, PROC_REF(on_print_mood))

/datum/antagonist/brother/remove_innate_effects(mob/living/mob_override)
	var/mob/living/living_mob = mob_override || owner.current
	if(telepathy)
		telepathy.Remove(living_mob)
		QDEL_NULL(telepathy)
	if(altruism)
		altruism.Remove(living_mob)
		QDEL_NULL(altruism)
	UnregisterSignal(living_mob, list(COMSIG_LIVING_DEATH, COMSIG_LIVING_REVIVE))
	if(iscarbon(living_mob))
		UnregisterSignal(living_mob, list(COMSIG_CARBON_CHECK_SELF_FOR_INJURIES, COMSIG_CARBON_GAIN_TRAUMA, COMSIG_CARBON_LOSE_TRAUMA, COMSIG_CARBON_PRINT_MOOD))

/datum/antagonist/brother/on_removal()
	owner.special_role = null
	owner.current.clear_mood_event("brother_death")
	return ..()

/datum/antagonist/brother/antag_panel_data()
	return "<b>Siblings:</b> [english_list(get_brother_names())]"

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
	for(var/datum/mind/brother_mind as anything in brothers)
		brother_names += brother_mind.name
	return brother_names

/datum/antagonist/brother/greet()
	to_chat(owner.current, span_alertsyndie("You are the [name] of [english_list(get_brother_names())]."))
	to_chat(owner.current, "Brains united as one, you know that you are more capable than the rest of the crew. Complete your objectives to ensure the eventual takeover of the station by the brotherhood.")
	owner.announce_objectives()

/datum/antagonist/brother/proc/update_name()
	if(!owner.current)
		return name
	switch(owner.current.gender)
		if(MALE)
			name = "\improper Blood Brother"
		else if(FEMALE)
			name = "\improper Blood Sister"
		else
			name = "\improper Blood Sibling"
	return name

/datum/antagonist/brother/proc/finalize_brother()
	update_name()
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
	var/datum/team/brother_team/team = new
	team.add_member(new_owner)
	team.add_member(candidates[choice])
	var/more_brothers = input(admin, "Add more brothers?", "Yes") as null|anything in list("Yes", "No")
	if(more_brothers == "Yes")
		while(choice)
			for(var/datum/mind/brother_mind in team.members)
				candidates -= brother_mind.name
			choice = input(admin, "Choose the blood brother.", "Brother") as null|anything in sort_names(candidates)
			if(!choice)
				more_brothers = "No"
				break
			team.add_member(candidates[choice])
	team.forge_brother_objectives()
	var/list/brothers_list = list()
	for(var/datum/mind/brother_mind as anything in team.members)
		brother_mind.add_antag_datum(/datum/antagonist/brother,team)
		brothers_list += key_name_admin(brother_mind)
	message_admins("[key_name_admin(admin)] made [english_list(brothers_list)] into blood brothers.")
	log_admin("[key_name(admin)] made [english_list(brothers_list)] into blood brothers.")

/datum/antagonist/brother/ui_static_data(mob/user)
	var/list/data = list()
	data["antag_name"] = name
	data["objectives"] = get_objectives()
	data["brothers"] = get_brother_names()
	return data

/datum/antagonist/brother/proc/on_death(mob/living/source, gibbed)
	SIGNAL_HANDLER

	var/brother_name = source.mind?.name || "[source.name]"
	var/brother_type = name
	var/datum/antagonist/brother/fellow_brother = source.mind?.has_antag_datum(/datum/antagonist/brother)
	if(fellow_brother)
		brother_type = fellow_brother.name
	for(var/datum/mind/brother_mind as anything in team.members)
		if((brother_mind == owner) || !isliving(brother_mind.current))
			continue
		var/mob/living/brother = brother_mind.current
		to_chat(brother, span_userdanger("MY [uppertext(brother_type)]! [uppertext(brother_name)] HAS DIED!"))
		INVOKE_ASYNC(brother, TYPE_PROC_REF(/mob, emote), "scream")
		if(iscarbon(brother))
			var/mob/living/carbon/traumatized = brother
			if(!(locate(/datum/brain_trauma/severe/stroke/brother) in traumatized.get_traumas()))
				traumatized.gain_trauma(/datum/brain_trauma/severe/stroke/brother)
			traumatized.add_mood_event("brother_death", /datum/mood_event/dead_brother, brother_type, brother_name)

/datum/antagonist/brother/proc/on_revive(mob/living/source, full_heal_flags)
	SIGNAL_HANDLER

	var/no_dead_brothers = TRUE
	var/live_brother = source.mind?.name || "[source.name]"
	for(var/datum/mind/brother_mind as anything in team.members)
		if((brother_mind == owner) || !isliving(brother_mind.current))
			continue
		var/mob/living/brother = brother_mind.current
		to_chat(brother, span_announce(span_boldnicegreen("[live_brother] is alive again!")))
		if(brother.stat >= DEAD)
			no_dead_brothers = FALSE

	if(!no_dead_brothers)
		return

	for(var/datum/mind/brother_mind as anything in team.members)
		if(!brother_mind.current || !iscarbon(brother_mind.current))
			continue
		var/mob/living/carbon/traumatized = brother_mind.current
		qdel(locate(/datum/brain_trauma/severe/stroke/brother) in traumatized.get_traumas())
		traumatized.clear_mood_event("brother_death")

/datum/antagonist/brother/proc/on_gain_trauma(mob/living/carbon/source, datum/brain_trauma/trauma, resilience, list/arguments)
	SIGNAL_HANDLER

	if(!trauma.random_gain)
		return

	for(var/datum/mind/brother_mind as anything in team.members)
		if((brother_mind == owner) || !iscarbon(brother_mind.current))
			continue
		var/mob/living/carbon/traumatized = brother_mind.current
		var/obj/item/organ/brain/brain = traumatized.get_organ_slot(ORGAN_SLOT_BRAIN)
		if(brain)
			brain.brain_gain_trauma(trauma.type, resilience, arguments)

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

/datum/antagonist/brother/proc/on_print_mood(datum/mood/source, mob/living/carbon/user, list/messages)
	SIGNAL_HANDLER

	if(!messages)
		return

	for(var/datum/mind/brother_mind as anything in team.members)
		if((brother_mind == owner) || !iscarbon(brother_mind.current))
			continue
		var/mob/living/carbon/moody = brother_mind.current
		if(!moody.mob_mood)
			continue
		messages += "\n<hr class='examine_divider'>"
		messages += span_info("<EM>[brother_mind.name]'s current mental status:</EM>")
		messages += (span_notice("[brother_mind.name]'s current sanity: ") + moody.mob_mood.get_sanity_string()) //Long term
		messages += (span_notice("[brother_mind.name]'s current mood: ") + moody.mob_mood.get_mood_string()) //Short term
		messages += span_notice("Moodlets:")
		messages += moody.mob_mood.get_moodlet_descriptions()

/datum/antagonist/brother/proc/on_check_self_for_injuries(mob/living/carbon/source, list/messages)
	SIGNAL_HANDLER

	if(!messages)
		return
	for(var/datum/mind/brother_mind as anything in team.members)
		if((brother_mind == owner) || !iscarbon(brother_mind.current))
			continue
		var/mob/living/carbon/hurt = brother_mind.current
		messages += "\n<hr class='examine_divider'>"
		var/list/brother_injuries = hurt.print_injuries(hurt)
		var/current_status_index = brother_injuries.Find(span_info("<EM>Current health status:</EM>"))
		if(current_status_index)
			brother_injuries.Cut(current_status_index, current_status_index+1)
			brother_injuries.Insert(current_status_index, span_info("<EM>[brother_mind.name]'s current health status:</EM>"))
		messages += brother_injuries

/datum/team/brother_team
	name = "\improper Brotherhood"
	member_name = "blood brother"

/datum/team/brother_team/proc/update_name()
	var/list/gendercount = list(MALE = 0, FEMALE = 0, PLURAL = 0)
	var/list/last_names = list()
	var/static/regex/hyphen_or_space = regex(@"[ -]", "gi")
	for(var/datum/mind/brother_mind as anything in members)
		var/list/split_name = splittext(brother_mind.name, hyphen_or_space)
		last_names += split_name[split_name.len]
		if(!brother_mind.current)
			continue
		var/purposeful_gender = brother_mind.current.gender
		if(!(purposeful_gender in gendercount))
			purposeful_gender = PLURAL
		gendercount[purposeful_gender]++

	var/hood_type
	if(gendercount[MALE] > (gendercount[FEMALE]+gendercount[PLURAL]))
		hood_type = "\improper Brotherhood"
	else if(gendercount[FEMALE] > (gendercount[MALE]+gendercount[PLURAL]))
		hood_type = "\improper Sisterhood"
	else
		hood_type = "\improper Siblinghood"

	name = "[hood_type] of " + last_names.Join(" & ")

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

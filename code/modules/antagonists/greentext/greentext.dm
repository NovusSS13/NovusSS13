/datum/antagonist/greentext
	name = "\improper winner"
	show_in_antagpanel = FALSE
	show_name_in_check_antagonists = TRUE //Not that it will be there for long
	suicide_cry = "FOR THE GREENTEXT!!" // This can never actually show up, but not including it is a missed opportunity
	count_against_dynamic_roll_chance = FALSE
	antag_flags = FLAG_ANTAG_SAFE_TO_CRYO | FLAG_ANTAG_HEMISPHERECTOMIZABLE

/datum/antagonist/greentext/forge_objectives()
	var/datum/objective/succeed_objective = new /datum/objective("Succeed")
	succeed_objective.completed = TRUE //YES!
	succeed_objective.owner = owner
	objectives += succeed_objective

/datum/antagonist/greentext/on_gain()
	forge_objectives()
	. = ..()

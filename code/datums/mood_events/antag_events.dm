/datum/mood_event/brotherhoood
	description = "Brothers to the end!"
	mood_change = 4
	hidden = TRUE

/datum/mood_event/dead_brother
	description = "MY BLOOD BROTHER IS DEAD!"
	mood_change = -4
	hidden = TRUE

/datum/mood_event/dead_brother/add_effects(brother_type, brother_name)
	description = "MY [uppertext(brother_type)]! [uppertext(brother_name)] IS DEAD!"

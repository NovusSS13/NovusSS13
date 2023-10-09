/// The subsystem used to process [/datum/component/interactable] instances.
PROCESSING_SUBSYSTEM_DEF(interactables)
	name = "Interactables"
	wait = 5
	priority = FIRE_PRIORITY_INTERACTABLES
	flags = SS_NO_INIT | SS_BACKGROUND
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

/// Status effect from multiple sources, when all sources are removed, so is the effect
/datum/status_effect/grouped
	// Grouped effects adds itself to [var/sources] and destroys itself if one exists already, there are never actually multiple
	status_type = STATUS_EFFECT_MULTIPLE
	/// Assoc list of all sources applying this status effect, to the arguments passed over.
	var/list/sources = list()

/datum/status_effect/grouped/on_creation(mob/living/new_owner, source, ...)
	var/datum/status_effect/grouped/existing = new_owner.has_status_effect(type)
	if(existing)
		existing.sources[source] = args.Copy(3) //copy args
		qdel(src)
		return FALSE

	sources |= source
	return ..()

/datum/status_effect/grouped/before_remove(source)
	sources -= source
	return !length(sources)

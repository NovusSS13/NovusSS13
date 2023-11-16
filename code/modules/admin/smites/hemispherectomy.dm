/// Tears out half of the target's brain
/datum/smite/hemispherectomy
	name = "Hemispherectomy"

/datum/smite/hemispherectomy/effect(client/user, mob/living/target)
	. = ..()
	if (!iscarbon(target))
		to_chat(user, span_warning("This must be used on a carbon mob."), confidential = TRUE)
		return
	var/obj/item/organ/brain/brain = target.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(!brain)
		to_chat(user, span_warning("This mob has no brain."), confidential = TRUE)
		return
	else if(brain.hemispherectomized)
		to_chat(user, span_warning("Their brain has already been hemispherectomized."), confidential = TRUE)
		return

	brain.hemispherectomize(target)
	brain.traumatic_hemispherectomy(target)

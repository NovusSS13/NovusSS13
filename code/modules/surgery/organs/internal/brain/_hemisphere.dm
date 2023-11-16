/obj/item/hemisphere
	name = "brain hemisphere"
	desc = "A huge chunk carved out of someone's brain.\nYou can almost feel <i>something</i> trapped inside..."
	icon = 'icons/obj/medical/organs/brain.dmi'
	icon_state = "hemisphere"
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	throw_speed = 3
	throw_range = 5
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	attack_verb_continuous = list("attacks", "slaps", "whacks")
	attack_verb_simple = list("attack", "slap", "whack")

	/// Organ traits of the brain we were cut off from
	var/list/brain_traits
	/// Brain traumas of the brain we were cut off from, type -> resilience
	var/list/brain_traumas

/obj/item/hemisphere/Initialize(mapload, obj/item/organ/brain/owner_brain)
	. = ..()
	if(owner_brain)
		if(LAZYLEN(owner_brain.organ_traits))
			LAZYINITLIST(brain_traits)
			brain_traits |= owner_brain.organ_traits
		if(LAZYLEN(owner_brain.traumas))
			LAZYINITLIST(brain_traumas)
			for(var/datum/brain_trauma/trauma as anything in owner_brain.traumas)
				//we only want traumas up to lobotomy tier
				if(trauma.resilience > TRAUMA_RESILIENCE_LOBOTOMY)
					continue
				brain_traumas |= trauma.type

/obj/item/hemisphere/zombie
	icon_state = "hemisphere-greyscale"
	color = COLOR_GREEN_GRAY

/obj/item/hemisphere/alien
	icon_state = "hemisphere-greyscale"
	color = COLOR_GREEN_GRAY

/obj/item/hemisphere/golem
	icon_state = "hemisphere-golem"
	color = COLOR_GOLEM_GRAY

/obj/item/hemisphere/lustrous
	icon_state = "hemisphere-bluespace"

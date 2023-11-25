/obj/item/organ/liver/jelly
	name = "revil"
	desc = "A very odd looking liver."
	icon = 'icons/obj/medical/organs/jelly_organs.dmi'
	icon_state = "revil"
	filterToxins = FALSE //WE FUCKING LOVE TOXINS!
	organ_traits = list(TRAIT_TOXINLOVER)

/obj/item/organ/liver/jelly/handle_chemical(mob/living/carbon/organ_owner, datum/reagent/chem, seconds_per_tick, times_fired)
	. = ..()
	if((. & COMSIG_MOB_STOP_REAGENT_CHECK) || (organ_flags & ORGAN_FAILING))
		return

	if(istype(chem, /datum/reagent/consumable/ethanol))
		var/datum/reagent/consumable/ethanol/alcohol = chem
		alcohol.boozepwr = -initial(alcohol.boozepwr)
		return // Do normal metabolism now that we inverted the boozepwr

	if(istype(chem, /datum/reagent/medicine/antihol))
		var/datum/reagent/medicine/antihol/antihol = chem
		antihol.boozepwr = -initial(antihol.boozepwr)
		return // Do normal metabolism now that we inverted the boozepwr

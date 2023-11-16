///maximum a vampire will drain, they will drain less if they hit their cap
#define VAMP_DRAIN_AMOUNT 50

/obj/item/organ/tongue/vampire
	name = "vampire tongue"
	actions_types = list(/datum/action/item_action/organ_action/vampire)
	color = "#1C1C1C"
	organ_traits = list(TRAIT_DRINKS_BLOOD)
	COOLDOWN_DECLARE(drain_cooldown)

/datum/action/item_action/organ_action/vampire
	name = "Drain Victim"
	desc = "Leech blood from any carbon victim you are passively grabbing."

/datum/action/item_action/organ_action/vampire/Trigger(trigger_flags)
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/H = owner
		var/obj/item/organ/tongue/vampire/V = target
		if(!COOLDOWN_FINISHED(V, drain_cooldown))
			to_chat(H, span_warning("You just drained blood, wait a few seconds!"))
			return
		if(H.pulling && iscarbon(H.pulling))
			var/mob/living/carbon/victim = H.pulling
			if(H.blood_volume >= BLOOD_VOLUME_MAXIMUM)
				to_chat(H, span_warning("You're already full!"))
				return
			if(victim.stat == DEAD)
				to_chat(H, span_warning("You need a living victim!"))
				return
			if(!victim.blood_volume || (victim.dna && (HAS_TRAIT(victim, TRAIT_NOBLOOD) || victim.dna.species.exotic_blood)))
				to_chat(H, span_warning("[victim] doesn't have blood!"))
				return
			COOLDOWN_START(V, drain_cooldown, 3 SECONDS)
			if(victim.can_block_magic(MAGIC_RESISTANCE_HOLY, charge_cost = 0))
				victim.show_message(span_warning("[H] tries to bite you, but stops before touching you!"))
				to_chat(H, span_warning("[victim] is blessed! You stop just in time to avoid catching fire."))
				return
			if(victim.has_reagent(/datum/reagent/consumable/garlic))
				victim.show_message(span_warning("[H] tries to bite you, but recoils in disgust!"))
				to_chat(H, span_warning("[victim] reeks of garlic! you can't bring yourself to drain such tainted blood."))
				return
			if(!do_after(H, 3 SECONDS, target = victim))
				return
			var/blood_volume_difference = BLOOD_VOLUME_MAXIMUM - H.blood_volume //How much capacity we have left to absorb blood
			var/drained_blood = min(victim.blood_volume, VAMP_DRAIN_AMOUNT, blood_volume_difference)
			victim.show_message(span_danger("[H] is draining your blood!"))
			to_chat(H, span_notice("You drain some blood!"))
			playsound(H, 'sound/items/drink.ogg', 30, TRUE, -2)
			victim.blood_volume = clamp(victim.blood_volume - drained_blood, 0, BLOOD_VOLUME_MAXIMUM)
			H.blood_volume = clamp(H.blood_volume + drained_blood, 0, BLOOD_VOLUME_MAXIMUM)
			if(!victim.blood_volume)
				to_chat(H, span_notice("You finish off [victim]'s blood supply."))

#undef VAMP_DRAIN_AMOUNT

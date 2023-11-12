/obj/item/organ/liver/felinid
	name = "fluffy liver"
	desc = "The liver of a felinid, strangely covered in fur."
	color = COLOR_PINK

/obj/item/organ/liver/felinid/handle_chemical(mob/living/carbon/organ_owner, datum/reagent/chem, seconds_per_tick, times_fired)
	. = ..()
	if((. & COMSIG_MOB_STOP_REAGENT_CHECK) || (organ_flags & ORGAN_FAILING))
		return

	//felinids do not take damage from carpotoxin!
	if(istype(chem, /datum/reagent/toxin/carpotoxin))
		var/datum/reagent/toxin/carpotoxin/fish = chem
		fish.toxpwr = 0
		return

	var/static/list/choccy_chems = list(
		/datum/reagent/consumable/coco,
		/datum/reagent/consumable/hot_coco,
		/datum/reagent/consumable/italian_coco,
		/datum/reagent/consumable/choccyshake,
		/datum/reagent/consumable/chocolatepudding,
		/datum/reagent/consumable/milk/chocolate_milk,
	)
	if(!(locate(chem.type) in choccy_chems))
		return

	if(SPT_PROB(20, seconds_per_tick))
		organ_owner.adjust_disgust_effect(20)
	if(SPT_PROB(5, seconds_per_tick))
		organ_owner.visible_message(span_warning("[organ_owner] [pick("dry heaves!","coughs!","splutters!")]"))
	if(SPT_PROB(10, seconds_per_tick))
		var/sick_message = pick("Your insides revolt at the presence of lethal chocolate!", "You feel nyauseous.", "You're nya't feeling so good.","You feel like your insides are melting.","You feel illsies.")
		to_chat(organ_owner, span_userdanger(sick_message))
	if(SPT_PROB(35, seconds_per_tick))
		var/obj/item/organ/guts = pick(organ_owner.organs)
		guts.apply_organ_damage(15)

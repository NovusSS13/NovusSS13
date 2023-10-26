//CUM
/datum/reagent/consumable/cum
	name = "Semen"
	description = "Baby batter."
	taste_description = "something salty"
	data = list("viruses"=null,"blood_DNA"=null,"blood_type"=null,"resistances"=null,"trace_chem"=null,"mind"=null,"ckey"=null,"gender"=null,"real_name"=null,"cloneable"=null,"factions"=null,"quirks"=null)
	color = COLOR_CUM
	ph = 7.2
	/// Type of decal, to simplify the code
	var/decal_type = /obj/effect/decal/cleanable/cum

// FEED ME
/datum/reagent/consumable/cum/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	mytray.adjust_pestlevel(rand(2, 3))

/datum/reagent/consumable/cum/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message=TRUE, touch_protection=0)
	. = ..()
	if(data && data["viruses"])
		for(var/thing in data["viruses"])
			var/datum/disease/strain = thing

			if((strain.spread_flags & DISEASE_SPREAD_SPECIAL) || (strain.spread_flags & DISEASE_SPREAD_NON_CONTAGIOUS))
				continue

			if(methods & (INJECT|INGEST|PATCH))
				exposed_mob.ForceContractDisease(strain)
			else if((methods & (TOUCH|VAPOR)) && (strain.spread_flags & DISEASE_SPREAD_CONTACT_FLUIDS))
				exposed_mob.ContactContractDisease(strain)

/datum/reagent/consumable/cum/on_new(list/data)
	. = ..()
	if(istype(data))
		SetViruses(src, data)

/datum/reagent/consumable/cum/on_merge(list/mix_data)
	if(data && mix_data)
		if(data["blood_DNA"] != mix_data["blood_DNA"])
			data["cloneable"] = 0 //On mix, consider the genetic sampling unviable for pod cloning if the DNA sample doesn't match.
		if(data["viruses"] || mix_data["viruses"])
			var/list/mix1 = data["viruses"]
			var/list/mix2 = mix_data["viruses"]

			// Stop issues with the list changing during mixing.
			var/list/to_mix = list()

			for(var/datum/disease/advance/AD in mix1)
				to_mix += AD
			for(var/datum/disease/advance/AD in mix2)
				to_mix += AD

			var/datum/disease/advance/AD = Advance_Mix(to_mix)
			if(AD)
				var/list/preserve = list(AD)
				for(var/D in data["viruses"])
					if(!istype(D, /datum/disease/advance))
						preserve += D
				data["viruses"] = preserve
	return 1

/datum/reagent/consumable/cum/proc/get_diseases()
	. = list()
	if(data && data["viruses"])
		for(var/thing in data["viruses"])
			var/datum/disease/D = thing
			. += D

/datum/reagent/consumable/cum/expose_turf(turf/exposed_turf, reac_volume)//splash the blood all over the place
	. = ..()
	if(!istype(exposed_turf))
		return
	if(reac_volume < 3)
		return

	var/obj/effect/decal/cleanable/cummies = locate(decal_type) in exposed_turf //find some cummies here
	if(!cummies)
		cummies = new decal_type(exposed_turf, data["viruses"])
	else if(LAZYLEN(data["viruses"]))
		var/list/viri_to_add = list()
		for(var/datum/disease/virus in data["viruses"])
			if(virus.spread_flags & DISEASE_SPREAD_CONTACT_FLUIDS)
				viri_to_add += virus
		if(LAZYLEN(viri_to_add))
			cummies.AddComponent(/datum/component/infective, viri_to_add)
	if(data["blood_DNA"])
		cummies.add_blood_DNA(list(data["blood_DNA"] = data["blood_type"]))

//FEMCUM SUBTYPE
/datum/reagent/consumable/cum/femcum
	name = "Squirt"
	description = "I can't believe it's not urine!"
	taste_description = "something slightly sweet"
	color = COLOR_FEMCUM
	decal_type = /obj/effect/decal/cleanable/cum/femcum

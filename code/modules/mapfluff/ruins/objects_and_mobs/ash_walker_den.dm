#define ASHWALKER_SPAWN_THRESHOLD 2
//The ash walker den consumes corpses or unconscious mobs to create ash walker eggs. For more info on those, check ghost_role_spawners.dm
/obj/structure/lavaland/ashwalker
	name = "necropolis tendril nest"
	desc = "A vile tendril of corruption. It's surrounded by a nest of rapidly growing eggs..."
	icon = 'icons/mob/simple/lavaland/nest.dmi'
	icon_state = "ash_walker_nest"

	move_resist=INFINITY // just killing it tears a massive hole in the ground, let's not move it
	anchored = TRUE
	density = TRUE

	resistance_flags = FIRE_PROOF | LAVA_PROOF
	max_integrity = 200


	var/faction = list(FACTION_ASHWALKER)
	var/meat_counter = 6
	var/datum/team/ashwalkers/ashies
	var/datum/linked_objective

/obj/structure/lavaland/ashwalker/Initialize(mapload)
	.=..()
	ashies = new /datum/team/ashwalkers()
	var/datum/objective/protect_object/objective = new
	objective.set_target(src)
	objective.team = ashies
	linked_objective = objective
	ashies.objectives += objective
	START_PROCESSING(SSprocessing, src)

/obj/structure/lavaland/ashwalker/Destroy()
	ashies = null
	linked_objective = null
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/structure/lavaland/ashwalker/deconstruct(disassembled)
	var/core_to_drop = pick(subtypesof(/obj/item/assembly/signaler/anomaly))
	new core_to_drop (get_step(loc, pick(GLOB.alldirs)))
	new /obj/effect/collapse(loc)
	return ..()

/obj/structure/lavaland/ashwalker/process()
	consume()
	spawn_mob()

/obj/structure/lavaland/ashwalker/proc/consume()
	for(var/mob/living/sacrifice in view(src, 1)) //Only for corpse right next to/on same tile
		if(!sacrifice.stat)
			continue

		for(var/obj/item/wielded in sacrifice)
			if(!sacrifice.dropItemToGround(wielded))
				qdel(wielded)

		if(issilicon(sacrifice)) //no advantage to sacrificing borgs...
			sacrifice.investigate_log("has been gibbed by the necropolis tendril.", INVESTIGATE_DEATHS)
			visible_message(span_notice("Serrated tendrils eagerly pull [sacrifice] apart, but find nothing of interest."))
			return

		if(sacrifice.mind?.has_antag_datum(/datum/antagonist/ashwalker) && (sacrifice.key || sacrifice.get_ghost(FALSE, TRUE))) //special interactions for dead lava lizards with ghosts attached
			visible_message(span_warning("Serrated tendrils carefully pull [sacrifice] to [src], absorbing the body and creating it anew."))
			var/datum/mind/deadmind
			if(sacrifice.key)
				deadmind = sacrifice
			else
				deadmind = sacrifice.get_ghost(FALSE, TRUE)

			to_chat(deadmind, "Your body has been returned to the nest. You are being remade anew, and will awaken shortly. </br><b>Your memories will remain intact in your new body, as your soul is being salvaged</b>")
			SEND_SOUND(deadmind, sound('sound/magic/enter_blood.ogg', volume=100))
			addtimer(CALLBACK(src, PROC_REF(remake_walker), sacrifice.mind, sacrifice.real_name), 20 SECONDS)
			new /obj/effect/gibspawner/generic(get_turf(sacrifice))
			qdel(sacrifice)
			return

		var/added_meat = 1
		if(ismegafauna(sacrifice))
			added_meat = 20

		meat_counter += added_meat
		visible_message(span_warning("Serrated tendrils eagerly pull [sacrifice] to [src], tearing the body apart as its blood seeps over the eggs."))
		playsound(get_turf(src),'sound/magic/demon_consume.ogg', 100, TRUE)

		var/mob/living/deliverymob = get_mob_by_key(sacrifice.fingerprintslast) //mob of said key
		if(deliverymob)
			SEND_SIGNAL(deliverymob, COMSIG_ON_SACRIFICE, src, added_meat)

		sacrifice.investigate_log("has been gibbed by the necropolis tendril.", INVESTIGATE_DEATHS)
		sacrifice.gib()
		atom_integrity = min(atom_integrity + (max_integrity * 0.05 * added_meat), max_integrity)//restores 5% hp of tendril
		for(var/mob/living/observer in view(src, 5))
			if(observer.mind?.has_antag_datum(/datum/antagonist/ashwalker))
				observer.add_mood_event("oogabooga", /datum/mood_event/sacrifice_good)
			else
				observer.add_mood_event("oogabooga", /datum/mood_event/sacrifice_bad)

		ashies.sacrifices_made++

/obj/structure/lavaland/ashwalker/proc/remake_walker(datum/mind/oldmind, oldname)
	var/mob/living/carbon/human/M = new /mob/living/carbon/human(get_step(loc, pick(GLOB.alldirs)))
	M.set_species(/datum/species/lizard/ashwalker)
	M.real_name = oldname
	M.underwear = "Nude"
	M.update_body()
	M.remove_language(/datum/language/common)
	oldmind.transfer_to(M)
	M.mind.grab_ghost()
	to_chat(M, "<b>You have been pulled back from beyond the grave, with a new body and renewed purpose. Glory to the Necropolis!</b>")
	playsound(get_turf(M),'sound/magic/exit_blood.ogg', 100, TRUE)

/obj/structure/lavaland/ashwalker/proc/spawn_mob()
	if(meat_counter >= ASHWALKER_SPAWN_THRESHOLD)
		new /obj/effect/mob_spawn/ghost_role/human/ashwalker(get_step(loc, pick(GLOB.alldirs)), ashies)
		visible_message(span_danger("One of the eggs swells to an unnatural size and tumbles free. It's ready to hatch!"))
		meat_counter -= ASHWALKER_SPAWN_THRESHOLD
		ashies.eggs_created++

/obj/structure/lavaland/ashwalker_fake
	name = "necropolis tendril nest"
	desc = "A vile tendril of corruption. It's surrounded by a nest of rapidly growing eggs..."
	icon = 'icons/mob/simple/lavaland/nest.dmi'
	icon_state = "ash_walker_nest"
	move_resist = INFINITY
	anchored = TRUE
	resistance_flags = FIRE_PROOF | LAVA_PROOF
	max_integrity = 200

#undef ASHWALKER_SPAWN_THRESHOLD

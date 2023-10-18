//very sex
/obj/item/organ/genital
	name = "genital"
	desc = "A reproductive organ which is completely invalid and which you should not be seeing. Make a bug report or bother the cooders."

	visual = TRUE

	/// Whether or not we can coom
	var/can_climax = TRUE

	/// The organ slot we actually provide our fluid to - If null, fill ourselves
	var/fluid_receiving_slot
	/// If we produce any reagent, set it here
	var/fluid_reagent
	/// The rate we produce fluids at, per second, when we have an owner
	var/fluid_production_rate = 0.2 //almost 4 minutes to fill up with coom
	/// Amount of fluid we expel on orgasm
	var/fluid_amount_orgasm = 15
	/// The splatter we create if we don't want to create a fluid flood
	var/splatter_type

/obj/item/organ/genital/Initialize(mapload)
	. = ..()
	if(fluid_reagent && fluid_production_rate)
		if(!reagents)
			create_reagents(reagent_vol, REAGENT_HOLDER_ALIVE)
		else
			reagents.flags |= REAGENT_HOLDER_ALIVE

/obj/item/organ/genital/update_icon_state()
	. = ..()
	var/datum/bodypart_overlay/mutant/genital/overlay = bodypart_overlay
	color = overlay.draw_color
	var/datum/sprite_accessory/genital/genital_accessory = overlay.sprite_datum
	icon_state = "[genital_accessory.icon_state]_[overlay.genital_size][(overlay.uses_skintone && genital_accessory.supports_skintones) ? "_s" : ""]"

/obj/item/organ/genital/on_remove(mob/living/carbon/organ_owner, special)
	. = ..()
	var/datum/bodypart_overlay/mutant/genital/genital_overlay = bodypart_overlay
	//reset overlay to default visibility and arousal when removed
	if(istype(genital_overlay))
		genital_overlay.arousal_state = 0
		genital_overlay.genital_visibility = GENITAL_VISIBILITY_CLOTHING
	update_appearance()

/obj/item/organ/genital/on_life(seconds_per_tick, times_fired)
	. = ..()
	if((organ_flags & ORGAN_FAILING) || !reagents || !fluid_reagent || !fluid_production_rate)
		return
	handle_coom(seconds_per_tick, times_fired)

/obj/item/organ/genital/proc/set_genital_size(value)
	return //handled by subtypes

/obj/item/organ/genital/proc/get_genital_examine()
	return "very buggy genital" //handled by subtypes

/// Coom regeneration
/obj/item/organ/genital/proc/handle_coom(delta_time, times_fired)
	var/obj/item/organ/genital/fluid_receiver
	if(fluid_receiving_slot)
		fluid_receiver = owner.get_organ_slot(fluid_receiving_slot)
	if(fluid_production_rate && (reagents?.total_volume < reagents?.maximum_volume))
		reagents.add_reagent(fluid_reagent, fluid_production_rate * delta_time, data = owner.get_blood_dna_list())
	if(fluid_receiver)
		reagents.trans_id_to(fluid_receiver, fluid_reagent, fluid_production_rate, TRUE)
	return TRUE

/// Handle cooming
/obj/item/organ/genital/proc/handle_climax(atom/target, methods = INGEST, spill = TRUE)
	if(!can_climax || (organ_flags & ORGAN_FAILING) || !fluid_reagent || !fluid_amount_orgasm)
		return FALSE
	var/volume = fluid_amount_orgasm
	var/datum/reagents/coom_holder = new(1000)
	reagents.trans_id_to(coom_holder, fluid_reagent, volume, preserve_data = TRUE)
	var/turf/target_turf = isturf(target) ? target : get_turf(target)
	var/spilled_milk = 0
	if(target == target_turf)
		spilled_milk = 1
	else if(spill)
		spilled_milk = 0.5
	if(spilled_milk)
		coom_holder.expose(target_turf, TOUCH)
		if(!splatter_type)
			target_turf.add_liquid_from_reagents(coom_holder)
		else
			var/atom/movable/cummy_decal = locate(splatter_type) in target_turf
			if(!cummy_decal)
				cummy_decal = new splatter_type(target)
				if(!cummy_decal.reagents)
					cummy_decal.create_reagents(100)
				cummy_decal.reagents.remove_all(1000)
			coom_holder.trans_to(cummy_decal, coom_holder.total_volume, methods = TOUCH, multiplier = spilled_milk)
	if(spilled_milk < 1)
		if(!target.reagents)
			coom_holder.expose(target, methods)
		else
			coom_holder.trans_to(target, coom_holder.total_volume, methods = methods)
	qdel(coom_holder)
	return TRUE

/datum/bodypart_overlay/mutant/genital
	color_source = ORGAN_COLOR_DNA
	/// Size of the organ, used for building the icon state
	var/genital_size = 1
	/// Whether or not the overlay should use skintones for coloring
	var/uses_skintone = FALSE
	/// Basically determines visibility behavior for the overlay, generally can be changed by the user
	var/genital_visibility = GENITAL_VISIBILITY_CLOTHING
	/// Arousal state, used for building the icon state
	var/arousal_state = 0
	/// Arousal options that can be selected by the user
	var/list/arousal_options

/datum/bodypart_overlay/mutant/genital/can_draw_on_body(obj/item/bodypart/ownerlimb, mob/living/carbon/human/owner)
	switch(genital_visibility)
		if(GENITAL_VISIBILITY_NEVER)
			return FALSE //duh
		if(GENITAL_VISIBILITY_ALWAYS)
			return TRUE //duher
	return TRUE // GENITAL_VISIBILITY_CLOTHING is handled by subtypes

/datum/bodypart_overlay/mutant/genital/inherit_color(obj/item/bodypart/ownerlimb, force = FALSE)
	. = ..()
	if(!.)
		return
	//skintone handling, a bit silly but i don't really want to change the color source for... reasons
	if(uses_skintone && (color_source == ORGAN_COLOR_DNA))
		draw_color = ownerlimb.draw_color


/obj/item/organ/genital/penis
	name = "penis"
	desc = "Circumcision gone too far."
	icon = 'icons/obj/medical/organs/genitals/penis.dmi'
	icon_state = "human_2_s"

	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_PENIS

	dna_block = DNA_PENIS_BLOCK
	bodypart_overlay = /datum/bodypart_overlay/mutant/genital/penis

	fluid_reagent = /datum/reagent/consumable/cum
	fluid_production_rate = 0
	splatter_type = /obj/effect/decal/cleanable/cum

/obj/item/organ/genital/penis/mutate_features(list/features, mob/living/carbon/human/human)
	. = ..()
	if(!.)
		return
	var/size = features["penis_size"]
	if(size)
		set_genital_size(size)

/obj/item/organ/genital/penis/imprint_dna(mob/living/carbon/receiver, obj/item/bodypart/owner_limb)
	. = ..()
	set_genital_size(receiver.dna.features["penis_size"] || 2)

/obj/item/organ/genital/penis/set_genital_size(value)
	var/datum/bodypart_overlay/mutant/genital/overlay = bodypart_overlay

	value = clamp(text2num(value), 1, 4)
	overlay.genital_size = value

/obj/item/organ/genital/penis/get_genital_examine()
	var/datum/bodypart_overlay/mutant/genital/overlay = bodypart_overlay

	var/size = lowertext(GLOB.penis_size_names["[overlay.genital_size]"])
	var/shape = "[overlay.arousal_state ? "erect" : "flaccid"] [lowertext(overlay.sprite_datum.name)]"
	//the modulo is because GLOB.penis_size_names conveniently has sizes arranged in a way that lets us do this
	return "[!(overlay.genital_size % 2) ? "an" : "a"] [size], [shape] penis"

/datum/bodypart_overlay/mutant/genital/penis
	layers = EXTERNAL_FRONT|EXTERNAL_BEHIND
	feature_key = "penis"
	feature_color_key = "penis_color"
	arousal_options = list("Not aroused" = 0, "Aroused" = 1)

/datum/bodypart_overlay/mutant/genital/penis/can_draw_on_body(obj/item/bodypart/ownerlimb, mob/living/carbon/human/owner)
	. = ..()
	if(!.)
		return
	if(genital_visibility == GENITAL_VISIBILITY_CLOTHING)
		if(owner.get_all_covered_flags() & GROIN)
			return FALSE
		//this is fucked man
		if(owner.underwear && (owner.underwear != SPRITE_ACCESSORY_NONE))
			return FALSE

/datum/bodypart_overlay/mutant/genital/penis/get_base_icon_state()
	var/datum/sprite_accessory/genital/genital_accessory = sprite_datum
	return "[genital_accessory.icon_state]_[genital_size]_[arousal_state][(uses_skintone && genital_accessory.supports_skintones) ? "_s" : ""]"

/datum/bodypart_overlay/mutant/genital/penis/get_global_feature_list()
	return GLOB.penis_list


/obj/item/organ/genital/testicles
	name = "testicles"
	desc = "Some balls are held for charity, and some for fancy dress. \
			But when they're held for pleasure, they're the balls that I like best."
	icon = 'icons/obj/medical/organs/genitals/testicles.dmi'
	icon_state = "pair_2_s"

	dna_block = DNA_TESTICLES_BLOCK
	bodypart_overlay = /datum/bodypart_overlay/mutant/genital/testicles

	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_TESTICLES

	can_climax = FALSE

	fluid_receiving_slot = ORGAN_SLOT_PENIS
	fluid_reagent = /datum/reagent/consumable/cum
	splatter_type = /obj/effect/decal/cleanable/cum

/obj/item/organ/genital/testicles/mutate_features(list/features, mob/living/carbon/human/human)
	. = ..()
	if(!.)
		return
	var/size = features["testicles_size"]
	if(size)
		set_genital_size(size)

/obj/item/organ/genital/testicles/imprint_dna(mob/living/carbon/receiver, obj/item/bodypart/owner_limb)
	. = ..()
	set_genital_size(receiver.dna.features["testicles_size"] || 2)

/obj/item/organ/genital/testicles/get_genital_examine()
	var/datum/bodypart_overlay/mutant/genital/overlay = bodypart_overlay

	//until we have more testicles, this is enough
	return "a pair of [lowertext(GLOB.testicles_size_names["[overlay.genital_size]"])] testicles"

/datum/bodypart_overlay/mutant/genital/testicles
	layers = EXTERNAL_BEHIND | EXTERNAL_ADJACENT
	feature_key = "testicles"
	feature_color_key = "testicles_color"

/datum/bodypart_overlay/mutant/genital/testicles/get_base_icon_state()
	var/datum/sprite_accessory/genital/genital_accessory = sprite_datum
	return "[genital_accessory.icon_state]_[genital_size][(uses_skintone && genital_accessory.supports_skintones) ? "_s" : ""]"

/datum/bodypart_overlay/mutant/genital/testicles/get_global_feature_list()
	return GLOB.testicles_list

/datum/bodypart_overlay/mutant/genital/testicles/can_draw_on_body(obj/item/bodypart/ownerlimb, mob/living/carbon/human/owner)
	. = ..()
	if(!.)
		return
	if(genital_visibility == GENITAL_VISIBILITY_CLOTHING)
		if(owner.get_all_covered_flags() & GROIN)
			return FALSE
		//this is fucked man
		if(owner.underwear && (owner.underwear != SPRITE_ACCESSORY_NONE))
			return FALSE


/obj/item/organ/genital/vagina
	name = "vagina"
	desc = "A pussy. Just like you!"
	icon = 'icons/obj/medical/organs/genitals/vagina.dmi'
	icon_state = "vagina_s"

	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_VAGINA

	dna_block = DNA_VAGINA_BLOCK
	bodypart_overlay = /datum/bodypart_overlay/mutant/genital/vagina

	fluid_reagent = /datum/reagent/consumable/cum/femcum
	splatter_type = /obj/effect/decal/cleanable/cum/femcum

/obj/item/organ/genital/vagina/update_icon_state()
	. = ..()
	var/datum/bodypart_overlay/mutant/genital/overlay = bodypart_overlay
	var/datum/sprite_accessory/genital/genital_accessory = overlay.sprite_datum
	icon_state = "vagina[(overlay.uses_skintone && genital_accessory.supports_skintones) ? "_s" : ""]"

/obj/item/organ/genital/vagina/get_genital_examine()
	var/datum/bodypart_overlay/mutant/genital/overlay = bodypart_overlay
	var/datum/sprite_accessory/genital/vagina/accessory = overlay.sprite_datum

	return "a [overlay.arousal_state ? "moist" : "dry"] [accessory.examine_name_override || "[lowertext(overlay.sprite_datum.name)] [name]"]"


/datum/bodypart_overlay/mutant/genital/vagina
	layers = EXTERNAL_FRONT
	feature_key = "vagina"
	feature_color_key = "vagina_color"
	arousal_options = list("Not aroused" = 0, "Aroused" = 1)

/datum/bodypart_overlay/mutant/genital/vagina/get_base_icon_state()
	var/datum/sprite_accessory/genital/genital_accessory = sprite_datum
	return "[genital_accessory.icon_state]_[arousal_state][(uses_skintone && genital_accessory.supports_skintones) ? "_s" : ""]"

/datum/bodypart_overlay/mutant/genital/vagina/get_global_feature_list()
	return GLOB.vagina_list

/datum/bodypart_overlay/mutant/genital/vagina/can_draw_on_body(obj/item/bodypart/ownerlimb, mob/living/carbon/human/owner)
	. = ..()
	if(!.)
		return
	if(genital_visibility == GENITAL_VISIBILITY_CLOTHING)
		if(owner.get_all_covered_flags() & GROIN)
			return FALSE
		//this is fucked man
		if(owner.underwear && (owner.underwear != SPRITE_ACCESSORY_NONE))
			return FALSE


/obj/item/organ/genital/breasts
	name = "breasts"
	desc = "Does not belong on reptiles."
	icon = 'icons/obj/medical/organs/genitals/breasts.dmi'
	icon_state = "breasts_pair_c_s"

	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_BREASTS

	dna_block = DNA_BREASTS_BLOCK
	bodypart_overlay = /datum/bodypart_overlay/mutant/genital/breasts

	can_climax = FALSE

	fluid_reagent = /datum/reagent/consumable/milk

/obj/item/organ/genital/breasts/mutate_features(list/features, mob/living/carbon/human/human)
	. = ..()
	if(!.)
		return
	var/size = features["breasts_size"]
	if(size)
		set_genital_size(size)

/obj/item/organ/genital/breasts/set_genital_size(value)
	var/datum/sprite_accessory/genital/breasts/sprite_accessory = bodypart_overlay.sprite_datum
	value = clamp(text2num(value), 1, sprite_accessory.max_size)

	var/datum/bodypart_overlay/mutant/genital/overlay = bodypart_overlay
	overlay.genital_size = value

/obj/item/organ/genital/breasts/get_genital_examine()
	var/datum/bodypart_overlay/mutant/genital/overlay = bodypart_overlay
	var/datum/sprite_accessory/genital/breasts/accessory = overlay.sprite_datum

	return "[accessory.examine_name_override] of [overlay.arousal_state ? "perky " : ""]breasts"

/obj/item/organ/genital/breasts/imprint_dna(mob/living/carbon/receiver, obj/item/bodypart/owner_limb)
	. = ..()
	set_genital_size(receiver.dna.features["breasts_size"] || 2)

/datum/bodypart_overlay/mutant/genital/breasts
	layers = EXTERNAL_FRONT|EXTERNAL_BEHIND
	feature_key = "breasts"
	feature_color_key = "breasts_color"

/datum/bodypart_overlay/mutant/genital/breasts/get_base_icon_state()
	var/datum/sprite_accessory/genital/genital_accessory = sprite_datum
	return "[genital_accessory.icon_state]_[genital_size][(uses_skintone && genital_accessory.supports_skintones) ? "_s" : ""]"

/datum/bodypart_overlay/mutant/genital/breasts/get_global_feature_list()
	return GLOB.breasts_list

/datum/bodypart_overlay/mutant/genital/breasts/can_draw_on_body(obj/item/bodypart/ownerlimb, mob/living/carbon/human/owner)
	. = ..()
	if(!.)
		return
	if(genital_visibility == GENITAL_VISIBILITY_CLOTHING)
		if(owner.get_all_covered_flags() & CHEST)
			return FALSE
		//this is fucked man
		if(owner.undershirt && (owner.undershirt != SPRITE_ACCESSORY_NONE))
			return FALSE

/obj/item/organ/genital/anus
	name = "anus"
	desc = "Space asshole. In a truck, flying off a ridge. Space asshole. Smashing through a bridge."
	icon = 'icons/obj/medical/organs/genitals/anus.dmi'
	icon_state = "anus"

	dna_block = DNA_ANUS_BLOCK
	bodypart_overlay = /datum/bodypart_overlay/mutant/genital/anus

	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_ANUS

	can_climax = FALSE

/obj/item/organ/genital/anus/get_genital_examine()
	var/datum/bodypart_overlay/mutant/genital/overlay = bodypart_overlay
	var/datum/sprite_accessory/genital/anus/accessory = overlay.sprite_datum

	return "a [accessory.examine_name_override || "[lowertext(overlay.sprite_datum.name)] [name]"]"

/datum/bodypart_overlay/mutant/genital/anus
	// anuses are not meant to be visible, so no layers - this overlay basically only exists for the sake of calling can_draw_on_body()
	layers = NONE
	feature_key = "anus"

/datum/bodypart_overlay/mutant/genital/anus/get_global_feature_list()
	return GLOB.anus_list

/datum/bodypart_overlay/mutant/genital/anus/can_draw_on_body(obj/item/bodypart/ownerlimb, mob/living/carbon/human/owner)
	. = ..()
	if(!.)
		return
	if(genital_visibility == GENITAL_VISIBILITY_CLOTHING)
		if(owner.get_all_covered_flags() & GROIN)
			return FALSE
		//this is fucked man
		if(owner.underwear && (owner.underwear != SPRITE_ACCESSORY_NONE))
			return FALSE

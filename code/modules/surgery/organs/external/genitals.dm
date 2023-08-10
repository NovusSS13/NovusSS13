//very sex
/obj/item/organ/genital
	name = "genital"
	desc = "A reproductive organ which is completely invalid and which you should not be seeing. Make a bug report or bother the cooders."

	bodypart_overlay = /datum/bodypart_overlay/mutant/genital

	visual = TRUE
	process_life = FALSE
	process_death = FALSE

/obj/item/organ/genital/update_icon_state()
	. = ..()
	var/datum/bodypart_overlay/mutant/genital/overlay = bodypart_overlay
	color = overlay.draw_color
	icon_state = "[overlay.sprite_datum.icon_state]_[overlay.genital_size][overlay.uses_skintone ? "_s" : ""]"

/obj/item/organ/genital/on_remove(mob/living/carbon/organ_owner, special)
	. = ..()
	var/datum/bodypart_overlay/mutant/genital/genital_overlay = bodypart_overlay
	//reset overlay to default visibility and arousal when removed
	if(istype(genital_overlay))
		genital_overlay.arousal_state = 0
		genital_overlay.genital_visibility = GENITAL_VISIBILITY_CLOTHING
	update_appearance()

/obj/item/organ/genital/proc/set_genital_size(value)
	return //handled by subtypes

/obj/item/organ/genital/proc/get_genital_examine()
	return "very buggy genital" //handled by subtypes


/datum/bodypart_overlay/mutant/genital
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

/datum/bodypart_overlay/mutant/genital/can_draw_on_bodypart(mob/living/carbon/human/human)
	switch(genital_visibility)
		if(GENITAL_VISIBILITY_NEVER)
			return FALSE //duh
		if(GENITAL_VISIBILITY_ALWAYS)
			return TRUE //duher
	return TRUE // GENITAL_VISIBILITY_CLOTHING is handled by subtypes


/obj/item/organ/genital/penis
	name = "penis"
	desc = "A male reproductive organ."
	icon = 'icons/obj/medical/organs/genitals/penis.dmi'

	dna_block = DNA_PENIS_BLOCK
	bodypart_overlay = /datum/bodypart_overlay/mutant/genital/penis
	preference = "feature_penis"

	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_PENIS

/obj/item/organ/genital/penis/mutate_feature(features, mob/living/carbon/human/human)
	. = ..()
	var/size = deconstruct_block(get_uni_feature_block(features, DNA_PENIS_SIZE_BLOCK), length(GLOB.penis_size_names))
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
	return "[overlay.genital_size % 2 ? "an" : "a"] [size], [shape] penis"

/datum/bodypart_overlay/mutant/genital/penis
	layers = EXTERNAL_FRONT|EXTERNAL_BEHIND
	feature_key = "penis"
	arousal_options = list("Not aroused" = 0, "Aroused" = 1)

/datum/bodypart_overlay/mutant/genital/penis/can_draw_on_bodypart(mob/living/carbon/human/human)
	. = ..()
	if(!.)
		return
	if(genital_visibility == GENITAL_VISIBILITY_CLOTHING)
		if(human.get_all_covered_flags() & GROIN)
			return FALSE
		//this is fucked man
		if(human.underwear && (human.underwear != "Nude"))
			return FALSE

/datum/bodypart_overlay/mutant/genital/penis/get_base_icon_state()
	return "[sprite_datum.icon_state]_[genital_size]_[arousal_state][uses_skintone ? "_s" : ""]"

/datum/bodypart_overlay/mutant/genital/penis/get_global_feature_list()
	return GLOB.penis_list


/obj/item/organ/genital/testicles
	name = "testicles"
	desc = "A male reproductive organ."
	icon = 'icons/obj/medical/organs/genitals/testicles.dmi'

	dna_block = DNA_TESTICLES_BLOCK
	bodypart_overlay = /datum/bodypart_overlay/mutant/genital/testicles
	preference = "feature_testicles"

	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_TESTICLES

/obj/item/organ/genital/testicles/get_genital_examine()
	var/datum/bodypart_overlay/mutant/genital/overlay = bodypart_overlay

	//until we have more testicles, this is enough
	return "a pair of [lowertext(GLOB.penis_size_names["[overlay.genital_size]"])] testicles"

/datum/bodypart_overlay/mutant/genital/testicles
	layers = EXTERNAL_ADJACENT|EXTERNAL_BEHIND
	feature_key = "testicles"

/datum/bodypart_overlay/mutant/genital/testicles/get_base_icon_state()
	return "[sprite_datum.icon_state][uses_skintone ? "_s" : ""]"

/datum/bodypart_overlay/mutant/genital/testicles/get_global_feature_list()
	return GLOB.testicles_list

/datum/bodypart_overlay/mutant/genital/testicles/can_draw_on_bodypart(mob/living/carbon/human/human)
	. = ..()
	if(!.)
		return
	if(genital_visibility == GENITAL_VISIBILITY_CLOTHING)
		if(human.get_all_covered_flags() & GROIN)
			return FALSE
		//this is fucked
		if(human.underwear && (human.underwear != "Nude"))
			return FALSE


/obj/item/organ/genital/vagina
	name = "vagina"
	desc = "A female reproductive organ."
	icon = 'icons/obj/medical/organs/genitals/vagina.dmi'

	dna_block = DNA_VAGINA_BLOCK
	bodypart_overlay = /datum/bodypart_overlay/mutant/genital/vagina
	preference = "feature_vagina"

	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_VAGINA

/obj/item/organ/genital/vagina/update_icon_state()
	. = ..()
	var/datum/bodypart_overlay/mutant/genital/overlay = bodypart_overlay
	icon_state = "vagina[overlay.uses_skintone ? "_s" : ""]"

/obj/item/organ/genital/vagina/get_genital_examine()
	var/datum/bodypart_overlay/mutant/genital/overlay = bodypart_overlay
	var/datum/sprite_accessory/vagina/accessory = overlay.sprite_datum

	return "a [overlay.arousal_state ? "moist" : "dry"] [accessory.examine_name_override || "[lowertext(overlay.sprite_datum.name)] [name]"]"


/datum/bodypart_overlay/mutant/genital/vagina
	layers = EXTERNAL_FRONT
	feature_key = "vagina"
	arousal_options = list("Not aroused" = 0, "Aroused" = 1)

/datum/bodypart_overlay/mutant/genital/vagina/get_base_icon_state()
	return "[sprite_datum.icon_state]_[arousal_state][uses_skintone ? "_s" : ""]"

/datum/bodypart_overlay/mutant/genital/vagina/get_global_feature_list()
	return GLOB.vagina_list

/datum/bodypart_overlay/mutant/genital/vagina/can_draw_on_bodypart(mob/living/carbon/human/human)
	. = ..()
	if(!.)
		return
	if(genital_visibility == GENITAL_VISIBILITY_CLOTHING)
		if(human.get_all_covered_flags() & GROIN)
			return FALSE
		//this is fucked
		if(human.underwear && (human.underwear != "Nude"))
			return FALSE


/obj/item/organ/genital/breasts
	name = "breasts"
	desc = "A female secondary sexual characteristic."

	dna_block = DNA_BREASTS_BLOCK
	bodypart_overlay = /datum/bodypart_overlay/mutant/genital/breasts
	preference = "feature_breasts"

	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_BREASTS

/obj/item/organ/genital/breasts/mutate_feature(features, mob/living/carbon/human/human)
	. = ..()
	var/size = deconstruct_block(get_uni_feature_block(features, DNA_BREASTS_SIZE_BLOCK), length(GLOB.breasts_size_names))
	if(size)
		set_genital_size(size)

/obj/item/organ/genital/breasts/set_genital_size(value)
	var/datum/sprite_accessory/breasts/sprite_accessory = bodypart_overlay.sprite_datum
	value = clamp(text2num(value), 1, sprite_accessory.max_size)

	var/datum/bodypart_overlay/mutant/genital/overlay = bodypart_overlay
	overlay.genital_size = value

/obj/item/organ/genital/breasts/get_genital_examine()
	var/datum/bodypart_overlay/mutant/genital/overlay = bodypart_overlay
	var/datum/sprite_accessory/breasts/accessory = overlay.sprite_datum

	return "[accessory.examine_name] of [overlay.arousal_state ? "perked up " : ""] breasts"


/obj/item/organ/genital/breasts/imprint_dna(mob/living/carbon/receiver, obj/item/bodypart/owner_limb)
	. = ..()
	set_genital_size(receiver.dna.features["breasts_size"] || 2)

/datum/bodypart_overlay/mutant/genital/breasts
	layers = EXTERNAL_FRONT|EXTERNAL_BEHIND
	feature_key = "breasts"

/datum/bodypart_overlay/mutant/genital/breasts/get_base_icon_state()
	return "[sprite_datum.icon_state]_[genital_size][uses_skintone ? "_s" : ""]"

/datum/bodypart_overlay/mutant/genital/breasts/get_global_feature_list()
	return GLOB.breasts_list

/datum/bodypart_overlay/mutant/genital/breasts/can_draw_on_bodypart(mob/living/carbon/human/human)
	. = ..()
	if(!.)
		return
	if(genital_visibility == GENITAL_VISIBILITY_CLOTHING)
		if(human.get_all_covered_flags() & CHEST)
			return FALSE
		//this is fucked
		if(human.undershirt && (human.undershirt != "Nude"))
			return FALSE

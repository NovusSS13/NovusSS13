/datum/preference/choiced/testicles
	savefile_key = "feature_testicles"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/genital/testicles

/datum/preference/choiced/testicles/init_possible_values()
	return assoc_to_keys_features(GLOB.testicles_list)

/datum/preference/choiced/testicles/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["testicles"] = value

/datum/preference/choiced/testicles/create_informed_default_value(datum/preferences/preferences)
	if(preferences.read_preference(/datum/preference/choiced/gender) != MALE)
		return SPRITE_ACCESSORY_NONE

	var/datum/sprite_accessory/genital/testicles/testicles = /datum/sprite_accessory/genital/testicles/pair
	return initial(testicles.name)


/datum/preference/toggle/testicles_uses_skintone
	savefile_key = "feature_testicles_skintone"
	savefile_identifier = PREFERENCE_CHARACTER
	priority = PREFERENCE_PRIORITY_BODYPARTS
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/genital/testicles

/datum/preference/toggle/testicles_uses_skintone/is_accessible(datum/preferences/preferences)
	return ..() && preferences.read_preference(/datum/preference/choiced/testicles) != SPRITE_ACCESSORY_NONE

/datum/preference/toggle/testicles_uses_skintone/create_informed_default_value(datum/preferences/preferences)
	var/species_type = preferences.read_preference(/datum/preference/choiced/species)
	var/datum/species/species = new species_type
	return (TRAIT_USES_SKINTONES in species.inherent_traits)

/datum/preference/toggle/testicles_uses_skintone/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/prefs)
	var/obj/item/organ/genital/testicles = target.get_organ_slot(ORGAN_SLOT_TESTICLES)
	if(isnull(testicles))
		return

	var/datum/bodypart_overlay/mutant/genital/overlay = testicles.bodypart_overlay
	overlay.uses_skintone = value
	overlay.color_source = value ? ORGAN_COLOR_INHERIT : ORGAN_COLOR_DNA

/datum/preference/tri_color/testicles
	savefile_key = "feature_testicles_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/genital/testicles

/datum/preference/tri_color/testicles/is_accessible(datum/preferences/preferences)
	return ..() && (preferences.read_preference(/datum/preference/choiced/testicles) != SPRITE_ACCESSORY_NONE) && !preferences.read_preference(/datum/preference/toggle/testicles_uses_skintone)

/datum/preference/tri_color/testicles/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["testicles_color"] = value

/datum/preference/choiced/mutant/testicles
	savefile_key = "feature_testicles"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/genital/testicles
	modified_feature = "testicles"
	supplemental_feature_key = "feature_testicles_color"

/datum/preference/choiced/mutant/testicles/init_possible_values()
	return assoc_to_keys_features(GLOB.testicles_list)

/datum/preference/tricolor/mutant/testicles
	savefile_key = "feature_testicles_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/genital/testicles
	modified_feature = "testicles_color"
	primary_feature_key = "feature_testicles"

/datum/preference/tricolor/mutant/testicles/is_accessible(datum/preferences/preferences)
	return ..() && preferences.read_preference(/datum/preference/choiced/mutant/testicles) != SPRITE_ACCESSORY_NONE

/datum/preference/tricolor/mutant/testicles/get_global_feature_list()
	return GLOB.testicles_list

/datum/preference/toggle/testicles_uses_skintone
	savefile_key = "feature_testicles_skintone"
	savefile_identifier = PREFERENCE_CHARACTER
	priority = PREFERENCE_PRIORITY_BODYPARTS
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_inherent_trait = TRAIT_USES_SKINTONES
	relevant_cosmetic_organ = /obj/item/organ/genital/testicles

/datum/preference/toggle/testicles_uses_skintone/is_accessible(datum/preferences/preferences)
	return ..() && preferences.read_preference(/datum/preference/choiced/mutant/testicles) != SPRITE_ACCESSORY_NONE

/datum/preference/toggle/testicles_uses_skintone/create_informed_default_value(datum/preferences/preferences)
	var/species_type = preferences.read_preference(/datum/preference/choiced/species)
	var/datum/species/species = new species_type
	return (TRAIT_USES_SKINTONES in species.inherent_traits)

/datum/preference/toggle/testicles_uses_skintone/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/prefs)
	var/obj/item/organ/genital/testicles = target.get_organ_slot(ORGAN_SLOT_TESTICLES)
	if(isnull(testicles) || !HAS_TRAIT_FROM(target, TRAIT_USES_SKINTONES, SPECIES_TRAIT))
		return

	var/datum/bodypart_overlay/mutant/genital/overlay = testicles.bodypart_overlay
	overlay.uses_skintone = value

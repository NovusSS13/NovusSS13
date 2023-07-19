/datum/preference/choiced/penis_shape
	savefile_key = "feature_penis_shape"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/genital/penis

/datum/preference/choiced/penis_shape/init_possible_values()
	return assoc_to_keys_features(GLOB.penis_list)

/datum/preference/choiced/penis_shape/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["penis"] = value

/datum/preference/choiced/penis_shape/create_informed_default_value(datum/preferences/preferences)
	if(preferences.read_preference(/datum/preference/choiced/body_type) != MALE)
		return SPRITE_ACCESSORY_NONE

	var/datum/sprite_accessory/penis/boring_human_penis = /datum/sprite_accessory/penis/human
	return initial(boring_human_penis.name)


/datum/preference/choiced/penis_size
	savefile_key = "feature_penis_size"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/genital/penis

/datum/preference/choiced/penis_size/init_possible_values()
	return assoc_to_keys(GLOB.penis_size_names)

/datum/preference/choiced/penis_size/compile_constant_data()
	var/list/data = ..()

	data[CHOICED_PREFERENCE_DISPLAY_NAMES] = GLOB.penis_size_names

	return data

/datum/preference/choiced/penis_size/is_accessible(datum/preferences/preferences)
	return ..() && preferences.read_preference(/datum/preference/choiced/penis_shape) != SPRITE_ACCESSORY_NONE

/datum/preference/choiced/penis_size/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["penis_size"] = value

/datum/preference/choiced/penis_size/create_default_value()
	return "2"


/datum/preference/toggle/penis_uses_skintone
	savefile_key = "feature_penis_skintone"
	savefile_identifier = PREFERENCE_CHARACTER
	priority = PREFERENCE_PRIORITY_BODYPARTS
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/genital/penis

/datum/preference/toggle/penis_uses_skintone/is_accessible(datum/preferences/preferences)
	return ..() && preferences.read_preference(/datum/preference/choiced/penis_shape) != SPRITE_ACCESSORY_NONE

/datum/preference/toggle/penis_uses_skintone/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/prefs)
	var/obj/item/organ/genital/penis = target.get_organ_slot(ORGAN_SLOT_PENIS)
	if(isnull(penis))
		return

	var/datum/bodypart_overlay/mutant/genital/overlay = penis.bodypart_overlay
	overlay.uses_skintone = value



/datum/preference/choiced/testicles_shape
	savefile_key = "feature_testicles_shape"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/genital/testicles

/datum/preference/choiced/testicles_shape/init_possible_values()
	return assoc_to_keys_features(GLOB.testicles_list)

/datum/preference/choiced/testicles_shape/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["testicles"] = value

/datum/preference/choiced/testicles_shape/create_informed_default_value(datum/preferences/preferences)
	if(preferences.read_preference(/datum/preference/choiced/body_type) != MALE)
		return SPRITE_ACCESSORY_NONE

	var/datum/sprite_accessory/testicles/testicles = /datum/sprite_accessory/testicles/pair
	return initial(testicles.name)


/datum/preference/toggle/testicles_uses_skintone
	savefile_key = "feature_testicles_skintone"
	savefile_identifier = PREFERENCE_CHARACTER
	priority = PREFERENCE_PRIORITY_BODYPARTS
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/genital/testicles

/datum/preference/toggle/testicles_uses_skintone/is_accessible(datum/preferences/preferences)
	return ..() && preferences.read_preference(/datum/preference/choiced/testicles_shape) != SPRITE_ACCESSORY_NONE

/datum/preference/toggle/testicles_uses_skintone/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/prefs)
	var/obj/item/organ/genital/testicles = target.get_organ_slot(ORGAN_SLOT_TESTICLES)
	if(isnull(testicles))
		return

	var/datum/bodypart_overlay/mutant/genital/overlay = testicles.bodypart_overlay
	overlay.uses_skintone = value



/datum/preference/choiced/vagina_shape
	savefile_key = "feature_vagina_shape"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/genital/vagina

/datum/preference/choiced/vagina_shape/init_possible_values()
	return assoc_to_keys_features(GLOB.vagina_list)

/datum/preference/choiced/vagina_shape/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["vagina"] = value

/datum/preference/choiced/vagina_shape/create_informed_default_value(datum/preferences/preferences)
	if(preferences.read_preference(/datum/preference/choiced/body_type) != FEMALE)
		return SPRITE_ACCESSORY_NONE

	var/datum/sprite_accessory/penis/boring_human_vagina = /datum/sprite_accessory/vagina/human
	return initial(boring_human_vagina.name)


/datum/preference/toggle/vagina_uses_skintone
	savefile_key = "feature_vagina_skintone"
	savefile_identifier = PREFERENCE_CHARACTER
	priority = PREFERENCE_PRIORITY_BODYPARTS
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/genital/vagina

/datum/preference/toggle/vagina_uses_skintone/is_accessible(datum/preferences/preferences)
	return ..() && preferences.read_preference(/datum/preference/choiced/vagina_shape) != SPRITE_ACCESSORY_NONE

/datum/preference/toggle/vagina_uses_skintone/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/prefs)
	var/obj/item/organ/genital/vagina = target.get_organ_slot(ORGAN_SLOT_VAGINA)
	if(isnull(vagina))
		return

	var/datum/bodypart_overlay/mutant/genital/overlay = vagina.bodypart_overlay
	overlay.uses_skintone = value


/datum/preference/choiced/breasts_shape
	savefile_key = "feature_breasts_shape"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/genital/breasts

/datum/preference/choiced/breasts_shape/init_possible_values()
	return assoc_to_keys_features(GLOB.breasts_list)

/datum/preference/choiced/breasts_shape/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["breasts"] = value

/datum/preference/choiced/breasts_shape/create_informed_default_value(datum/preferences/preferences)
	if(preferences.read_preference(/datum/preference/choiced/body_type) != FEMALE)
		return SPRITE_ACCESSORY_NONE

	var/datum/sprite_accessory/penis/boring_human_breasts = /datum/sprite_accessory/breasts/pair
	return initial(boring_human_breasts.name)


/datum/preference/choiced/breasts_size
	savefile_key = "feature_breasts_size"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/genital/breasts

/datum/preference/choiced/breasts_size/init_possible_values()
	return assoc_to_keys(GLOB.breasts_size_names)

/datum/preference/choiced/breasts_size/compile_constant_data()
	var/list/data = ..()

	data[CHOICED_PREFERENCE_DISPLAY_NAMES] = GLOB.breasts_size_names

	return data

/datum/preference/choiced/breasts_size/is_accessible(datum/preferences/preferences)
	return ..() && preferences.read_preference(/datum/preference/choiced/breasts_shape) != SPRITE_ACCESSORY_NONE

/datum/preference/choiced/breasts_size/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["breasts_size"] = value

/datum/preference/choiced/breasts_size/create_default_value()
	return "2"


/datum/preference/toggle/breasts_uses_skintone
	savefile_key = "feature_breasts_skintone"
	savefile_identifier = PREFERENCE_CHARACTER
	priority = PREFERENCE_PRIORITY_BODYPARTS
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/genital/breasts

/datum/preference/toggle/breasts_uses_skintone/is_accessible(datum/preferences/preferences)
	return ..() && preferences.read_preference(/datum/preference/choiced/breasts_shape) != SPRITE_ACCESSORY_NONE

/datum/preference/toggle/breasts_uses_skintone/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/prefs)
	var/obj/item/organ/genital/breasts = target.get_organ_slot(ORGAN_SLOT_BREASTS)
	if(isnull(breasts))
		return

	var/datum/bodypart_overlay/mutant/genital/overlay = breasts?.bodypart_overlay
	overlay.uses_skintone = value

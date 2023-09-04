/datum/preference/choiced/mutant/felinid_tail
	savefile_key = "feature_felinid_tail"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	can_randomize = FALSE
	relevant_cosmetic_organ = /obj/item/organ/tail/cat
	relevant_feature = "tail"

/datum/preference/choiced/mutant/felinid_tail/init_possible_values()
	return assoc_to_keys_features(GLOB.tails_list_human)

/datum/preference/choiced/mutant/felinid_tail/create_default_value()
	var/datum/sprite_accessory/tails/human/cat/tail = /datum/sprite_accessory/tails/human/cat
	return initial(tail.name)

/datum/preference/choiced/mutant/felinid_tail/compile_constant_data()
	var/list/data = ..()

	data[SUPPLEMENTAL_FEATURE_KEY] = "feature_felinid_tail_color"

	return data

/datum/preference/tri_color/mutant/felinid_tail
	savefile_key = "feature_felinid_tail_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/tail/lizard
	relevant_feature = "tail_color"

/datum/preference/choiced/mutant/felinid_ears
	savefile_key = "feature_felinid_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	can_randomize = FALSE
	relevant_cosmetic_organ = /obj/item/organ/ears/cat
	relevant_feature = "ears"

/datum/preference/choiced/mutant/felinid_ears/init_possible_values()
	return assoc_to_keys_features(GLOB.ears_list)

/datum/preference/choiced/mutant/felinid_ears/create_default_value()
	var/datum/sprite_accessory/ears/cat/ears = /datum/sprite_accessory/ears/cat
	return initial(ears.name)

/datum/preference/choiced/mutant/felinid_ears/compile_constant_data()
	var/list/data = ..()

	data[SUPPLEMENTAL_FEATURE_KEY] = "feature_felinid_ears_color"

	return data

/datum/preference/tri_color/mutant/felinid_ears
	savefile_key = "feature_felinid_ears_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_cosmetic_organ = /obj/item/organ/ears/cat
	relevant_feature = "ears_color"

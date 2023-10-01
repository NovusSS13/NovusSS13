/datum/preference/text/custom_say_mod
	priority = PREFERENCE_PRIORITY_BODYPARTS // needs to be done after organs are created!
	category = PREFERENCE_CATEGORY_BACKGROUND
	savefile_key = "custom_say_mod"
	savefile_identifier = PREFERENCE_CHARACTER

	maximum_value_length = 16 // why TF would you need a speech verb longer than this

/datum/preference/text/custom_say_mod/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	if(!value)
		return
	var/obj/item/organ/tongue/tongue = target.get_organ_slot(ORGAN_SLOT_TONGUE)
	if(tongue)
		tongue.say_mod = value

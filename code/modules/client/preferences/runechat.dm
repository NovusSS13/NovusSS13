/datum/preference/toggle/enable_runechat
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "chat_on_map"
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/enable_runechat_non_mobs
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "see_chat_non_mob"
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/toggle/see_rc_emotes
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "see_rc_emotes"
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/numeric/max_chat_length
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "max_chat_length"
	savefile_identifier = PREFERENCE_PLAYER

	minimum = 1
	maximum = CHAT_MESSAGE_MAX_LENGTH

/datum/preference/numeric/max_chat_length/create_default_value(datum/preferences/preferences)
	return CHAT_MESSAGE_MAX_LENGTH

/datum/preference/toggle/random_chat_color
	priority = PREFERENCE_PRIORITY_NAME_MODIFICATIONS //does not actually matter but w/e
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_key = "random_chat_color"
	savefile_identifier = PREFERENCE_CHARACTER
	default_value = TRUE

//by it's very nature, when this is true that means it's random...
/datum/preference/toggle/random_chat_color/create_random_value(datum/preferences/preferences)
	return TRUE

//not needed of course
/datum/preference/toggle/random_chat_color/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/prefs)
	return

/datum/preference/color/chat_color
	priority = PREFERENCE_PRIORITY_NAME_MODIFICATIONS
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_key = "chat_color"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/color/chat_color/is_accessible(datum/preferences/preferences)
	return ..() && preferences && !preferences.read_preference(/datum/preference/toggle/random_chat_color)

/datum/preference/color/chat_color/create_default_value(datum/preferences/preferences)
	. = ..()
	var/say_my_name = preferences?.read_preference(/datum/preference/name/real_name)
	if(say_my_name)
		return colorize_string(say_my_name)
	return "#[random_color()]"

/datum/preference/color/chat_color/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/prefs)
	if(!is_accessible(prefs) || isdummy(target))
		return
	if(isnull(GLOB.protected_chat_colors[target.real_name]))
		GLOB.chat_colors[target.real_name] = value
	target.update_chat_color(forced = TRUE)

/// The color admins will speak in for OOC.
/datum/preference/color/ooc_color
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "ooccolor"
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/color/ooc_color/create_default_value(datum/preferences/preferences)
	return "#c43b23"

/datum/preference/color/ooc_color/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	return is_admin(preferences.parent) || preferences.unlock_content

/datum/preference/toggle/mute_looc
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "mute_looc"
	savefile_identifier = PREFERENCE_PLAYER
	default_value = FALSE

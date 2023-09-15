/// For choiced preferences, this key will be used to set display names in constant data.
#define CHOICED_PREFERENCE_DISPLAY_NAMES "display_names"

/// For main feature preferences, this key refers to a feature considered supplemental.
/// For instance, hair color being supplemental to hair.
#define SUPPLEMENTAL_FEATURE_KEY "supplemental_feature"

/// An assoc list list of types to instantiated `/datum/preference` instances
GLOBAL_LIST_INIT(preference_entries, init_preference_entries())

/// An assoc list of preference entries by their `savefile_key`
GLOBAL_LIST_INIT(preference_entries_by_key, init_preference_entries_by_key())

/proc/init_preference_entries()
	var/list/output = list()
	for (var/datum/preference/preference_type as anything in subtypesof(/datum/preference))
		if (initial(preference_type.abstract_type) == preference_type)
			continue
		output[preference_type] = new preference_type
	return output

/proc/init_preference_entries_by_key()
	var/list/output = list()
	for (var/datum/preference/preference_type as anything in subtypesof(/datum/preference))
		if (initial(preference_type.abstract_type) == preference_type)
			continue
		output[initial(preference_type.savefile_key)] = GLOB.preference_entries[preference_type]
	return output

/// Returns a flat list of preferences in order of their priority
/proc/get_preferences_in_priority_order()
	var/list/preferences[MAX_PREFERENCE_PRIORITY]

	for (var/preference_type in GLOB.preference_entries)
		var/datum/preference/preference = GLOB.preference_entries[preference_type]
		LAZYADD(preferences[preference.priority], preference)

	var/list/flattened = list()
	for (var/index in 1 to MAX_PREFERENCE_PRIORITY)
		flattened += preferences[index]
	return flattened

/// Represents an individual preference.
/datum/preference
	/// The key inside the savefile to use.
	/// This is also sent to the UI.
	/// Once you pick this, don't change it.
	var/savefile_key

	/// The category of preference, for use by the PreferencesMenu.
	/// This isn't used for anything other than as a key for UI data.
	/// It is up to the PreferencesMenu UI itself to interpret it.
	var/category = "misc"

	/// Do not instantiate if type matches this.
	var/abstract_type = /datum/preference

	/// What savefile should this preference be read from?
	/// Valid values are PREFERENCE_CHARACTER and PREFERENCE_PLAYER.
	/// See the documentation in [code/__DEFINES/preferences.dm].
	var/savefile_identifier

	/// The priority of when to apply this preference.
	/// Used for when you need to rely on another preference.
	var/priority = PREFERENCE_PRIORITY_DEFAULT

	/// If set, will be available to randomize, but only if the preference
	/// is for PREFERENCE_CHARACTER.
	var/can_randomize = TRUE

	/// If randomizable (PREFERENCE_CHARACTER and can_randomize), whether
	/// or not to enable randomization by default.
	/// This doesn't mean it'll always be random, but rather if a player
	/// DOES have random body on, will this already be randomized?
	var/randomize_by_default = TRUE

	/// If the selected species has this in its /datum/species/mutant_bodyparts,
	/// will show the feature as selectable.
	var/relevant_mutant_bodypart = null

	/// If the selected species has this in its /datum/species/inherent_traits,
	/// will show the feature as selectable.
	var/relevant_inherent_trait = null

	/// If the selected species has this in its /datum/species/var/cosmetic_organs,
	/// will show the feature as selectable.
	var/relevant_cosmetic_organ = null

	/// If the selected species has this head_flag by default,
	/// will show the feature as selectable.
	var/relevant_head_flag = null

/// Called on the saved input when retrieving.
/// Also called by the value sent from the user through UI. Do not trust it.
/// Input is the value inside the savefile, output is to tell other code
/// what the value is.
/// This is useful either for more optimal data saving or for migrating
/// older data.
/// Must be overridden by subtypes.
/// Can return null if no value was found.
/datum/preference/proc/deserialize(input, datum/preferences/preferences)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(FALSE)
	CRASH("`deserialize()` was not implemented on [type]!")

/// Called on the input while saving.
/// Input is the current value, output is what to save in the savefile.
/datum/preference/proc/serialize(input)
	SHOULD_NOT_SLEEP(TRUE)
	return input

/// Produce a default value for when no value for this preference is found in the savefile.
/datum/preference/proc/create_default_value(datum/preferences/preferences)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(FALSE)
	CRASH("`create_default_value()` was not implemented on [type]!")

/// Produce a random value for the purposes of character randomization.
/// Will just create a default value by default.
/datum/preference/proc/create_random_value(datum/preferences/preferences)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(FALSE)
	CRASH("`create_random_value()` was not implemented on [type]!")

/// Returns whether or not a preference can be randomized.
/datum/preference/proc/is_randomizable()
	SHOULD_NOT_OVERRIDE(TRUE)
	return savefile_identifier == PREFERENCE_CHARACTER && can_randomize

/// Given a savefile, return either the saved data or an acceptable default.
/// This will write to the savefile if a value was not found with the new value.
/datum/preference/proc/read(list/save_data, datum/preferences/preferences)
	SHOULD_NOT_OVERRIDE(TRUE)

	var/value

	if (!isnull(save_data))
		value = save_data[savefile_key]

	if (isnull(value))
		return null
	else
		return deserialize(value, preferences)

/// Apply this preference onto the given client.
/// Called when the savefile_identifier == PREFERENCE_PLAYER.
/datum/preference/proc/apply_to_client(client/client, value)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(FALSE)
	return

/// Fired when the preference is updated.
/// Calls apply_to_client by default, but can be overridden.
/datum/preference/proc/apply_to_client_updated(client/client, value)
	SHOULD_NOT_SLEEP(TRUE)
	apply_to_client(client, value)

/// Apply this preference onto the given human.
/// Must be overriden by subtypes.
/// Called when the savefile_identifier == PREFERENCE_CHARACTER.
/datum/preference/proc/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/prefs)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(FALSE)
	CRASH("`apply_to_human()` was not implemented for [type]!")

/// Read a /datum/preference type and return its value.
/// This will write to the savefile if a value was not found with the new value.
/datum/preferences/proc/read_preference(preference_type, char_id = current_ids[current_char_key], char_key = current_char_key)
	var/datum/preference/preference_entry = GLOB.preference_entries[preference_type]
	if (isnull(preference_entry))
		var/extra_info = ""

		// Current initializing subsystem is important to know because it might be a problem with
		// things running pre-assets-initialization.
		if (!isnull(Master.current_initializing_subsystem))
			extra_info = "Info was attempted to be retrieved while [Master.current_initializing_subsystem] was initializing."
		else if (!MC_RUNNING())
			extra_info = "Info was attempted to be retrieved before the MC started, but not while it was actively initializing a subsystem"

		CRASH("Preference type `[preference_type]` is invalid! [extra_info]")

	var/savefile_entry = savefile.get_entry(preference_entry.savefile_identifier == PREFERENCE_CHARACTER ? "character_[char_key]_[char_id]" : null)
	var/value = preference_entry.read(savefile_entry, src)
	if (isnull(value))
		var/old_id = current_ids[char_key]
		var/old_key = current_char_key

		current_char_key = char_key
		current_ids[char_key] = char_id

		value = preference_entry.create_default_value(src)

		current_ids[char_key] = old_id
		current_char_key = old_key

		if (!write_preference(preference_entry, value, char_id, char_key))
			CRASH("Couldn't write the default value for [preference_type] (received [value])")

	return value

/// Set a /datum/preference entry.
/// Returns TRUE for a successful preference application.
/// Returns FALSE if it is invalid.
/datum/preferences/proc/write_preference(datum/preference/preference_entry, preference_value, char_id = current_ids[current_char_key], char_key = current_char_key)
	var/save_data = savefile.get_entry(preference_entry.savefile_identifier == PREFERENCE_CHARACTER ? "character_[char_key]_[char_id]" : null)
	if(isnull(save_data))
		return TRUE

	if(!preference_entry.is_valid(preference_value))
		return FALSE

	save_data[preference_entry.savefile_key] = preference_entry.serialize(preference_value, src)
	return TRUE

/// Will perform an update on the preference, as well as all the appropriate sanity checks and updates.
/// This will, for instance, update the character preference view.
/datum/preferences/proc/update_preference(datum/preference/preference, preference_value)
	if (!preference.is_accessible(src))
		return FALSE

	var/success = write_preference(preference, preference.deserialize(preference_value, src))
	if (!success)
		return FALSE

	if (preference.savefile_identifier == PREFERENCE_PLAYER)
		preference.apply_to_client_updated(parent, read_preference(preference.type))
	else
		character_preview_view?.update_body()

	return TRUE

/// Checks that a given value is valid.
/// Must be overriden by subtypes.
/// Any type can be passed through.
/datum/preference/proc/is_valid(value)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(FALSE)
	CRASH("`is_valid()` was not implemented for [type]!")

/// Returns data to be sent to users in the menu
/datum/preference/proc/compile_ui_data(mob/user, value)
	SHOULD_NOT_SLEEP(TRUE)

	return serialize(value)

/// Returns data compiled into the preferences JSON asset
/datum/preference/proc/compile_constant_data()
	SHOULD_NOT_SLEEP(TRUE)

	return null

/// Returns whether or not this preference is accessible.
/// If FALSE, will not show in the UI and will not be editable (by update_preference).
/datum/preference/proc/is_accessible(datum/preferences/preferences)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	if ( \
		!isnull(relevant_mutant_bodypart) \
		|| !isnull(relevant_inherent_trait) \
		|| !isnull(relevant_cosmetic_organ) \
		|| !isnull(relevant_head_flag) \
	)
		var/species_type = preferences.read_preference(/datum/preference/choiced/species)

		var/datum/species/species = new species_type
		if (!(savefile_key in species.get_features()))
			return FALSE

	if (!should_show_on_page(preferences.current_window))
		return FALSE

	return TRUE

/// Returns whether or not, given the PREFERENCE_TAB_*, this preference should
/// appear.
/datum/preference/proc/should_show_on_page(preference_tab)
	var/is_on_character_page = preference_tab == PREFERENCE_TAB_CHARACTER_PREFERENCES
	var/is_character_preference = savefile_identifier == PREFERENCE_CHARACTER
	return is_on_character_page == is_character_preference

/// A preference that is a choice of one option among a fixed set.
/// Used for preferences such as clothing.
/datum/preference/choiced
	/**
	 * If this is TRUE, an icon will be generated for every value.
	 * If you implement this, you must implement `icon_for(value)` for every possible value.
	 */
	var/should_generate_icons = FALSE

	var/list/cached_values

	/// If the preference is a main feature (PREFERENCE_CATEGORY_FEATURES or PREFERENCE_CATEGORY_CLOTHING)
	/// this is the name of the feature that will be presented.
	var/main_feature_name

	abstract_type = /datum/preference/choiced

/// Returns a list of every possible value.
/// The first time this is called, will run `init_values()`.
/// Return value can be in the form of:
/// - A flat list of raw values, such as list(MALE, FEMALE, PLURAL).
/// - An assoc list of raw values to atoms/icons.
/datum/preference/choiced/proc/get_choices()
	// Override `init_values()` instead.
	SHOULD_NOT_OVERRIDE(TRUE)

	if (isnull(cached_values))
		cached_values = init_possible_values()
		ASSERT(cached_values.len)

	return cached_values

/// Returns a list of every possible value, serialized.
/// Return value can be in the form of:
/// - A flat list of serialized values, such as list(MALE, FEMALE, PLURAL).
/// - An assoc list of serialized values to atoms/icons.
/datum/preference/choiced/proc/get_choices_serialized()
	// Override `init_values()` instead.
	SHOULD_NOT_OVERRIDE(TRUE)

	var/list/serialized_choices = list()

	for (var/choice in get_choices())
		serialized_choices += serialize(choice)

	return serialized_choices

/// Returns a list of every possible value.
/// This must be overriden by `/datum/preference/choiced` subtypes.
/// If `should_generate_icons` is TRUE, then you will also need to implement `icon_for(value)`
/// for every possible value.
/datum/preference/choiced/proc/init_possible_values()
	CRASH("`init_possible_values()` was not implemented for [type]!")

/// When `should_generate_icons` is TRUE, this proc is called for every value.
/// It can return either an icon or a typepath to an atom to create.
/datum/preference/choiced/proc/icon_for(value)
	SHOULD_CALL_PARENT(FALSE)
	SHOULD_NOT_SLEEP(TRUE)
	CRASH("`icon_for()` was not implemented for [type], even though should_generate_icons = TRUE!")

/datum/preference/choiced/is_valid(value)
	return value in get_choices()

/datum/preference/choiced/deserialize(input, datum/preferences/preferences)
	return sanitize_inlist(input, get_choices(), create_default_value(preferences))

/datum/preference/choiced/create_default_value(datum/preferences/preferences)
	return get_choices()[1]

/datum/preference/choiced/create_random_value(datum/preferences/preferences)
	return pick(get_choices())

/datum/preference/choiced/compile_constant_data()
	var/list/data = list()

	var/list/choices = list()

	for (var/choice in get_choices())
		choices += choice

	data["choices"] = choices

	if (should_generate_icons)
		var/list/icons = list()

		for (var/choice in choices)
			icons[choice] = get_spritesheet_key(choice)

		data["icons"] = icons

	if (!isnull(main_feature_name))
		data["name"] = main_feature_name

	return data

/// A preference that represents an RGB color of something.
/// Will give the value as 6 hex digits, without a hash.
/datum/preference/color
	abstract_type = /datum/preference/color

/datum/preference/color/deserialize(input, datum/preferences/preferences)
	return sanitize_hexcolor(input)

/datum/preference/color/create_default_value()
	return "#[random_color()]"

/datum/preference/color/serialize(input)
	return sanitize_hexcolor(input)

/datum/preference/color/is_valid(value)
	return findtext(value, GLOB.is_color)

/// A numeric preference with a minimum and maximum value
/datum/preference/numeric
	/// The minimum value
	var/minimum

	/// The maximum value
	var/maximum

	/// The step of the number, such as 1 for integers or 0.5 for half-steps.
	var/step = 1

	abstract_type = /datum/preference/numeric

/datum/preference/numeric/deserialize(input, datum/preferences/preferences)
	if(istext(input)) // Sometimes TGUI will return a string instead of a number, so we take that into account.
		input = text2num(input) // Worst case, it's null, it'll just use create_default_value()
	return sanitize_float(input, minimum, maximum, step, create_default_value(preferences))

/datum/preference/numeric/serialize(input)
	return sanitize_float(input, minimum, maximum, step, create_default_value())

/datum/preference/numeric/create_default_value(datum/preferences/preferences)
	return (minimum + maximum) / 2

/datum/preference/numeric/create_random_value(datum/preferences/preferences)
	return rand(minimum, maximum)

/datum/preference/numeric/is_valid(value)
	return isnum(value) && value >= round(minimum, step) && value <= round(maximum, step)

/datum/preference/numeric/compile_constant_data()
	return list(
		"minimum" = minimum,
		"maximum" = maximum,
		"step" = step,
	)

/// A preference whose value is always TRUE or FALSE
/datum/preference/toggle
	abstract_type = /datum/preference/toggle

	/// The default value of the toggle, if create_default_value is not specified
	var/default_value = TRUE

/datum/preference/toggle/create_default_value(datum/preferences/preferences)
	return default_value

/datum/preference/toggle/create_random_value(datum/preferences/preferences)
	return rand(0, 1)

/datum/preference/toggle/deserialize(input, datum/preferences/preferences)
	return !!input

/datum/preference/toggle/is_valid(value)
	return value == TRUE || value == FALSE


/// A string-based preference accepting arbitrary string values entered by the user, with a maximum length.
/datum/preference/text
	abstract_type = /datum/preference/text

	/// What is the maximum length of the value allowed in this field?
	var/maximum_value_length = 256

	/// Should we strip HTML the input or simply restrict it to the maximum_value_length?
	var/should_strip_html = TRUE


/datum/preference/text/deserialize(input, datum/preferences/preferences)
	return should_strip_html ? STRIP_HTML_SIMPLE(input, maximum_value_length) : copytext(input, 1, maximum_value_length)

/datum/preference/text/create_default_value(datum/preferences/preferences)
	return ""

/datum/preference/text/create_random_value(datum/preferences/preferences)
	return create_default_value(preferences)

/datum/preference/text/is_valid(value)
	return istext(value) && length(value) < maximum_value_length

/datum/preference/text/compile_constant_data()
	return list("maximum_length" = maximum_value_length)

/// Like a normal color preference, but can hold up to three colors.
/datum/preference/tricolor
	abstract_type = /datum/preference/tricolor

/datum/preference/tricolor/deserialize(input, datum/preferences/preferences)
	var/list/input_colors = splittext(input, ";")
	input_colors.len = 3
	return sanitize_hexcolor_list(input_colors, 6, TRUE, COLOR_VIBRANT_LIME)

/datum/preference/tricolor/serialize(input)
	return "[input[1]];[input[2]];[input[3]]"

/datum/preference/tricolor/create_default_value(datum/preferences/preferences)
	if(preferences)
		return preferences.read_preference(/datum/preference/tricolor/mutant/mutant_color)
	return list("#FFFFFF", "#FFFFFF", "#FFFFFF")

/datum/preference/tricolor/create_random_value(datum/preferences/preferences)
	return list("#[random_color()]", "#[random_color()]", "#[random_color()]")

/datum/preference/tricolor/is_valid(value)
	var/list/value_list = value
	if(!islist(value_list))
		return FALSE
	if(value_list.len != 3)
		return FALSE
	for(var/index in 1 to 3)
		if(!findtext(sanitize_hexcolor(value_list[index], 6, TRUE), GLOB.is_color))
			return FALSE
	return TRUE

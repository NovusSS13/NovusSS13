
// Legacy preference toggles.
// !!! DO NOT ADD ANY NEW ONES HERE !!!
// Use `/datum/preference/toggle` instead.
#define SOUND_ADMINHELP (1<<0)
#define MEMBER_PUBLIC (1<<4)
#define SOUND_PRAYERS (1<<9)
#define ANNOUNCE_LOGIN (1<<10)
#define DISABLE_DEATHRATTLE (1<<12)
#define DISABLE_ARRIVALRATTLE (1<<13)
#define COMBOHUD_LIGHTING (1<<14)
#define DEADMIN_ALWAYS (1<<15)
#define DEADMIN_ANTAGONIST (1<<16)
#define DEADMIN_POSITION_HEAD (1<<17)
#define DEADMIN_POSITION_SECURITY (1<<18)
#define DEADMIN_POSITION_SILICON (1<<19)
#define ADMIN_IGNORE_CULT_GHOST (1<<21)
#define SPLIT_ADMIN_TABS (1<<23)

#define TOGGLES_DEFAULT (SOUND_ADMINHELP|MEMBER_PUBLIC|SOUND_PRAYERS)

// Legacy chat toggles.
// !!! DO NOT ADD ANY NEW ONES HERE !!!
// Use `/datum/preference/toggle` instead.
#define CHAT_OOC (1<<0)
#define CHAT_DEAD (1<<1)
#define CHAT_GHOSTEARS (1<<2)
#define CHAT_GHOSTSIGHT (1<<3)
#define CHAT_PRAYER (1<<4)
#define CHAT_PULLR (1<<6)
#define CHAT_GHOSTWHISPER (1<<7)
#define CHAT_GHOSTPDA (1<<8)
#define CHAT_GHOSTRADIO (1<<9)
#define CHAT_BANKCARD (1<<10)
#define CHAT_GHOSTLAWS (1<<11)
#define CHAT_LOGIN_LOGOUT (1<<12)

#define TOGGLES_DEFAULT_CHAT (CHAT_OOC|CHAT_DEAD|CHAT_GHOSTEARS|CHAT_GHOSTSIGHT|CHAT_PRAYER|CHAT_PULLR|CHAT_GHOSTWHISPER|CHAT_GHOSTPDA|CHAT_GHOSTRADIO|CHAT_BANKCARD|CHAT_GHOSTLAWS|CHAT_LOGIN_LOGOUT)

#define PARALLAX_INSANE "Insane"
#define PARALLAX_HIGH "High"
#define PARALLAX_MED "Medium"
#define PARALLAX_LOW "Low"
#define PARALLAX_DISABLE "Disabled"

#define SCALING_METHOD_NORMAL "normal"
#define SCALING_METHOD_DISTORT "distort"
#define SCALING_METHOD_BLUR "blur"

#define PARALLAX_DELAY_DEFAULT world.tick_lag
#define PARALLAX_DELAY_MED 1
#define PARALLAX_DELAY_LOW 2

#define SEC_DEPT_NONE "None"
#define SEC_DEPT_ENGINEERING "Engineering"
#define SEC_DEPT_MEDICAL "Medical"
#define SEC_DEPT_SCIENCE "Science"
#define SEC_DEPT_SUPPLY "Supply"

// Playtime tracking system, see jobs_exp.dm
#define EXP_TYPE_LIVING "Living"
#define EXP_TYPE_CREW "Crew"
#define EXP_TYPE_COMMAND "Command"
#define EXP_TYPE_ENGINEERING "Engineering"
#define EXP_TYPE_MEDICAL "Medical"
#define EXP_TYPE_SCIENCE "Science"
#define EXP_TYPE_SUPPLY "Supply"
#define EXP_TYPE_SECURITY "Security"
#define EXP_TYPE_SILICON "Silicon"
#define EXP_TYPE_SERVICE "Service"
#define EXP_TYPE_ANTAG "Antag"
#define EXP_TYPE_SPECIAL "Special"
#define EXP_TYPE_GHOST "Ghost"
#define EXP_TYPE_ADMIN "Admin"

//Flags in the players table in the db
/// Is the user exempt from the job exp system?
#define DB_FLAG_EXEMPT (1<<0)
/// Did the user pass the automated age gate?
#define DB_FLAG_AGE_VETTED (1<<1)
/// Has the user read the rules yet?
#define DB_FLAG_READ_RULES (1<<2)

#define DEFAULT_CYBORG_NAME "Default Cyborg Name"


//Job preferences levels
#define JP_LOW 1
#define JP_MEDIUM 2
#define JP_HIGH 3

//randomised elements
#define RANDOM_ANTAG_ONLY 1
#define RANDOM_DISABLED 2
#define RANDOM_ENABLED 3

//recommened client FPS
#define RECOMMENDED_FPS 100

// randomise_appearance_prefs() and randomize_human_appearance() proc flags
#define RANDOMIZE_BY_DEFAULT (1<<0)
#define RANDOMIZE_NAME (1<<1)
#define RANDOMIZE_SPECIES (1<<2)
#define RANDOMIZE_GENITALS (1<<3)

// Values for /datum/preference/savefile_identifier
/// This preference is character specific.
#define PREFERENCE_CHARACTER "character"
/// This preference is account specific.
#define PREFERENCE_PLAYER "player"

// Values for /datum/preferences/current_tab
/// Open the character preference window
#define PREFERENCE_TAB_CHARACTER_PREFERENCES 0

/// Open the game preferences window
#define PREFERENCE_TAB_GAME_PREFERENCES 1

/// Open the keybindings window
#define PREFERENCE_TAB_KEYBINDINGS 2

/// These will be shown in the character sidebar, but at the bottom.
#define PREFERENCE_CATEGORY_FEATURES "features"

/// Any preferences that will show to the sides of the character in the setup menu.
#define PREFERENCE_CATEGORY_CLOTHING "clothing"

/// Preferences that will be put into the 3rd list, and are not contextual.
#define PREFERENCE_CATEGORY_NON_CONTEXTUAL "non_contextual"

/// These will show in the list to the right of the character preview.
#define PREFERENCE_CATEGORY_SECONDARY_FEATURES "secondary_features"

/// These are preferences that are supplementary for main features, such as hair color being affixed to hair.
#define PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES "supplemental_features"

/// Preferences that will be put into the background list, which is on a separate tab.
#define PREFERENCE_CATEGORY_BACKGROUND "background_features"

/// Will be put under the game preferences window.
#define PREFERENCE_CATEGORY_GAME_PREFERENCES "game_preferences"

// Priorities must be in order!
/// The default priority level
#define PREFERENCE_PRIORITY_DEFAULT 1

/// The priority at which species runs, needed for external organs to apply properly.
#define PREFERENCE_PRIORITY_SPECIES 2

/// The priority at which gender is determined, needed for proper randomization.
#define PREFERENCE_PRIORITY_GENDER 3

/// The priority at which body type is decided, applied after gender so we can support the "use gender" option.
#define PREFERENCE_PRIORITY_BODY_TYPE 4

/**
 * Some preferences get applied directly to bodyparts (anything head_flags dependent right now).
 * These must apply after species, as species gaining might replace the bodyparts of the human.
 * These also should apply after gender and body type, as those might change the bodyparts.
 */
#define PREFERENCE_PRIORITY_BODYPARTS 5

/// The priority at which names are decided, needed for proper randomization.
#define PREFERENCE_PRIORITY_NAMES 6

/// Preferences that aren't names, but change the name changes set by PREFERENCE_PRIORITY_NAMES.
#define PREFERENCE_PRIORITY_NAME_MODIFICATIONS 7

/// Preferences that require the name to be set properly to work
#define PREFERENCE_PRIORITY_AFTER_NAMES 8

/// The maximum preference priority, keep this updated, but don't use it for `priority`.
#define MAX_PREFERENCE_PRIORITY PREFERENCE_PRIORITY_AFTER_NAMES

// Priorities must be in order here too!
/// Middleware that comes before normal prefs
#define MIDDLEWARE_PRIORITY_BEFORE 1
/// Middleware that comes after normal prefs
#define MIDDLEWARE_PRIORITY_AFTER 2

/// Default middleware priority
#define MIDDLEWARE_PRIORITY_DEFAULT MIDDLEWARE_PRIORITY_AFTER

// Playtime is tracked in minutes
/// The time needed to unlock hardcore random mode in preferences
#define PLAYTIME_HARDCORE_RANDOM 120 // 2 hours
/// The time needed to unlock the gamer cloak in preferences
#define PLAYTIME_VETERAN 300000 // 5,000 hours

/// The key used for sprite accessories that should never actually be applied to the player.
#define SPRITE_ACCESSORY_NONE "None"

/// Normal legs, the default for everyone
#define LEGS_NORMAL "Normal"
/// Digitigrade pref, used in feature if you're meant to be a Digitigrade.
#define LEGS_DIGITIGRADE "Digitigrade Legs"

// See: datum/species/var/digitigrade_customization
/// The species does not have digitigrade legs in generation.
#define DIGITIGRADE_NEVER 0
/// The species can have digitigrade legs in generation
#define DIGITIGRADE_OPTIONAL 1
/// The species is forced to have digitigrade legs in generation.
#define DIGITIGRADE_FORCED 2

// Uniform prefs
#define PREF_SUIT "Jumpsuit"
#define PREF_SKIRT "Jumpskirt"

// Backpack prefs
#define PREF_DEP_BACKPACK "Department Backpack"
#define PREF_DEP_DUFFELBAG "Department Duffel Bag"
#define PREF_DEP_SATCHEL "Department Satchel"
#define PREF_GREY_BACKPACK "Grey Backpack"
#define PREF_GREY_DUFFELBAG "Grey Duffel Bag"
#define PREF_GREY_SATCHEL "Grey Satchel"
#define PREF_LEATHER_SATCHEL "Leather Satchel"

// Uplink spawn loc prefs
#define UPLINK_PDA "PDA"
#define UPLINK_RADIO "Radio"
#define UPLINK_PEN "Pen" //like a real spy!
#define UPLINK_IMPLANT "Implant"

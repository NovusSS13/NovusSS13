//Preferences stuff
	//Hairstyles
GLOBAL_LIST_EMPTY(hairstyles_list) //stores /datum/sprite_accessory/hair indexed by name
GLOBAL_LIST_EMPTY(hairstyles_male_list) //stores only hair names
GLOBAL_LIST_EMPTY(hairstyles_female_list) //stores only hair names
GLOBAL_LIST_EMPTY(facial_hairstyles_list) //stores /datum/sprite_accessory/facial_hair indexed by name
GLOBAL_LIST_EMPTY(facial_hairstyles_male_list) //stores only hair names
GLOBAL_LIST_EMPTY(facial_hairstyles_female_list) //stores only hair names
GLOBAL_LIST_EMPTY(hair_gradients_list) //stores /datum/sprite_accessory/hair_gradient indexed by name
GLOBAL_LIST_EMPTY(facial_hair_gradients_list) //stores /datum/sprite_accessory/facial_hair_gradient indexed by name
	//Underwear
GLOBAL_LIST_EMPTY(underwear_list) //stores /datum/sprite_accessory/underwear indexed by name
GLOBAL_LIST_EMPTY(underwear_m) //stores only underwear name
GLOBAL_LIST_EMPTY(underwear_f) //stores only underwear name
	//Undershirts
GLOBAL_LIST_EMPTY(undershirt_list) //stores /datum/sprite_accessory/undershirt indexed by name
GLOBAL_LIST_EMPTY(undershirt_m)  //stores only undershirt name
GLOBAL_LIST_EMPTY(undershirt_f)  //stores only undershirt name
	//Socks
GLOBAL_LIST_EMPTY(socks_list) //stores /datum/sprite_accessory/socks indexed by name
	//Lizard Bits (all datum lists indexed by name)
GLOBAL_LIST_EMPTY(horns_list)
GLOBAL_LIST_EMPTY(horns_list_lizard)
GLOBAL_LIST_EMPTY(frills_list)
GLOBAL_LIST_EMPTY(frills_list_lizard)
GLOBAL_LIST_EMPTY(spines_list)
GLOBAL_LIST_EMPTY(spines_list_lizard)

	//Mutant Human bits
GLOBAL_LIST_EMPTY(snouts_list)
GLOBAL_LIST_EMPTY(snouts_list_lizard)
GLOBAL_LIST_EMPTY(legs_list)
GLOBAL_LIST_EMPTY(tails_list)
GLOBAL_LIST_EMPTY(tails_list_monkey)
GLOBAL_LIST_EMPTY(tails_list_human)
GLOBAL_LIST_EMPTY(tails_list_lizard)
GLOBAL_LIST_EMPTY(tails_list_avali)
GLOBAL_LIST_EMPTY(ears_list)
GLOBAL_LIST_EMPTY(ears_list_human)
GLOBAL_LIST_EMPTY(ears_list_avali)
GLOBAL_LIST_EMPTY(wings_list)
GLOBAL_LIST_EMPTY(wings_open_list)
GLOBAL_LIST_EMPTY(moth_wings_list)
GLOBAL_LIST_EMPTY(moth_antennae_list)
GLOBAL_LIST_EMPTY(mushroom_caps_list)
GLOBAL_LIST_EMPTY(pod_hair_list)

	//Human bits bits
GLOBAL_LIST_EMPTY(penis_list)
GLOBAL_LIST_EMPTY(testicles_list)
GLOBAL_LIST_EMPTY(vagina_list)
GLOBAL_LIST_EMPTY(breasts_list)
GLOBAL_LIST_EMPTY(anus_list)

GLOBAL_LIST_INIT(penis_size_names, list(
	"1" = "Small",
	"2" = "Average",
	"3" = "Big",
	"4" = "Enormous",
))

GLOBAL_LIST_INIT(testicles_size_names, list(
	"1" = "Small",
	"2" = "Average",
	"3" = "Big",
))

GLOBAL_LIST_INIT(breasts_size_names, list(
	"1" = "A",
	"2" = "C",
	"3" = "B",
	"4" = "D",
	"5" = "E",
	"6" = "F",
	"7" = "G",
	"8" = "H",
	"9" = "I",
	"10" = "J",
	"11" = "K",
	"12" = "L",
	"13" = "M",
	"14" = "N",
	"15" = "O",
	"16" = "P"
))

GLOBAL_LIST_INIT(genital_visibility_list, list(
	"Always hidden" = GENITAL_VISIBILITY_NEVER,
	"Hidden behind clothing" = GENITAL_VISIBILITY_CLOTHING,
	"Always visible" = GENITAL_VISIBILITY_ALWAYS,
))

	//Custom bodypart icon selection
GLOBAL_LIST_INIT(pref_bodypart_names, list(
	"Mutant" = SPECIES_MUTANT,
	"Lizard" = SPECIES_LIZARD,
))

GLOBAL_LIST_INIT(pref_bodypart_id_to_icon, list(
	SPECIES_MUTANT = 'icons/mob/species/mutant/mutant_bodyparts.dmi',
	SPECIES_LIZARD = 'icons/mob/species/lizard/bodyparts.dmi',
))

	//Markings
GLOBAL_LIST_EMPTY(body_markings)

GLOBAL_LIST_EMPTY(body_markings_by_zone)

GLOBAL_LIST_EMPTY(body_marking_sets)

GLOBAL_LIST_INIT(marking_zones, list(
	BODY_ZONE_HEAD,
	BODY_ZONE_CHEST,
	BODY_ZONE_L_ARM,
	BODY_ZONE_R_ARM,
	BODY_ZONE_PRECISE_L_HAND,
	BODY_ZONE_PRECISE_R_HAND,
	BODY_ZONE_L_LEG,
	BODY_ZONE_R_LEG,
))

GLOBAL_LIST_INIT(marking_zone_to_bitflag, list(
	BODY_ZONE_HEAD = HEAD,
	BODY_ZONE_CHEST = CHEST,
	BODY_ZONE_L_ARM = ARM_LEFT,
	BODY_ZONE_R_ARM = ARM_RIGHT,
	BODY_ZONE_PRECISE_L_HAND = HAND_LEFT,
	BODY_ZONE_PRECISE_R_HAND = HAND_RIGHT,
	BODY_ZONE_L_LEG = LEG_LEFT,
	BODY_ZONE_R_LEG = LEG_RIGHT,
	BODY_ZONE_PRECISE_L_FOOT = FOOT_LEFT,
	BODY_ZONE_PRECISE_R_FOOT = FOOT_RIGHT,
))

	//Heights
GLOBAL_LIST_INIT(height_names, list(
	"Dwarf" = HUMAN_HEIGHT_DWARF,
	"Shorter" = HUMAN_HEIGHT_SHORTER,
	"Short" = HUMAN_HEIGHT_SHORT,
	"Medium" = HUMAN_HEIGHT_MEDIUM,
	"Tall" = HUMAN_HEIGHT_TALL,
	"Taller" = HUMAN_HEIGHT_TALLER,
	"Manmore" = HUMAN_HEIGHT_MANMORE,
))

GLOBAL_LIST_INIT(mob_heights, list(
	HUMAN_HEIGHT_DWARF,
	HUMAN_HEIGHT_SHORTER,
	HUMAN_HEIGHT_SHORT,
	HUMAN_HEIGHT_MEDIUM,
	HUMAN_HEIGHT_TALL,
	HUMAN_HEIGHT_TALLER,
	HUMAN_HEIGHT_MANMORE,
))

GLOBAL_LIST_INIT(mob_height_to_name, list(
	"[HUMAN_HEIGHT_DWARF]" = "Dwarf",
	"[HUMAN_HEIGHT_SHORTER]" = "Shorter",
	"[HUMAN_HEIGHT_SHORT]" = "Short",
	"[HUMAN_HEIGHT_MEDIUM]" = "Medium",
	"[HUMAN_HEIGHT_TALL]" = "Tall",
	"[HUMAN_HEIGHT_TALLER]" = "Taller",
	"[HUMAN_HEIGHT_MANMORE]" = "Manmore",
))

	//Gender
GLOBAL_LIST_INIT(genders, list(
	MALE,
	FEMALE,
	PLURAL,
))

GLOBAL_LIST_INIT(body_types, list(
	MALE,
	FEMALE,
))

	//Colors
//normal ethereal colors
GLOBAL_LIST_INIT(color_list_ethereal, list(
	"Blue" = "#3399ff",
	"Bright Yellow" = "#ffff99",
	"Burnt Orange" = "#cc4400",
	"Cyan Blue" = "#00ffff",
	"Dark Blue" = "#6666ff",
	"Dark Fuschia" = "#cc0066",
	"Dark Green" = "#37835b",
	"Dark Red" = "#9c3030",
	"Dull Yellow" = "#fbdf56",
	"Faint Blue" = "#b3d9ff",
	"Faint Green" = "#ddff99",
	"Faint Red" = "#ffb3b3",
	"Green" = "#97ee63",
	"Orange" = "#ffa64d",
	"Pink" = "#ff99cc",
	"Purple" = "#ee82ee",
	"Red" = "#ff4d4d",
	"Seafoam Green" = "#00fa9a",
	"White" = "#f2f2f2",
))

//lustrous ethereal color list
GLOBAL_LIST_INIT(color_list_lustrous, list(
	"Cyan Blue" = "#00ffff",
	"Sky Blue" = "#37c0ff",
	"Blue" = "#3374ff",
	"Dark Blue" = "#5b5beb",
	"Bright Red" = "#fa2d2d",
))

//runechat colors
GLOBAL_LIST_INIT(chat_colors, list(
	"Unknown" = COLOR_GRAY,
))

GLOBAL_LIST_INIT(protected_chat_colors, list(
	"Unknown" = COLOR_GRAY,
))

//voice packs
GLOBAL_LIST_EMPTY(voice_packs)

GLOBAL_LIST_EMPTY(voice_packs_by_type)

//flavor text holders
GLOBAL_LIST_EMPTY(flavor_holders)

//stores the ghost forms that support directional sprites
GLOBAL_LIST_INIT(ghost_forms_with_directions_list, list(
	"catghost",
	"ghost_black",
	"ghost_blazeit",
	"ghost_blue",
	"ghost_camo",
	"ghost_cyan",
	"ghost_dblue",
	"ghost_dcyan",
	"ghost_dgreen",
	"ghost_dpink",
	"ghost_dred",
	"ghost_dyellow",
	"ghost_fire",
	"ghost_funkypurp",
	"ghost_green",
	"ghost_grey",
	"ghost_mellow",
	"ghost_pink",
	"ghost_pinksherbert",
	"ghost_purpleswirl",
	"ghost_rainbow",
	"ghost_red",
	"ghost_yellow",
	"ghost",
	"ghostian",
	"ghostian2",
	"ghostking",
	"skeleghost",
))

//stores the ghost forms that support hair and other such things
GLOBAL_LIST_INIT(ghost_forms_with_accessories_list, list(
	"ghost_black",
	"ghost_blazeit",
	"ghost_blue",
	"ghost_camo",
	"ghost_cyan",
	"ghost_dblue",
	"ghost_dcyan",
	"ghost_dgreen",
	"ghost_dpink",
	"ghost_dred",
	"ghost_dyellow",
	"ghost_fire",
	"ghost_funkypurp",
	"ghost_green",
	"ghost_grey",
	"ghost_mellow",
	"ghost_pink",
	"ghost_pinksherbert",
	"ghost_purpleswirl",
	"ghost_rainbow",
	"ghost_red",
	"ghost_yellow",
	"ghost",
	"skeleghost",
))

GLOBAL_LIST_INIT(security_depts_prefs, sort_list(list(
	SEC_DEPT_ENGINEERING,
	SEC_DEPT_MEDICAL,
	SEC_DEPT_NONE,
	SEC_DEPT_SCIENCE,
	SEC_DEPT_SUPPLY,
)))

	//Backpacks
GLOBAL_LIST_INIT(backpacklist, list(
	PREF_DEP_BACKPACK,
	PREF_DEP_DUFFELBAG,
	PREF_DEP_SATCHEL,
	PREF_GREY_BACKPACK,
	PREF_GREY_DUFFELBAG,
	PREF_GREY_SATCHEL,
	PREF_LEATHER_SATCHEL,
))

	//Female Uniforms
GLOBAL_LIST_EMPTY(female_clothing_icons)

GLOBAL_LIST_INIT(scarySounds, list(
	'sound/effects/footstep/clownstep1.ogg',
	'sound/effects/footstep/clownstep2.ogg',
	'sound/effects/glassbr1.ogg',
	'sound/effects/glassbr2.ogg',
	'sound/effects/glassbr3.ogg',
	'sound/items/welder.ogg',
	'sound/items/welder2.ogg',
	'sound/machines/airlock.ogg',
	'sound/voice/hiss1.ogg',
	'sound/voice/hiss2.ogg',
	'sound/voice/hiss3.ogg',
	'sound/voice/hiss4.ogg',
	'sound/voice/hiss5.ogg',
	'sound/voice/hiss6.ogg',
	'sound/weapons/armbomb.ogg',
	'sound/weapons/taser.ogg',
	'sound/weapons/thudswoosh.ogg',
))


// Reference list for disposal sort junctions. Set the sortType variable on disposal sort junctions to
// the index of the sort department that you want. For example, sortType set to 2 will reroute all packages
// tagged for the Cargo Bay.

/* List of sortType codes for mapping reference
0 Waste
1 Disposals - All unwrapped items and untagged parcels get picked up by a junction with this sortType. Usually leads to the recycler.
2 Cargo Bay
3 QM Office
4 Engineering
5 CE Office
6 Atmospherics
7 Security
8 HoS Office
9 Medbay
10 CMO Office
11 Chemistry
12 Research
13 RD Office
14 Robotics
15 HoP Office
16 Library
17 Chapel
18 Theatre
19 Bar
20 Kitchen
21 Hydroponics
22 Janitor
23 Genetics
24 Experimentor Lab
25 Ordnance
26 Dormitories
27 Virology
28 Xenobiology
29 Law Office
30 Detective's Office
*/

//The whole system for the sorttype var is determined based on the order of this list,
//disposals must always be 1, since anything that's untagged will automatically go to disposals, or sorttype = 1 --Superxpdude

//If you don't want to fuck up disposals, add to this list, and don't change the order.
//If you insist on changing the order, you'll have to change every sort junction to reflect the new order. --Pete

GLOBAL_LIST_INIT(TAGGERLOCATIONS, list("Disposals",
	"Cargo Bay", "QM Office", "Engineering", "CE Office",
	"Atmospherics", "Security", "HoS Office", "Medbay",
	"CMO Office", "Chemistry", "Research", "RD Office",
	"Robotics", "HoP Office", "Library", "Chapel", "Theatre",
	"Bar", "Kitchen", "Hydroponics", "Janitor Closet","Genetics",
	"Experimentor Lab", "Ordnance", "Dormitories", "Virology",
	"Xenobiology", "Law Office","Detective's Office"))

GLOBAL_LIST_INIT(station_prefixes, world.file2list("strings/station_prefixes.txt"))

GLOBAL_LIST_INIT(station_names, world.file2list("strings/station_names.txt"))

GLOBAL_LIST_INIT(station_suffixes, world.file2list("strings/station_suffixes.txt"))

GLOBAL_LIST_INIT(greek_letters, world.file2list("strings/greek_letters.txt"))

GLOBAL_LIST_INIT(phonetic_alphabet, world.file2list("strings/phonetic_alphabet.txt"))

GLOBAL_LIST_INIT(numbers_as_words, world.file2list("strings/numbers_as_words.txt"))

GLOBAL_LIST_INIT(wisdoms, world.file2list("strings/wisdoms.txt"))

/proc/generate_number_strings()
	var/list/L[198]
	for(var/i in 1 to 99)
		L += "[i]"
		L += "\Roman[i]"
	return L

GLOBAL_LIST_INIT(station_numerals, greek_letters + phonetic_alphabet + numbers_as_words + generate_number_strings())

GLOBAL_LIST_INIT(admiral_messages, list(
	"<i>Error: No comment given.</i>",
	"<i>null</i>",
	"Do you know how expensive these stations are?",
	"I was sleeping, thanks a lot.",
	"It's a good day to die!",
	"No.",
	"Stand and fight you cowards!",
	"Stop being paranoid.",
	"Stop wasting my time.",
	"Whatever's broken just build a new one.",
	"You knew the risks coming in.",
))

GLOBAL_LIST_INIT(junkmail_messages, world.file2list("strings/junkmail.txt"))

// All valid inputs to status display post_status
GLOBAL_LIST_INIT(status_display_approved_pictures, list(
	"blank",
	"shuttle",
	"default",
	"biohazard",
	"lockdown",
	"redalert",
))

// Members of status_display_approved_pictures that are actually states and not alert values
GLOBAL_LIST_INIT(status_display_state_pictures, list(
	"blank",
	"shuttle",
))

/// Interaction datums
GLOBAL_LIST_EMPTY(interactions)

/// Interaction datums, but by category
GLOBAL_LIST_EMPTY(interactions_by_category)

/// Order of interaction categories, for sorting
GLOBAL_LIST_INIT(interaction_categories, list(
	INTERACTION_CATEGORY_MEAN,
	INTERACTION_CATEGORY_FRIENDLY,
	INTERACTION_CATEGORY_ROMANTIC,
	INTERACTION_CATEGORY_SEXUAL,
))

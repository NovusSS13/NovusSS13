// Defines for Species IDs. Used to refer to the name of a species, for things like bodypart names or species preferences.
#define SPECIES_ABDUCTOR "abductor"
#define SPECIES_ANDROID "android"
#define SPECIES_DULLAHAN "dullahan"
#define SPECIES_ETHEREAL "ethereal"
#define SPECIES_ETHEREAL_LUSTROUS "lustrous"
#define SPECIES_FELINE "felinid"
#define SPECIES_FLYPERSON "fly"
#define SPECIES_GOLEM "golem"
#define SPECIES_HUMAN "human"
#define SPECIES_JELLYPERSON "jelly"
#define SPECIES_SLIMEPERSON "slime"
#define SPECIES_LUMINESCENT "luminescent"
#define SPECIES_STARGAZER "stargazer"
#define SPECIES_LIZARD "lizard"
#define SPECIES_LIZARD_ASH "ashwalker"
#define SPECIES_LIZARD_SILVER "silverscale"
#define SPECIES_NIGHTMARE "nightmare"
#define SPECIES_MONKEY "monkey"
#define SPECIES_MONKEY_FREAK "monkey_freak"
#define SPECIES_MONKEY_HUMAN_LEGGED "monkey_human_legged"
#define SPECIES_MOTH "moth"
#define SPECIES_MUTANT "mutant"
#define SPECIES_MUSHROOM "mush"
#define SPECIES_PLASMAMAN "plasmaman"
#define SPECIES_PODPERSON "pod"
#define SPECIES_SHADOW "shadow"
#define SPECIES_SKELETON "skeleton"
#define SPECIES_SNAIL "snail"
#define SPECIES_TALLBOY "tallboy"
#define SPECIES_VAMPIRE "vampire"
#define SPECIES_ZOMBIE "zombie"
#define SPECIES_ZOMBIE_INFECTIOUS "memezombie"
#define SPECIES_ZOMBIE_KROKODIL "krokodil_zombie"

// Defines for used in creating "perks" for the species preference pages.
/// A key that designates UI icon displayed on the perk.
#define SPECIES_PERK_ICON "ui_icon"
/// A key that designates the name of the perk.
#define SPECIES_PERK_NAME "name"
/// A key that designates the description of the perk.
#define SPECIES_PERK_DESC "description"
/// A key that designates what type of perk it is (see below).
#define SPECIES_PERK_TYPE "perk_type"

// The possible types each perk can be.
// Positive perks are shown in green, negative in red, and neutral in grey.
#define SPECIES_POSITIVE_PERK "positive"
#define SPECIES_NEGATIVE_PERK "negative"
#define SPECIES_NEUTRAL_PERK "neutral"

/// Golem food defines
#define GOLEM_FOOD_IRON "golem_food_iron"
#define GOLEM_FOOD_GLASS "golem_food_glass"
#define GOLEM_FOOD_URANIUM "golem_food_uranium"
#define GOLEM_FOOD_SILVER "golem_food_silver"
#define GOLEM_FOOD_PLASMA "golem_food_plasma"
#define GOLEM_FOOD_GOLD "golem_food_gold"
#define GOLEM_FOOD_DIAMOND "golem_food_diamond"
#define GOLEM_FOOD_TITANIUM "golem_food_titanium"
#define GOLEM_FOOD_PLASTEEL "golem_food_plasteel"
#define GOLEM_FOOD_BANANIUM "golem_food_bananium"
#define GOLEM_FOOD_BLUESPACE "golem_food_bluespace"
#define GOLEM_FOOD_GIBTONITE "golem_food_gibtonite"
#define GOLEM_FOOD_LIGHTBULB "golem_food_lightbulb"

/// Golem food datum singletons
GLOBAL_LIST_INIT(golem_stack_food_types, list(
	GOLEM_FOOD_IRON = new /datum/golem_food_buff/iron(),
	GOLEM_FOOD_GLASS = new /datum/golem_food_buff/glass(),
	GOLEM_FOOD_URANIUM = new /datum/golem_food_buff/uranium(),
	GOLEM_FOOD_SILVER = new /datum/golem_food_buff/silver(),
	GOLEM_FOOD_PLASMA = new /datum/golem_food_buff/plasma(),
	GOLEM_FOOD_GOLD = new /datum/golem_food_buff/gold(),
	GOLEM_FOOD_DIAMOND = new /datum/golem_food_buff/diamond(),
	GOLEM_FOOD_TITANIUM = new /datum/golem_food_buff/titanium(),
	GOLEM_FOOD_PLASTEEL = new /datum/golem_food_buff/plasteel(),
	GOLEM_FOOD_BANANIUM = new /datum/golem_food_buff/bananium(),
	GOLEM_FOOD_BLUESPACE = new /datum/golem_food_buff/bluespace(),
	GOLEM_FOOD_GIBTONITE = new /datum/golem_food_buff/gibtonite(),
	GOLEM_FOOD_LIGHTBULB = new /datum/golem_food_buff/lightbulb(),
))

/// Associated list of stack types to a golem food
GLOBAL_LIST_INIT(golem_stack_food_directory, list(
	/obj/item/gibtonite = GLOB.golem_stack_food_types[GOLEM_FOOD_GIBTONITE],
	/obj/item/light = GLOB.golem_stack_food_types[GOLEM_FOOD_LIGHTBULB],
	/obj/item/stack/sheet/iron = GLOB.golem_stack_food_types[GOLEM_FOOD_IRON],
	/obj/item/stack/ore/iron = GLOB.golem_stack_food_types[GOLEM_FOOD_IRON],
	/obj/item/stack/sheet/glass = GLOB.golem_stack_food_types[GOLEM_FOOD_GLASS],
	/obj/item/stack/sheet/mineral/uranium = GLOB.golem_stack_food_types[GOLEM_FOOD_URANIUM],
	/obj/item/stack/ore/uranium = GLOB.golem_stack_food_types[GOLEM_FOOD_URANIUM],
	/obj/item/stack/sheet/mineral/silver = GLOB.golem_stack_food_types[GOLEM_FOOD_SILVER],
	/obj/item/stack/ore/silver = GLOB.golem_stack_food_types[GOLEM_FOOD_SILVER],
	/obj/item/stack/sheet/mineral/plasma = GLOB.golem_stack_food_types[GOLEM_FOOD_PLASMA],
	/obj/item/stack/ore/plasma = GLOB.golem_stack_food_types[GOLEM_FOOD_PLASMA],
	/obj/item/stack/sheet/mineral/gold = GLOB.golem_stack_food_types[GOLEM_FOOD_GOLD],
	/obj/item/stack/ore/gold = GLOB.golem_stack_food_types[GOLEM_FOOD_GOLD],
	/obj/item/stack/sheet/mineral/diamond = GLOB.golem_stack_food_types[GOLEM_FOOD_DIAMOND],
	/obj/item/stack/ore/diamond = GLOB.golem_stack_food_types[GOLEM_FOOD_DIAMOND],
	/obj/item/stack/sheet/mineral/titanium = GLOB.golem_stack_food_types[GOLEM_FOOD_TITANIUM],
	/obj/item/stack/ore/titanium = GLOB.golem_stack_food_types[GOLEM_FOOD_TITANIUM],
	/obj/item/stack/sheet/plasteel = GLOB.golem_stack_food_types[GOLEM_FOOD_PLASTEEL],
	/obj/item/stack/ore/bananium = GLOB.golem_stack_food_types[GOLEM_FOOD_BANANIUM],
	/obj/item/stack/sheet/mineral/bananium = GLOB.golem_stack_food_types[GOLEM_FOOD_BANANIUM],
	/obj/item/stack/ore/bluespace_crystal = GLOB.golem_stack_food_types[GOLEM_FOOD_BLUESPACE],
	/obj/item/stack/ore/bluespace_crystal/refined = GLOB.golem_stack_food_types[GOLEM_FOOD_BLUESPACE],
	/obj/item/stack/ore/bluespace_crystal/artificial = GLOB.golem_stack_food_types[GOLEM_FOOD_BLUESPACE],
	/obj/item/stack/sheet/bluespace_crystal = GLOB.golem_stack_food_types[GOLEM_FOOD_BLUESPACE],
))

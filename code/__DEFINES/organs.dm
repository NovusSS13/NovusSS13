//organ slots
#define ORGAN_SLOT_ADAMANTINE_RESONATOR "adamantine_resonator"
#define ORGAN_SLOT_APPENDIX "appendix"
#define ORGAN_SLOT_BRAIN "brain"
#define ORGAN_SLOT_BRAIN_ANTIDROP "brain_antidrop"
#define ORGAN_SLOT_BRAIN_ANTISTUN "brain_antistun"
#define ORGAN_SLOT_BREATHING_TUBE "breathing_tube"
#define ORGAN_SLOT_EARS "ears"
#define ORGAN_SLOT_EYES "eyes"
#define ORGAN_SLOT_HEART "heart"
#define ORGAN_SLOT_HEART_AID "heartdrive"
#define ORGAN_SLOT_HUD "eye_hud"
#define ORGAN_SLOT_LIVER "liver"
#define ORGAN_SLOT_LUNGS "lungs"
#define ORGAN_SLOT_PARASITE_EGG "parasite_egg"
#define ORGAN_SLOT_MONSTER_CORE "monstercore"
#define ORGAN_SLOT_RIGHT_ARM_AUG "r_arm_device"
#define ORGAN_SLOT_LEFT_ARM_AUG "l_arm_device" //This one ignores alphabetical order cause the arms should be together
#define ORGAN_SLOT_STOMACH "stomach"
#define ORGAN_SLOT_STOMACH_AID "stomach_aid"
#define ORGAN_SLOT_THRUSTERS "thrusters"
#define ORGAN_SLOT_TONGUE "tongue"
#define ORGAN_SLOT_VOICE "vocal_cords"
#define ORGAN_SLOT_ZOMBIE "zombie_infection"

// organ slot external
#define ORGAN_SLOT_EXTERNAL_TAIL "tail"
#define ORGAN_SLOT_EXTERNAL_SPINES "spines"
#define ORGAN_SLOT_EXTERNAL_SNOUT "snout"
#define ORGAN_SLOT_EXTERNAL_FRILLS "frills"
#define ORGAN_SLOT_EXTERNAL_HORNS "horns"
#define ORGAN_SLOT_EXTERNAL_WINGS "wings"
#define ORGAN_SLOT_EXTERNAL_ANTENNAE "antennae"
#define ORGAN_SLOT_EXTERNAL_BODYMARKINGS "bodymarkings"
#define ORGAN_SLOT_EXTERNAL_MUSHROOM_CAP "mushroom_cap"
#define ORGAN_SLOT_EXTERNAL_POD_HAIR "pod_hair"

// genitalia
#define ORGAN_SLOT_PENIS "penis"
#define ORGAN_SLOT_TESTICLES "testicles" //no bob im not adding 2 slots for each testicle //fuck you
#define ORGAN_SLOT_BREASTS "breasts"
#define ORGAN_SLOT_VAGINA "vagina"
#define ORGAN_SLOT_WOMB "womb"

// xenomorph organ slots
#define ORGAN_SLOT_XENO_ACIDGLAND "acid_gland"
#define ORGAN_SLOT_XENO_EGGSAC "eggsac"
#define ORGAN_SLOT_XENO_HIVENODE "hive_node"
#define ORGAN_SLOT_XENO_NEUROTOXINGLAND "neurotoxin_gland"
#define ORGAN_SLOT_XENO_PLASMAVESSEL "plasma_vessel"
#define ORGAN_SLOT_XENO_RESINSPINNER "resin_spinner"

//organ defines
#define STANDARD_ORGAN_THRESHOLD 100
#define STANDARD_ORGAN_HEALING (50 / 100000)
/// designed to fail organs when left to decay for ~15 minutes
#define STANDARD_ORGAN_DECAY (111 / 100000)

/// Uses the parent limb's drawcolor value.
#define ORGAN_COLOR_INHERIT (1<<0)
/// Uses a DNA feature for coloring, if one is available.
#define ORGAN_COLOR_DNA (1<<1)
/// Uses /datum/bodypart_overlay/proc/override_color()'s return value
#define ORGAN_COLOR_OVERRIDE (1<<2)
/// Uses the parent's hair color
#define ORGAN_COLOR_HAIR (1<<3)
/// Uses the parent's facial hair color
#define ORGAN_COLOR_FACIAL_HAIR (1<<4)

// Tail wagging
/// Tail is capable of wagging
#define WAG_ABLE (1<<0)
/// Tail is currently wagging
#define WAG_WAGGING (1<<1)

// Genital visibility
/// Never visible
#define GENITAL_VISIBILITY_NEVER 0
/// Visible when naked
#define GENITAL_VISIBILITY_CLOTHING 1
/// Always visible
#define GENITAL_VISIBILITY_ALWAYS 2

/// Defines how a mob's organs_slot is ordered
/// Exists so Life()'s organ process order is consistent
GLOBAL_LIST_INIT(organ_process_order, list(
	ORGAN_SLOT_BRAIN,
	ORGAN_SLOT_APPENDIX,
	ORGAN_SLOT_RIGHT_ARM_AUG,
	ORGAN_SLOT_LEFT_ARM_AUG,
	ORGAN_SLOT_STOMACH,
	ORGAN_SLOT_STOMACH_AID,
	ORGAN_SLOT_BREATHING_TUBE,
	ORGAN_SLOT_EARS,
	ORGAN_SLOT_EYES,
	ORGAN_SLOT_LUNGS,
	ORGAN_SLOT_HEART,
	ORGAN_SLOT_ZOMBIE,
	ORGAN_SLOT_THRUSTERS,
	ORGAN_SLOT_HUD,
	ORGAN_SLOT_LIVER,
	ORGAN_SLOT_TONGUE,
	ORGAN_SLOT_VOICE,
	ORGAN_SLOT_ADAMANTINE_RESONATOR,
	ORGAN_SLOT_HEART_AID,
	ORGAN_SLOT_BRAIN_ANTIDROP,
	ORGAN_SLOT_BRAIN_ANTISTUN,
	ORGAN_SLOT_PARASITE_EGG,
	ORGAN_SLOT_MONSTER_CORE,
	ORGAN_SLOT_XENO_PLASMAVESSEL,
	ORGAN_SLOT_XENO_HIVENODE,
	ORGAN_SLOT_XENO_RESINSPINNER,
	ORGAN_SLOT_XENO_ACIDGLAND,
	ORGAN_SLOT_XENO_NEUROTOXINGLAND,
	ORGAN_SLOT_XENO_EGGSAC,
	ORGAN_SLOT_EXTERNAL_TAIL,
	ORGAN_SLOT_EXTERNAL_SPINES,
	ORGAN_SLOT_EXTERNAL_SNOUT,
	ORGAN_SLOT_EXTERNAL_FRILLS,
	ORGAN_SLOT_EXTERNAL_HORNS,
	ORGAN_SLOT_EXTERNAL_WINGS,
	ORGAN_SLOT_EXTERNAL_ANTENNAE,
	ORGAN_SLOT_EXTERNAL_BODYMARKINGS,
	ORGAN_SLOT_EXTERNAL_MUSHROOM_CAP,
	ORGAN_SLOT_EXTERNAL_POD_HAIR,
))

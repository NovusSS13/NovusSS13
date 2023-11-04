//Bodypart icon defines
#define DEFAULT_BODYPART_ICON_ORGANIC 'icons/mob/species/human/bodyparts_greyscale.dmi'
#define DEFAULT_BODYPART_ICON_ROBOTIC 'icons/mob/augmentation/augments.dmi'

//Bodytype defines for how things can be worn, surgery, and other misc things.
///The limb is organic.
#define BODYTYPE_ORGANIC (1<<0)
///The limb is robotic.
#define BODYTYPE_ROBOTIC (1<<1)
///The limb fits the human mold. This is not meant to be literal, if the sprite "fits" on a human, it is "humanoid", regardless of origin.
#define BODYTYPE_HUMANOID (1<<2)
///The limb fits the monkey mold.
#define BODYTYPE_MONKEY (1<<3)
///The limb is digitigrade.
#define BODYTYPE_DIGITIGRADE (1<<4)
///The limb is digitigrade, but is being compressed for the sake of icon rendering.
#define BODYTYPE_COMPRESSED (1<<5)
///The limb is snouted.
#define BODYTYPE_SNOUTED (1<<6)
///A placeholder bodytype for xeno larva, so their limbs cannot be attached to anything.
#define BODYTYPE_LARVA (1<<7)
///The limb is from a xenomorph.
#define BODYTYPE_ALIEN (1<<8)
///The limb is from a golem
#define BODYTYPE_GOLEM (1<<9)

/// Helper to figure out if a limb is organic
#define IS_ORGANIC_LIMB(limb) (limb.bodytype & BODYTYPE_ORGANIC)
/// Helper to figure out if a limb is robotic
#define IS_ROBOTIC_LIMB(limb) (limb.bodytype & BODYTYPE_ROBOTIC)

#define BODYTYPE_BIOSCRAMBLE_INCOMPATIBLE (BODYTYPE_ROBOTIC | BODYTYPE_GOLEM)
#define BODYTYPE_BIOSCRAMBLE_COMPATIBLE (BODYTYPE_HUMANOID | BODYTYPE_MONKEY | BODYTYPE_ALIEN)
#define BODYTYPE_CAN_BE_BIOSCRAMBLED(bodytype) (!(bodytype & BODYTYPE_BIOSCRAMBLE_INCOMPATIBLE) && (bodytype & BODYTYPE_BIOSCRAMBLE_COMPATIBLE))

// Flags for the bodypart_flags var on /obj/item/bodypart
/// Bodypart cannot be dismembered or amputated
#define BODYPART_UNREMOVABLE (1<<0)
/// Bodypart is a pseudopart (like a chainsaw arm)
#define BODYPART_PSEUDOPART (1<<1)
/// Bodypart did not match the owner's default bodypart limb_id when surgically implanted
#define BODYPART_IMPLANTED (1<<2)

// Bodypart change blocking flags for change_exempt_flags var on /obj/item/bodypart
///Bodypart does not get replaced during set_species()
#define BP_BLOCK_CHANGE_SPECIES (1<<0)

// Like species IDs, but not specifically attached a species.
#define BODYPART_ID_ROBOTIC "robotic"
#define BODYPART_ID_ALIEN "alien"
#define BODYPART_ID_LARVA "larva"
#define BODYPART_ID_PSYKER "psyker"

///The standard amount of bodyparts a carbon has. Currently 6, HEAD/L_ARM/R_ARM/CHEST/L_LEG/R_LEG
#define BODYPARTS_DEFAULT_MAXIMUM 6

// Flags for the head_flags var on /obj/item/bodypart/head
/// Head can have hair
#define HEAD_HAIR (1<<0)
/// Head can have facial hair
#define HEAD_FACIAL_HAIR (1<<1)
/// Head can have lips
#define HEAD_LIPS (1<<2)
/// Head can have eye sprites
#define HEAD_EYESPRITES (1<<3)
/// Head will have colored eye sprites
#define HEAD_EYECOLOR (1<<4)
/// Head can have eyeholes when missing eyes
#define HEAD_EYEHOLES (1<<5)
/// Head can have debrain overlay
#define HEAD_DEBRAIN (1<<6)
/// All head flags, default for most heads
#define HEAD_ALL_FLAGS (HEAD_HAIR|HEAD_FACIAL_HAIR|HEAD_LIPS|HEAD_EYESPRITES|HEAD_EYECOLOR|HEAD_EYEHOLES|HEAD_DEBRAIN)

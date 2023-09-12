/// Return value when the surgery step fails :(
#define SURGERY_STEP_FAIL -1

// Flags for surgery_flags on /datum/surgery
///Will allow the surgery to bypass clothes
#define SURGERY_IGNORE_CLOTHES (1<<0)
///Will allow the surgery to be performed by the user on themselves.
#define SURGERY_SELF_OPERABLE (1<<1)
///Will allow the surgery to work on mobs that aren't lying down.
#define SURGERY_REQUIRE_RESTING (1<<2)
///Will allow the surgery to work only if there's a limb.
#define SURGERY_REQUIRE_LIMB (1<<3)
///Will allow the surgery to work only if there's a real (eg. not pseudopart) limb.
#define SURGERY_REQUIRES_REAL_LIMB (1<<4)
///Will grant a bonus during surgery steps to users with TRAIT_MORBID while they're using tools with CRUEL_IMPLEMENT
#define SURGERY_MORBID_CURIOSITY (1<<5)

///Return true if target is not in a valid body position for the surgery
#define IS_IN_INVALID_SURGICAL_POSITION(target, surgery) ((surgery.surgery_flags & SURGERY_REQUIRE_RESTING) && (target.mobility_flags & MOBILITY_LIEDOWN && target.body_position != LYING_DOWN))

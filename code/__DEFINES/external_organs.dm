/// Uses the parent limb's drawcolor value.
#define ORGAN_COLOR_INHERIT (1<<0)
/// Uses /datum/bodypart_overlay/proc/override_color()'s return value
#define ORGAN_COLOR_OVERRIDE (1<<1)
/// Uses the parent's haircolor
#define ORGAN_COLOR_HAIR (1<<2)

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

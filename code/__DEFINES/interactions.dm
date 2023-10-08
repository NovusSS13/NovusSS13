/// Default interaction cooldown, can be changed on each interaction datum
#define DEFAULT_INTERACTION_COOLDOWN 0.5 SECONDS

// ~interaction flags
/// Use audible_message instead of visible_message
#define INTERACTION_AUDIBLE (1<<0)
/// Self interaction, can be used on yourself
#define INTERACTION_SELF (1<<1)
/// Other interaction, can be used on others
#define INTERACTION_OTHER (1<<2)
/// Respects interaction_cooldown
#define INTERACTION_RESPECT_COOLDOWN (1<<3)
/// Respects "orgasm" cooldown, aka reffractive period or whatever
#define INTERACTION_RESPECT_SEX_COOLDOWN (1<<4)
/// Interaction will call climax() on the user, if applicable
#define INTERACTION_USER_CLIMAX (1<<5)
/// Interaction will call climax() on the target, if applicable
#define INTERACTION_TARGET_CLIMAX (1<<6)
/// Interaction will call lust_message() on the user, if applicable
#define INTERACTION_USER_LUST (1<<7)
/// Interaction will call lust_message() on the target, if applicable
#define INTERACTION_TARGET_LUST (1<<8)

// ~interaction categories
/// Mean interactions, such as giving someone the finger
#define INTERACTION_CATEGORY_MEAN "Mean"
/// Nice interactions, such as a handshake
#define INTERACTION_CATEGORY_FRIENDLY "Friendly"
/// Romantic interactions, like kissing and holding hands
#define INTERACTION_CATEGORY_ROMANTIC "Romantic"
/// GAY SEX
#define INTERACTION_CATEGORY_SEXUAL "Sexual"

/// Factor at which genitals lose their proximity to orgasm, per second
#define DELUST_FACTOR 0.2

/// Once we hit this amount of lust, we orgasm
#define LUST_CLIMAX 300
/// No arousal gain
#define AROUSAL_GAIN_NONE 0
/// Small arousal gain
#define AROUSAL_GAIN_LOW AROUSAL_LEVEL_AROUSED/10
/// Normal arousal gain
#define AROUSAL_GAIN_NORMAL AROUSAL_LEVEL_AROUSED/5

/// No lust increase (ass slap)
#define LUST_GAIN_NONE 0
/// Low lust increase on sex (thigh smother, deep kiss, etc)
#define LUST_GAIN_LOW 2.5
/// Normal lust increase on sex
#define LUST_GAIN_NORMAL 10


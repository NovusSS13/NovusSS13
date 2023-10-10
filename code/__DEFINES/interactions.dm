/// Default interaction cooldown, can be changed on each interaction datum
#define DEFAULT_INTERACTION_COOLDOWN_DURATION 0.5 SECONDS

// ~interaction usage flags
/// Self interaction, can be used on yourself
#define INTERACTION_SELF (1<<0)
/// Other interaction, can be used on others
#define INTERACTION_OTHER (1<<1)

// ~interaction flags
/// Use audible_message instead of visible_message
#define INTERACTION_AUDIBLE (1<<0)
/// Respects interaction_cooldown
#define INTERACTION_COOLDOWN (1<<1)
/// Respects "orgasm" cooldown, aka reffractive period or whatever
#define INTERACTION_SEX_COOLDOWN (1<<2)
/// Interaction will handle lust on the user, if applicable
#define INTERACTION_USER_LUST (1<<3)
/// Interaction will handle lust on the target, if applicable
#define INTERACTION_TARGET_LUST (1<<4)
/// Interaction will call climax() on the user, if applicable
#define INTERACTION_USER_CLIMAX (1<<5)
/// Interaction will call climax() on the target, if applicable
#define INTERACTION_TARGET_CLIMAX (1<<6)

// ~interaction categories
/// Mean interactions, such as giving someone the finger
#define INTERACTION_CATEGORY_MEAN "Mean"
/// Nice interactions, such as a handshake
#define INTERACTION_CATEGORY_FRIENDLY "Friendly"
/// Romantic interactions, like kissing and holding hands
#define INTERACTION_CATEGORY_ROMANTIC "Romantic"
/// SAY GEX
#define INTERACTION_CATEGORY_SEXUAL "Sexual"

// Arousal levels for humans
#define AROUSAL_LEVEL_MAXIMUM 1000
#define AROUSAL_LEVEL_HORNY 550
#define AROUSAL_LEVEL_AROUSED 300

#define AROUSAL_LEVEL_START_MIN 0
#define AROUSAL_LEVEL_START_MAX 200

/// No arousal gain
#define AROUSAL_GAIN_NONE 0
/// Small arousal gain
#define AROUSAL_GAIN_LOW AROUSAL_LEVEL_AROUSED/10
/// Normal arousal gain
#define AROUSAL_GAIN_NORMAL AROUSAL_LEVEL_AROUSED/5

/// Once we hit this amount of lust, we orgasm
#define LUST_CLIMAX 300
/// Factor at which genitals lose their proximity to orgasm, per second
#define DELUST_FACTOR 0.2

/// No lust increase (ass slap)
#define LUST_GAIN_NONE 0
/// Low lust increase on sex (thigh smother, deep kiss, etc)
#define LUST_GAIN_LOW 2.5
/// Normal lust increase on sex (anal sex)
#define LUST_GAIN_NORMAL 10

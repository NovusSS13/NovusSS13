// Bitflags for emotes, used in var/emote_type of the emote datum
/// Is the emote audible?
#define EMOTE_AUDIBLE (1<<0)
/// Is the emote visible?
#define EMOTE_VISIBLE (1<<1)
/// Is it an emote that should be shown regardless of blindness/deafness?
#define EMOTE_IMPORTANT (1<<2)
/// Is it a subtle emote that should only be shown to mobs 1 tile adjacent?
#define EMOTE_SUBTLE (1<<3)

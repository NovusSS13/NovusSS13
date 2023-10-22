//Bitflags for the layers a bodypart overlay can draw on (can be drawn on multiple layers)
/// Draws overlay on the BODY_BEHIND_LAYER
#define EXTERNAL_BEHIND (1<<0)
/// Draws overlay on the BODY_ADJ_LAYER
#define EXTERNAL_ADJACENT (1<<1)
/// Draws overlay on the BODY_HIGH_LAYER
#define EXTERNAL_HIGH (1<<2)
/// Draws overlay on the BODY_FRONT_LAYER
#define EXTERNAL_FRONT (1<<3)
/// Draws organ on all EXTERNAL layers
#define EXTERNAL_ALL_LAYERS EXTERNAL_BEHIND | EXTERNAL_ADJACENT | EXTERNAL_HIGH | EXTERNAL_FRONT

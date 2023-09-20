/**
 * Converts a bitflag to the right layer.
 * I'd love to make this a static index list, but byond made an attempt on my life when i did.
 */
/proc/external_bitflag_to_layer(layer)
	switch(layer)
		if(EXTERNAL_BEHIND)
			return -BODY_BEHIND_LAYER
		if(EXTERNAL_ADJACENT)
			return -BODY_ADJ_LAYER
		if(EXTERNAL_FRONT)
			return -BODY_FRONT_LAYER
	return layer

/**
 * This exists so sprite accessories can still be per-layer without having to include that layer's
 * number in their sprite name, which causes issues when those numbers change.
 */
/proc/mutant_bodyparts_layertext(layer)
	switch(layer)
		if(-BODY_BEHIND_LAYER)
			return "BEHIND"
		if(-BODY_ADJ_LAYER)
			return "ADJ"
		if(-BODY_FRONT_LAYER)
			return "FRONT"
	return layer

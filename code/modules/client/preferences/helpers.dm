/// Checks if a sprite accessory is actually valid for rendering
/proc/is_valid_rendering_sprite_accessory(datum/sprite_accessory/sprite_accessory)
	if (isnull(sprite_accessory) || !sprite_accessory.icon_state || (sprite_accessory.name == SPRITE_ACCESSORY_NONE))
		return FALSE
	return TRUE

/// Blends a given icon with the returned appearance from a bodypart overlay
/proc/blend_bodypart_overlay(icon/to_blend, datum/bodypart_overlay/mutant/bodypart_overlay, datum/sprite_accessory/sprite_accessory, draw_color, dir = SOUTH, operation = ICON_OVERLAY)
	if(!is_valid_rendering_sprite_accessory(sprite_accessory))
		return to_blend
	bodypart_overlay.draw_color = draw_color
	bodypart_overlay.set_appearance(sprite_accessory.type)
	for(var/layer in GLOB.external_layer_bitflags)
		if(!(bodypart_overlay.layers & layer))
			continue
		for(var/mutable_appearance/appearance in bodypart_overlay.get_overlays(layer))
			if(isnull(appearance))
				continue
			var/icon/accessory_icon = getFlatIcon(appearance, dir)
			if(isnull(accessory_icon))
				continue
			to_blend.Blend(accessory_icon, operation)
	return to_blend

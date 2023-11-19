/**
 * Simple mutant bodypart overlay that doesn't rely on organs
 * Requires feature_key and feature_key_color to be set on new, or manually
 */
/datum/bodypart_overlay/mutant/marking
	required_bodytype = BODYTYPE_HUMANOID | BODYTYPE_AVALI
	layers = EXTERNAL_ADJACENT
	color_source = ORGAN_COLOR_DNA
	imprint_on_next_insertion = FALSE //nah lol
	/// Body zone we are currently on, VERY IMPORTANT otherwise we won't get the proper icon state!
	var/body_zone

/datum/bodypart_overlay/mutant/marking/New(body_zone, feature_key, feature_color_key, color_source)
	. = ..()
	src.body_zone = body_zone
	//Hands are REALLY stupid and display on a higher layer than other crap
	if((body_zone == BODY_ZONE_PRECISE_R_HAND) || (body_zone == BODY_ZONE_PRECISE_L_HAND))
		layers &= ~EXTERNAL_ADJACENT
		layers |= EXTERNAL_HIGH
	src.feature_key = feature_key
	src.feature_color_key = feature_color_key
	if(color_source)
		src.color_source = color_source

/datum/bodypart_overlay/mutant/marking/get_icon_feature_key()
	return "markings"

/datum/bodypart_overlay/mutant/marking/get_base_icon_state()
	return  sprite_datum.icon_state + (body_zone ? "_[body_zone]" : "")

/datum/bodypart_overlay/mutant/marking/get_global_feature_list()
	if(body_zone)
		return GLOB.body_markings_by_zone[body_zone]
	return GLOB.body_markings

/// Update our features after something changed our appearance (if we have an actual feature key)
/datum/bodypart_overlay/mutant/marking/proc/mutate_features(list/features, obj/item/bodypart/bodypart, mob/living/carbon/human/human)
	if(!feature_key && !feature_color_key)
		return FALSE

	var/marking_name = features[feature_key]
	if(marking_name && (marking_name != SPRITE_ACCESSORY_NONE))
		set_appearance_from_name(marking_name)
	inherit_color(bodypart, force = TRUE)
	return TRUE

/**
 * Creamed component
 *
 * For when you have pie on your face... or something else...
 */
/datum/component/creamed
	/// Text string for use in examine ("Their lips are covered in coom!")
	var/cover_lips
	/// Creampie overlay we use for non-carbon mobs
	var/mutable_appearance/normal_overlay
	/// Creampie bodypart overlay we use for carbon mobs
	var/datum/bodypart_overlay/simple/bodypart_overlay = /datum/bodypart_overlay/simple/creampie
	/// Cached head for carbons, to ensure proper removal of the creampie overlay
	var/obj/item/bodypart/my_head

/datum/component/creamed/Initialize()
	if(!is_type_in_typecache(parent, get_creamable_list()))
		return COMPONENT_INCOMPATIBLE

	SEND_SIGNAL(parent, COMSIG_MOB_CREAMED, src)

/datum/component/creamed/RegisterWithParent()
	if(iscarbon(parent))
		var/mob/living/carbon/human/carbon_parent = parent
		my_head = carbon_parent.get_bodypart(BODY_ZONE_HEAD)
		if(!my_head) //just to be sure
			qdel(src)
			return
		RegisterSignals(my_head, list(COMSIG_BODYPART_REMOVED, COMSIG_QDELETING), PROC_REF(lost_head))
	on_creamed()
	create_overlays()
	RegisterSignals(parent, list(
		COMSIG_COMPONENT_CLEAN_ACT,
		COMSIG_COMPONENT_CLEAN_FACE_ACT),
		PROC_REF(clean_up)
	)
	if(normal_overlay)
		var/atom/atom_parent = parent
		RegisterSignal(atom_parent, COMSIG_ATOM_UPDATE_OVERLAYS, PROC_REF(update_overlays))
		atom_parent.update_appearance()

/datum/component/creamed/UnregisterFromParent()
	on_uncreamed()
	UnregisterSignal(parent, list(
		COMSIG_COMPONENT_CLEAN_ACT,
		COMSIG_COMPONENT_CLEAN_FACE_ACT))
	UnregisterSignal(parent, COMSIG_ATOM_EXAMINE)
	if(my_head)
		if(bodypart_overlay)
			my_head.remove_bodypart_overlay(bodypart_overlay)
			if(my_head.owner)
				my_head.owner.update_body_parts()
			else
				my_head.update_icon_dropped()
		UnregisterSignal(my_head, list(COMSIG_BODYPART_REMOVED, COMSIG_QDELETING))
		my_head = null
	QDEL_NULL(bodypart_overlay)
	if(normal_overlay)
		var/atom/atom_parent = parent
		UnregisterSignal(atom_parent, COMSIG_ATOM_UPDATE_OVERLAYS)
		atom_parent.update_appearance()
		normal_overlay = null

/datum/component/creamed/Destroy(force)
	. = ..()
	normal_overlay = null
	my_head = null
	QDEL_NULL(bodypart_overlay)

/// Creates the overlay, as well as bodypart overlay if applicable
/datum/component/creamed/proc/create_overlays()
	return

/// Returns the typecache of mobs we can apply to
/datum/component/creamed/proc/get_creamable_list()
	RETURN_TYPE(/list)
	return list()

/// Proc to handle misc events, such as creating a memory or mood event
/datum/component/creamed/proc/on_creamed()
	return

/// Proc to handle reversal of misc events, such as removing the mood event
/datum/component/creamed/proc/on_uncreamed()
	return

/// Callback to remove pieface
/datum/component/creamed/proc/clean_up(datum/source, clean_types)
	SIGNAL_HANDLER

	if(!(clean_types & CLEAN_TYPE_BLOOD))
		return NONE

	qdel(src)
	return COMPONENT_CLEANED

/// Ensures normal_overlay overlay in case the mob is not a carbon
/datum/component/creamed/proc/update_overlays(atom/parent_atom, list/overlays)
	SIGNAL_HANDLER

	if(normal_overlay)
		overlays += normal_overlay

/// Removes component when the head gets dismembered
/datum/component/creamed/proc/lost_head(obj/item/bodypart/source, mob/living/carbon/owner, dismembered)
	SIGNAL_HANDLER

	qdel(src)

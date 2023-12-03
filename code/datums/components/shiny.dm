/**
 * Shiny component
 *
 * This component handles adding a simple reflection to a given atom.
 */
/datum/component/shiny
	/// Shine mask icon state, either "full" or "partial"
	var/shine_mask = "full"
	/// Shine displacement icon state, probably going to be "flip"
	var/shine_displacement = "flip"
	/// Optional callback so you can perform additional checks before adding the shine
	var/datum/callback/check_callback

/datum/component/shiny/Initialize(shine_mask = "full", shine_displacement = "flip", datum/callback/check_callback)
	. = ..()
	src.shine_mask = shine_mask
	src.shine_displacement = shine_displacement
	src.check_callback = check_callback

/datum/component/shiny/RegisterWithParent()
	ADD_TRAIT(parent, TRAIT_SHINY, REF(src))
	RegisterSignal(parent, COMSIG_ATOM_UPDATE_OVERLAYS, PROC_REF(on_update_overlays))
	RegisterSignal(parent, COMSIG_ATOM_SMOOTHED_ICON, PROC_REF(on_smoothed_icon))
	var/atom/atom_parent = parent
	atom_parent.update_appearance()

/datum/component/shiny/UnregisterFromParent()
	REMOVE_TRAIT(parent, TRAIT_SHINY, REF(src))
	UnregisterSignal(parent, COMSIG_ATOM_UPDATE_OVERLAYS)
	UnregisterSignal(parent, COMSIG_ATOM_SMOOTHED_ICON)
	var/atom/atom_parent = parent
	if(!QDELETED(atom_parent))
		atom_parent.update_appearance()

/// Used to maintain the shiny overlays on the parent [/atom].
/datum/component/shiny/proc/on_update_overlays(atom/source, list/overlays)
	SIGNAL_HANDLER

	if(check_callback && !check_callback.Invoke(src))
		return

	if(shine_displacement)
		var/mutable_appearance/displacer = mutable_appearance('icons/effects/shine.dmi', shine_displacement, offset_spokesman = source, plane = REFLECTION_DISPLACEMENT_PLANE, appearance_flags = RESET_COLOR|RESET_ALPHA)
		overlays += displacer
	var/mutable_appearance/reflector = mutable_appearance(source.icon, source.icon_state, offset_spokesman = source, plane = REFLECTION_MASK_PLANE, appearance_flags = RESET_COLOR)
	reflector.add_filter("mask", 1, alpha_mask_filter(icon = icon('icons/effects/shine.dmi', shine_mask)))
	overlays += reflector

/// Used to call update_overlays() when the parent atom gets smoothed
/datum/component/shiny/proc/on_smoothed_icon(atom/source)
	SIGNAL_HANDLER

	source.update_appearance(~UPDATE_SMOOTHING)

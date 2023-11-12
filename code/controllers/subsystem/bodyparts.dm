/**
 * This subsystem only exists to initialize bodyparts and organs lists AFTER necessary subsystems, like greyscale,
 * have been initialized - As well as static variables.
 */
SUBSYSTEM_DEF(bodyparts)
	name = "Bodyparts"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_BODYPARTS
	/// List of all bodypart subtypes
	var/list/bodyparts = list()
	/// List of all bodypart subtypes, indexed by their path
	var/list/bodyparts_by_path = list()
	/**
	 * A bit of an oddball, this is a list of lists of bodyparts indexed by limb_id.
	 * The inner lists are then indexed by their path.
	 */
	var/list/bodyparts_by_limb_id = list()

	/// List of all organ subtypes
	var/list/organs = list()
	/// List of all organ subtypes, indexed by their path
	var/list/organs_by_path = list()

/datum/controller/subsystem/bodyparts/Initialize()
	init_bodyparts_lists()
	init_organs_lists()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/bodyparts/proc/init_bodyparts_lists()
	for(var/path in subtypesof(/obj/item/bodypart))
		var/obj/item/bodypart/bodypart = new path
		bodyparts += bodypart
		bodyparts_by_path[path] = bodypart
		if(bodypart.limb_id)
			LAZYADDASSOC(bodyparts_by_limb_id[bodypart.limb_id], path, bodypart)
	bodyparts_by_path = sort_list(bodyparts_by_path, GLOBAL_PROC_REF(cmp_typepaths_asc))
	bodyparts_by_limb_id = sort_list(bodyparts_by_limb_id, GLOBAL_PROC_REF(cmp_text_asc))
	for(var/limb_id in bodyparts_by_limb_id)
		bodyparts_by_limb_id[limb_id] = sort_list(bodyparts_by_limb_id[limb_id], GLOBAL_PROC_REF(cmp_typepaths_asc))

/datum/controller/subsystem/bodyparts/proc/init_organs_lists()
	for(var/path in subtypesof(/obj/item/organ))
		var/obj/item/organ/organ = new path
		organs += organ
		organs_by_path[path] = organ
	organs_by_path = sort_list(organs_by_path, GLOBAL_PROC_REF(cmp_typepaths_asc))

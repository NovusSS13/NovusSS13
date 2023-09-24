/// An assoc list of bodyparts that gets cached for use in various ways
GLOBAL_LIST_EMPTY(bodyparts)
/// Like GLOB.bodyparts, but indexed by path
GLOBAL_LIST_EMPTY(bodyparts_by_path)
/// Bodyparts indexed by body zone
GLOBAL_LIST_INIT(bodyparts_by_zone, list(
	BODY_ZONE_HEAD = new /obj/item/bodypart/head,
	BODY_ZONE_CHEST = new /obj/item/bodypart/chest,
	BODY_ZONE_L_ARM = new /obj/item/bodypart/arm/left,
	BODY_ZONE_R_ARM = new /obj/item/bodypart/arm/right,
	BODY_ZONE_L_LEG = new /obj/item/bodypart/leg/left,
	BODY_ZONE_R_LEG = new /obj/item/bodypart/leg/right,
))
/// A bit of an oddball, this is a list of list of bodyparts indexed by limb_id
GLOBAL_LIST_EMPTY(bodyparts_by_limb_id)

/proc/init_bodyparts_lists()
	for(var/path in subtypesof(/obj/item/bodypart))
		var/obj/item/bodypart/bodypart = new path
		GLOB.bodyparts += bodypart
		GLOB.bodyparts_by_path[path] = path
		if(bodypart.limb_id)
			LAZYADDASSOC(GLOB.bodyparts_by_limb_id[bodypart.limb_id], path, bodypart)
	GLOB.bodyparts_by_path = sort_list(GLOB.bodyparts_by_path, GLOBAL_PROC_REF(cmp_typepaths_asc))
	GLOB.bodyparts_by_limb_id = sort_list(GLOB.bodyparts_by_limb_id, GLOBAL_PROC_REF(cmp_text_asc))
	for(var/limb_id in GLOB.bodyparts_by_limb_id)
		GLOB.bodyparts_by_limb_id[limb_id] = sort_list(GLOB.bodyparts_by_limb_id[limb_id], GLOBAL_PROC_REF(cmp_typepaths_asc))

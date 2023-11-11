/// An assoc list of organs that gets cached for use in various ways
GLOBAL_LIST_EMPTY(organs)
/// Like GLOB.organs, but indexed by path
GLOBAL_LIST_EMPTY(organs_by_path)

/proc/init_organs_lists()
	for(var/path in subtypesof(/obj/item/bodypart))
		var/obj/item/organ/organ = new path
		GLOB.organs += organ
		GLOB.organs_by_path[path] = path
	GLOB.organs_by_path = sort_list(GLOB.organs_by_path, GLOBAL_PROC_REF(cmp_typepaths_asc))

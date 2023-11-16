/datum/experiment/scanning/random/organs
	name = "Organ Scanning Experiment"
	description = "Base experiment for scanning organs"
	exp_tag = "Organ Scan"
	total_requirement = 4
	max_requirement_per_type = 2
	possible_types = list(
		/obj/item/organ/brain,
		/obj/item/organ/eyes,
		/obj/item/organ/ears,
		/obj/item/organ/tongue,
		/obj/item/organ/heart,
		/obj/item/organ/lungs,
		/obj/item/organ/liver,
		/obj/item/organ/stomach,
		/obj/item/organ/appendix,
	)
	traits = EXPERIMENT_TRAIT_DESTRUCTIVE
	/// Whether or not we allow failing organs to be scanned
	var/allow_failing = FALSE
	/// Whether or not we allow roboticc organs
	var/allow_robotic = FALSE

/datum/experiment/scanning/random/organs/final_contributing_index_checks(atom/target, typepath)
	. = ..()
	if(!.)
		return
	var/obj/item/organ/organ = target
	if(!allow_failing && (organ.organ_flags & ORGAN_FAILING)) //must be a working organ
		return FALSE
	if(!allow_robotic && IS_ROBOTIC_ORGAN(organ)) //must be a biological organ
		return FALSE

/datum/experiment/scanning/random/organs/serialize_progress_stage(atom/target, list/seen_instances)
	var/scanned_total = traits & EXPERIMENT_TRAIT_DESTRUCTIVE ? scanned[target] : seen_instances.len
	var/name_with_requirements = "[initial(target.name)]"
	if(!allow_robotic)
		name_with_requirements = "organic [name_with_requirements]"
	if(!allow_failing)
		name_with_requirements = "working [name_with_requirements]"
	return EXPERIMENT_PROG_INT("Scan samples of \a [name_with_requirements]", scanned_total, required_atoms[target])

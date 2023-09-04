/**
 * ABSTRACT TYPES FOR MUTANT BODYPART PREFS
 */

/datum/preference/choiced/mutant
	abstract_type = /datum/preference/choiced/mutant
	/// Feature that will be changed on apply_on_human()
	var/relevant_feature

/datum/preference/choiced/mutant/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/prefs)
	// Doesn't make sense
	if(!relevant_feature)
		return
	// Mutant preferences do not apply if not accessible
	else if(!is_accessible(prefs))
		return
	target.dna.features[relevant_feature] = value

/datum/preference/tri_color/mutant
	abstract_type = /datum/preference/tri_color/mutant
	/// Feature that will be changed on apply_on_human()
	var/relevant_feature

/obj/item/organ/brain/megamind
	name = "megabrain"
	desc = "Oh you're a villain alright, just not a <b>super</b> one!"
	icon_state = "brain-psyker"
	w_class = WEIGHT_CLASS_NORMAL
	maxHealth = BRAIN_DAMAGE_DEATH * 1.5
	low_threshold = BRAIN_DAMAGE_DEATH * 1.5 * 0.225
	high_threshold = BRAIN_DAMAGE_DEATH * 1.5 * 0.6
	organ_traits = list(
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_LITERATE,
		TRAIT_CAN_STRIP,
		TRAIT_SPECIAL_TRAUMA_BOOST,
		TRAIT_MEGAMIND,
		TRAIT_ANTIMAGIC_NO_SELFBLOCK,
		TRAIT_BALD,
		TRAIT_WIG_DESTROYER,
		TRAIT_SHAVED,
	)
	hemispherectomy_overlay = null
	hemisphere_type = null
	megamind = TRUE

/obj/item/organ/brain/megamind/on_insert(mob/living/carbon/organ_owner, special)
	. = ..()
	organ_owner.add_actionspeed_modifier(/datum/actionspeed_modifier/megamind)
	organ_owner.AddComponent(/datum/component/anti_magic, antimagic_flags = MAGIC_RESISTANCE_MIND)
	if(organ_owner.dna)
		organ_owner.dna.add_mutation(/datum/mutation/human/telekinesis)
		organ_owner.dna.add_mutation(/datum/mutation/human/telepathy)
		organ_owner.dna.add_mutation(/datum/mutation/human/mindreader)
	//yeah we need to recolor mutant organs too... sorry liberal
	organ_owner.update_body(is_creating = TRUE)

/obj/item/organ/brain/megamind/on_remove(mob/living/carbon/organ_owner, special)
	. = ..()
	organ_owner.remove_actionspeed_modifier(/datum/actionspeed_modifier/megamind)
	qdel(organ_owner.GetComponent(/datum/component/anti_magic))
	if(organ_owner.dna)
		organ_owner.dna.remove_mutation(/datum/mutation/human/telekinesis)
		organ_owner.dna.remove_mutation(/datum/mutation/human/telepathy)
		organ_owner.dna.remove_mutation(/datum/mutation/human/mindreader)
	//yeah we need to recolor mutant organs too... sorry liberal
	organ_owner.update_body(is_creating = TRUE)

/obj/item/organ/brain/megamind/add_to_limb(obj/item/bodypart/bodypart, special)
	. = ..()
	ADD_TRAIT(bodypart, TRAIT_MEGAMIND, REF(src))

/obj/item/organ/brain/megamind/remove_from_limb(obj/item/bodypart/bodypart, special)
	. = ..()
	REMOVE_TRAIT(bodypart, TRAIT_MEGAMIND, REF(src))

/obj/item/organ/brain/megamind/hemispherectomize(mob/living/user, harmful)
	if(!user)
		return FALSE
	to_chat(user, span_userdanger("[src] is too smart to be mutilated like this!"))
	if(iscarbon(user))
		var/mob/living/carbon/smallmind = user
		smallmind.adjustOrganLoss(ORGAN_SLOT_BRAIN, BRAIN_DAMAGE_DEATH/2)
	explosion(user, light_impact_range = 1, flash_range = 1, explosion_cause = src)
	return FALSE

/obj/item/organ/brain/megamind/traumatic_hemispherectomy(mob/living/carbon/victim, silent)
	return FALSE

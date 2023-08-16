/mob/living/carbon/human/examine(mob/user)
	//this is very slightly better than it was because you can use it more places. still can't do \his[src] though.
	var/t_He = p_they(TRUE)
	var/t_His = p_their(TRUE)
	var/t_his = p_their()
	var/t_him = p_them()
	var/t_has = p_have()
	var/t_is = p_are()

	var/obscure_name = FALSE
	var/obscure_examine = FALSE
	var/obscure_species = FALSE
	if(isliving(user))
		if(HAS_TRAIT(user, TRAIT_PROSOPAGNOSIA))
			obscure_name = TRUE
		if(HAS_TRAIT(src, TRAIT_INVISIBLE_MAN))
			obscure_name = TRUE
			obscure_species = TRUE
		if(HAS_TRAIT(src, TRAIT_UNKNOWN))
			obscure_name = TRUE
			obscure_species = TRUE
			obscure_examine = TRUE

	var/datum/flavor_holder/flavor_holder = GLOB.flavor_holders[name]
	var/species_name = flavor_holder?.custom_species_name || dna.species.name
	var/species_icon = icon2html(GLOB.species_examine_icons[obscure_species ? "Unknown" : initial(dna.species.name)], user)
	. = list("<span class='info'>[species_icon] This is <EM>[!obscure_name ? span_color(name, chat_color) : colorize_string("Unknown")], a [obscure_species ? "[span_color("Human", COLOR_GRAY)]?" : "[span_color(species_name, dna.species.chat_color)]!"]</EM>")
	if(obscure_examine)
		. += span_warning("You're struggling to make out any details...")
		.[length(.)] += "</span>" //closes info class without creating another line
		return

	var/obscured = check_obscured_slots()

	//lips
	var/obj/item/bodypart/shoeonhead = get_bodypart(BODY_ZONE_HEAD)
	if(shoeonhead)
		var/list/covered_lips = list()
		for(var/component_type in subtypesof(/datum/component/creamed))
			var/datum/component/creamed/coom = GetComponent(component_type)
			if(coom?.cover_lips)
				covered_lips += coom.cover_lips
		if((stat <= CONSCIOUS) && ((!client && !ai_controller) || HAS_TRAIT(src, TRAIT_DUMB)))
			covered_lips += span_color("drool", "#b6e7f5")
		if(LAZYLEN(covered_lips))
			. += "Mmm, [t_his] lips are covered with [english_list(covered_lips)]!"

	//head
	if(head && !(obscured & ITEM_SLOT_HEAD) && !(head.item_flags & EXAMINE_SKIP))
		. += "[t_He] [t_is] wearing [head.get_examine_string(user)] on [t_his] head."
	//uniform
	if(w_uniform && !(obscured & ITEM_SLOT_ICLOTHING) && !(w_uniform.item_flags & EXAMINE_SKIP))
		//accessory
		var/accessory_msg
		if(istype(w_uniform, /obj/item/clothing/under))
			var/obj/item/clothing/under/under = w_uniform
			if(under.attached_accessory && !(under.attached_accessory.item_flags & EXAMINE_SKIP))
				accessory_msg += " with [under.attached_accessory.get_examine_string(user)]"

		. += "[t_He] [t_is] wearing [w_uniform.get_examine_string(user)][accessory_msg]."
	//suit/armor
	if(wear_suit && !(obscured & ITEM_SLOT_OCLOTHING) && !(wear_suit.item_flags & EXAMINE_SKIP))
		. += "[t_He] [t_is] wearing [wear_suit.get_examine_string(user)]."
		//suit/armor storage
		if(s_store && !(obscured & ITEM_SLOT_SUITSTORE) && !(s_store.item_flags & EXAMINE_SKIP))
			. += "[t_He] [t_is] carrying [s_store.get_examine_string(user)] on [t_his] [wear_suit.name]."
	//back
	if(back && !(obscured & ITEM_SLOT_BACK) && !(back.item_flags & EXAMINE_SKIP))
		. += "[t_He] [t_has] [back.get_examine_string(user)] on [t_his] back."

	//hands
	if(!(obscured & ITEM_SLOT_HANDS))
		for(var/obj/item/held_thing in held_items)
			if(held_thing.item_flags & (ABSTRACT|EXAMINE_SKIP|HAND_ITEM))
				continue
			. += "[t_He] [t_is] holding [held_thing.get_examine_string(user)] in [t_his] [get_held_index_name(get_held_index_of_item(held_thing))]."

	//gloves
	if(!(obscured & ITEM_SLOT_GLOVES))
		if(gloves && !(gloves.item_flags & EXAMINE_SKIP))
			. += "[t_He] [t_has] [gloves.get_examine_string(user)] on [t_his] hands."
		else if(GET_ATOM_BLOOD_DNA_LENGTH(src) && blood_in_hands)
			if(num_hands)
				. += span_warning("[t_He] [t_has] [num_hands > 1 ? "" : "a "][span_bloody("<b>blood-stained</b>")] hand[num_hands > 1 ? "s" : ""]!")

	//handcuffed
	if(handcuffed && !(obscured && ITEM_SLOT_HANDCUFFED) && !(handcuffed.item_flags & EXAMINE_SKIP))
		. += span_warning("[t_He] [t_is] <b>restrained</b> with [handcuffed.get_examine_string(user)]!")

	//belt
	if(belt && !(obscured & ITEM_SLOT_BELT) && !(belt.item_flags & EXAMINE_SKIP))
		. += "[t_He] [t_has] [belt.get_examine_string(user)] about [t_his] waist."

	//shoes
	if(shoes && !(obscured & ITEM_SLOT_FEET)  && !(shoes.item_flags & EXAMINE_SKIP))
		. += "[t_He] [t_is] wearing [shoes.get_examine_string(user)] on [t_his] feet."

	//mask
	if(wear_mask && !(obscured & ITEM_SLOT_MASK)  && !(wear_mask.item_flags & EXAMINE_SKIP))
		. += "[t_He] [t_has] [wear_mask.get_examine_string(user)] on [t_his] face."

	if(wear_neck && !(obscured & ITEM_SLOT_NECK)  && !(wear_neck.item_flags & EXAMINE_SKIP))
		. += "[t_He] [t_is] wearing [wear_neck.get_examine_string(user)] around [t_his] neck."

	//eyes
	if(!(obscured & ITEM_SLOT_EYES))
		if(glasses  && !(glasses.item_flags & EXAMINE_SKIP))
			. += "[t_He] [t_has] [glasses.get_examine_string(user)] covering [t_his] eyes."
		else if(HAS_TRAIT(src, TRAIT_UNNATURAL_RED_GLOWY_EYES))
			. += span_warning("<B>[t_His] eyes are glowing with an [span_red("unnatural red aura")]!</B>")
		else if(HAS_TRAIT(src, TRAIT_BLOODSHOT_EYES))
			. += span_warning("<B>[t_His] eyes are [span_bloody("<b>bloodshot</b>")]!</B>")

	//ears
	if(ears && !(obscured & ITEM_SLOT_EARS) && !(ears.item_flags & EXAMINE_SKIP))
		. += "[t_He] [t_has] [ears.get_examine_string(user)] on [t_his] ears."

	//ID
	if(wear_id && !(wear_id.item_flags & EXAMINE_SKIP))
		. += "[t_He] [t_is] wearing [wear_id.get_examine_string(user)]."
		var/list/id_examine_strings = wear_id.get_id_examine_strings(user)
		if(LAZYLEN(id_examine_strings))
			. += id_examine_strings

	//Common traits
	var/list/trait_examines = common_trait_examine()
	if (LAZYLEN(trait_examines))
		. += trait_examines

	//Status effects
	var/list/status_examines = get_status_effect_examinations()
	if (LAZYLEN(status_examines))
		. += status_examines

	//genital handling. not on organ/on_owner_examine() because i want a pretty list.
	var/list/genital_strings = list()
	for(var/obj/item/organ/genital/genital in organs)
		if(!genital.bodypart_overlay?.can_draw_on_body(get_bodypart(check_zone(genital.zone)), src))
			continue
		genital_strings += genital.get_genital_examine()
	if(LAZYLEN(genital_strings))
		. += span_notice("[t_He] [t_has] [english_list(genital_strings)], on full display.")

	var/appears_dead = FALSE
	var/just_sleeping = FALSE
	if(stat == DEAD || HAS_TRAIT(src, TRAIT_FAKEDEATH))
		appears_dead = TRUE

		var/obj/item/clothing/glasses/glasses = get_item_by_slot(ITEM_SLOT_EYES)
		var/are_we_in_weekend_at_bernies = glasses?.tint && istype(buckled, /obj/vehicle/ridden/wheelchair)

		if(isliving(user) && (are_we_in_weekend_at_bernies || HAS_MIND_TRAIT(user, TRAIT_NAIVE)))
			just_sleeping = TRUE

	var/list/msg = list()

	if(nutrition < NUTRITION_LEVEL_STARVING - 50)
		msg += "[t_He] [t_is] severely malnourished.\n"
	else if(nutrition >= NUTRITION_LEVEL_FAT)
		if(user.nutrition < NUTRITION_LEVEL_STARVING - 50)
			msg += "[t_He] [t_is] plump and delicious looking - Like a fat little piggy. A tasty piggy.\n"
		else
			msg += "[t_He] [t_is] quite chubby.\n"

	if(pulledby?.grab_state)
		msg += "[t_He] [t_is] restrained by [pulledby]'s grip.\n"

	if((user != src) || !has_status_effect(/datum/status_effect/grouped/screwy_hud/fake_healthy)) //fake healthy
		var/temp
		if(user == src && has_status_effect(/datum/status_effect/grouped/screwy_hud/fake_crit))//fake damage
			temp = 50
		else
			temp = getBruteLoss()
		var/list/damage_desc = get_majority_bodypart_damage_desc()
		if(temp)
			if(temp < 25)
				msg += "[t_He] [t_has] minor [damage_desc[BRUTE]].\n"
			else if(temp < 50)
				msg += "[t_He] [t_has] <b>moderate</b> [damage_desc[BRUTE]]!\n"
			else
				msg += "<B>[t_He] [t_has] severe [damage_desc[BRUTE]]!</B>\n"

		temp = getFireLoss()
		if(temp)
			if(temp < 25)
				msg += "[t_He] [t_has] minor [damage_desc[BURN]].\n"
			else if (temp < 50)
				msg += "[t_He] [t_has] <b>moderate</b> [damage_desc[BURN]]!\n"
			else
				msg += "<B>[t_He] [t_has] severe [damage_desc[BURN]]!</B>\n"

		temp = getCloneLoss()
		if(temp)
			if(temp < 25)
				msg += "[t_He] [t_has] minor [damage_desc[CLONE]].\n"
			else if(temp < 50)
				msg += "[t_He] [t_has] <b>moderate</b> [damage_desc[CLONE]]!\n"
			else
				msg += "<b>[t_He] [t_has] severe [damage_desc[CLONE]]!</b>\n"

	var/list/missing = list(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	var/list/disabled = list()
	for(var/obj/item/bodypart/body_part as anything in bodyparts)
		if(body_part.bodypart_disabled)
			disabled += body_part
		missing -= body_part.body_zone
		for(var/obj/item/item in body_part.embedded_objects)
			msg += "<B>[t_He] [t_has] [item.get_examine_string(user)] [item.isEmbedHarmless() ?  "stuck to" : "embedded in"] [t_his] [body_part.name]!</B>\n"

		for(var/datum/wound/wound as anything in body_part.wounds)
			msg += "[wound.get_examine_description(user)]\n"

	for(var/obj/item/bodypart/body_part as anything in disabled)
		if(HAS_TRAIT(body_part, TRAIT_DISABLED_BY_WOUND))
			continue // skip if it's disabled by a wound (cuz we'll be able to see the bone sticking out!)
		msg += "<B>[t_His] [body_part.name] is limp and lifeless!</B>\n"

	//stores missing limbs
	var/l_limbs_missing = 0
	var/r_limbs_missing = 0
	for(var/zone in missing)
		if(zone == BODY_ZONE_HEAD)
			msg += "<span class='deadsay'><B>[t_His] [parse_zone(zone)] is missing!</B></span>\n"
			continue
		if(zone == BODY_ZONE_L_ARM || zone == BODY_ZONE_L_LEG)
			l_limbs_missing++
		else if(zone == BODY_ZONE_R_ARM || zone == BODY_ZONE_R_LEG)
			r_limbs_missing++

		msg += "<B>[t_His] [parse_zone(zone)] is missing!</B>\n"

	if(l_limbs_missing >= 2 && r_limbs_missing == 0)
		msg += "[t_He] look[p_s()] all right now.\n"
	else if(l_limbs_missing == 0 && r_limbs_missing >= 2)
		msg += "[t_He] really keep[p_s()] to the left.\n"
	else if(l_limbs_missing >= 2 && r_limbs_missing >= 2)
		msg += "[t_He] [p_do()]n't seem all there.\n"

	if(is_bleeding())
		var/list/obj/item/bodypart/bleeding_limbs = list()
		var/list/obj/item/bodypart/grasped_limbs = list()

		for(var/obj/item/bodypart/body_part as anything in bodyparts)
			if(body_part.get_modified_bleed_rate())
				bleeding_limbs += body_part
			if(body_part.grasped_by)
				grasped_limbs += body_part

		var/list/bleed_text
		if(appears_dead)
			bleed_text = list("<span class='deadsay'><B>Blood is visible in [t_his]")
		else
			bleed_text = list("<B>[t_He] [t_is] bleeding from [t_his]")

		var/list/bleeding_limb_names = list()
		for(var/obj/item/bodypart/body_part as anything in bleeding_limbs)
			bleeding_limb_names += body_part.plaintext_zone
		bleed_text += " [english_list(bleeding_limb_names)]"

		if(appears_dead)
			bleed_text += ", but it has pooled and is not flowing.</B></span>\n"
		else
			if(reagents.has_reagent(/datum/reagent/toxin/heparin, needs_metabolizing = TRUE))
				bleed_text += " incredibly quickly"

			bleed_text += "!</B>\n"

		if(length(grasped_limbs))
			var/list/grasped_limb_names = list()
			for(var/obj/item/bodypart/body_part as anything in grasped_limbs)
				grasped_limb_names += body_part.plaintext_zone
			bleed_text += "[t_He] [t_is] holding [t_his] [english_list(grasped_limb_names)] to slow the bleeding!\n"

		msg += bleed_text.Join()

	var/apparent_blood_volume = blood_volume
	if(HAS_TRAIT(src, TRAIT_USES_SKINTONES) && (skin_tone == "albino"))
		apparent_blood_volume -= 150 // enough to knock you down one tier
	switch(apparent_blood_volume)
		if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
			msg += "[t_He] [t_has] pale skin.\n"
		if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
			msg += "<b>[t_He] look[p_s()] like pale death.</b>\n"
		if(-INFINITY to BLOOD_VOLUME_BAD)
			msg += "[span_deadsay("<b>[t_He] resemble[p_s()] a crushed, empty juice pouch.</b>")]\n"

	if(!appears_dead)
		var/mob/living/living_user = user
		if(src != user)
			if(HAS_TRAIT(user, TRAIT_EMPATH))
				if (combat_mode)
					msg += "[t_He] seem[p_s()] to be on guard.\n"
				if (getOxyLoss() >= 10)
					msg += "[t_He] seem[p_s()] winded.\n"
				if (getToxLoss() >= 10)
					msg += "[t_He] seem[p_s()] sickly.\n"
				if (mob_mood.sanity <= SANITY_DISTURBED)
					msg += "[t_He] seem[p_s()] distressed.\n"
					living_user.add_mood_event("empath", /datum/mood_event/sad_empath, src)
				if (is_blind())
					msg += "[t_He] appear[p_s()] to be staring off into space.\n"
				if (HAS_TRAIT(src, TRAIT_DEAF))
					msg += "[t_He] appear[p_s()] to not be responding to noises.\n"
				if (bodytemperature > dna.species.bodytemp_heat_damage_limit)
					msg += "[t_He] [t_is] flushed and wheezing.\n"
				if (bodytemperature < dna.species.bodytemp_cold_damage_limit)
					msg += "[t_He] [t_is] shivering.\n"

			if(HAS_TRAIT(user, TRAIT_SPIRITUAL) && mind?.holy_role)
				msg += "[t_He] [t_has] a holy aura about [t_him].\n"
				living_user.add_mood_event("religious_comfort", /datum/mood_event/religiously_comforted)

		switch(stat)
			if(UNCONSCIOUS, HARD_CRIT)
				msg += "[t_He] [t_is]n't responding to anything around [t_him] and seem[p_s()] to be asleep.\n"
			if(SOFT_CRIT)
				msg += "[t_He] [t_is] barely conscious.\n"
			if(CONSCIOUS)
				if(shoeonhead && HAS_TRAIT(src, TRAIT_DUMB))
					msg += "[t_He] [t_has] a stupid expression on [t_his] face.\n"

		if(!ai_controller && get_organ_slot(ORGAN_SLOT_BRAIN))
			if(!key)
				msg += "[span_deadsay("[t_He] [t_is] totally catatonic. The stresses of life in deep-space must have been too much for [t_him]. Any recovery is unlikely.")]\n"
			else if(!client)
				msg += "[t_He] [t_has] a blank, absent-minded stare and appears completely unresponsive to anything. [t_He] may snap out of it soon.\n"
	else
		if(just_sleeping)
			msg += "[t_He] [t_is]n't responding to anything around [t_him] and seem[p_s()] to be asleep.\n"
		else
			msg += generate_death_examine_text()
			msg += "\n"

	var/scar_severity = 0
	for(var/datum/scar/scar as anything in all_scars)
		if(scar.is_visible(user))
			scar_severity += scar.severity

	switch(scar_severity)
		if(1 to 4)
			msg += "[span_tinynoticeital("[t_He] [t_has] visible scarring, you can look again to take a closer look...")]\n"
		if(5 to 8)
			msg += "[span_smallnoticeital("[t_He] [t_has] several bad scars, you can look again to take a closer look...")]\n"
		if(9 to 11)
			msg += "[span_notice("<i>[t_He] [t_has] significantly disfiguring scarring, you can look again to take a closer look...</i>")]\n"
		if(12 to INFINITY)
			msg += "[span_notice("<b><i>[t_He] [t_is] just absolutely fucked up, you can look again to take a closer look...</i></b>")]\n"

	if(length(msg))
		var/sane_msg = msg.Join("")
		sane_msg = replacetext(sane_msg, "\n", "", -2)
		sane_msg = span_warning(sane_msg)
		. += sane_msg

	var/perpname = get_face_name(get_id_name(""))
	var/has_sec_hud = HAS_TRAIT(user, TRAIT_SECURITY_HUD)
	var/has_med_hud = HAS_TRAIT(user, TRAIT_MEDICAL_HUD)
	if(perpname && (has_med_hud || has_sec_hud))
		var/datum/record/crew/target_record = find_record(perpname)
		if(target_record)
			. += "<span class='deptradio'>Rank:</span> [target_record.rank]\n\
				<a href='?src=[REF(src)];hud=1;photo_front=1;examine_time=[world.time]'>\[Front photo\]</a>\
				<a href='?src=[REF(src)];hud=1;photo_side=1;examine_time=[world.time]'>\[Side photo\]</a>"

		if(has_med_hud)
			var/cyberimp_detect
			for(var/obj/item/organ/cyberimp/cyberimp in organs)
				if(IS_ROBOTIC_ORGAN(cyberimp) && !(cyberimp.organ_flags & ORGAN_HIDDEN))
					cyberimp_detect += "[!cyberimp_detect ? "[cyberimp.get_examine_string(user)]" : ", [cyberimp.get_examine_string(user)]"]"
			if(cyberimp_detect)
				. += "<span class='notice ml-1'>Detected cybernetic modifications:</span>"
				. += "<span class='notice ml-2'>[cyberimp_detect]</span>"
			if(target_record)
				var/health_record = target_record.physical_status
				. += "<a href='?src=[REF(src)];hud=m;physical_status=1;examine_time=[world.time]'>\[[health_record]\]</a>"
				health_record = target_record.mental_status
				. += "<a href='?src=[REF(src)];hud=m;mental_status=1;examine_time=[world.time]'>\[[health_record]\]</a>"
			target_record = find_record(perpname)
			if(target_record)
				. += "<a href='?src=[REF(src)];hud=m;evaluation=1;examine_time=[world.time]'>\[Medical evaluation\]</a><br>"
			. += "<a href='?src=[REF(src)];hud=m;quirk=1;examine_time=[world.time]'>\[See quirks\]</a>"

		if(has_sec_hud)
			if((user != src) && (user.stat <= CONSCIOUS)) //Fluff: Sechuds have eye-tracking technology and sets 'arrest' to people that the wearer looks and blinks at.
				var/wanted_status = WANTED_NONE
				var/security_note = "None."

				target_record = find_record(perpname)
				if(target_record)
					wanted_status = target_record.wanted_status
					if(target_record.security_note)
						security_note = target_record.security_note

				. += "<span class='deptradio'>Criminal status:</span> <a href='?src=[REF(src)];hud=s;status=1;examine_time=[world.time]'>\[[wanted_status]\]</a>"
				. += "<span class='deptradio'>Important Notes: [security_note]"
				. += jointext(list("<span class='deptradio'>Security record:</span> <a href='?src=[REF(src)];hud=s;view=1;examine_time=[world.time]'>\[View\]</a>",
					"<a href='?src=[REF(src)];hud=s;add_citation=1;examine_time=[world.time]'>\[Add citation\]</a>",
					"<a href='?src=[REF(src)];hud=s;add_crime=1;examine_time=[world.time]'>\[Add crime\]</a>",
					"<a href='?src=[REF(src)];hud=s;add_note=1;examine_time=[world.time]'>\[Add note\]</a>"), "")
	else if(isobserver(user))
		. += span_info("<b>Traits:</b> [get_quirk_string(FALSE, CAT_QUIRK_ALL)]")
	.[length(.)] += "</span>" //closes info class without creating another line

	SEND_SIGNAL(src, COMSIG_ATOM_EXAMINE, user, .)

/**
 * Shows any and all examine text related to any status effects the user has.
 */
/mob/living/proc/get_status_effect_examinations()
	var/list/examine_list = list()

	for(var/datum/status_effect/effect as anything in status_effects)
		var/effect_text = effect.get_examine_text()
		if(!effect_text)
			continue

		examine_list += effect_text

	if(!length(examine_list))
		return

	return examine_list.Join("\n")

/mob/living/carbon/human/examine_more(mob/user)
	. = ..()
	if ((wear_mask && (wear_mask.flags_inv & HIDEFACE)) || (head && (head.flags_inv & HIDEFACE)))
		return
	var/age_text
	switch(age)
		if(-INFINITY to 25)
			age_text = "very young"
		if(26 to 35)
			age_text = "of adult age"
		if(36 to 55)
			age_text = "middle-aged"
		if(56 to 75)
			age_text = "rather old"
		if(76 to 100)
			age_text = "very old"
		if(101 to INFINITY)
			age_text = "withering away"
	. += span_notice("[p_they(TRUE)] appear[p_s()] to be [age_text].")

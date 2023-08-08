/mob/living/carbon/verb/set_genital_visibility()
	set name = "Expose/Hide genitals"
	set desc = "Adjust the visibility of your genitals, if any."
	set category = "IC"

	if(stat == DEAD)
		to_chat(usr, span_warning("You can't do that when you're dead!"))
		return

	var/list/genitals = list()
	for(var/obj/item/organ/genital/genital in organs)
		genitals += genital

	if(!length(genitals))
		to_chat(usr, span_warning("You don't have any genitals to adjust."))
		return

	var/obj/item/organ/genital/chosen_genital = tgui_input_list(src, "Choose the genital to adjust.", items = genitals)
	if(isnull(chosen_genital) || stat == DEAD || !(chosen_genital in organs))
		return

	var/chosen_visibility = tgui_input_list(src, "Choose the desired visibility.", items = GLOB.genital_visibility_list)
	if(isnull(chosen_genital) || stat == DEAD || !(chosen_genital in organs))
		return

	var/datum/bodypart_overlay/mutant/genital/overlay = chosen_genital.bodypart_overlay
	overlay.genital_visibility = GLOB.genital_visibility_list[chosen_visibility]
	update_body_parts()

/mob/living/carbon/verb/set_genital_arousal()
	set name = "Toggle Arousal"
	set desc = "Adjust the arousal of your genitals, if any."
	set category = "IC"

	if(stat == DEAD)
		to_chat(usr, span_warning("You can't do that when you're dead!"))
		return

	var/list/genitals = list()
	for(var/obj/item/organ/genital/genital in organs)
		var/datum/bodypart_overlay/mutant/genital/genital_overlay = genital.bodypart_overlay
		if(isnull(genital_overlay?.arousal_options))
			continue

		genitals += genital

	if(length(genitals) == 0)
		to_chat(usr, span_warning("You don't have any genitals to adjust."))
		return

	var/obj/item/organ/genital/chosen_genital = tgui_input_list(src, "Choose the genital to adjust.", items = genitals)
	if(isnull(chosen_genital) || stat == DEAD || !(chosen_genital in organs))
		return

	var/datum/bodypart_overlay/mutant/genital/genital_overlay = chosen_genital.bodypart_overlay
	var/chosen_arousal = tgui_input_list(src, "Choose the desired arousal.", items = genital_overlay.arousal_options)
	if(isnull(chosen_genital) || stat == DEAD || !(chosen_genital in organs))
		return

	var/datum/bodypart_overlay/mutant/genital/overlay = chosen_genital.bodypart_overlay
	overlay.arousal_state = overlay.arousal_options[chosen_arousal]
	update_body_parts()

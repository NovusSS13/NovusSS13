//there is no apply_to_silicon() proc nor do i want to implement one
//therefore this shitcode:
/mob/living/silicon/robot/apply_prefs_job(client/player_client, datum/job/job)
	. = ..() //you ever wonder why everyone does . = ..() when very often ..() is quite enough
	var/flavor_text = player_client?.prefs.read_preference(/datum/preference/text/cyborg_flavor_text)
	if(!flavor_text)
		return

	if(isnull(examine_panel))
		examine_panel = new(src, player_client.prefs)
		return
	examine_panel.cyborg_flavor_text = flavor_text

/mob/living/silicon/ai/apply_prefs_job(client/player_client, datum/job/job)
	. = ..()
	var/flavor_text = player_client?.prefs.read_preference(/datum/preference/text/ai_flavor_text)
	if(!flavor_text)
		return
	if(isnull(examine_panel))
		examine_panel = new(src, player_client.prefs)
		return
	examine_panel.ai_flavor_text = flavor_text

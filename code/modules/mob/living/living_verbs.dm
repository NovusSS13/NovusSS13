/mob/living/verb/set_temporary_flavor()
	set category = "IC"
	set name = "Set Temporary Flavor Text"
	set desc = "Allows you to set a temporary flavor text."

	if(stat != CONSCIOUS)
		to_chat(usr, span_warning("You must be concious to do this!"))
		return

	examine_panel ||= new(src, client.prefs)

	var/msg = tgui_input_text(usr, "Set the temporary flavor text in your 'examine' verb. This is for describing what people can tell by looking at your character.", "Temporary Flavor Text", examine_panel.temporary_flavor_text, max_length = 2048, multiline = TRUE)
	if(!msg)
		return

	examine_panel.temporary_flavor_text = msg

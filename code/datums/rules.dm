/**
 * This datum essentially handles the UI for rules. Most of the code is handled on the front end, this is a very simple datum.
 */
/datum/rules
	var/list/rules_list

/datum/rules/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Rules")
		ui.open()

/datum/rules/ui_state(mob/user)
	return GLOB.always_state

/datum/rules/ui_static_data(mob/user)
	var/list/data = list()

	var/list/categories = list()
	for(var/category in rules_list)
		var/list/this_category = list()

		this_category["name"] = category
		var/this_category_content = list()
		for(var/rule in rules_list[category])
			var/list/this_rule = list()

			this_rule["name"] = rule
			this_rule["content"] = jointext(rules_list[category][rule], "")

			this_category_content += list(this_rule)
		this_category["rules"] = this_category_content

		categories += list(this_category)
	data["categories"] = categories

	return data

/datum/rules/ui_close(mob/user)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(do_update_db), user)

/datum/rules/proc/do_update_db(mob/user)
	user.client?.update_flag_db(DB_FLAG_READ_RULES, TRUE)

/client/proc/delayed_rules_message()
	to_chat(src, span_warning("You have not read the rules yet! You should <a href='?src=[REF(src)];read_rules=1'>read them</a> before playing."))

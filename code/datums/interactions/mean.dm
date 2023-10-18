/datum/interaction/mean
	icon = "handshake"
	color = "bad"
	category = INTERACTION_CATEGORY_MEAN

/datum/interaction/mean/flipoff
	name = "Flip Them Off"
	desc = "Tell them to fuck off!"
	icon = "hand-middle-finger"
	message = span_warning("%USER flip%USER_S %TARGET off.")
	user_message = span_warning("You flip %TARGET off!")
	target_message = span_warning("%USER flip%USER_S you off!")
	user_hands_required = 1
	maximum_distance = 7

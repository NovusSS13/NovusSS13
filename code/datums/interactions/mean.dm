/datum/interaction/mean
	icon = "handshake"
	category = INTERACTION_CATEGORY_MEAN
	interaction_flags = INTERACTION_RESPECT_COOLDOWN

/datum/interaction/mean/middlefinger
	name = "Flip Them Off"
	desc = "Tell them to fuck off!"
	icon = "hand-middle-finger"
	message = span_warning("%USER flips %TARGET off.")
	user_message = span_warning("You flip %TARGET off!")
	target_message = span_warning("%USER flips you off!")
	user_hands_required = 1
	maximum_distance = 7

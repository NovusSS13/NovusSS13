/datum/voice/human/classic
	name = "Human (Classic)"

/datum/voice/human/classic/New()
	. = ..()
	emote_sounds[/datum/emote/living/carbon/human/scream] = list(
		MALE = list(
			'sound/voice/human/male_scream_alt1.ogg',
			'sound/voice/human/male_scream_alt2.ogg',
		),
		FEMALE = list(
			'sound/voice/human/female_scream_alt1.ogg',
			'sound/voice/human/female_scream_alt2.ogg',
			'sound/voice/human/female_scream_alt3.ogg',
		),
	)

/datum/voice/human/grim
	name = "Grim"

/datum/voice/human/grim/New()
	. = ..()
	emote_sounds[/datum/emote/living/laugh] = list(
		MALE = list(
			'sound/voice/human/poopdark/laugh_male1.ogg',
			'sound/voice/human/poopdark/laugh_male2.ogg',
			'sound/voice/human/poopdark/laugh_male3.ogg',
		),
		FEMALE = list(
			'sound/voice/human/poopdark/laugh_female1.ogg',
			'sound/voice/human/poopdark/laugh_female2.ogg',
			'sound/voice/human/poopdark/laugh_female3.ogg',
		),
	)
	emote_sounds[/datum/emote/living/carbon/human/scream] = list(
		MALE = list(
			'sound/voice/human/poopdark/terror_scream_male1.ogg',
			'sound/voice/human/poopdark/terror_scream_male2.ogg',
		),
		FEMALE = list(
			'sound/voice/human/poopdark/terror_scream_female1.ogg',
			'sound/voice/human/poopdark/terror_scream_female2.ogg',
		),
	)

/datum/voice/human/scientist
	name = "Scientist"

/datum/voice/human/scientist/New()
	. = ..()
	emote_sounds[/datum/emote/living/carbon/human/scream] = list(
		PLURAL = list(
			'sound/voice/human/scientist/scientist_scream1.ogg',
			'sound/voice/human/scientist/scientist_scream2.ogg',
			'sound/voice/human/scientist/scientist_scream3.ogg',
			'sound/voice/human/scientist/scientist_scream4.ogg',
			'sound/voice/human/scientist/scientist_scream5.ogg',
		),
	)

/datum/voice/human/cultist
	name = "Cultist"

/datum/voice/human/cultist/New()
	. = ..()
	emote_sounds[/datum/emote/living/laugh] = list(
		PLURAL = list(
			'sound/voice/human/cultist/cultist_laugh1.ogg',
			'sound/voice/human/cultist/cultist_laugh2.ogg',
			'sound/voice/human/cultist/cultist_laugh3.ogg',
			'sound/voice/human/cultist/cultist_laugh4.ogg',
			'sound/voice/human/cultist/cultist_laugh5.ogg',
			'sound/voice/human/cultist/cultist_laugh6.ogg',
			'sound/voice/human/cultist/cultist_laugh7.ogg',
			'sound/voice/human/cultist/cultist_laugh8.ogg',
		),
	)
	emote_sounds[/datum/emote/living/carbon/human/scream] = list(
		PLURAL = list(
			'sound/voice/human/cultist/cultist_scream1.ogg',
			'sound/voice/human/cultist/cultist_scream2.ogg',
			'sound/voice/human/cultist/cultist_scream3.ogg',
			'sound/voice/human/cultist/cultist_scream4.ogg',
			'sound/voice/human/cultist/cultist_scream5.ogg',
		),
	)

/datum/voice/human/cultist/get_preview_sound(gender)
	return 'sound/voice/human/cultist/iliveagain.ogg'

/datum/voice/monkey/alt
	name = "Monkey (Alt)"

/datum/voice/monkey/alt/New()
	. = ..()
	emote_sounds[/datum/emote/living/carbon/human/scream] = list(
		PLURAL = list(
			'sound/creatures/monkey/monkey_screech_alt.ogg',
		),
	)

/datum/voice/lizard/classic
	name = "Lizard (Classic)"
	emote_sounds = list(
		/datum/emote/living/carbon/human/scream = list(
			PLURAL = list(
				'sound/voice/lizard/lizard_scream_alt.ogg',
			),
		),
	)

/datum/voice/lizard/classic/New()
	. = ..()
	emote_sounds[/datum/emote/living/carbon/human/scream] = list(
		PLURAL = list(
			'sound/voice/lizard/lizard_scream_alt.ogg',
		),
	)

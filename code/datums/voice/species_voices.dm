/datum/voice/human
	name = "Human"

/datum/voice/human/get_sound_for_emote(datum/emote/emote, mob/living/user)
	var/emote_type = istype(emote) ? emote.type : emote
	if((emote_type == /datum/emote/living/carbon/human/scream) && ishuman(user))
		var/mob/living/carbon/human/human_user = user
		if((human_user.physique == MALE) && prob(1))
			return 'sound/voice/human/wilhelm_scream.ogg'
	return ..()

/datum/voice/human/felinid
	name = "Felinid"
	preview_emote = /datum/emote/living/laugh

/datum/voice/human/felinid/New()
	. = ..()
	emote_sounds[/datum/emote/living/laugh] = list(
		PLURAL = list(
			'sound/voice/human/nyahaha_1.ogg',
			'sound/voice/human/nyahaha_2.ogg',
			'sound/voice/human/nyahehe.ogg',
			'sound/voice/human/nyaha.ogg',
		),
	)

/datum/voice/monkey
	name = "Monkey"
	emote_sounds = list(
		/datum/emote/living/carbon/human/scream = list(
			PLURAL = list(
				'sound/creatures/monkey/monkey_screech_1.ogg',
				'sound/creatures/monkey/monkey_screech_2.ogg',
				'sound/creatures/monkey/monkey_screech_3.ogg',
				'sound/creatures/monkey/monkey_screech_4.ogg',
				'sound/creatures/monkey/monkey_screech_5.ogg',
				'sound/creatures/monkey/monkey_screech_6.ogg',
				'sound/creatures/monkey/monkey_screech_7.ogg',
			),
		),
	)

/datum/voice/lizard
	name = "Lizard"

/datum/voice/lizard/New()
	. = ..()
	emote_sounds[/datum/emote/living/carbon/human/scream] = list(
		PLURAL = list(
			'sound/voice/lizard/lizard_scream_1.ogg',
			'sound/voice/lizard/lizard_scream_2.ogg',
			'sound/voice/lizard/lizard_scream_3.ogg',
		),
	)

/datum/voice/moth
	name = "Moth"

/datum/voice/moth/New()
	. = ..()
	emote_sounds[/datum/emote/living/laugh] = list(
		PLURAL = list(
			'sound/voice/moth/laugh_moth.ogg',
		),
	)
	emote_sounds[/datum/emote/living/carbon/human/scream] = list(
		PLURAL = list(
			'sound/voice/moth/scream_moth.ogg',
		),
	)

/datum/voice/plasmaman
	name = "Plasmaman"

/datum/voice/plasmaman/New()
	. = ..()
	emote_sounds[/datum/emote/living/carbon/human/scream] = list(
		PLURAL = list(
			'sound/voice/plasmaman/plasmeme_scream_1.ogg',
			'sound/voice/plasmaman/plasmeme_scream_2.ogg',
			'sound/voice/plasmaman/plasmeme_scream_3.ogg',
		),
	)

/datum/voice/ethereal
	name = "Ethereal"
	emote_sounds = list(
		/datum/emote/living/carbon/human/scream = list(
			PLURAL = list(
				'sound/voice/ethereal/ethereal_scream_1.ogg',
				'sound/voice/ethereal/ethereal_scream_2.ogg',
				'sound/voice/ethereal/ethereal_scream_3.ogg',
			),
		),
	)

/datum/voice/ethereal/New()
	. = ..()
	emote_sounds[/datum/emote/living/carbon/human/scream] = list(
		PLURAL = list(
			'sound/voice/ethereal/ethereal_scream_1.ogg',
			'sound/voice/ethereal/ethereal_scream_2.ogg',
			'sound/voice/ethereal/ethereal_scream_3.ogg',
		),
	)

/datum/voice/ethereal/lustrous
	name = "Lustrous"

/datum/voice/ethereal/lustrous/New()
	. = ..()
	emote_sounds[/datum/emote/living/carbon/human/scream] = list(
		PLURAL = list(
			'sound/voice/ethereal/lustrous_scream_1.ogg',
			'sound/voice/ethereal/lustrous_scream_2.ogg',
			'sound/voice/ethereal/lustrous_scream_3.ogg',
		),
	)

/datum/voice/jelly
	name = "Jelly"

/datum/voice/jelly/New()
	. = ..()
	emote_sounds[/datum/emote/living/carbon/human/scream] = list(
		PLURAL = list(
			'sound/voice/jelly/jelly_scream.ogg',
		),
	)

/datum/voice/mutant
	name = "Beast"

/datum/voice/mutant/New()
	. = ..()
	//i could not for the life of me, find female laughing sounds - so you get male for both fuck you
	emote_sounds[/datum/emote/living/laugh] = list(
		PLURAL = list(
			'sound/voice/mutant/oblivion/male_beast_laugh_1.ogg',
			'sound/voice/mutant/oblivion/male_beast_laugh_2.ogg',
			'sound/voice/mutant/oblivion/male_beast_laugh_3.ogg',
			'sound/voice/mutant/oblivion/male_beast_laugh_4.ogg',
			'sound/voice/mutant/oblivion/male_beast_laugh_5.ogg',
			'sound/voice/mutant/oblivion/male_beast_laugh_6.ogg',
			'sound/voice/mutant/oblivion/male_beast_laugh_7.ogg',
			'sound/voice/mutant/oblivion/male_beast_laugh_8.ogg',
			'sound/voice/mutant/oblivion/male_beast_laugh_9.ogg',
		),
	)
	emote_sounds[/datum/emote/living/carbon/human/scream] = list(
		MALE = list(
			'sound/voice/mutant/morrowind/male_beast_scream_1.ogg',
			'sound/voice/mutant/morrowind/male_beast_scream_2.ogg',
			'sound/voice/mutant/morrowind/male_beast_scream_3.ogg',
			'sound/voice/mutant/morrowind/male_beast_scream_4.ogg',
			'sound/voice/mutant/morrowind/male_beast_scream_5.ogg',
			'sound/voice/mutant/morrowind/male_beast_scream_6.ogg',
			'sound/voice/mutant/morrowind/male_beast_scream_7.ogg',
			'sound/voice/mutant/morrowind/male_beast_scream_8.ogg',
			'sound/voice/mutant/morrowind/male_beast_scream_9.ogg',
			'sound/voice/mutant/morrowind/male_beast_scream_10.ogg',
		),
		FEMALE = list(
			'sound/voice/mutant/morrowind/female_beast_scream_1.ogg',
			'sound/voice/mutant/morrowind/female_beast_scream_2.ogg',
			'sound/voice/mutant/morrowind/female_beast_scream_3.ogg',
			'sound/voice/mutant/morrowind/female_beast_scream_4.ogg',
			'sound/voice/mutant/morrowind/female_beast_scream_5.ogg',
			'sound/voice/mutant/morrowind/female_beast_scream_6.ogg',
			'sound/voice/mutant/morrowind/female_beast_scream_7.ogg',
			'sound/voice/mutant/morrowind/female_beast_scream_8.ogg',
			'sound/voice/mutant/morrowind/female_beast_scream_9.ogg',
			'sound/voice/mutant/morrowind/female_beast_scream_10.ogg',
		),
	)
	//male "dying" sounds were just better and more beastlike, so you get no female ones here
	emote_sounds[/datum/emote/living/deathgasp] = list(
		PLURAL = list(
			'sound/voice/mutant/oblivion/male_beast_deathgasp_1.ogg',
			'sound/voice/mutant/oblivion/male_beast_deathgasp_2.ogg',
		),
	)

/datum/voice/mutant/get_preview_sound(gender)
	if(gender == FEMALE)
		return 'sound/voice/mutant/morrowind/female_beast_greetings.ogg'
	return 'sound/voice/mutant/morrowind/male_beast_greetings.ogg'

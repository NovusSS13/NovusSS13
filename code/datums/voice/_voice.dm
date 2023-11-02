/// A singleton datum used to store sounds for mob emotes, very simple stuff
/datum/voice
	/// The name of this voice pack
	var/name
	/// An associative list of emote typepaths to lists possible sounds, indexed by physique
	var/list/emote_sounds = list(
		/datum/emote/living/laugh = list(
			MALE = list(
				'sound/voice/human/manlaugh1.ogg',
				'sound/voice/human/manlaugh2.ogg',
			),
			FEMALE = list(
				'sound/voice/human/womanlaugh.ogg',
			),
		),
		/datum/emote/living/gasp = list(
			MALE = list(
				'sound/voice/human/gasp_male1.ogg',
				'sound/voice/human/gasp_male2.ogg',
			),
			FEMALE = list(
				'sound/voice/human/gasp_female1.ogg',
				'sound/voice/human/gasp_female2.ogg',
				'sound/voice/human/gasp_female3.ogg',
			),
		),
		/datum/emote/living/gasp_shock = list(
			MALE = list(
				'sound/voice/human/gasp_male1.ogg',
				'sound/voice/human/gasp_male2.ogg',
			),
			FEMALE = list(
				'sound/voice/human/gasp_female1.ogg',
				'sound/voice/human/gasp_female2.ogg',
				'sound/voice/human/gasp_female3.ogg',
			),
		),
		/datum/emote/living/carbon/human/scream = list(
			MALE = list(
				'sound/voice/human/malescream_1.ogg',
				'sound/voice/human/malescream_2.ogg',
				'sound/voice/human/malescream_3.ogg',
				'sound/voice/human/malescream_4.ogg',
				'sound/voice/human/malescream_5.ogg',
				'sound/voice/human/malescream_6.ogg',
			),
			FEMALE = list(
				'sound/voice/human/femalescream_1.ogg',
				'sound/voice/human/femalescream_2.ogg',
				'sound/voice/human/femalescream_3.ogg',
				'sound/voice/human/femalescream_4.ogg',
				'sound/voice/human/femalescream_5.ogg',
			),
		),
	)
	/// Emote we use for sound preview
	var/preview_emote = /datum/emote/living/carbon/human/scream

/datum/voice/proc/get_sound_for_emote(datum/emote/emote, mob/living/user)
	var/emote_type = istype(emote) ? emote.type : emote
	var/sounds_list = LAZYACCESS(emote_sounds, emote_type)
	if(!sounds_list)
		return
	var/gender = user.gender
	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		gender = human_user.physique
	else
		gender = user.gender
	if(sounds_list[gender])
		return pick(sounds_list[gender])
	return pick(sounds_list[sounds_list[1]])

/datum/voice/proc/get_preview_sound(gender = MALE)
	var/sounds_list = LAZYACCESS(emote_sounds, preview_emote)
	if(isnull(sounds_list))
		return
	if(sounds_list[gender])
		return sounds_list[gender][1]
	return sounds_list[sounds_list[1]][1]

/datum/voice/none
	name = "Silent"
	emote_sounds = list()

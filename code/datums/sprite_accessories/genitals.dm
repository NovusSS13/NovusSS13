/datum/sprite_accessory/genital
	/// Whether or not this piece of shit has a skintoned version
	var/supports_skintones = TRUE
	/// The text that shows up in organ/get_genital_examine()
	var/examine_name_override = null


/datum/sprite_accessory/genital/penis
	icon = 'icons/mob/species/genitals/penis_onmob.dmi'
	center = TRUE

/datum/sprite_accessory/genital/penis/human
	name = "Human"
	icon_state = "human"

/datum/sprite_accessory/genital/penis/knotted
	name = "Knotted"
	icon_state = "knotted"

/datum/sprite_accessory/genital/penis/flared
	name = "Flared"
	icon_state = "flared"

/datum/sprite_accessory/genital/penis/barbknot
	name = "Barbed, Knotted"
	icon_state = "barbknot"

/datum/sprite_accessory/genital/penis/tapered
	name = "Tapered"
	icon_state = "tapered"

/datum/sprite_accessory/genital/penis/tentacle
	name = "Tentacled"
	icon_state = "tentacle"

/datum/sprite_accessory/genital/penis/hemi
	name = "Hemi"
	icon_state = "hemi"

/datum/sprite_accessory/genital/penis/hemiknot
	name = "Hemi, Knotted"
	icon_state = "hemiknot"



/datum/sprite_accessory/genital/testicles
	icon = 'icons/mob/species/genitals/testicles_onmob.dmi'

/datum/sprite_accessory/genital/testicles/pair
	name = "Pair"
	icon_state = "pair"


/datum/sprite_accessory/genital/vagina
	icon = 'icons/mob/species/genitals/vagina_onmob.dmi'

/datum/sprite_accessory/genital/vagina/human
	name = "Human"
	icon_state = "human"

/datum/sprite_accessory/genital/vagina/tentacles
	name = "Tentacle"
	icon_state = "tentacle"

/datum/sprite_accessory/genital/vagina/dentata
	name = "Dentata"
	icon_state = "dentata"

/datum/sprite_accessory/genital/vagina/hairy
	name = "Hairy"
	icon_state = "hairy"

/datum/sprite_accessory/genital/vagina/spade
	name = "Spade"
	icon_state = "spade"

/datum/sprite_accessory/genital/vagina/furred
	name = "Furred"
	icon_state = "furred"

/datum/sprite_accessory/genital/vagina/gaping
	name = "Gaping"
	icon_state = "gaping"

/datum/sprite_accessory/genital/vagina/cloaca
	name = "Cloaca"
	icon_state = "cloaca"
	examine_name_override = "cloaca" //yes, this var exists only for this.


/datum/sprite_accessory/genital/breasts
	icon = 'icons/mob/species/genitals/breasts_onmob.dmi'
	/// Maximum size this titty accessory can reach, visually at least
	var/max_size = 16

/datum/sprite_accessory/genital/breasts/pair
	name = "Pair"
	icon_state = "pair"
	examine_name_override = "a pair"

/datum/sprite_accessory/genital/breasts/quad
	name = "Quad"
	icon_state = "quad"
	max_size = 5
	examine_name_override = "two pairs"

/datum/sprite_accessory/genital/breasts/sextuple
	name = "Sextuple"
	icon_state = "sextuple"
	max_size = 5
	examine_name_override = "a sextuplet"

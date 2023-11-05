/datum/sprite_accessory/tails
	default_color = 1
	default_colors = list(COLOR_ORANGE, COLOR_SOFT_RED, COLOR_WHITE)
	/**
	 * Whether or not we can wag
	 * Not about actually preventing the emote, it's just for sprite updates
	 */
	var/can_wag = FALSE

/datum/sprite_accessory/tails/lizard
	icon = 'icons/mob/human/species/lizard/lizard_tails.dmi'
	feature_suffix = "lizard"
	color_amount = 1
	can_wag = TRUE

/datum/sprite_accessory/tails/lizard/smooth
	name = "Smooth"
	icon_state = "smooth"

/datum/sprite_accessory/tails/lizard/dtiger
	name = "Dark Tiger"
	icon_state = "dtiger"

/datum/sprite_accessory/tails/lizard/ltiger
	name = "Light Tiger"
	icon_state = "ltiger"

/datum/sprite_accessory/tails/lizard/spikes
	name = "Spikes"
	icon_state = "spikes"

/datum/sprite_accessory/tails/human
	icon = 'icons/mob/human/sprite_accessory/cat_features.dmi'
	color_amount = 1

/datum/sprite_accessory/tails/human/cat
	name = "Cat"
	icon_state = "default"
	feature_suffix = "cat"

/datum/sprite_accessory/tails/monkey
	color_amount = 0
	feature_suffix = "monkey"

/datum/sprite_accessory/tails/monkey/default
	name = "Monkey"
	icon = 'icons/mob/human/species/monkey/monkey_tail.dmi'
	icon_state = "default"

/// MUTANT SPRITES

/datum/sprite_accessory/tails/mutant
	icon = 'icons/mob/human/species/mutant/tails_mutant.dmi'
	color_amount = 3

/datum/sprite_accessory/tails/mutant/wagging
	/* ENABLE THIS WHEN THE SPRITE FILE IS UNFUCKED... SOMEHOW
	can_wag = TRUE
	*/

/datum/sprite_accessory/tails/mutant/wagging/big
	icon = 'icons/mob/human/species/mutant/tails_mutant_big.dmi'
	dimension_x = 64
	center = TRUE

/datum/sprite_accessory/tails/mutant/wagging/avian
	name = "Avian"
	icon_state = "avian1"

/datum/sprite_accessory/tails/mutant/wagging/avian/alt
	name = "Avian (Alt)"
	icon_state = "avian2"

/datum/sprite_accessory/tails/mutant/wagging/axolotl
	name = "Axolotl"
	icon_state = "axolotl"

/datum/sprite_accessory/tails/mutant/wagging/bat_long
	name = "Bat (Long)"
	icon_state = "batl"

/datum/sprite_accessory/tails/mutant/wagging/bat_short
	name = "Bat (Short)"
	icon_state = "bats"

/datum/sprite_accessory/tails/mutant/wagging/cable
	name = "Cable"
	icon_state = "cable"

/datum/sprite_accessory/tails/mutant/wagging/bee
	name = "Bee"
	icon_state = "bee"

/datum/sprite_accessory/tails/mutant/wagging/queenbee
	name = "Queen Bee"
	icon_state = "queenbee"

/datum/sprite_accessory/tails/mutant/wagging/cat_big
	name = "Cat (Big)"
	icon_state = "catbig"
	color_amount = 1

/datum/sprite_accessory/tails/mutant/wagging/cat_double
	name = "Cat (Double)"
	icon_state = "twocat"

/datum/sprite_accessory/tails/mutant/wagging/cat_triple
	name = "Cat (Triple)"
	icon_state = "threecat"

/datum/sprite_accessory/tails/mutant/wagging/corvid
	name = "Corvid"
	icon_state = "crow"

/datum/sprite_accessory/tails/mutant/wagging/cow
	name = "Cow"
	icon_state = "cow"

/datum/sprite_accessory/tails/mutant/wagging/data_shark
	name = "Data shark"
	icon_state = "datashark"

/datum/sprite_accessory/tails/mutant/deer
	name = "Deer"
	icon_state = "deer"

/datum/sprite_accessory/tails/mutant/wagging/deer_two
	name = "Deer II"
	icon_state = "deer_two"
	color_amount = 1

/datum/sprite_accessory/tails/mutant/wagging/eevee
	name = "Eevee"
	icon_state = "eevee"

/datum/sprite_accessory/tails/mutant/wagging/fennec
	name = "Fennec"
	icon_state = "fennec"

/datum/sprite_accessory/tails/mutant/wagging/fox
	name = "Fox"
	icon_state = "fox"

/datum/sprite_accessory/tails/mutant/wagging/fox/alt_1
	name = "Fox (Alt 1)"
	icon_state = "fox2"

/datum/sprite_accessory/tails/mutant/wagging/fox/alt_2
	name = "Fox (Alt 2)"
	icon_state = "fox3"

/datum/sprite_accessory/tails/mutant/wagging/guilmon
	name = "Guilmon"
	icon_state = "guilmon"

/datum/sprite_accessory/tails/mutant/wagging/hawk
	name = "Hawk"
	icon_state = "hawk"

/datum/sprite_accessory/tails/mutant/wagging/horse
	name = "Horse"
	icon_state = "horse"
	color_amount = 1

/datum/sprite_accessory/tails/mutant/wagging/husky
	name = "Husky"
	icon_state = "husky"

/datum/sprite_accessory/tails/mutant/wagging/insect
	name = "Insect"
	icon_state = "insect"

/datum/sprite_accessory/tails/mutant/wagging/queeninsect
	name = "Queen Insect"
	icon_state = "queeninsect"

/datum/sprite_accessory/tails/mutant/wagging/kangaroo
	name = "Kangaroo"
	icon_state = "kangaroo"

/datum/sprite_accessory/tails/mutant/wagging/kitsune
	name = "Kitsune"
	icon_state = "kitsune"

/datum/sprite_accessory/tails/mutant/wagging/lunasune
	name = "Kitsune (Lunasune)"
	icon_state = "lunasune"
	color_amount = 1

/datum/sprite_accessory/tails/mutant/wagging/kitsune/sabresune
	name = "Kitsune (Sabresune)"
	icon_state = "sabresune"

/datum/sprite_accessory/tails/mutant/wagging/kitsune/septuple
	name = "Kitsune (Septuple)"
	icon_state = "sevenkitsune"

/datum/sprite_accessory/tails/mutant/wagging/kitsune/tamamo
	name = "Kitsune (Tamamo)"
	icon_state = "9sune"

/datum/sprite_accessory/tails/mutant/wagging/lab
	name = "Labrador"
	icon_state = "lab"

/datum/sprite_accessory/tails/mutant/wagging/leopard
	name = "Leopard"
	icon_state = "leopard"

/datum/sprite_accessory/tails/mutant/wagging/murid
	name = "Murid"
	icon_state = "murid"

/datum/sprite_accessory/tails/mutant/wagging/murid_two
	name = "Murid II"
	icon_state = "murid_two"

/datum/sprite_accessory/tails/mutant/wagging/orca
	name = "Orca"
	icon_state = "orca"

/datum/sprite_accessory/tails/mutant/wagging/otie
	name = "Otusian"
	icon_state = "otie"

/datum/sprite_accessory/tails/mutant/wagging/plug
	name = "Plug"
	icon_state = "plugtail"

/datum/sprite_accessory/tails/mutant/wagging/rabbit
	name = "Rabbit"
	icon_state = "rabbit"

/datum/sprite_accessory/tails/mutant/wagging/rabbit/alt
	name = "Rabbit (Alt)"
	icon_state = "rabbit_alt"

/datum/sprite_accessory/tails/mutant/raptor
	name = "Raptor"
	icon_state = "raptor"

/datum/sprite_accessory/tails/mutant/wagging/red_panda
	name = "Red Panda"
	icon_state = "wah"

/datum/sprite_accessory/tails/mutant/wagging/pede
	name = "Scolipede"
	icon_state = "pede"

/datum/sprite_accessory/tails/mutant/wagging/segmented
	name = "Segmented"
	icon_state = "segmentedtail"

/datum/sprite_accessory/tails/mutant/wagging/sergal
	name = "Sergal"
	icon_state = "sergal"

/datum/sprite_accessory/tails/mutant/wagging/servelyn
	name = "Servelyn"
	icon_state = "tiger2"

/datum/sprite_accessory/tails/mutant/wagging/big/shade
	name = "Shade"
	icon_state = "shadekin_large"
	color_amount = 3

/datum/sprite_accessory/tails/mutant/wagging/big/shade/long
	name = "Shade (Long)"
	icon_state = "shadekinlong_large"

/datum/sprite_accessory/tails/mutant/wagging/big/shade/striped
	name = "Shade (Striped)"
	icon_state = "shadekinlongstriped_large"

/datum/sprite_accessory/tails/mutant/wagging/akula
	name = "Akula"
	icon_state = "akula"

/datum/sprite_accessory/tails/mutant/wagging/shark
	name = "Shark"
	icon_state = "shark"

/datum/sprite_accessory/tails/mutant/wagging/shark_no_fin
	name = "Shark (No Fin)"
	icon_state = "sharknofin"

/datum/sprite_accessory/tails/mutant/wagging/fish
	name = "Fish"
	icon_state = "fish"

/datum/sprite_accessory/tails/mutant/wagging/shepherd
	name = "Shepherd"
	icon_state = "shepherd"

/datum/sprite_accessory/tails/mutant/wagging/skunk
	name = "Skunk"
	icon_state = "skunk"

/datum/sprite_accessory/tails/mutant/wagging/snake
	name = "Snake"
	icon_state = "snaketail"
	color_amount = 1

/datum/sprite_accessory/tails/mutant/wagging/snake_dual
	name = "Snake (Dual)"
	icon_state = "snakedual"

/datum/sprite_accessory/tails/mutant/wagging/snake_stripe
	name = "Snake (Stripe)"
	icon_state = "snakestripe"

/datum/sprite_accessory/tails/mutant/wagging/snake_stripe_alt
	name = "Snake (Stripe Alt)"
	icon_state = "snakestripealt"

/datum/sprite_accessory/tails/mutant/wagging/snake_under
	name = "Snake (Undertail color)"
	icon_state = "snakeunder"

/datum/sprite_accessory/tails/mutant/wagging/squirrel
	name = "Squirrel"
	icon_state = "squirrel"
	color_amount = 1

/datum/sprite_accessory/tails/mutant/wagging/stripe
	name = "Stripe"
	icon_state = "stripe"

/datum/sprite_accessory/tails/mutant/wagging/straight
	name = "Straight Tail"
	icon_state = "straighttail"

/datum/sprite_accessory/tails/mutant/wagging/spade
	name = "Succubus Spade Tail"
	icon_state = "spade"

/datum/sprite_accessory/tails/mutant/wagging/tailmaw
	name = "Tailmaw"
	icon_state = "tailmaw"
	color_amount = 1

/datum/sprite_accessory/tails/mutant/wagging/tailmaw/wag
	name = "Tailmaw (Wag)"
	icon_state = "tailmawwag"

/datum/sprite_accessory/tails/mutant/wagging/tentacle
	name = "Tentacle"
	icon_state = "tentacle"

/datum/sprite_accessory/tails/mutant/wagging/tiger
	name = "Tiger"
	icon_state = "tiger"

/datum/sprite_accessory/tails/mutant/wagging/wolf
	name = "Wolf"
	icon_state = "wolf"
	color_amount = 1

/datum/sprite_accessory/tails/mutant/wagging/zorgoia
	name = "Zorgoia tail"
	icon_state = "zorgoia"

/datum/sprite_accessory/tails/mutant/reptileslim
	name = "Slim reptile"
	icon_state = "reptileslim"
	color_amount = 1

/datum/sprite_accessory/tails/mutant/wagging/australian_shepherd
	name = "Australian Shepherd"
	icon_state = "australianshepherd"

/// A screenshot test for every humanoid species with a handful of jobs.
/datum/unit_test/screenshot_humanoids

/datum/unit_test/screenshot_humanoids/Run()
	var/static/list/pre_tested_species = list(
		/datum/species/lizard,
		/datum/species/lizard/ashwalker,
		/datum/species/lizard/silverscale,
		/datum/species/moth,
		/datum/species/mutant,
	)
	// Test lizards as their own thing so we can get more coverage on their features
	var/mob/living/carbon/human/lizard = allocate(/mob/living/carbon/human/dummy/consistent)
	lizard.dna.features["mcolor"] = "#009999"
	lizard.dna.features["tail"] = "Light Tiger"
	lizard.dna.features["tail_color"] = "#009999"
	lizard.dna.features["spines"] = "Long"
	lizard.dna.features["spines_color"] = "#009999"
	lizard.dna.features["snout"] = "Sharp + Light"
	lizard.dna.features["snout_color"] = "#009999"
	lizard.dna.features["horns"] = "Simple"
	lizard.dna.features["horns_color"] = COLOR_WHITE
	lizard.dna.features["frills"] = "Aquatic"
	lizard.dna.features["frills_color"] = "#009999"
	lizard.dna.features["legs"] = LEGS_NORMAL
	lizard.set_species(/datum/species/lizard)
	lizard.equipOutfit(/datum/outfit/job/engineer, visualsOnly = TRUE)
	test_screenshot("[/datum/species/lizard]", get_flat_icon_for_all_directions(lizard))

	// Ashwalkers for the same reason
	var/mob/living/carbon/human/ashwalker = allocate(/mob/living/carbon/human/dummy/consistent)
	ashwalker.dna.features["mcolor"] = "#990000"
	ashwalker.dna.features["tail"] = "Light Tiger"
	ashwalker.dna.features["tail_color"] = "#990000"
	ashwalker.dna.features["spines"] = "Long"
	ashwalker.dna.features["spines_color"] = "#990000"
	ashwalker.dna.features["snout"] = "Sharp + Light"
	ashwalker.dna.features["snout_color"] = "#990000"
	ashwalker.dna.features["horns"] = "Simple"
	ashwalker.dna.features["horns_color"] = COLOR_WHITE
	ashwalker.dna.features["frills"] = "Aquatic"
	ashwalker.dna.features["frills_color"] = "#990000"
	ashwalker.dna.features["legs"] = LEGS_DIGITIGRADE
	ashwalker.set_species(/datum/species/lizard/ashwalker)
	ashwalker.equipOutfit(/datum/outfit/ashwalker/spear, visualsOnly = TRUE)
	test_screenshot("[/datum/species/lizard/ashwalker]", get_flat_icon_for_all_directions(ashwalker))

	// Silverscales for the same reason
	var/mob/living/carbon/human/silverscale = allocate(/mob/living/carbon/human/dummy/consistent)
	silverscale.dna.features["mcolor"] = "#eeeeee"
	silverscale.dna.features["tail"] = "Smooth"
	silverscale.dna.features["tail_color"] = "#eeeeee"
	silverscale.dna.features["spines"] = "Short + Membrane"
	silverscale.dna.features["spines_color"] = "#eeeeee"
	silverscale.dna.features["snout"] = "Sharp + Light"
	silverscale.dna.features["snout_color"] = "#eeeeee"
	silverscale.dna.features["horns"] = "Simple"
	silverscale.dna.features["horns_color"] = COLOR_WHITE
	silverscale.dna.features["frills"] = "Aquatic"
	silverscale.dna.features["frills_color"] = "#eeeeee"
	silverscale.dna.features["legs"] = LEGS_NORMAL
	silverscale.set_species(/datum/species/lizard/silverscale)
	silverscale.equipOutfit(/datum/outfit/pirate/silverscale/captain, visualsOnly = TRUE)
	test_screenshot("[/datum/species/lizard/silverscale]", get_flat_icon_for_all_directions(silverscale))

	// let me have this
	var/mob/living/carbon/human/moth = allocate(/mob/living/carbon/human/dummy/consistent)
	moth.dna.features["moth_antennae"] = "Firewatch"
	moth.dna.features["moth_wings"] = "Firewatch"
	moth.set_species(/datum/species/moth)
	moth.equipOutfit(/datum/outfit/job/cmo, visualsOnly = TRUE)
	test_screenshot("[/datum/species/moth]", get_flat_icon_for_all_directions(moth))

	// Muties are a nightmare, so uhhh here is susie deltarune
	var/mob/living/carbon/human/mutant = allocate(/mob/living/carbon/human/dummy/consistent)
	mutant.set_haircolor("#291420", update = FALSE)
	mutant.set_hairstyle("Long Bedhead", update = FALSE)
	mutant.gender = FEMALE
	mutant.physique = FEMALE
	mutant.dna.features["mcolor"] = "#AF67AF"
	mutant.dna.features["tail"] = "Smooth"
	mutant.dna.features["tail_color"] = "#AF67AF"
	mutant.dna.features["spines"] = SPRITE_ACCESSORY_NONE
	mutant.dna.features["spines_color"] = "#AF67AF"
	mutant.dna.features["snout"] = "Round"
	mutant.dna.features["snout_color"] = "#AF67AF"
	mutant.dna.features["horns"] = SPRITE_ACCESSORY_NONE
	mutant.dna.features["horns_color"] = COLOR_WHITE
	mutant.dna.features["frills"] = SPRITE_ACCESSORY_NONE
	mutant.dna.features["frills_color"] = "#AF67AF"
	mutant.dna.features["ears"] = SPRITE_ACCESSORY_NONE
	mutant.dna.features["ears_color"] = "#AF67AF"
	mutant.dna.features["legs"] = LEGS_NORMAL
	mutant.set_species(/datum/species/mutant)
	mutant.equipOutfit(/datum/outfit/job/janitor, visualsOnly = TRUE)
	test_screenshot("[/datum/species/mutant]", get_flat_icon_for_all_directions(mutant))

	// The rest of the species
	for (var/species_type as anything in subtypesof(/datum/species) - pre_tested_species)
		test_screenshot("[species_type]", get_flat_icon_for_all_directions(make_dummy(species_type, /datum/outfit/job/assistant/consistent)))

/datum/unit_test/screenshot_humanoids/proc/make_dummy(species, job_outfit)
	var/mob/living/carbon/human/dummy/consistent/dummy = allocate(/mob/living/carbon/human/dummy/consistent)
	dummy.set_species(species)
	dummy.equipOutfit(job_outfit, visualsOnly = TRUE)
	return dummy

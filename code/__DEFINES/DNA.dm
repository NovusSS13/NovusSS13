/*ALL DNA AND GENETICS-RELATED DEFINES GO HERE*/

#define CHECK_DNA_AND_SPECIES(C) if(!(C.dna?.species)) return

#define UE_CHANGED "ue changed"
#define UI_CHANGED "ui changed"
#define UF_CHANGED "uf changed"

#define CHAMELEON_MUTATION_DEFAULT_TRANSPARENCY 204

// String identifiers for associative list lookup

//Types of usual mutations
#define POSITIVE 1
#define NEGATIVE 2
#define MINOR_NEGATIVE 4

//Mutation classes. Normal being on them, extra being additional mutations with instability and other being stuff you dont want people to fuck with like wizard mutate
/// A mutation that can be activated and deactived by completing a sequence
#define MUT_NORMAL 1
/// A mutation that is in the mutations tab, and can be given and taken away through though the DNA console. Has a 0 before it's name in the mutation section of the dna console
#define MUT_EXTRA 2
/// Cannot be interacted with by players through normal means. I.E. wizards mutate
#define MUT_OTHER 3

//DNA block size defines - Because fuck you and your magic numbers being all over the codebase.
#define DNA_BLOCK_SIZE 3
#define DNA_BLOCK_SIZE_COLOR DEFAULT_HEX_COLOR_LEN
#define DNA_BLOCK_SIZE_TRICOLOR DEFAULT_HEX_COLOR_LEN * 3

#define DNA_GENDER_BLOCK 1
#define DNA_BODY_TYPE_BLOCK 2
#define DNA_SKIN_TONE_BLOCK 3
#define DNA_HEIGHT_BLOCK 4
#define DNA_BODY_SIZE_BLOCK 5
#define DNA_EYE_COLOR_LEFT_BLOCK 6
#define DNA_EYE_COLOR_RIGHT_BLOCK 7
#define DNA_HAIRSTYLE_BLOCK 8
#define DNA_HAIR_COLOR_BLOCK 9
#define DNA_FACIAL_HAIRSTYLE_BLOCK 10
#define DNA_FACIAL_HAIR_COLOR_BLOCK 11

#define DNA_UNI_IDENTITY_BLOCKS DNA_FACIAL_HAIR_COLOR_BLOCK

/// This number needs to equal the total number of DNA blocks
#define DNA_MUTANT_COLOR_BLOCK 1
#define DNA_ETHEREAL_COLOR_BLOCK 2
#define DNA_TAIL_BLOCK 3
#define DNA_TAIL_COLOR_BLOCK 4
#define DNA_SNOUT_BLOCK 5
#define DNA_SNOUT_COLOR_BLOCK 6
#define DNA_HORNS_BLOCK 7
#define DNA_HORNS_COLOR_BLOCK 8
#define DNA_FRILLS_BLOCK 9
#define DNA_FRILLS_COLOR_BLOCK 10
#define DNA_SPINES_BLOCK 11
#define DNA_SPINES_COLOR_BLOCK 12
#define DNA_EARS_BLOCK 13
#define DNA_EARS_COLOR_BLOCK 14
#define DNA_MOTH_WINGS_BLOCK 15
#define DNA_MOTH_ANTENNAE_BLOCK 16
#define DNA_MUSHROOM_CAPS_BLOCK 17
#define DNA_POD_HAIR_BLOCK 18

//dumb genital crap ugh
#define DNA_PENIS_BLOCK 19
#define DNA_PENIS_COLOR_BLOCK 20
#define DNA_PENIS_SIZE_BLOCK 21
#define DNA_TESTICLES_BLOCK 22
#define DNA_TESTICLES_COLOR_BLOCK 23
#define DNA_TESTICLES_SIZE_BLOCK 24
#define DNA_VAGINA_BLOCK 25
#define DNA_VAGINA_COLOR_BLOCK 26
#define DNA_BREASTS_BLOCK 27
#define DNA_BREASTS_COLOR_BLOCK 28
#define DNA_BREASTS_SIZE_BLOCK 29
#define DNA_ANUS_BLOCK 30

/// Total amount of feature blocks, NOT COUNTING MARKINGS
#define DNA_MAIN_FEATURE_BLOCKS DNA_ANUS_BLOCK

/// Maximum amount of markings a limb can ever have
#define MAXIMUM_MARKINGS_PER_LIMB 5

/// Amount of DNA blocks a single marking takes up
#define DNA_BLOCKS_PER_MARKING 2 //one name block, one color block

/// Total amount of feature blocks, COUNTING MARKINGS
#define DNA_FEATURE_BLOCKS (DNA_MAIN_FEATURE_BLOCKS + (GLOB.marking_zones.len * MAXIMUM_MARKINGS_PER_LIMB * DNA_BLOCKS_PER_MARKING))

#define DNA_SEQUENCE_LENGTH 4
#define DNA_MUTATION_BLOCKS 8
#define DNA_UNIQUE_ENZYMES_LEN 32

//used for the can_chromosome var on mutations
#define CHROMOSOME_NEVER 0
#define CHROMOSOME_NONE 1
#define CHROMOSOME_USED 2

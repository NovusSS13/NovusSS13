import { Feature, FeatureTextInput, FeatureShortTextInput } from '../base';

//i don't get why people have one of these per file
export const flavor_text: Feature<string> = {
  name: 'Flavor Text',
  description: 'The flavor text of your character.',
  component: FeatureTextInput,
};

export const cyborg_flavor_text: Feature<string> = {
  name: 'Flavor Text (Cyborg)',
  description: 'The flavor text of your character, when a cyborg.',
  component: FeatureTextInput,
};

export const ai_flavor_text: Feature<string> = {
  name: 'Flavor Text (AI)',
  description: 'The flavor text of your character, when an AI.',
  component: FeatureTextInput,
};

export const naked_flavor_text: Feature<string> = {
  name: 'Naked Flavor Text',
  description: 'The flavor text of your character, shown when naked.',
  component: FeatureTextInput,
};

export const custom_species_name: Feature<string> = {
  name: 'Custom Species Name',
  component: FeatureShortTextInput,
};

export const custom_species_desc: Feature<string> = {
  name: 'Custom Species Description',
  component: FeatureTextInput,
};

export const ooc_notes: Feature<string> = {
  name: 'OOC Notes',
  component: FeatureTextInput,
};

export const headshot_link: Feature<string> = {
  name: 'Headshot Link',
  component: FeatureShortTextInput,
};

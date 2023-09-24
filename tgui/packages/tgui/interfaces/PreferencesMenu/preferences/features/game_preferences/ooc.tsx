import { FeatureColorInput, Feature, FeatureToggle, CheckboxInput } from '../base';

export const ooccolor: Feature<string> = {
  name: 'OOC color',
  category: 'CHAT',
  description: 'The color of your OOC messages.',
  component: FeatureColorInput,
};

export const mute_looc: FeatureToggle = {
  name: 'Mute LOOC',
  category: 'CHAT',
  component: CheckboxInput,
};

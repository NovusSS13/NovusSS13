import { Feature, FeatureColorInput, FeatureToggle, CheckboxInput } from '../base';

export const random_chat_color: FeatureToggle = {
  name: 'Random chat color',
  component: CheckboxInput,
};

export const chat_color: Feature<string> = {
  name: 'Chat color',
  component: FeatureColorInput,
};

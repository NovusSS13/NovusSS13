import { FeatureColorInput, Feature, FeatureToggle, CheckboxInput, FeatureValueProps } from '../base';

export const ooccolor: Feature<string> = {
  name: 'OOC color',
  category: 'CHAT',
  description: 'The color of your OOC messages.',
  component: (
    props: FeatureValueProps<string, boolean> & { hide_mutant: boolean }
  ) => {
    return <FeatureColorInput {...props} hide_mutant />;
  },
};

export const mute_looc: FeatureToggle = {
  name: 'Mute LOOC',
  category: 'CHAT',
  component: CheckboxInput,
};

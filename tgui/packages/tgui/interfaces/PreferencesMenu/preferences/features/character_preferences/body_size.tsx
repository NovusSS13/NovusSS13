import { Feature, FeatureNumberInput, FeatureChoiced, FeatureDropdownInput } from '../base';

export const body_size: Feature<number> = {
  name: 'Body size',
  component: FeatureNumberInput,
};

export const body_scaling: FeatureChoiced = {
  name: 'Body scaling',
  component: FeatureDropdownInput,
};

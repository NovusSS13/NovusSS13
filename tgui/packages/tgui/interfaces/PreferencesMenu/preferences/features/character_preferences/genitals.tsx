import { CheckboxInput, FeatureChoiced, FeatureDropdownInput, FeatureValueProps, FeatureToggle, FeatureTriColorInput, FeatureChoicedServerData } from '../base';

export const feature_penis: FeatureChoiced = {
  name: 'Penis',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const feature_penis_size: FeatureChoiced = {
  name: 'Penis size',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const feature_penis_skintone: FeatureToggle = {
  name: 'Penis uses skintone',
  component: CheckboxInput,
};

export const feature_penis_color: FeatureToggle = {
  name: 'Penis color',
  component: FeatureTriColorInput,
};

export const feature_testicles: FeatureChoiced = {
  name: 'Testicles',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const feature_testicles_skintone: FeatureToggle = {
  name: 'Testicles uses skintone',
  component: CheckboxInput,
};

export const feature_testicles_color: FeatureToggle = {
  name: 'Testicles color',
  component: FeatureTriColorInput,
};

export const feature_vagina: FeatureChoiced = {
  name: 'Vagina',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const feature_vagina_skintone: FeatureToggle = {
  name: 'Vagina uses skintone',
  component: CheckboxInput,
};

export const feature_vagina_color: FeatureToggle = {
  name: 'Vagina color',
  component: FeatureTriColorInput,
};

export const feature_breasts: FeatureChoiced = {
  name: 'Breasts',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const feature_breasts_size: FeatureChoiced = {
  name: 'Breasts size',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const feature_breasts_skintone: FeatureToggle = {
  name: 'Breasts use skintone',
  component: CheckboxInput,
};

export const feature_breasts_color: FeatureToggle = {
  name: 'Breasts color',
  component: FeatureTriColorInput,
};

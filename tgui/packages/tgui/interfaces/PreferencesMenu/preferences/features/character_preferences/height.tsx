import { FeatureChoiced, FeatureDropdownInput, FeatureValueProps, FeatureChoicedServerData } from '../base';

export const height: FeatureChoiced = {
  name: 'Height',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

import { FeatureChoiced, FeatureChoicedServerData, FeatureDropdownInput, FeatureValueProps } from '../base';

export const body_type: FeatureChoiced = {
  name: 'Body type',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

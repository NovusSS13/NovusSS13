import { FeatureChoiced, FeatureDropdownInput, FeatureValueProps, FeatureChoicedServerData } from '../base';

export const blood_type: FeatureChoiced = {
  name: 'Blood type',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

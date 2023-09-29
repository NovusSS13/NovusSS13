import { FeatureChoiced, FeatureDropdownInput, FeatureValueProps, FeatureChoicedServerData } from '../base';
import { Stack, Button } from '../../../../../components';

const FeatureVoicePackDropdownInput = (
  props: FeatureValueProps<string, string, FeatureChoicedServerData>
) => {
  return (
    <Stack>
      <Stack.Item grow>
        <FeatureDropdownInput buttons {...props} />
      </Stack.Item>
      <Stack.Item>
        <Button
          onClick={() => {
            props.act('preview_voice_pack', {
              voice_pack: props.value,
            });
          }}
          icon="play"
          width="100%"
          height="100%"
        />
      </Stack.Item>
    </Stack>
  );
};

export const voice_pack: FeatureChoiced = {
  name: 'Voice type',
  component: FeatureVoicePackDropdownInput,
};

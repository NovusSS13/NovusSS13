import { toFixed } from 'common/math';
import { useBackend, useSharedState } from '../backend';
import { NoticeBox, Button, Section, Stack, Tooltip, LabeledControls, Knob } from '../components';
import { Window } from '../layouts';
import { SearchBar } from './Fabrication/SearchBar';

type Data = {
  target_name: string;
  categories: Category[];
  last_interaction: Interaction;
  repeat_last_action: number;
  on_cooldown: Boolean;
};

type Category = {
  name: string;
  interactions: Interaction[];
};

type Interaction = {
  name: string;
  desc: string;
  icon: string;
  path: string;
  minimum_repeat_time: number;
  maximum_repeat_time: number;
  block_interact: Boolean;
};

export const InteractionMenu = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const {
    target_name,
    categories,
    on_cooldown,
    last_interaction,
    repeat_last_action,
  } = data;
  const [searchText, setSearchText] = useSharedState(
    context,
    'search_text',
    ''
  );
  let validcategories: Category[] = [];
  if (searchText) {
    for (let category of categories) {
      for (let interaction of category.interactions) {
        if (
          interaction.name.toLowerCase().indexOf(searchText.toLowerCase()) !==
          -1
        ) {
          validcategories.push(category);
          break;
        }
      }
    }
  } else {
    validcategories = categories;
  }

  return (
    <Window
      width={400}
      height={600}
      title={'Interacting with ' + target_name}
      theme="cutesy">
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            {(on_cooldown && <NoticeBox danger>On cooldown</NoticeBox>) || (
              <NoticeBox success>Able to interact</NoticeBox>
            )}
          </Stack.Item>
          {repeat_last_action && last_interaction && (
            <Stack.Item fill align="center" justify="center">
              <LabeledControls>
                <LabeledControls.Item label={last_interaction.name}>
                  <Knob
                    value={repeat_last_action}
                    minValue={last_interaction.minimum_repeat_time}
                    maxValue={last_interaction.maximum_repeat_time}
                    format={(value) => toFixed(value * 0.1) + 's'}
                    onChange={(e, value) =>
                      act('set_repeat_last_action', {
                        wait: value,
                      })
                    }
                  />
                </LabeledControls.Item>
              </LabeledControls>
            </Stack.Item>
          )}
          <Stack.Item>
            <Stack>
              <Stack.Item grow>
                <SearchBar
                  searchText={searchText}
                  onSearchTextChanged={setSearchText}
                />
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon="redo"
                  content="Repeat last action"
                  color={repeat_last_action ? 'good' : 'bad'}
                  disabled={!last_interaction}
                  onClick={() => act('repeat_last_action')}
                />
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item grow>
            <Section fill>
              {(validcategories.length !== 0 && (
                <Stack fill vertical>
                  {validcategories.map((category) => (
                    <Stack.Item key={category.name}>
                      <Section title={category.name}>
                        {category.interactions.map((interaction) => {
                          if (
                            searchText &&
                            interaction.name
                              .toLowerCase()
                              .indexOf(searchText.toLowerCase()) === -1
                          ) {
                            return null;
                          }
                          return (
                            <Tooltip
                              key={interaction.name}
                              content={interaction.desc}>
                              <Button
                                mt={0.5}
                                ml={0.5}
                                icon={interaction.icon}
                                disabled={interaction.block_interact}
                                onClick={() =>
                                  act('interact', {
                                    interaction: interaction.path,
                                  })
                                }>
                                {interaction.name}
                              </Button>
                            </Tooltip>
                          );
                        })}
                      </Section>
                    </Stack.Item>
                  ))}
                </Stack>
              )) || <NoticeBox info>No valid interactions!</NoticeBox>}
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

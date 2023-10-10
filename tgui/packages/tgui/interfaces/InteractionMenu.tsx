import { toFixed } from 'common/math';
import { useBackend, useSharedState, useLocalState } from '../backend';
import { NoticeBox, Button, Section, Stack, Knob, AnimatedNumber, BlockQuote, Tabs } from '../components';
import { Window } from '../layouts';
import { SearchBar } from './Fabrication/SearchBar';

type Data = {
  user_is_target: Boolean;
  interactors: Interactor[];
  categories: Category[];
  last_interaction: Interaction;
  repeat_last_action: number;
  on_cooldown: Boolean;
  genitals: Genital[];
};

type Interactor = {
  name: string;
  qualities: string[];
  pronoun: string;
};

type Category = {
  name: string;
  interactions: Interaction[];
};

type Interaction = {
  name: string;
  desc: string;
  icon: string;
  color: string;
  path: string;
  minimum_repeat_time: number;
  maximum_repeat_time: number;
  block_interact: Boolean;
};

enum GenitalVisibility {
  GENITAL_VISIBILITY_NEVER = 'Hidden',
  GENITAL_VISIBILITY_CLOTHING = 'Hidden by clothing',
  GENITAL_VISIBILITY_ALWAYS = 'Visible',
}

type Genital = {
  name: string;
  slot: string;
  visibility: GenitalVisibility;
  arousal_state: string;
  arousal_options: string[];
};

const GenitalsTab = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { genitals } = data;
  const GenitalVisibilityOptions = [
    GenitalVisibility.GENITAL_VISIBILITY_NEVER,
    GenitalVisibility.GENITAL_VISIBILITY_CLOTHING,
    GenitalVisibility.GENITAL_VISIBILITY_ALWAYS,
  ];
  GenitalVisibilityOptions[GenitalVisibility.GENITAL_VISIBILITY_NEVER] =
    'eye-slash';
  GenitalVisibilityOptions[GenitalVisibility.GENITAL_VISIBILITY_CLOTHING] =
    'tshirt';
  GenitalVisibilityOptions[GenitalVisibility.GENITAL_VISIBILITY_ALWAYS] = 'eye';

  return (
    <Section fill scrollable>
      {!genitals.length ? (
        <Section title="Oops!">
          You don&apos;t seem to have any genitals...
          <br />
          Well, none that you can modify at least.
        </Section>
      ) : (
        <Stack vertical fill textAlign="center">
          {genitals.map((genital) => (
            <Stack.Item key={genital.slot}>
              <Section fill title={genital.name}>
                <Stack>
                  <Stack.Item grow>
                    <Stack vertical>
                      <Stack.Item>Visibility</Stack.Item>
                      <Stack.Item>
                        {GenitalVisibilityOptions.map((option) => (
                          <Button
                            width={
                              100 / (GenitalVisibilityOptions.length * 1.75) +
                              '%'
                            }
                            selected={
                              option ===
                              GenitalVisibilityOptions[genital.visibility]
                            }
                            icon={GenitalVisibilityOptions[option]}
                            key={option}
                            tooltip={option}
                            onClick={() =>
                              act('set_genital_visibility', {
                                slot: genital.slot,
                                visibility:
                                  GenitalVisibilityOptions.indexOf(option),
                              })
                            }
                          />
                        ))}
                      </Stack.Item>
                    </Stack>
                  </Stack.Item>
                  {genital.arousal_options?.length ? (
                    <Stack.Item grow>
                      <Stack vertical>
                        <Stack.Item>Arousal</Stack.Item>
                        <Stack.Item>
                          {genital.arousal_options.map((option) => (
                            <Button
                              width={
                                100 / (genital.arousal_options.length * 1.75) +
                                '%'
                              }
                              icon={
                                option === 'Not aroused'
                                  ? 'heart-broken'
                                  : 'heart'
                              }
                              selected={option === genital.arousal_state}
                              key={option}
                              tooltip={option}
                              onClick={() =>
                                act('set_genital_arousal', {
                                  slot: genital.slot,
                                  arousal_state: option,
                                })
                              }
                            />
                          ))}
                        </Stack.Item>
                      </Stack>
                    </Stack.Item>
                  ) : null}
                </Stack>
              </Section>
            </Stack.Item>
          ))}
        </Stack>
      )}
    </Section>
  );
};
const InteractionsTab = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { categories, last_interaction, repeat_last_action } = data;
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
    <Section fill>
      <Stack vertical fill>
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
                content={
                  (last_interaction && last_interaction.name) || 'Last action'
                }
                selected={!!repeat_last_action}
                disabled={!last_interaction}
                onClick={() => act('repeat_last_action')}
              />
            </Stack.Item>
            {repeat_last_action && last_interaction ? (
              <Stack.Item fill align="center" justify="center">
                <Stack fill align="center" justify="center">
                  <Stack.Item>
                    <Knob
                      size={0.75}
                      value={repeat_last_action}
                      minValue={last_interaction.minimum_repeat_time}
                      maxValue={last_interaction.maximum_repeat_time}
                      format={(value) => toFixed(value * 0.1, 1) + 's'}
                      onChange={(e, value) =>
                        act('set_repeat_last_action', {
                          wait: value,
                        })
                      }
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <AnimatedNumber
                      value={repeat_last_action}
                      format={(value) => toFixed(value * 0.1, 1) + 's'}
                    />
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            ) : null}
          </Stack>
        </Stack.Item>
        <Stack.Item grow overflowX="hidden" scrollable>
          {(validcategories.length && (
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
                        <Button
                          mt={0.5}
                          ml={0.5}
                          key={interaction.name}
                          tooltip={interaction.desc}
                          icon={interaction.icon}
                          color={interaction.color}
                          disabled={interaction.block_interact}
                          onClick={() =>
                            act('interact', {
                              interaction: interaction.path,
                            })
                          }>
                          {interaction.name}
                        </Button>
                      );
                    })}
                  </Section>
                </Stack.Item>
              ))}
            </Stack>
          )) || <NoticeBox info>No valid interactions!</NoticeBox>}
        </Stack.Item>
      </Stack>
    </Section>
  );
};

export const InteractionMenu = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { user_is_target, on_cooldown, interactors } = data;

  const [tabIndex, setTabIndex] = useLocalState(context, 'tabIndex', 0);

  let target: Interactor = interactors[1];
  let user: Interactor = interactors[0];
  let validinteractors: Interactor[] = interactors;
  if (user_is_target) {
    validinteractors.splice(interactors.indexOf(target), 1);
  }

  return (
    <Window
      width={400}
      height={600}
      title={'Interacting with ' + (!user_is_target ? target.name : 'yourself')}
      theme="cutesy">
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            {(on_cooldown && <NoticeBox danger>On cooldown</NoticeBox>) || (
              <NoticeBox success>Able to interact</NoticeBox>
            )}
            <Stack fill>
              {validinteractors.map((interactor) => (
                <Stack.Item grow key={interactor.name}>
                  <Section>
                    <BlockQuote>
                      {interactor.pronoun}...
                      <br />
                      {interactor.qualities.map((quality) => (
                        <>
                          <span>...{quality}</span>
                          <br />
                        </>
                      ))}
                    </BlockQuote>
                  </Section>
                </Stack.Item>
              ))}
            </Stack>
          </Stack.Item>
          {user_is_target ? (
            <Stack.Item>
              <Tabs fluid textAlign="center">
                <Tabs.Tab
                  selected={tabIndex === 0}
                  onClick={() => setTabIndex(0)}>
                  Interactions
                </Tabs.Tab>
                <Tabs.Tab
                  selected={tabIndex === 1}
                  onClick={() => setTabIndex(1)}>
                  Genital Options
                </Tabs.Tab>
              </Tabs>
            </Stack.Item>
          ) : null}
          <Stack.Item grow>
            {(tabIndex === 0 && <InteractionsTab />) ||
              (tabIndex === 1 && <GenitalsTab />)}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

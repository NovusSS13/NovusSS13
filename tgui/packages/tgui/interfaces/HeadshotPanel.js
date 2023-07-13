import { resolveAsset } from '../assets';
import { useBackend, useLocalState } from '../backend';
import { Box, ByondUi, Flex, Section, Stack, Tabs } from '../components';
import { Window } from '../layouts';
import { CharacterPreview } from './common/CharacterPreview';

export const HeadshotPanel = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    mob_type,
    character_name,
    assigned_map,
    flavor_text,
    naked_flavor_text,
    temporary_flavor_text,
    custom_species_name,
    custom_species_desc,
    unobscured,
    ooc_notes,
    headshot_link,
  } = data;

  const tab_data = [
    ['Flavor Text', flavor_text],
    ['Naked Flavor Text', naked_flavor_text],
    ['Temporary Flavor Text', temporary_flavor_text],
  ];

  const [tabIndex, setTab] = useLocalState(
    context,
    'tab-index',
    flavor_text ? 0 : naked_flavor_text ? 1 : temporary_flavor_text ? 2 : 0 //this is ass
  );
  const make_tabs =
    !!flavor_text + !!naked_flavor_text + !!temporary_flavor_text > 1;
  const cs_name =
    (mob_type === 'ai' && 'AI Core') ||
    (mob_type === 'cyborg' && 'Cyborg') ||
    custom_species_name;
  const cs_desc =
    (mob_type === 'ai' && 'An AI unit.') ||
    (mob_type === 'cyborg' && 'A cyborg unit.') ||
    custom_species_desc;

  return (
    <Window title="Examine Panel" width={900} height={670} theme="admin">
      <Window.Content>
        <Stack fill>
          <Stack.Item fill width="30%">
            <Section
              fill
              height={headshot_link ? '50%' : ''}
              title="Character Preview">
              <ByondUi
                height="100%"
                className="ExaminePanel__map"
                params={{
                  id: assigned_map,
                  type: 'map',
                }}
              />
            </Section>
            {unobscured && headshot_link && (
              <Section title="Headshot">
                <Flex.Item align="center" justify="center">
                  <img src={resolveAsset(headshot_link)} width="100%" />
                </Flex.Item>
              </Section>
            )}
          </Stack.Item>
          <Stack.Item grow>
            <Stack fill vertical>
              <Stack.Item grow>
                {make_tabs && (
                  <Tabs>
                    {tab_data.map(
                      (arr, i) =>
                        arr[1] && (
                          <Tabs.Tab
                            lineHeight="23px"
                            selected={tabIndex === i}
                            onClick={() => setTab(i)}>
                            {arr[0]}
                          </Tabs.Tab>
                        )
                    )}
                  </Tabs>
                )}
                <Section
                  scrollable
                  fill
                  title={character_name + `s ${tab_data[tabIndex][0]}:`}
                  preserveWhitespace>
                  {tab_data[tabIndex][1]}
                </Section>
              </Stack.Item>
              <Stack.Item grow>
                <Stack fill>
                  <Stack.Item grow basis={0}>
                    <Section
                      scrollable
                      fill
                      title="OOC Notes"
                      preserveWhitespace>
                      {ooc_notes}
                    </Section>
                  </Stack.Item>
                  <Stack.Item grow basis={0}>
                    <Section
                      scrollable
                      fill
                      title={'Species: ' + cs_name}
                      preserveWhitespace>
                      {cs_desc}
                    </Section>
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

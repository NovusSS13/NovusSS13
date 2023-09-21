import { resolveAsset } from '../assets';
import { useBackend, useLocalState } from '../backend';
import { ByondUi, Flex, Section, Stack, Tabs } from '../components';
import { Window } from '../layouts';

export const ExaminePanel = (props, context) => {
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
    ['Flavor Text', flavor_text || 'No flavor text.'],
    ['Naked Flavor Text', naked_flavor_text || 'No naked flavor text.'],
    [
      'Temporary Flavor Text',
      temporary_flavor_text || 'No temporary flavor text.',
    ],
  ];

  const [tabIndex, setTab] = useLocalState(
    context,
    'tab-index',
    flavor_text ? 0 : naked_flavor_text ? 1 : temporary_flavor_text ? 2 : 0 // this is ass
  );
  const make_tabs =
    !!flavor_text + !!naked_flavor_text + !!temporary_flavor_text > 1;
  const cs_name =
    (mob_type === 'ai' && 'AI Core') ||
    (mob_type === 'cyborg' && 'Cyborg') ||
    custom_species_name ||
    'Unknown';
  const cs_desc =
    (mob_type === 'ai' && 'An AI unit.') ||
    (mob_type === 'cyborg' && 'A cyborg unit.') ||
    custom_species_desc ||
    'No species description.';

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
                      (tab, i) =>
                        tab[1] && (
                          <Tabs.Tab
                            lineHeight="23px"
                            selected={tabIndex === i}
                            onClick={() => setTab(i)}>
                            {tab[0]}
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
                  {unobscured ? tab_data[tabIndex][1] : 'Obscured.'}
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
                      {unobscured ? ooc_notes : 'Obscured.'}
                    </Section>
                  </Stack.Item>
                  <Stack.Item grow basis={0}>
                    <Section
                      scrollable
                      fill
                      title={'Species: ' + (unobscured ? cs_name : 'Obscured')}
                      preserveWhitespace>
                      {unobscured ? cs_desc : 'Obscured.'}
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

import { exhaustiveCheck } from 'common/exhaustive';
import { useBackend, useLocalState } from '../../backend';
import { Stack, Button, Flex, Dropdown, Box } from '../../components';
import { Window } from '../../layouts';
import { GhostRole, PreferencesMenuData, ServerData } from './data';
import { PageButton } from './PageButton';
import { AntagsPage } from './AntagsPage';
import { JobsPage } from './JobsPage';
import { MainPage } from './MainPage';
import { BackgroundPage } from './BackgroundPage';
import { SpeciesPage } from './SpeciesPage';
import { QuirksPage } from './QuirksPage';
import { Cargo } from '../Cargo';
import { ServerPreferencesFetcher } from './ServerPreferencesFetcher';

enum Page {
  Antags,
  Main,
  Background,
  Jobs,
  Species,
  Quirks,
}

const CharSlots = (props: {
  onClick: (action: string, payload?: object) => void;
  profiles: string[];
  slotKey: string;
  activeKey: string;
  maxSlots: number;
  activeSlot: number;
}) => {
  const activeSlotKeyCheck = props.slotKey == props.activeKey;
  //i cant make this wrap. fix htiws.
  return (
    <>
      {props.profiles.map((profile, slot_id) => (
        <Stack.Item key={slot_id}>
          <Button
            selected={slot_id === props.activeSlot - 1 && activeSlotKeyCheck}
            onClick={() => {
              props.onClick('change_slot', {
                slot_key: props.slotKey,
                slot_id: slot_id + 1,
              });
            }}
            fluid>
            {profile ?? 'FUNKY CODE, FUCK.'}
          </Button>
        </Stack.Item>
      ))}
      {Number(props.profiles?.length) < props.maxSlots && (
        <Stack.Item>
          <Button
            onClick={() => {
              props.onClick('new_slot', {
                slot_key: props.slotKey,
              });
            }}
            content="+"
            fluid
          />
        </Stack.Item>
      )}
    </>
  );
};

export const CharacterPreferenceWindow = (props, context) => {
  const { act, data } = useBackend<PreferencesMenuData>(context);

  const [currentPage, setCurrentPage] = useLocalState(
    context,
    'currentPage',
    Page.Main
  );

  let pageContents;

  switch (currentPage) {
    case Page.Antags:
      pageContents = <AntagsPage />;
      break;
    case Page.Jobs:
      pageContents = <JobsPage />;
      break;
    case Page.Main:
      pageContents = (
        <MainPage openSpecies={() => setCurrentPage(Page.Species)} />
      );

      break;
    case Page.Background:
      pageContents = (
        <BackgroundPage openSpecies={() => setCurrentPage(Page.Species)} />
      );
      break;
    case Page.Species:
      pageContents = (
        <SpeciesPage closeSpecies={() => setCurrentPage(Page.Main)} />
      );
      break;

    case Page.Quirks:
      pageContents = <QuirksPage />;
      break;
    default:
      exhaustiveCheck(currentPage);
  }

  return (
    <Window title="Character Preferences" width={920} height={770}>
      <Window.Content scrollable>
        <Stack vertical fill>
          {data.is_guest ? (
            <Stack.Item align="center">
              Create an account to save your character!
            </Stack.Item>
          ) : (
            <Stack.Item>
              <Stack justify="center" fill>
                <Stack.Item>
                  <Stack vertical fill fluid>
                    <Stack.Item>
                      <Stack justify="center" wrap>
                        <CharSlots
                          profiles={data.character_profiles['main']}
                          activeSlot={data.active_slot_ids['main']}
                          slotKey="main"
                          activeKey={data.active_slot_key}
                          maxSlots={data.max_slots_main}
                          onClick={(action, object) => {
                            if (currentPage == Page.Species)
                              setCurrentPage(Page.Main);
                            act(action, object);
                          }}
                        />
                      </Stack>
                    </Stack.Item>
                    {!data.content_unlocked && (
                      <Stack.Item align="center">
                        Buy BYOND premium for more slots!
                      </Stack.Item>
                    )}
                  </Stack>
                </Stack.Item>
                <Stack.Item>
                  <ServerPreferencesFetcher
                    render={(render_data: ServerData | null) => {
                      if (!render_data) {
                        return <Box>Loading ghost roles..</Box>;
                      }

                      const ghost_role_data: Record<string, GhostRole> =
                        render_data.ghost_role_data;

                      return (
                        <Stack vertical fill>
                          {Object.keys(data.character_profiles).map(
                            (slot_key) =>
                              slot_key != 'main' && (
                                <Stack.Item>
                                  <Stack>
                                    <Stack.Item>
                                      {ghost_role_data[slot_key].slot_name}
                                    </Stack.Item>
                                    <CharSlots
                                      onClick={(action, payload) => {
                                        if (currentPage == Page.Species)
                                          setCurrentPage(Page.Main);
                                        act(action, payload);
                                      }}
                                      profiles={
                                        data.character_profiles[slot_key]
                                      }
                                      maxSlots={data.max_slots_ghost}
                                      activeSlot={
                                        data.active_slot_ids[slot_key]
                                      }
                                      slotKey={slot_key}
                                      activeKey={data.active_slot_key}
                                    />
                                  </Stack>
                                </Stack.Item>
                              )
                          )}
                        </Stack>
                      );
                    }}
                  />
                </Stack.Item>
              </Stack>
            </Stack.Item>
          )}
          <Stack.Divider />

          <Stack.Item>
            <Stack fill>
              <Stack.Item grow>
                <PageButton
                  currentPage={currentPage}
                  page={Page.Main}
                  setPage={setCurrentPage}
                  otherActivePages={[Page.Species]}>
                  Character
                </PageButton>
              </Stack.Item>

              <Stack.Item grow>
                <PageButton
                  currentPage={currentPage}
                  page={Page.Background}
                  setPage={setCurrentPage}>
                  Background
                </PageButton>
              </Stack.Item>

              <Stack.Item grow>
                <PageButton
                  currentPage={currentPage}
                  page={Page.Jobs}
                  setPage={setCurrentPage}>
                  {/*
                    Fun fact: This isn't "Jobs" so that it intentionally
                    catches your eyes, because it's really important!
                  */}
                  Occupations
                </PageButton>
              </Stack.Item>

              <Stack.Item grow>
                <PageButton
                  currentPage={currentPage}
                  page={Page.Antags}
                  setPage={setCurrentPage}>
                  Antagonists
                </PageButton>
              </Stack.Item>

              <Stack.Item grow>
                <PageButton
                  currentPage={currentPage}
                  page={Page.Quirks}
                  setPage={setCurrentPage}>
                  Quirks
                </PageButton>
              </Stack.Item>
            </Stack>
          </Stack.Item>

          <Stack.Divider />

          <Stack.Item>{pageContents}</Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

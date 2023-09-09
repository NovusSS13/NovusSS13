import { exhaustiveCheck } from 'common/exhaustive';
import { useBackend, useLocalState } from '../../backend';
import { Button, Stack } from '../../components';
import { Window } from '../../layouts';
import { PreferencesMenuData } from './data';
import { PageButton } from './PageButton';
import { AntagsPage } from './AntagsPage';
import { JobsPage } from './JobsPage';
import { MainPage } from './MainPage';
import { SpeciesPage } from './SpeciesPage';
import { QuirksPage } from './QuirksPage';

enum Page {
  Antags,
  Main,
  Jobs,
  Species,
  Quirks,
}

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
          <Stack.Item>
            <Stack justify="center" wrap>
              {data.character_profiles['main'].map((profile, slot_id) => (
                <Stack.Item key={slot_id}>
                  <Button
                    selected={slot_id === data.active_slot_id - 1}
                    onClick={() => {
                      act('change_slot', {
                        slot_key: 'main',
                        slot_id: slot_id + 1,
                      });
                    }}
                    fluid>
                    {profile ?? 'FUNKY CODE, FUCK.'}
                  </Button>
                </Stack.Item>
              ))}
              {data.character_profiles['main'].length < data.max_slots_main && (
                <Stack.Item>
                  <Button
                    onClick={() => {
                      act('new_slot', {
                        slot_key: 'main',
                      });
                    }}
                    content="+"
                    fluid
                  />
                </Stack.Item>
              )}
              <Stack.Item></Stack.Item>
            </Stack>
          </Stack.Item>

          {!data.content_unlocked && (
            <Stack.Item align="center">
              Buy BYOND premium for more slots!
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

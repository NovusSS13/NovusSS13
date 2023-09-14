import { Section, Button, Box, ColorBox, Dropdown, Stack } from '../../components';
import { useBackend } from '../../backend';
import { Marking, MarkingZone, PreferencesMenuData } from './data';
import { CharacterPreview } from '../common/CharacterPreview';
import { CLOTHING_CELL_SIZE, CLOTHING_SIDEBAR_ROWS } from './MainPage';

const MarkingInput = (
  props: {
    our_zone: MarkingZone;
    marking: Marking;
  },
  context
) => {
  const { our_zone, marking } = props;
  const { act, data } = useBackend<PreferencesMenuData>(context);
  return (
    <Box textAlign="center" verticalAlign="middle" width="100%">
      {(marking.color_amount && (
        <Button
          width="25%"
          onClick={() =>
            act('color_marking', {
              body_zone: our_zone.body_zone,
              marking_name: marking.name,
              marking_index: marking.marking_index,
            })
          }>
          <ColorBox color={marking.color} />
        </Button>
      )) || <Button width="25%" />}
      <Button
        width="25%"
        icon="sort-up"
        onClick={() =>
          act('move_marking_up', {
            body_zone: our_zone.body_zone,
            marking_name: props.marking.name,
            marking_index: props.marking.marking_index,
          })
        }
      />
      <Button
        width="25%"
        icon="sort-down"
        onClick={() =>
          act('move_marking_down', {
            body_zone: our_zone.body_zone,
            marking_name: props.marking.name,
            marking_index: props.marking.marking_index,
          })
        }
      />
      <Button
        icon="times"
        color="bad"
        onClick={() =>
          act('remove_marking', {
            body_zone: our_zone.body_zone,
            marking_name: props.marking.name,
            marking_index: props.marking.marking_index,
          })
        }
      />
    </Box>
  );
};

const ZoneItem = (
  props: {
    key: string;
    our_zone: MarkingZone;
  },
  context
) => {
  const { act, data } = useBackend<PreferencesMenuData>(context);
  const { our_zone } = props;
  const maxmarkings = data.maximum_markings_per_limb;
  return (
    <Stack.Item key={props.key}>
      <Section
        title={
          our_zone.name +
          ' (' +
          our_zone.markings.length +
          '/' +
          maxmarkings +
          ')'
        }>
        <Stack vertical>
          <Stack.Item>
            {our_zone.markings.map((marking) => (
              <Stack key={marking.marking_index}>
                <Stack.Item width="50%" mb={1}>
                  <Dropdown
                    width="100%"
                    options={our_zone.markings_choices}
                    displayText={marking.name}
                    onSelected={(new_marking) =>
                      act('change_marking', {
                        body_zone: our_zone.body_zone,
                        marking_index: marking.marking_index,
                        new_marking: new_marking,
                      })
                    }
                  />
                </Stack.Item>
                <Stack.Item width="50%">
                  <MarkingInput our_zone={our_zone} marking={marking} />
                </Stack.Item>
              </Stack>
            ))}
          </Stack.Item>
          <Stack.Item>
            {(!our_zone.cant_add_markings && (
              <Button
                icon="plus"
                color="good"
                onClick={() =>
                  act('add_marking', {
                    body_zone: our_zone.body_zone,
                  })
                }
              />
            )) || <Box>{our_zone.cant_add_markings}</Box>}
          </Stack.Item>
        </Stack>
      </Section>
    </Stack.Item>
  );
};

export const MarkingsPage = (props, context, markingslist: MarkingZone[]) => {
  const { act, data } = useBackend<PreferencesMenuData>(context);
  markingslist = [];
  markingslist.length = data.marking_parts.length;
  for (let index = 0; index < data.marking_parts.length; index++) {
    markingslist[index] = data.marking_parts[index];
  }
  const firststack = markingslist.splice(0, 6);
  firststack.length = Math.min(firststack.length, 6);
  const secondstack = markingslist.splice(0, 6);
  secondstack.length = Math.min(firststack.length, 6);
  const maxmarkings = data.maximum_markings_per_limb;
  return (
    <Stack height={`${CLOTHING_SIDEBAR_ROWS * CLOTHING_CELL_SIZE * 1.25}px`}>
      <Stack.Item grow minWidth="15%" mr="10%">
        <CharacterPreview height="100%" id={data.character_preview_view} />
      </Stack.Item>
      <Stack.Item width="100%" height="100%">
        <Stack vertical width="100%" height="100%">
          <Stack.Item>
            <Dropdown
              width="100%"
              displayText="Presets"
              options={data.body_marking_sets}
              onSelected={(value) => act('set_preset', { preset: value })}
            />
          </Stack.Item>
          <Stack.Item width="100%" height="100%">
            <Stack width="100%" height="100%">
              <Stack.Item minWidth="50%">
                <Section overflowX="hidden" overflowY="auto" fill>
                  <Stack vertical>
                    {firststack.map((zone) => (
                      <ZoneItem key={zone.body_zone} our_zone={zone} />
                    ))}
                  </Stack>
                </Section>
              </Stack.Item>
              <Stack.Item minWidth="50%">
                <Section overflowX="hidden" overflowY="auto" fill>
                  <Stack vertical>
                    {secondstack.map((zone) => (
                      <ZoneItem key={zone.body_zone} our_zone={zone} />
                    ))}
                  </Stack>
                </Section>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

import { classes } from 'common/react';
import { Autofocus, Section, Button, Box, ColorBox, Flex, Popper, Stack, TrackOutsideClicks } from '../../components';
import { useBackend, useLocalState, useSharedState } from '../../backend';
import { Marking, MarkingZone, MarkingSet, PreferencesMenuData } from './data';
import { CharacterPreview, RotateButtons } from '../common/CharacterPreview';
import { CLOTHING_CELL_SIZE, CLOTHING_SIDEBAR_ROWS, CLOTHING_SELECTION_CELL_SIZE, CLOTHING_SELECTION_WIDTH, CLOTHING_SELECTION_MULTIPLIER } from './MainPage';
import { SearchBar } from '../Fabrication/SearchBar';

const SetButton = (
  props: {
    sets: MarkingSet[];
    isOpen: boolean;
    handleClose: () => void;
    handleOpen: () => void;
  },
  context
) => {
  const { sets, isOpen, handleClose, handleOpen } = props;
  const { act, data } = useBackend<PreferencesMenuData>(context);
  const [searchText, setSearchText] = useSharedState(
    context,
    'search_text',
    ''
  );
  return (
    <Popper
      options={{
        placement: 'bottom-start',
      }}
      popperContent={
        isOpen && (
          <TrackOutsideClicks
            onOutsideClick={() => {
              setSearchText('');
              handleClose();
            }}>
            <Box
              style={{
                background: 'white',
                padding: '5px',

                height: `${
                  CLOTHING_SELECTION_CELL_SIZE * CLOTHING_SELECTION_MULTIPLIER
                }px`,
                width: `${
                  CLOTHING_SELECTION_CELL_SIZE * CLOTHING_SELECTION_WIDTH
                }px`,
              }}>
              <Stack vertical fill>
                <Stack.Item>
                  <Stack fill>
                    <Stack.Item grow>
                      <Box
                        style={{
                          'border-bottom': '1px solid #888',
                          'font-weight': 'bold',
                          'font-size': '14px',
                          'text-align': 'center',
                        }}>
                        Select marking set
                      </Box>
                    </Stack.Item>

                    <Stack.Item grow>
                      <SearchBar
                        searchText={searchText}
                        onSearchTextChanged={setSearchText}
                      />
                    </Stack.Item>

                    <Stack.Item>
                      <Button
                        color="red"
                        onClick={() => {
                          setSearchText('');
                          handleClose();
                        }}>
                        X
                      </Button>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>

                <Stack.Item overflowX="hidden" overflowY="scroll">
                  <Autofocus>
                    <Flex wrap>
                      {sets.map((availableSet) => {
                        if (
                          searchText &&
                          availableSet.name
                            .toLowerCase()
                            .indexOf(searchText.toLowerCase()) === -1
                        ) {
                          return null;
                        }
                        return (
                          <Flex.Item
                            key={availableSet.name}
                            mx="10px"
                            basis={`${CLOTHING_SELECTION_CELL_SIZE}px`}
                            style={{
                              padding: '5px',
                            }}>
                            <Button
                              onClick={() => {
                                act('set_preset', {
                                  preset: availableSet.name,
                                });
                                setSearchText('');
                                handleClose();
                              }}
                              tooltip={availableSet.name}
                              tooltipPosition="right"
                              style={{
                                height: `${CLOTHING_SELECTION_CELL_SIZE}px`,
                                width: `${CLOTHING_SELECTION_CELL_SIZE}px`,
                              }}>
                              <Box
                                className={classes([
                                  'markings32x32',
                                  availableSet.icon,
                                  'centered-image',
                                ])}
                              />
                            </Button>
                            <Box textAlign="center">{availableSet.name}</Box>
                          </Flex.Item>
                        );
                      })}
                    </Flex>
                  </Autofocus>
                </Stack.Item>
              </Stack>
            </Box>
          </TrackOutsideClicks>
        )
      }>
      <Button
        width="100%"
        content="Presets"
        onClick={() => {
          handleOpen();
        }}
      />
    </Popper>
  );
};

const MarkingButton = (
  props: {
    key: string;
    zone: MarkingZone;
    selected_marking: Marking;
    isOpen: boolean;
    handleClose: () => void;
    handleOpen: () => void;
  },
  context
) => {
  const { zone, selected_marking, isOpen, handleClose, handleOpen } = props;
  const { act, data } = useBackend<PreferencesMenuData>(context);
  const [searchText, setSearchText] = useSharedState(
    context,
    'search_text',
    ''
  );
  return (
    <Popper
      key={props.key}
      options={{
        placement: 'bottom-start',
      }}
      popperContent={
        isOpen && (
          <TrackOutsideClicks
            onOutsideClick={() => {
              setSearchText('');
              handleClose();
            }}>
            <Box
              style={{
                background: 'white',
                padding: '5px',

                height: `${
                  CLOTHING_SELECTION_CELL_SIZE * CLOTHING_SELECTION_MULTIPLIER
                }px`,
                width: `${
                  CLOTHING_SELECTION_CELL_SIZE * CLOTHING_SELECTION_WIDTH
                }px`,
              }}>
              <Stack vertical fill>
                <Stack.Item>
                  <Stack fill>
                    <Stack.Item grow>
                      <Box
                        style={{
                          'border-bottom': '1px solid #888',
                          'font-weight': 'bold',
                          'font-size': '14px',
                          'text-align': 'center',
                        }}>
                        Select marking
                      </Box>
                    </Stack.Item>

                    <Stack.Item grow>
                      <SearchBar
                        searchText={searchText}
                        onSearchTextChanged={setSearchText}
                      />
                    </Stack.Item>

                    <Stack.Item>
                      <Button
                        color="red"
                        onClick={() => {
                          setSearchText('');
                          handleClose();
                        }}>
                        X
                      </Button>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>

                <Stack.Item overflowX="hidden" overflowY="scroll">
                  <Autofocus>
                    <Flex wrap>
                      {zone.markings_choices.map((markingChoice) => {
                        if (
                          searchText &&
                          markingChoice.name
                            .toLowerCase()
                            .indexOf(searchText.toLowerCase()) === -1
                        ) {
                          return null;
                        }
                        return (
                          <Flex.Item
                            key={markingChoice.name}
                            mx="10px"
                            basis={`${CLOTHING_SELECTION_CELL_SIZE}px`}
                            style={{
                              padding: '5px',
                            }}>
                            <Button
                              onClick={() => {
                                act('change_marking', {
                                  body_zone: zone.body_zone,
                                  marking_index: selected_marking.marking_index,
                                  new_marking: markingChoice.name,
                                });
                              }}
                              selected={
                                markingChoice.name === selected_marking.name
                              }
                              tooltip={markingChoice.name}
                              tooltipPosition="right"
                              style={{
                                height: `${CLOTHING_SELECTION_CELL_SIZE}px`,
                                width: `${CLOTHING_SELECTION_CELL_SIZE}px`,
                              }}>
                              <Box
                                className={classes([
                                  'markings32x32',
                                  markingChoice.icon,
                                  'centered-image',
                                ])}
                              />
                            </Button>
                            <Box textAlign="center">{markingChoice.name}</Box>
                          </Flex.Item>
                        );
                      })}
                    </Flex>
                  </Autofocus>
                </Stack.Item>
              </Stack>
            </Box>
          </TrackOutsideClicks>
        )
      }>
      <Button
        width="100%"
        content={selected_marking.name}
        onClick={() => {
          handleOpen();
        }}
      />
    </Popper>
  );
};

const MarkingInput = (
  props: {
    zone: MarkingZone;
    marking: Marking;
  },
  context
) => {
  const { zone, marking } = props;
  const { act, data } = useBackend<PreferencesMenuData>(context);
  return (
    <Stack fill textAlign="center" verticalAlign="middle">
      {(marking.color_amount && (
        <>
          <Stack.Item grow>
            <Button
              fill
              fluid
              onClick={() =>
                act('color_marking', {
                  body_zone: zone.body_zone,
                  marking_name: marking.name,
                  marking_index: marking.marking_index,
                })
              }>
              <ColorBox
                style={{
                  border: '2px solid white',
                  'box-sizing': 'content-box',
                }}
                color={marking.color}
              />
            </Button>
          </Stack.Item>
          <Stack.Item grow>
            <Button
              fill
              fluid
              tooltipPosition="top"
              tooltip="Set to mutant colors"
              onClick={() =>
                act('color_marking_mutant_colors', {
                  body_zone: zone.body_zone,
                  marking_name: marking.name,
                  marking_index: marking.marking_index,
                })
              }>
              M
            </Button>
          </Stack.Item>
        </>
      )) || (
        <>
          <Stack.Item grow>
            <Button fill fluid />
          </Stack.Item>
          <Stack.Item grow>
            <Button fill fluid />
          </Stack.Item>
        </>
      )}
      <Stack.Item grow>
        <Button
          fill
          fluid
          icon="sort-up"
          onClick={() =>
            act('move_marking_up', {
              body_zone: zone.body_zone,
              marking_name: props.marking.name,
              marking_index: props.marking.marking_index,
            })
          }
        />
      </Stack.Item>
      <Stack.Item grow>
        <Button
          fill
          fluid
          icon="sort-down"
          onClick={() =>
            act('move_marking_down', {
              body_zone: zone.body_zone,
              marking_name: props.marking.name,
              marking_index: props.marking.marking_index,
            })
          }
        />
      </Stack.Item>
      <Stack.Item grow>
        <Button
          fluid
          icon="times"
          color="bad"
          onClick={() =>
            act('remove_marking', {
              body_zone: zone.body_zone,
              marking_name: props.marking.name,
              marking_index: props.marking.marking_index,
            })
          }
        />
      </Stack.Item>
    </Stack>
  );
};

const ZoneItem = (
  props: {
    key: string;
    zone: MarkingZone;
  },
  context
) => {
  const { act, data } = useBackend<PreferencesMenuData>(context);
  const [currentMarkingMenu, setCurrentMarkingMenu] = useLocalState<
    string | null
  >(context, 'currentMarkingMenu', null);
  const { zone } = props;
  const maxmarkings = data.maximum_markings_per_limb;
  return (
    <Stack.Item key={props.key}>
      <Section
        title={
          zone.name + ' (' + zone.markings.length + '/' + maxmarkings + ')'
        }>
        <Stack vertical>
          <Stack.Item>
            {zone.markings.map((marking) => (
              <Stack key={marking.marking_index}>
                <Stack.Item width="50%" mb={1}>
                  <MarkingButton
                    key={props.key}
                    zone={zone}
                    selected_marking={marking}
                    isOpen={
                      currentMarkingMenu === zone.name + marking.marking_index
                    }
                    handleClose={() => {
                      setCurrentMarkingMenu(null);
                    }}
                    handleOpen={() => {
                      setCurrentMarkingMenu(zone.name + marking.marking_index);
                    }}
                  />
                </Stack.Item>
                <Stack.Item width="50%">
                  <MarkingInput zone={zone} marking={marking} />
                </Stack.Item>
              </Stack>
            ))}
          </Stack.Item>
          <Stack.Item>
            {(!zone.cant_add_markings && (
              <Button
                icon="plus"
                color="good"
                onClick={() =>
                  act('add_marking', {
                    body_zone: zone.body_zone,
                  })
                }
              />
            )) || <Box>{zone.cant_add_markings}</Box>}
          </Stack.Item>
        </Stack>
      </Section>
    </Stack.Item>
  );
};

export const MarkingsPage = (props, context) => {
  const { act, data } = useBackend<PreferencesMenuData>(context);
  const body_marking_sets = data.body_marking_sets;
  const markingslist: MarkingZone[] = [];
  markingslist.length = data.marking_parts.length;
  for (let index = 0; index < data.marking_parts.length; index++) {
    markingslist[index] = data.marking_parts[index];
  }
  const stacks: MarkingZone[][] = [];
  while (markingslist.length > 0) {
    stacks.push(markingslist.splice(0, 6));
  }
  const [currentMarkingMenu, setCurrentMarkingMenu] = useLocalState<
    string | null
  >(context, 'currentMarkingMenu', null);
  return (
    <Stack
      height={`${CLOTHING_SIDEBAR_ROWS * CLOTHING_CELL_SIZE * 1.25}px`}
      width={'100%'}>
      <Stack.Item fill>
        <Stack vertical fill>
          <Stack.Item grow>
            <CharacterPreview height="100%" id={data.character_preview_view} />
          </Stack.Item>
          <Stack.Item>
            <RotateButtons
              handleRotateLeft={() => {
                act('rotate', { direction: -1 });
              }}
              handleRotateRight={() => {
                act('rotate', { direction: 1 });
              }}
            />
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item width="100%" height="100%">
        <Stack vertical width="100%" height="100%">
          <Stack.Item>
            <SetButton
              sets={body_marking_sets}
              isOpen={currentMarkingMenu === 'presets'}
              handleClose={() => {
                setCurrentMarkingMenu(null);
              }}
              handleOpen={() => {
                setCurrentMarkingMenu('presets');
              }}
            />
          </Stack.Item>
          <Stack.Item width="100%" height="100%">
            <Stack width="100%" height="100%">
              {stacks.map((stack, index) => (
                <Stack.Item grow key={index}>
                  <Section overflowX="hidden" scrollable fill>
                    <Stack vertical>
                      {stack.map((zone) => (
                        <ZoneItem key={zone.body_zone} zone={zone} />
                      ))}
                    </Stack>
                  </Section>
                </Stack.Item>
              ))}
            </Stack>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

import { useBackend } from '../backend';
import { Box, Section, Stack } from '../components';
import { BooleanLike } from 'common/react';
import { Window } from '../layouts';

type Objective = {
  count: number;
  name: string;
  explanation: string;
  complete: BooleanLike;
  was_uncompleted: BooleanLike;
  reward: number;
};

type Info = {
  antag_name: string;
  objectives: Objective[];
  brothers: string[];
  brotherhood: string;
};

export const AntagInfoBrother = (props, context) => {
  const { data } = useBackend<Info>(context);
  const { antag_name, brotherhood } = data;
  return (
    <Window width={620} height={400} theme="syndicate">
      <Window.Content style={{ 'background-image': 'none' }}>
        <Stack vertical>
          <Stack.Item>
            <Stack>
              <Stack.Item>
                <Section title="Intro">
                  <Box textColor="red" fontSize="20px" mb={1}>
                    You are a {antag_name}!
                  </Box>
                  The {brotherhood} is your true allegiance. <br />
                  Your brains have united been into one, becoming more than the
                  sum of its parts.
                  <br />
                  Complete these objectives to ensure that you and your siblings
                  can eventually take over the station.
                </Section>
              </Stack.Item>
              <Stack.Item>
                <Section title="Siblings" fill>
                  <BrotherPrintout />
                </Section>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <Section title="Objectives" scrollable>
              <ObjectivePrintout />
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const BrotherPrintout = (props, context) => {
  const { data } = useBackend<Info>(context);
  const { brothers } = data;
  return (
    <Stack vertical>
      {(!brothers && 'None!') ||
        brothers.map((sibling) => (
          <Stack.Item key={sibling}>{sibling}</Stack.Item>
        ))}
    </Stack>
  );
};

const ObjectivePrintout = (props, context) => {
  const { data } = useBackend<Info>(context);
  const { objectives } = data;
  return (
    <Stack vertical>
      {(!objectives && 'None!') ||
        objectives.map((objective) => (
          <Stack.Item key={objective.count}>
            #{objective.count}: {objective.explanation}
          </Stack.Item>
        ))}
    </Stack>
  );
};

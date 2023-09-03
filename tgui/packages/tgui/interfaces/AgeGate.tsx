import { useBackend, useLocalState } from '../backend';
import { Box, BlockQuote, Button, Dropdown, Tooltip, Section, Flex } from '../components';
import { Window } from '../layouts';

const MonthOptions = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

// Current year turned into a string
const CurrentYear = new Date().getFullYear().toString();

// A list of years from 1920 to current year, in descending order, turned into strings
const YearOptions = Array.from(
  { length: new Date().getFullYear() - 1920 + 1 },
  (_, i) => (new Date().getFullYear() - i).toString()
);

export const AgeGate = (props, context) => {
  const { act, data } = useBackend(context);

  const [selectedMonth, selectMonth] = useLocalState<string>(
    context,
    'month',
    MonthOptions[0]
  );

  const [selectedYear, selectYear] = useLocalState<string>(
    context,
    'year',
    CurrentYear
  );

  return (
    <Window width={650} height={350} title="Age Verification">
      <Window.Content>
        <BlockQuote>
          This server requires you to perform age verification to be played on.
        </BlockQuote>
        <Box align="center" grow>
          <Section title="Date of birth" style={{ 'font-size': '150%' }}>
            <Flex style={{ 'justify-content': 'center' }}>
              <Flex.Item mr={1}>
                <Dropdown
                  options={MonthOptions}
                  selected={selectedMonth}
                  onSelected={(newmonth) => selectMonth(newmonth)}
                />
              </Flex.Item>
              <Flex.Item>
                <Dropdown
                  options={YearOptions}
                  selected={selectedYear}
                  onSelected={(newyear) => selectYear(newyear)}
                />
              </Flex.Item>
            </Flex>
          </Section>
          <Tooltip
            content={
              'By clicking this button, you consent to your month and year of birth being stored on the server.'
            }>
            <Button
              mt={1}
              style={{ 'font-size': '150%', 'vertical-align': 'bottom' }}
              onClick={() =>
                act('submit', { 'month': selectedMonth, 'year': selectedYear })
              }>
              Submit
            </Button>
          </Tooltip>
        </Box>
      </Window.Content>
    </Window>
  );
};

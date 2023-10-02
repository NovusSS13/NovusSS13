import { useBackend } from '../backend';
import { Button, LabeledList, NoticeBox, Section, Stack } from '../components';
import { Window } from '../layouts';

export const CryopodConsole = (props, context) => {
  const { data } = useBackend(context);
  const { account_name } = data;

  const welcomeTitle = `Hello, ${account_name || '[REDACTED]'}!`;

  return (
    <Window title="Cryopod Console" width={400} height={480}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Section title={welcomeTitle}>
              This automated cryogenic freezing unit will safely store your
              corporeal form until your next assignment.
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <CrewList />
          </Stack.Item>
          <Stack.Item grow>
            <ItemList />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const CrewList = (props, context) => {
  const { data } = useBackend(context);
  const { frozen_crew } = data;

  return (
    (frozen_crew.length && (
      <Section fill scrollable>
        <LabeledList>
          {frozen_crew.map((person) => (
            <LabeledList.Item key={person} label={person.name}>
              {person.job}
            </LabeledList.Item>
          ))}
        </LabeledList>
      </Section>
    )) || <NoticeBox>No stored crew!</NoticeBox>
  );
};

const ItemList = (props, context) => {
  const { act, data } = useBackend(context);
  const { item_refs, item_names, item_retrieval_allowed } = data;

  if (!item_retrieval_allowed)
    return <NoticeBox>You are not authorized for item management.</NoticeBox>;

  if (item_refs.length <= 0) return <NoticeBox>No stored items!</NoticeBox>;

  return (
    <Section fill scrollable>
      <LabeledList>
        {item_refs.map((item) => (
          <LabeledList.Item key={item} label={item_names[item]}>
            <Button
              icon="exclamation-circle"
              content="Retrieve"
              color="bad"
              onClick={() => act('get_item', { item_ref: item })}
            />
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
  );
};

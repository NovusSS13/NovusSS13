import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Button, LabeledList, NoticeBox, Section, Stack } from '../components';
import { Window } from '../layouts';

type Data = {
  frozen_crew: {
    name: string;
    rank: string;
  }[];
  item_refs: Record<string, string>;
  item_retrieval_allowed: BooleanLike;
  account_name: string;
};

export const CryopodConsole = (props, context) => {
  const { data } = useBackend<Data>(context);
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
  const { data } = useBackend<Data>(context);
  const { frozen_crew } = data;

  if (frozen_crew.length <= 0) return <NoticeBox>No stored crew!</NoticeBox>;

  return (
    <Section fill scrollable>
      <LabeledList>
        {frozen_crew.map((person_data) => (
          <LabeledList.Item label={person_data.name}>
            {person_data.rank}
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
  );
};

const ItemList = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { item_refs, item_retrieval_allowed } = data;

  if (!item_retrieval_allowed)
    return <NoticeBox>You are not authorized for item management.</NoticeBox>;

  const keys = Object.keys(item_refs);
  if (keys.length <= 0) return <NoticeBox>No stored items!</NoticeBox>;

  return (
    <Section fill scrollable>
      <LabeledList>
        {keys.map((ref) => (
          <LabeledList.Item label={item_refs[ref]}>
            <Button
              icon="exclamation-circle"
              content="Retrieve"
              color="bad"
              onClick={() => act('get_item', { item_ref: ref })}
            />
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
  );
};

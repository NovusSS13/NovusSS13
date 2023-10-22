import { resolveAsset } from '../assets';
import { useBackend } from '../backend';
import { Icon, LabeledList, Section, Stack } from '../components';
import { Window } from '../layouts';

type Data = {
  label: string;
  registered_name: string;
  registered_age: number;
  assignment: string;
  dna_hash: string;
  fingerprint: string;
  blood_type: string;
  registered_account: Account;
  front_photo: string;
  from_central_command: boolean;
  tastefully_thick: boolean;
};

type Account = {
  holder: string;
  balance: number;
  mining_points: number;
  department_account: string;
  department_balance: number;
  bounty: Bounty | null;
};

type Bounty = {
  name: string;
  description: string;
  reward: number;
};

export const IdCardPanel = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const {
    label,
    registered_name,
    assignment,
    registered_age,
    blood_type,
    dna_hash,
    fingerprint,
    registered_account,
    front_photo,
    from_central_command,
    tastefully_thick,
  } = data;
  const { bounty } = registered_account || { bounty: null };

  return (
    <Window title="ID Card" width={800} height={450}>
      <Window.Content
        style={
          !from_central_command && {
            'background': 'none',
          }
        }>
        <Section
          fill
          title={
            <Stack>
              <Stack.Item>
                <Icon
                  name={from_central_command ? 'tg-nanotrasen-logo' : 'id-card'}
                />
              </Stack.Item>
              <Stack.Item grow>{label}</Stack.Item>
            </Stack>
          }>
          <Stack>
            <Stack.Item maxWidth="65%">
              <LabeledList>
                <LabeledList.Item label="Name">
                  {registered_name || 'Unknown'}
                </LabeledList.Item>
                <LabeledList.Item label="Age">
                  {registered_age || '??'}
                </LabeledList.Item>
                <LabeledList.Item label="Assignment">
                  {assignment || 'Unknown'}
                </LabeledList.Item>
                <LabeledList.Item label="Blood Type">
                  {blood_type || '?'}
                </LabeledList.Item>
                <LabeledList.Item label="DNA Hash">
                  {dna_hash || '??????'}
                </LabeledList.Item>
                <LabeledList.Item label="Fingerprint">
                  {fingerprint || '??????'}
                </LabeledList.Item>
                {(registered_account && (
                  <>
                    <LabeledList.Item label="Bank Account">
                      {registered_account.holder}
                    </LabeledList.Item>
                    <LabeledList.Item label="Account Balance">
                      {registered_account.balance}cr
                    </LabeledList.Item>
                    <LabeledList.Item label="Mining Points">
                      {registered_account.mining_points}
                    </LabeledList.Item>
                    {registered_account.department_account && (
                      <>
                        <LabeledList.Item label="Department Account">
                          {registered_account.department_account}
                        </LabeledList.Item>
                        <LabeledList.Item label="Department Balance">
                          {registered_account.department_balance}cr
                        </LabeledList.Item>
                      </>
                    )}
                    {registered_account.bounty && (
                      <>
                        <LabeledList.Item label="Bounty Name">
                          {registered_account.bounty.name}
                        </LabeledList.Item>
                        <LabeledList.Item label="Bounty Description">
                          {registered_account.bounty.description}
                        </LabeledList.Item>
                        <LabeledList.Item label="Bounty Reward">
                          {registered_account.bounty.reward}cr
                        </LabeledList.Item>
                      </>
                    )}
                  </>
                )) ||
                  null}
              </LabeledList>
            </Stack.Item>
            <Stack.Divider />
            <Stack.Item width="35%">
              <Section>
                <Stack.Item
                  grow
                  style={{
                    'background-color': 'black',
                  }}>
                  <img src={resolveAsset(front_photo)} width="100%" />
                </Stack.Item>
              </Section>
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};

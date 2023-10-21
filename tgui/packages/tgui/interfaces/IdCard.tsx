import { useBackend } from '../backend';
import { Section } from '../components';
import { Window } from '../layouts';

type Data = {
  label: string;
  registered_name: string;
  assignment: string;
  registered_age: number;
  dna_hash: string;
  fingerprint: string;
  blood_type: string;
  front_photo: string;
  side_photo: string;
};

export const IdCard = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const {
    label,
    registered_name,
    assignment,
    registered_age,
    dna_hash,
    fingerprint,
    blood_type,
    front_photo,
    side_photo,
  } = data;

  return (
    <Window title="ID Card" width={600} height={400}>
      <Window.Content>
        <Section />
      </Window.Content>
    </Window>
  );
};

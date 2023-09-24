import { ByondUi, Stack, Button } from '../../components';

export const CharacterPreview = (props: { height: string; id: string }) => {
  return (
    <ByondUi
      width="220px"
      height={props.height}
      params={{
        id: props.id,
        type: 'map',
      }}
    />
  );
};

export const RotateButtons = (props: {
  handleRotateLeft: () => void;
  handleRotateRight: () => void;
}) => {
  return (
    <Stack width="100%" textAlign="center">
      <Stack.Item grow>
        <Button
          width="100%"
          onClick={props.handleRotateLeft}
          fontSize="22px"
          icon="undo"
          tooltip="Rotate left"
          tooltipPosition="bottom"
        />
      </Stack.Item>
      <Stack.Item grow>
        <Button
          width="100%"
          onClick={props.handleRotateRight}
          fontSize="22px"
          icon="redo"
          tooltip="Rotate right"
          tooltipPosition="bottom"
        />
      </Stack.Item>
    </Stack>
  );
};

import { CheckboxInput, FeatureToggle } from '../base';

export const balloon_alerts_on_map: FeatureToggle = {
  name: 'Enable Balloon Alerts',
  category: 'BALLOON',
  description: 'Balloon alerts will show above objects and mobs.',
  component: CheckboxInput,
};

export const balloon_alerts_on_chat: FeatureToggle = {
  name: 'Enable Balloon Alert Messages',
  category: 'BALLOON',
  description: 'Balloon alerts will show on the chat box.',
  component: CheckboxInput,
};

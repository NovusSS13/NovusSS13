import { multiline } from 'common/string';
import { CheckboxInput, FeatureToggle } from '../base';

export const display_login_logout: FeatureToggle = {
  name: 'Display login/logout',
  category: 'GAMEPLAY',
  description: multiline`
    When enabled, you will see messages about players connecting to or disconnecting from the server.
  `,
  component: CheckboxInput,
};

import { Antagonist, Category } from '../base';
import { BROTHER_MECHANICAL_DESCRIPTION } from './bloodbrother';

const AwakenedBloodBrother: Antagonist = {
  key: 'awakenedbloodbrother',
  name: 'Awakened Blood Brother',
  description: [
    `A form of blood brother that can trigger midround.`,
    BROTHER_MECHANICAL_DESCRIPTION,
  ],
  category: Category.Midround,
  priority: -1,
};

export default AwakenedBloodBrother;

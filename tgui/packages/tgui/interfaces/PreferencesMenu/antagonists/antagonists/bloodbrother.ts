import { Antagonist, Category } from '../base';
import { multiline } from 'common/string';

export const BROTHER_MECHANICAL_DESCRIPTION = multiline`
      Team up with other crew members as blood brothers to combine the strengths
      of your departments, break each other out of prison, and overwhelm the
      station.
      `;

const BloodBrother: Antagonist = {
  key: 'bloodbrother',
  name: 'Blood Brother',
  description: [
    `Some crewmembers have gone through an experimental surgery to unite parts of
     their brain together. They have developed a psychic link and can communicate
     with each other with ease, along with other abilities.`,
    BROTHER_MECHANICAL_DESCRIPTION,
  ],
  category: Category.Roundstart,
};

export default BloodBrother;

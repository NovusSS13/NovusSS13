import { useBackend } from '../backend';
import { Collapsible, Section, Stack } from '../components';
import { Window } from '../layouts';

type Rule = {
  name: string;
  content: string;
};

type RuleCategory = {
  name: string;
  rules: Rule[];
};

type Data = {
  categories: RuleCategory[];
};
export const Rules = (props, context) => {
  const { data } = useBackend<Data>(context);
  const { categories } = data;

  return (
    <Window title={'Server Rules'} width={600} height={800}>
      <Window.Content overflowY="scroll">
        <Stack vertical>
          {categories.map((category: RuleCategory) => (
            <Stack.Item fill key={category.name}>
              <Collapsible title={category.name}>
                <Stack vertical>
                  {category.rules.map((rule: Rule) => (
                    <Stack.Item key={rule.name}>
                      <Section title={rule.name}>{rule.content}</Section>
                    </Stack.Item>
                  ))}
                </Stack>
              </Collapsible>
            </Stack.Item>
          ))}
        </Stack>
      </Window.Content>
    </Window>
  );
};

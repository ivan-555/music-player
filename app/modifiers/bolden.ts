import { modifier } from 'ember-modifier';

interface BoldenSignature {
  Element: HTMLElement;
  Args: {
    Named: Record<string, never>;
    Positional: [];
  };
}

export default modifier<BoldenSignature>((element: HTMLElement) => {
  element.style.fontWeight = 'bold';
});

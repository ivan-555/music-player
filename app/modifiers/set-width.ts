import { modifier } from 'ember-modifier';

interface SetWidthSignature {
  Element: HTMLElement;
  Args: {
    Named: {
      percentage: number;
    };
    Positional: [];
  };
}

export default modifier<SetWidthSignature>(
  (element: HTMLElement, _positional, named) => {
    const percentage = named.percentage ?? 0;
    element.style.width = `${percentage}%`;
  }
);

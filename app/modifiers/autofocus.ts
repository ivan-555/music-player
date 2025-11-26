import { modifier } from 'ember-modifier';

interface AutofocusSignature {
  Element: HTMLElement;
  Args: {
    Named: {
      isActive?: boolean;
    };
    Positional: [];
  };
}

export default modifier<AutofocusSignature>(
  (element: HTMLElement, _positional, named) => {
    if (named.isActive) {
      requestAnimationFrame(() => {
        element.focus();
      });
    }
  }
);

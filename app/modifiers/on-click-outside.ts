import { modifier } from 'ember-modifier';

interface OnClickOutsideSignature {
  Element: HTMLElement; // The HTML element the modifier is applied to
  Args: {
    Named: {
      // Named Arguments = arguments passed by name = callback=this.closeModal
      callback: () => void;
    };
    Positional: []; // Positional Arguments = arguments passed by position only, none here. Example = {{someModifier "first" "second"}}
  };
}

export default modifier<OnClickOutsideSignature>(
  (element: HTMLElement, positional, named) => {
    const handleClick = (event: MouseEvent) => {
      if (!element.contains(event.target as Node)) {
        named.callback();
      }
    };

    setTimeout(() => {
      document.addEventListener('click', handleClick);
    }, 0);

    return () => {
      document.removeEventListener('click', handleClick);
    };
  }
);

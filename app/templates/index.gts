import type { TOC } from '@ember/component/template-only';
import { pageTitle } from 'ember-page-title';

interface IndexSignature {
  Args: {
    model: unknown;
    controller: unknown;
  };
}

<template>
  {{pageTitle "Home"}}
  <h1>MusicPlayer</h1>
</template> satisfies TOC<IndexSignature>;

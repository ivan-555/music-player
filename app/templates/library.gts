import Component from '@glimmer/component';
import { pageTitle } from 'ember-page-title';
import Playlist from '../components/playlist';

interface LibrarySignature {
  Args: {
    model: unknown;
    controller: unknown;
  };
}

interface Song {
  title: string;
  artist: string;
  duration: number;
}

export default class Library extends Component<LibrarySignature> {
  get songs() {
    return this.args.model as Song[];
  }

  <template>
    {{pageTitle "Library"}}
    <Playlist @songs={{this.songs}} @name="Library" />
  </template>
}

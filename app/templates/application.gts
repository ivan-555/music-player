import { pageTitle } from 'ember-page-title';
import Component from '@glimmer/component';
import Sidebar from '../components/sidebar';
import PlayBar from '../components/play-bar';

export default class Application extends Component {
  <template>
    {{pageTitle "MusicPlayer"}}
    <div class="app">
      <Sidebar />
      <div class="window">
        {{outlet}}
      </div>
      <PlayBar />
    </div>
  </template>
}

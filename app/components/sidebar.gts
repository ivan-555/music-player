import Component from '@glimmer/component';
import { LinkTo } from '@ember/routing';
import CreatePlaylistModal from './create-playlist-modal';
import { tracked } from '@glimmer/tracking';
import { on } from '@ember/modifier';
import { service } from '@ember/service';
import type DataService from '../services/data';

export interface SidebarSignature {
  Args: {};
  Blocks: {
    default: [];
  };
  Element: null;
}

export interface Song {
  title: string;
  artist: string;
  duration: number;
}

export default class Sidebar extends Component<SidebarSignature> {
  @tracked createPlaylistModalState: 'closed' | 'open' = 'closed';

  toggleCreatePlaylistModal = (event: Event) => {
    event.stopPropagation();
    this.createPlaylistModalState =
      this.createPlaylistModalState === 'closed' ? 'open' : 'closed';
  };

  closeCreatePlaylistModal = () => {
    this.createPlaylistModalState = 'closed';
  };

  get createPlaylistModalClass() {
    return this.createPlaylistModalState === 'open' ? 'active' : '';
  }

  @service declare data: DataService;

  addPlaylist = (name: string) => {
    if (!name || name.trim() === '') {
      return;
    }
    this['data'].addPlaylist(name);
  };

  get playlists() {
    return this['data'].playlists;
  }

  <template>
    <div class="sidebar">
      <LinkTo @route="index" @activeClass="active"><i
          class="fa-solid fa-house"
        ></i>
        Home</LinkTo>
      <LinkTo @route="library" @activeClass="active"><i
          class="fa-solid fa-database"
        ></i>
        Library</LinkTo>
      <div class="create-playlist-wrapper">
        <button
          type="button"
          class="create-playlist-btn"
          {{on "click" this.toggleCreatePlaylistModal}}
        >+ Create Playlist</button>
        <CreatePlaylistModal
          @class={{this.createPlaylistModalClass}}
          @createNewPlaylistFn={{this.addPlaylist}}
          @closeCreatePlaylistModalFn={{this.closeCreatePlaylistModal}}
        />
      </div>
      <ul>
        <span>Playlists:</span>
        {{#each this.playlists as |playlist|}}
          <li>
            <LinkTo
              @route="playlists"
              @model={{playlist.name}}
              @activeClass="active"
            ><i class="fa-solid fa-headphones"></i>
              {{playlist.name}}</LinkTo>
          </li>
        {{/each}}
      </ul>
    </div>
  </template>
}

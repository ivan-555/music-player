import Component from '@glimmer/component';
import { service } from '@ember/service';
import onClickOutside from 'music-player/modifiers/on-click-outside';
import type DataService from '../services/data';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';
import { tracked } from '@glimmer/tracking';

export interface AddToPlaylistModalSignature {
  Args: {
    class: string;
    addSongToPlaylistFn: (song: Song, playlistName: string) => void;
    song: Song;
    closeAddToPlaylistModalFn: (song: Song) => void;
  };
}

interface Song {
  title: string;
  artist: string;
  duration: number;
}

export default class AddToPlaylistModal extends Component<AddToPlaylistModalSignature> {
  @service declare data: DataService;

  get playlists() {
    return this['data'].playlists;
  }

  @tracked _selectedPlaylist: string = '';

  get selectedPlaylist() {
    if (this._selectedPlaylist) {
      return this._selectedPlaylist;
    }
    return this.playlists.length > 0 ? (this.playlists[0]?.name ?? '') : '';
  }

  setSelectedPlaylist = (e: Event) => {
    if (!(e.target instanceof HTMLSelectElement)) {
      return;
    }
    this._selectedPlaylist = e.target.value;
  };

  handleAddClick = (event: Event) => {
    event.stopPropagation();
    if (!this.selectedPlaylist) {
      return;
    }
    this.args.addSongToPlaylistFn(this.args.song, this.selectedPlaylist);
    this.args.closeAddToPlaylistModalFn(this.args.song);
  };

  isSongInPlaylist = (song: Song, playlistName: string): boolean => {
    const playlist = this.playlists.find((p) => p.name === playlistName);
    if (!playlist) {
      return false;
    }
    return playlist.songs.some(
      (s) => s.title === song.title && s.artist === song.artist
    );
  };

  handleClickOutside = () => {
    this.args.closeAddToPlaylistModalFn(this.args.song);
  };

  <template>
    <div
      class="add-to-playlist-modal {{@class}}"
      {{onClickOutside callback=this.handleClickOutside}}
    >
      <form>
        <label for="playlist-select">Select Playlist:</label>
        <select
          id="playlist-select"
          name="playlist-select"
          {{on "change" this.setSelectedPlaylist}}
        >
          {{#each this.playlists as |playlist|}}
            <option
              value="{{playlist.name}}"
              class="{{if
                  (this.isSongInPlaylist @song playlist.name)
                  'disabled'
                  ''
                }}"
            >{{playlist.name}}</option>
          {{/each}}
        </select>
        <button type="button" {{on "click" this.handleAddClick}}>Add</button>
      </form>
    </div>
  </template>
}

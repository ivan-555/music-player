import Component from '@glimmer/component';
import { service } from '@ember/service';
import type DataService from '../services/data';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';
import AddToPlaylistModal from './add-to-playlist-modal';
import { tracked } from '@glimmer/tracking';
import type RouterService from '@ember/routing/router-service';
import { and, eq } from 'ember-truth-helpers';
import { formatDuration } from 'music-player/helpers/format-duration';

export interface PlaylistSignature {
  Args: {
    songs: Song[];
    name: string;
    editablePlaylist?: boolean;
  };
  Blocks: {
    default: [];
  };
  Element: null;
}

interface Song {
  title: string;
  artist: string;
  duration: number;
}

export default class Playlist extends Component<PlaylistSignature> {
  @service declare data: DataService;
  @service declare router: RouterService;

  addSongToPlaylist = (song: Song, playlistName: string) => {
    this['data'].addSongToPlaylist(playlistName, song);
  };

  @tracked openModalForSong: Song | null = null;

  isModalOpen = (song: Song) => {
    return this.openModalForSong === song ? 'active' : '';
  };

  toggleAddToPlaylistModal = (song: Song, event: Event) => {
    event.stopPropagation();
    this.openModalForSong = this.openModalForSong === song ? null : song;
  };

  closeAddToPlaylistModal = (song: Song) => {
    if (this.openModalForSong === song) {
      this.openModalForSong = null;
    }
  };

  removeSongFromPlaylist = (song: Song, playlistName: string) => {
    this.data.removeSongFromPlaylist(song, playlistName);
  };

  @tracked isDisabled: boolean = true;

  enableInput = () => {
    this.isDisabled = false;
  };

  disableInput = () => {
    this.isDisabled = true;
  };

  handleBlur = (e: Event) => {
    if (!(e.target instanceof HTMLInputElement)) {
      return;
    }
    const newName = e.target.value;
    const oldName = this.args.name;
    if (newName && newName !== oldName) {
      this.data.renamePlaylist(oldName, newName);
      this.router.transitionTo('playlists', newName);
    }
    this.disableInput();
  };

  deletePlaylist = () => {
    this.data.deletePlaylist(this.args.name);
    this.router.transitionTo('library');
  };

  toggleDeletePlaylistAlert = () => {
    const confirmation = window.confirm(
      `Are you sure you want to delete the playlist "${this.args.name}"? This action cannot be undone.`
    );
    if (confirmation) {
      this.deletePlaylist();
    }
  };

  playSong = (song: Song) => {
    this.data.playSong(song);
  };

  get currentlyPlayingSong() {
    return this.data.currentlyPlayingSong;
  }

  isCurrentlyPlayingSong = (song: Song): boolean => {
    if (!this.currentlyPlayingSong) {
      return false;
    }
    const isSameSong =
      this.currentlyPlayingSong.title === song.title &&
      this.currentlyPlayingSong.artist === song.artist;

    // Wenn keine Playlist gesetzt ist, zeige den Song trotzdem an
    if (!this.data.currentlyPlayingPlaylistName) {
      return isSameSong;
    }

    const isSamePlaylist =
      this.data.currentlyPlayingPlaylistName === this.args.name;
    return isSameSong && isSamePlaylist;
  };

  get currentlyPlayingPlaylist() {
    return this.data.currentlyPlayingPlaylistName;
  }

  setCurrentlyPlayingPlaylist = (playlistName: string) => {
    this.data.setCurrentlyPlayingPlaylist(playlistName);
  };

  handleSongClick = (song: Song, event: Event) => {
    event.stopPropagation();
    this.playSong(song);
    this.setCurrentlyPlayingPlaylist(this.args.name);
  };

  get isPlaying() {
    return this.data.isPlaying;
  }

  playPlaylist = (playlistName: string) => {
    const songs = this.args.songs;
    const firstSong = songs[0];
    if (firstSong) {
      this.playSong(firstSong);
      this.setCurrentlyPlayingPlaylist(playlistName);
    }
  };

  <template>
    <div class="playlist">
      <div class="heading">
        <input
          disabled={{this.isDisabled}}
          type="text"
          id="playlist-name-input"
          value="{{@name}}"
          {{on "blur" this.handleBlur}}
        />
        <button type="button" {{on "click" (fn this.playPlaylist @name)}}>
          <i class="fa-solid fa-circle-play"></i>
        </button>
        {{#if @editablePlaylist}}
          <label for="playlist-name-input" {{on "click" this.enableInput}}>
            <i class="fa-solid fa-pencil"></i>
          </label>
          <button type="button" {{on "click" this.toggleDeletePlaylistAlert}}><i
              class="fa-solid fa-trash"
            ></i></button>
        {{/if}}
      </div>
      <ul class="song-list">
        {{#each @songs as |song|}}
          {{! template-lint-disable no-invalid-interactive }}
          <li
            class="song-item
              {{if (this.isCurrentlyPlayingSong song) 'playing'}}"
            {{on "click" (fn this.handleSongClick song)}}
          >
            <i
              class="fa-solid fa-music
                {{if
                  (and
                    (eq this.isPlaying true) (this.isCurrentlyPlayingSong song)
                  )
                  'playing'
                }}"
            ></i>
            <span class="song-title">{{song.title}}</span>
            -
            <span class="song-artist">{{song.artist}}</span>
            -
            <span class="song-duration">{{formatDuration song.duration}}</span>
            <div class="button-wrapper">
              <button
                type="button"
                {{on "click" (fn this.toggleAddToPlaylistModal song)}}
                class="add-btn"
              >+ add to a playlist</button>
              <AddToPlaylistModal
                @addSongToPlaylistFn={{this.addSongToPlaylist}}
                @song={{song}}
                @class={{this.isModalOpen song}}
                @closeAddToPlaylistModalFn={{this.closeAddToPlaylistModal}}
              />
            </div>
            {{#if @editablePlaylist}}
              <button
                type="button"
                {{on "click" (fn this.removeSongFromPlaylist song @name)}}
                class="remove-btn"
              >X</button>
            {{/if}}
          </li>
        {{/each}}
      </ul>
    </div>
  </template>
}

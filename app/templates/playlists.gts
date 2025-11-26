import { pageTitle } from 'ember-page-title';
import Component from '@glimmer/component';
import Playlist from '../components/playlist';
import { service } from '@ember/service';
import type DataService from '../services/data';

interface PlaylistsSignature {
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

interface PlaylistModel {
  name: string;
  songs: Song[];
}

export default class Playlists extends Component<PlaylistsSignature> {
  @service declare data: DataService;

  get playlistName() {
    return (this.args.model as PlaylistModel).name;
  }

  get playlist() {
    return this['data'].playlists.find((p) => p.name === this.playlistName);
  }

  <template>
    {{pageTitle "Playlists"}}
    {{#if this.playlist}}
      <Playlist
        @songs={{this.playlist.songs}}
        @name={{this.playlist.name}}
        @editablePlaylist={{true}}
      />
    {{/if}}
  </template>
}

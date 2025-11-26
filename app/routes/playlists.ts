import Route from '@ember/routing/route';
import { service } from '@ember/service';
import type DataService from '../services/data';

export default class PlaylistsRoute extends Route {
  @service declare 'data': DataService;

  model(params: { playlist_id: string }) {
    return this['data'].playlists.find(
      (playlist) => playlist.name === params.playlist_id
    );
  }
}

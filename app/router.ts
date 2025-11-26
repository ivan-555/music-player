import EmberRouter from '@embroider/router';
import config from 'music-player/config/environment';

export default class Router extends EmberRouter {
  location = config.locationType;
  rootURL = config.rootURL;
}

Router.map(function () {
  this.route('library');
  this.route('playlists', { path: '/playlists/:playlist_id' });
});

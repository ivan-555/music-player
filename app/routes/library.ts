import Route from '@ember/routing/route';
import { service } from '@ember/service';
import type DataService from '../services/data';

export default class LibraryRoute extends Route {
  @service declare 'data': DataService;

  async model() {
    await this['data'].fetchSongs();
    return this['data'].songs;
  }
}

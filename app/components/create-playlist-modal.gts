import autofocus from 'music-player/modifiers/autofocus';
import onClickOutside from 'music-player/modifiers/on-click-outside';
import Component from '@glimmer/component';
import { fn } from '@ember/helper';
import { on } from '@ember/modifier';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';

export interface CreatePlaylistModalSignature {
  Args: {
    class: string;
    createNewPlaylistFn: (name: string) => void;
    closeCreatePlaylistModalFn: () => void;
  };
  Blocks: {
    default: [];
  };
  Element: null;
}

export default class CreatePlaylistModal extends Component<CreatePlaylistModalSignature> {
  @tracked playlistNameInput: string = '';

  get isActive() {
    return this.args.class.includes('active');
  }

  @action setPlaylistNameInput(e: Event) {
    if (!(e.target instanceof HTMLInputElement)) {
      return;
    }
    this.playlistNameInput = e.target.value;
  }

  @action handleCreateClick() {
    if (!this.playlistNameInput) {
      return;
    }
    this.args.createNewPlaylistFn(this.playlistNameInput);
    this.playlistNameInput = '';
    this.args.closeCreatePlaylistModalFn();
  }

  <template>
    <div
      class="create-playlist-modal {{@class}}"
      {{onClickOutside callback=@closeCreatePlaylistModalFn}}
    >
      <form>
        <label for="playlist-name">Playlist Name:</label>
        <input
          value={{this.playlistNameInput}}
          type="text"
          id="playlist-name"
          name="playlist-name"
          {{on "input" this.setPlaylistNameInput}}
          {{autofocus isActive=this.isActive}}
        />
        <button
          type="button"
          {{on "click" this.handleCreateClick}}
        >Create</button>
      </form>
    </div>
  </template>
}

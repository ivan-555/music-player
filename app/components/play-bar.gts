import Component from '@glimmer/component';
import bolden from '../modifiers/bolden';

export interface PlayBarSignature {
  Args: {};
  Blocks: {
    default: [];
  };
  Element: null;
}

export default class PlayBar extends Component<PlayBarSignature> {
  <template>
    <div class="play-bar">
      <div class="wrapper">
        <div class="infos" {{bolden}}>
          <span class="song-title">Song Title</span>
          <span class="song-artist">Artist Name</span>
          <span class="song-duration">0:00</span>
        </div>
        <div class="controls">
          <button type="button" class="previous button"><i
              class="fa-solid fa-backward"
            ></i></button>
          <button type="button" class="play button"><i
              class="fa-solid fa-play"
            ></i></button>
          <button type="button" class="pause button"><i
              class="fa-solid fa-pause"
            ></i></button>
          <button type="button" class="next button"><i
              class="fa-solid fa-forward"
            ></i></button>
        </div>
      </div>
    </div>
  </template>
}

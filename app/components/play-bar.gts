import Component from '@glimmer/component';

export interface PlayBarSignature {
  // The arguments accepted by the component
  Args: {};
  // Any blocks yielded by the component
  Blocks: {
    default: [];
  };
  // The element to which `...attributes` is applied in the component template
  Element: null;
}

export default class PlayBar extends Component<PlayBarSignature> {
  <template>
    <div class="play-bar">
      <div class="wrapper">
        <div class="infos">
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

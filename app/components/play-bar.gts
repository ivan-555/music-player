import Component from '@glimmer/component';
import bolden from '../modifiers/bolden';
import { service } from '@ember/service';
import type DataService from '../services/data';
import { on } from '@ember/modifier';
import { and, eq } from 'ember-truth-helpers';
import { formatDuration } from 'music-player/helpers/format-duration';
import { formatTime } from 'music-player/helpers/format-time';
import setWidth from 'music-player/modifiers/set-width';

export interface PlayBarSignature {
  Args: {};
  Blocks: {
    default: [];
  };
  Element: null;
}

export default class PlayBar extends Component<PlayBarSignature> {
  @service declare data: DataService;

  get currentlyPlayingSong() {
    return this.data.currentlyPlayingSong;
  }

  get displayTitle() {
    return this.currentlyPlayingSong?.title ?? '---';
  }

  get displayArtist() {
    return this.currentlyPlayingSong?.artist ?? '---';
  }

  get displayDuration() {
    const duration = this.currentlyPlayingSong?.duration;
    return duration ? formatDuration(duration) : '---';
  }

  playNextSong = () => {
    this.data.playNextSong();
  };

  playPreviousSong = () => {
    this.data.playPreviousSong();
  };

  playSongAction = () => {
    this.data.playSongAction();
  };

  pauseSong = () => {
    this.data.pauseSong();
  };

  get isPlaying() {
    return this.data.isPlaying;
  }

  get timer() {
    return this.data.timer;
  }

  get progressPercentage() {
    if (!this.currentlyPlayingSong) {
      return 0;
    }
    const duration = this.currentlyPlayingSong.duration;
    const totalSeconds =
      Math.floor(duration) * 60 +
      Math.round((duration - Math.floor(duration)) * 100);
    return (this.timer / totalSeconds) * 100;
  }

  handleProgressBarClick = (event: MouseEvent) => {
    if (!this.currentlyPlayingSong) {
      return;
    }
    const target = event.currentTarget as HTMLElement;
    const rect = target.getBoundingClientRect();
    const clickX = event.clientX - rect.left;
    const percentage = clickX / rect.width;
    const duration = this.currentlyPlayingSong.duration;
    const totalSeconds =
      Math.floor(duration) * 60 +
      Math.round((duration - Math.floor(duration)) * 100);
    const newTime = Math.floor(percentage * totalSeconds);
    this.data.seekTo(newTime);
  };

  get isShuffling() {
    return this.data.isShuffling;
  }

  shuffleSongs = () => {
    this.data.shuffleSongs();
  };

  <template>
    <div class="play-bar">
      <div class="wrapper">
        <div class="infos" {{bolden}}>
          <span class="song-title">{{this.displayTitle}}</span>
          -
          <span class="song-artist">{{this.displayArtist}}</span>
        </div>
        <div class="timeline">
          <i class="fa-solid fa-music {{if this.isPlaying 'playing'}}"></i>
          <span
            class="progress-time {{if this.currentlyPlayingSong 'active'}}"
          >{{formatTime this.timer}}</span>
          {{! template-lint-disable no-invalid-interactive }}
          <div class="line" {{on "click" this.handleProgressBarClick}}>
            <div
              class="progress"
              {{setWidth percentage=this.progressPercentage}}
            ></div>
          </div>
          <span class="song-duration">{{this.displayDuration}}</span>
        </div>
        <div class="controls">
          <button
            type="button"
            class="previous button {{if this.currentlyPlayingSong 'active'}}"
            {{on "click" this.playPreviousSong}}
          ><i class="fa-solid fa-backward"></i></button>
          <button
            type="button"
            class="play button
              {{if
                (and (eq this.isPlaying false) this.currentlyPlayingSong)
                'active'
              }}"
            {{on "click" this.playSongAction}}
          ><i class="fa-solid fa-play"></i></button>
          <button
            type="button"
            class="pause button {{if this.isPlaying 'active'}}"
            {{on "click" this.pauseSong}}
          ><i class="fa-solid fa-pause"></i></button>
          <button
            type="button"
            class="next button {{if this.currentlyPlayingSong 'active'}}"
            {{on "click" this.playNextSong}}
          ><i class="fa-solid fa-forward"></i></button>
          <button
            type="button"
            class="shuffle button {{if this.isShuffling 'active'}}"
            {{on "click" this.shuffleSongs}}
          >
            <i class="fa-solid fa-shuffle"></i>
          </button>
        </div>
      </div>
    </div>
  </template>
}

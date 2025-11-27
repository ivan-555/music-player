import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';

export interface Song {
  title: string;
  artist: string;
  duration: number;
}

export interface Playlist {
  name: string;
  songs: Song[];
}

export default class DataService extends Service {
  @tracked songs: Song[] = [];

  async fetchSongs(): Promise<void> {
    const res = await fetch('/data/data.json');
    this.songs = (await res.json()) as Song[];
  }

  @tracked playlists: Playlist[] = [];

  constructor(...args: ConstructorParameters<typeof Service>) {
    super(...args);
    this.getLocalStoragePlaylists();
    setInterval(() => {
      this.timer += this.isPlaying ? 1 : 0;
      if (this.currentlyPlayingSong) {
        const duration = this.currentlyPlayingSong.duration;
        const totalSeconds =
          Math.floor(duration) * 60 +
          Math.round((duration - Math.floor(duration)) * 100);
        if (this.timer >= totalSeconds) {
          this.playNextSong();
          this.timer = 0;
        }
      }
    }, 1000);
  }

  renamePlaylist(oldName: string, newName: string): void {
    this.playlists = this.playlists.map((playlist) => {
      if (playlist.name === oldName) {
        return { ...playlist, name: newName };
      }
      return playlist;
    });
    this.setLocalStoragePlaylists();
  }

  deletePlaylist(playlistName: string): void {
    this.playlists = this.playlists.filter(
      (playlist) => playlist.name !== playlistName
    );
    this.setLocalStoragePlaylists();
  }

  setLocalStoragePlaylists(): void {
    localStorage.setItem('playlists', JSON.stringify(this.playlists));
  }

  getLocalStoragePlaylists(): void {
    const storedPlaylists = localStorage.getItem('playlists');
    if (storedPlaylists) {
      this.playlists = JSON.parse(storedPlaylists) as Playlist[];
    }
  }

  addPlaylist(name: string): void {
    this.playlists = [...this.playlists, { name, songs: [] }];
    this.setLocalStoragePlaylists();
  }

  addSongToPlaylist(playlistName: string, song: Song): void {
    this.playlists = this.playlists.map((playlist) => {
      if (playlist.name === playlistName) {
        if (playlist.songs.find((s) => s.title === song.title)) {
          return playlist;
        }
        return { ...playlist, songs: [...playlist.songs, song] };
      }
      return playlist;
    });
    this.setLocalStoragePlaylists();
  }

  removeSongFromPlaylist(song: Song, playlistName: string): void {
    this.playlists = this.playlists.map((playlist) => {
      if (playlist.name === playlistName) {
        return {
          ...playlist,
          songs: playlist.songs.filter((s) => s.title !== song.title),
        };
      }
      return playlist;
    });
    this.setLocalStoragePlaylists();
    this.pauseSong();
    this.currentlyPlayingSong = null;
  }

  @tracked currentlyPlayingSong: Song | null = null;
  @tracked currentlyPlayingPlaylistName: string | null = null;

  playSong(song: Song): void {
    this.currentlyPlayingSong = song;
    this.isPlaying = true;
    this.timer = 0;
  }

  setCurrentlyPlayingPlaylist(playlistName: string): void {
    this.currentlyPlayingPlaylistName = playlistName;
  }

  playNextSong(): void {
    if (!this.currentlyPlayingSong || !this.currentlyPlayingPlaylistName) {
      return;
    }

    let songs: Song[] = [];

    if (this.currentlyPlayingPlaylistName === 'Library') {
      songs = this.songs;
    } else {
      const playlist = this.playlists.find(
        (pl) => pl.name === this.currentlyPlayingPlaylistName
      );
      if (!playlist) {
        return;
      }
      songs = playlist.songs;
    }

    const currentIndex = songs.findIndex(
      (s) =>
        s.title === this.currentlyPlayingSong!.title &&
        s.artist === this.currentlyPlayingSong!.artist
    );
    const nextIndex = (currentIndex + 1) % songs.length;
    const nextSong = songs[nextIndex];
    if (nextSong) {
      this.currentlyPlayingSong = nextSong;
    }
    this.isPlaying = true;
    this.timer = 0;
  }

  playPreviousSong(): void {
    if (!this.currentlyPlayingSong || !this.currentlyPlayingPlaylistName) {
      return;
    }

    let songs: Song[] = [];

    if (this.currentlyPlayingPlaylistName === 'Library') {
      songs = this.songs;
    } else {
      const playlist = this.playlists.find(
        (pl) => pl.name === this.currentlyPlayingPlaylistName
      );
      if (!playlist) {
        return;
      }
      songs = playlist.songs;
    }

    const currentIndex = songs.findIndex(
      (s) =>
        s.title === this.currentlyPlayingSong!.title &&
        s.artist === this.currentlyPlayingSong!.artist
    );
    const previousIndex = (currentIndex - 1 + songs.length) % songs.length;
    const previousSong = songs[previousIndex];
    if (previousSong) {
      this.currentlyPlayingSong = previousSong;
    }
    this.isPlaying = true;
    this.timer = 0;
  }

  @tracked isPlaying: boolean = false;

  pauseSong = () => {
    if (!this.currentlyPlayingSong) {
      return;
    }
    this.isPlaying = false;
  };

  playSongAction = () => {
    if (!this.currentlyPlayingSong) {
      return;
    }
    this.isPlaying = true;
  };

  seekTo = (seconds: number) => {
    this.timer = seconds;
  };

  @tracked timer: number = 0;
}

declare module '@ember/service' {
  interface Registry {
    data: DataService;
  }
}

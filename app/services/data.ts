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

  constructor() {
    super(...arguments);
    this.getLocalStoragePlaylists();
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
          return playlist; // Song already in playlist, do not add
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
  }
}

declare module '@ember/service' {
  interface Registry {
    data: DataService;
  }
}

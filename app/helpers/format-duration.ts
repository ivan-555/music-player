import { helper } from '@ember/component/helper';

export function formatDuration(duration: number): string {
  const minutes = Math.floor(duration);
  const seconds = Math.round((duration - minutes) * 100);
  const formattedSeconds = seconds.toString().padStart(2, '0');
  return `${minutes}:${formattedSeconds}`;
}

export default helper(([duration]: [number]) => formatDuration(duration));

import { helper } from '@ember/component/helper';
import { formatDuration } from '../utils/format-duration';

export default helper(function formatDurationHelper([seconds]: [number]) {
  return formatDuration(seconds);
});

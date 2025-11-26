import { module, test } from 'qunit';
import { setupTest } from 'music-player/tests/helpers';

module('Unit | Route | playlists', function (hooks) {
  setupTest(hooks);

  test('it exists', function (assert) {
    const route = this.owner.lookup('route:playlists');
    assert.ok(route);
  });
});

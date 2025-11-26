import { module, test } from 'qunit';
import { setupRenderingTest } from 'music-player/tests/helpers';
import { render } from '@ember/test-helpers';
import Playlist from 'music-player/components/playlist';

module('Integration | Component | playlist', function (hooks) {
  setupRenderingTest(hooks);

  test('it renders', async function (assert) {
    // Updating values is achieved using autotracking, just like in app code. For example:
    // class State { @tracked myProperty = 0; }; const state = new State();
    // and update using state.myProperty = 1; await rerender();
    // Handle any actions with function myAction(val) { ... };

    await render(<template><Playlist /></template>);

    assert.dom().hasText('');

    // Template block usage:
    await render(<template>
      <Playlist>
        template block text
      </Playlist>
    </template>);

    assert.dom().hasText('template block text');
  });
});

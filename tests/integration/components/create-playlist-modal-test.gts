import { module, test } from 'qunit';
import { setupRenderingTest } from 'music-player/tests/helpers';
import { render } from '@ember/test-helpers';
import CreatePlaylistModal from 'music-player/components/create-playlist-modal';

module('Integration | Component | create-playlist-modal', function (hooks) {
  setupRenderingTest(hooks);

  test('it renders', async function (assert) {
    // Updating values is achieved using autotracking, just like in app code. For example:
    // class State { @tracked myProperty = 0; }; const state = new State();
    // and update using state.myProperty = 1; await rerender();
    // Handle any actions with function myAction(val) { ... };

    await render(<template><CreatePlaylistModal /></template>);

    assert.dom().hasText('');

    // Template block usage:
    await render(<template>
      <CreatePlaylistModal>
        template block text
      </CreatePlaylistModal>
    </template>);

    assert.dom().hasText('template block text');
  });
});

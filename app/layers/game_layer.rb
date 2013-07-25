class GameLayer < Joybox::Core::Layer

  include GameHelper
  include GameController

  attr_accessor :player

  def on_enter
    setup_sprite_batches

    init_player
    init_dpad

    schedule_update do |dt|
      control_player(@player)
      @player.update(dt)
    end
  end

  def on_exit
    # Tear down
  end

  def setup_sprite_batches
    SpriteFrameCache.frames.add file_name: 'sprites/characters.plist'
    sprite_batch = SpriteBatch.new file_name: 'sprites/characters.pvr.ccz'
    sprite_batch.texture.setAliasTexParameters
    self << sprite_batch
  end

  def init_player
    @player = CharacterSprite.new name: 'pete', frame_name: 'pete-character-idle0.png', position: center
    # @player = CharacterSprite.with_name name: 'pete', frame_name: 'pete-character-idle0.png', position: center
    @player.idle
    self << @player
  end

end

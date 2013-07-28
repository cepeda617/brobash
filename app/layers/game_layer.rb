class GameLayer < Joybox::Core::Layer

  include GameHelper
  include GameController

  attr_accessor :player, :world

  def on_enter
    setup_sprite_batches
    init_world
    init_player
    init_dpad

    schedule_update do |dt|
      control_player(@player)
      @player.update(dt)

      @world.step delta: dt
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

  def init_world
    @world = World.new gravity: [0, -10]

    ground = world.new_body position: [0, 0] do
      polygon_fixture box: [Screen.width, 20]
    end
  end

  def init_player
    body = world.new_body position: [0, 0], type: KDynamicBodyType do
      polygon_fixture box: [32, 32]
    end

    @player = Character.new 'pete', position: center, body: body
    @player.idle
    self << @player.sprite
  end

end

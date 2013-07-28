class GameLayer < Joybox::Core::Layer

  include GameHelper
  include GameController

  attr_accessor :player, :world
  attr_reader :ground

  def on_enter
    setup_sprite_batches
    init_world
    init_player
    init_dpad

    schedule_update do |dt|
      control_player

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
    @world = World.new gravity: [0, -20]

    @ground = world.new_body position: [0, 0] do
      polygon_fixture box: [Screen.width, 60], friction: 1.0
    end
  end

  def init_player
    body_options = {
      fixed_rotation: true,
      position: [0, 0],
      type: KDynamicBodyType
    }

    body = world.new_body body_options do
      polygon_fixture box: [32, 32], friction: 0.5, density: 1.0
    end

    @player = Character.new 'pete', position: center, body: body
    @player.idle
    self << @player.sprite

    world.when_collide ground do |colliding_body, is_touching|
      @player.on_ground = true if colliding_body == body
    end
  end

end

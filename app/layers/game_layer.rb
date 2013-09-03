class GameLayer < Joybox::Core::Layer

  scene

  attr_accessor :player, :controller

  def on_enter
    SpriteFrameCache.frames.add file_name: 'sprites/characters.plist'
    sprite_batch = SpriteBatch.new file_name: 'sprites/characters.pvr.ccz'
    sprite_batch.texture.setAliasTexParameters
    self << sprite_batch

    background = LayerColor.new color: "92d6dd".to_color
    self << background

    map_layer = MapLayer.new
    self << map_layer

    world = GameWorld.new
    world.ground = map_layer.ground

    @player = Player.new character: 'pete', position: [Screen.half_width, Screen.height * 0.8]
    map_layer << @player.character
    world << @player.character

    # Handle touch events
    touch_input

    # Game ticker
    schedule_update do |dt|
      world.update(dt)
      @player.controller.interpret dt
    end
  end

  def on_exit
    # Tear down
  end

  def touch_input
    on_touches_began do |touches, event|
      @player.controller.begin touches
    end

    on_touches_ended do |touches, event|
      @player.controller.end touches
    end

    on_touches_moved do |touches, event|
      @player.controller.move touches
    end
  end

end

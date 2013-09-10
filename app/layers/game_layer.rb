class GameLayer < Joybox::Core::Layer

  scene

  include Joybox::TMX

  attr_accessor :player, :controller, :world

  def on_enter
    add_sprite_batch :characters

    @world = World.new gravity: [0, -25]

    # background = LayerColor.new color: "92d6dd".to_color
    # self << background

    grid = Sprite.new file_name: 'arena.png', position: Screen.center
    self << grid

    self << level
    add_ground

    puts "#{ world.bodies.map(&:position).map(&:to_a) }"

    character_body = @world.new_body position: [Screen.half_width, Screen.height * 0.8], type: Body::Dynamic do
      polygon_fixture box: [32, 32]
    end

    @player = Player.new character: 'pete', body: character_body
    level << @player.character

    # Handle touch events
    touch_input

    # Game ticker
    schedule_update do |dt|
      @world.step delta: dt
      @player.controller.interpret dt
      @player.character.update
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

  def add_sprite_batch( file_name )
    SpriteFrameCache.frames.add file_name: "sprites/#{ file_name }.plist"
    sprite_batch = SpriteBatch.new file_name: "sprites/#{ file_name }.pvr.ccz"
    sprite_batch.texture.setAliasTexParameters
    self << sprite_batch
  end

  def level
    @level ||= TileMap.new file_name: 'world1-level1.tmx'
  end

  def ground
    @ground ||= level.object_layers[:collision]
  end

  def add_ground
    ground.objects.each do |object|
      world.new_body position: [object[:x], object[:y]], type: Body::Static do
        polygon_fixture box: [object[:width].to_i, object[:height].to_i]
      end
    end
  end

end

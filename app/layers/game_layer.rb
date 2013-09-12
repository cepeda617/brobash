class GameLayer < Joybox::Core::Layer

  scene

  include Joybox::TMX

  attr_accessor :player, :controller, :world

  def on_enter
    add_sprite_batch :characters

    @world = World.new gravity: [0, -25]

    add_level

    character_body = @world.new_body position: Screen.center, type: Body::Dynamic do
      polygon_fixture box: [16, 16]
    end

    @player = Player.new character: 'pete', body: character_body
    self << @player.character

    # Handle touch events
    touch_input

    # Game ticker
    schedule_update do |dt|
      @world.step delta: dt
      @player.controller.interpret dt
      @player.character.update
    end
  end

  def add_level
    level_image = Sprite.new file_name: 'arena.png', position: Screen.center
    level_image.zOrder = -10
    self << level_image

    world.new_body type: Body::Static do
      # polygon_fixture vertices: [[64, 95], [416, 95], [434, 87], [46, 87]]
      edge_fixture start_point: [64, 95], end_point: [416, 95]
      edge_fixture start_point: [416, 95], end_point: [434, 87]
      edge_fixture start_point: [434, 87], end_point: [46, 87]
      edge_fixture start_point: [46, 87], end_point: [64, 95]
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

end

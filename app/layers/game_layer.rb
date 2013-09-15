class GameLayer < Joybox::Core::Layer

  scene

  include Joybox::TMX

  attr_accessor :player, :controller, :world

  def on_enter
    add_sprite_batch :characters

    Level.arena self

    @player = Player.new character: 'pete'
    self << @player.character

    # Handle touch events
    touch_input

    # Game ticker
    schedule_update do |dt|
      Level.world.step delta: dt
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

end

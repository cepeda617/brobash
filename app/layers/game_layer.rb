class GameLayer < Joybox::Core::Layer

  attr_accessor :player, :controller

  def on_enter
    setup_sprite_batches

    background = LayerColor.new color: "92d6dd".to_color
    self << background

    level = MapLayer.new
    self << level
    
    @player = Player.new character: 'pete', position: [Screen.width * 0.5, Screen.height * 0.8]
    level << @player.sprite

    schedule_update do |dt|
      player.update(dt)
      controller.control(player)
      level.collide_with(player)
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

  def center
    [Screen.width, Screen.height].to_point.half
  end

end

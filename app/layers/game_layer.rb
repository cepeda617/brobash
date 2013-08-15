class GameLayer < Joybox::Core::Layer

  attr_accessor :player, :controller

  def on_enter
    setup_sprite_batches

    background = LayerColor.new color: "92d6dd".to_color
    self << background
    level = MapLayer.new
    self << level
    
    @player = Player.new character: 'pete', position: [Screen.width * 0.5, Screen.width * 0.9]
    self << @player.sprite

    schedule_update do |dt|
      player.update(dt)
      send_controller_input_to_player
      # level.tiles_surrounding(player.sprite, level.ground)
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

  def send_controller_input_to_player
    if controller.left_button.held?
      player.move_left
    elsif controller.right_button.held?
      player.move_right
    end

    if controller.jump_button.held?
      player.jump
    end

    (player.grounded? ? player.idle : player.fall) unless controller.input?
  end

  def center
    [Screen.width, Screen.height].to_point.half
  end

end

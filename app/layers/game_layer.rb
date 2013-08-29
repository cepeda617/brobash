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

    @player = Player.new character: 'pete', position: [Screen.width * 0.5, Screen.height * 0.8]
    map_layer << @player.character

    schedule_update do |dt|
      GameWorld.apply_gravity @player.character, dt
      TileCollisions.resolve map_layer.ground, @player.character
      @player.character.move_to_destination
    end
  end

  def on_exit
    # Tear down
  end

end

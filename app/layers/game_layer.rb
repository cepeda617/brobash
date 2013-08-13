class GameLayer < Joybox::Core::Layer

  include Helper

  attr_accessor :player, :world, :controller

  def on_enter
    setup_sprite_batches

    @world = GameWorld.new
    
    @player = Player.new character: 'pete', position: center, world: world
    self << @player.sprite

    setup_player_collisions

    schedule_update do |dt|
      world.update(dt)
      player.update(dt)
      player.input(controller)
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

  def setup_player_collisions
    @world.physics.when_collide @player.sprite do |colliding_body, is_touching|
      player.character.land if colliding_body == @world.ground
    end
  end

end

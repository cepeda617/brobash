class GameWorld

  attr_accessor :world

  def initialize
    @world = World.new gravity: [0, -20]
  end

  def physics
    @world
  end

  def ground
    @ground ||= world.new_body position: [0, 0] do
      polygon_fixture box: [Screen.width, 60], friction: 1.0
    end
  end

  def update(dt)
    world.step delta: dt
  end

end
class GameWorldObject

  attr_accessor :on_ground, :object

  def initialize( object )
    @object = object
    @on_ground = false
  end

  def apply_gravity( gravity, dt)
    unless grounded?
      gravity_step = gravity.multiply_by dt
      object.velocity = object.velocity.add_to gravity_step
      velocity_step = object.velocity.multiply_by dt
      object.destination = object.position.to_a.add_to velocity_step
    end
  end

  def grounded?
    on_ground
  end

  def collisions_with( layer )
    @collisions ||= TileCollisions.new(layer, self)
  end

end

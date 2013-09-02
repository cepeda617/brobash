module GameWorldObject

  def apply_gravity( gravity, dt)
    unless grounded?
      gravity_step = gravity.multiply_by dt
      self.velocity = self.velocity.add_to gravity_step
      velocity_step = self.velocity.multiply_by dt
      self.destination = self.position.to_a.add_to velocity_step
    end
  end

  def collisions_with( layer )
    @collisions ||= TileCollisions.new(layer, self)
  end

  def update_position
    self.position = self.destination
  end

  def grounded?
    self.on_ground
  end

end

class GameWorld

  @gravity = [0, -450]

  class << self

    attr_accessor :gravity

    def apply_gravity( object, dt )
      gravity_step = gravity.multiply_by dt
      object.velocity = object.velocity.add_to gravity_step
      velocity_step = object.velocity.multiply_by dt
      object.position = object.position.to_a.add_to velocity_step
    end

  end

end

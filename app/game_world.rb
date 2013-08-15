class GameWorld

  @gravity = [0, -450]

  class << self

    attr_accessor :gravity

    def apply_gravity( object, dt )
      velocity = velocity_step(object.velocity, dt)
      object.desired_position = [object.position[0] + velocity[0], object.position[1] + velocity[1]].to_point
    end

    def velocity_step( velocity, dt )
      gravity = gravity_step(dt)
      velocity = [velocity[0] + gravity[0], velocity[1] + gravity[1]]
      [velocity[0] * dt, velocity[1] * dt]
    end

    def gravity_step( dt )
       [gravity[0] * dt, gravity[1] * dt]
     end

  end

end
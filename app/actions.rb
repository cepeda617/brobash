module Actions

  STATES = {
    idle: 1,
    walking: 2,
    jumping: 3,
    falling: 4
  }

  def states
    STATES
  end

  # Creating methods for checking specific states
  STATES.keys.each do |state_name|
    define_method "#{ state_name.to_s }?" do
      self.state == STATES[state_name]
    end
  end

  def update( dt )
    # step_velocity = jbpMult(self.velocity, dt)
    # self.body.position = jbpAdd(self.body.position, step_velocity)
    # self.body.apply_force force: self.force
    # self.sprite.position = updated_body_position(dt)
  end

  def idle
    unless idle?
      sprite.stop_all_actions# and sprite.run_action idle_animation
      # self.velocity = zero
      # self.force = [0, 0]
      self.state = states[:idle]
      self.on_ground = true
    end
  end

  def move_left
    move_with_direction -1 and puts 'moving left'
  end

  def move_right
    move_with_direction 1 and puts 'moving right'
  end

  def move_with_direction( direction )
    if idle?
      sprite.stop_all_actions# and sprite.run_action walk_animation
      self.state = states[:walking]
    end

    if moving?
      # self.velocity = jbp(direction * self.speed, self.velocity.y)
      # self.force = [direction * self.speed, self.force[1]]
      # self.velocity = [direction * speed, self.velocity[1]]
      sprite.body.apply_force force: [direction * speed, 0]
      sprite.flip x: (direction >= 0) ? false : true
    end
  end

  def jump
    if grounded?
      sprite.stop_all_actions and puts 'jumping' #and sprite.run_action jump_animation
      # self.velocity = [clamped_velocity[0], 300]
      self.state = states[:jumping]
      self.on_ground = false
    end

    if jumping?
      sprite.body.apply_force force: [0, vertical]
      # jump_force = jbp(0.0, self.vertical.to_f)
      # self.velocity = jbpAdd(self.velocity, jump_force)
      # self.body.apply_force force: [self.force[0], vertical]
      # self.velocity = [clamped_velocity[0], clamped_velocity[1] * 0.9]
      # self.body.apply_force force: [clamped_velocity[0], vertical]
    end
  end

  def fall
    unless falling?
      sprite.stop_all_actions #and sprite.run_action fall_animation
      self.state = states[:falling]
      puts 'falling'
    end
  end

  def land
    unless grounded?
      self.on_ground = true and puts 'landing'
      idle
    end
  end

  def moving?
    walking? || jumping?
  end

  def grounded?
    self.on_ground
  end

  def speed
    self.stats :speed
  end

  def vertical
    self.stats :vertical
  end

  private

  def updated_body_position( dt )
    position = self.sprite.position.to_a
    [position[0] + velocity_step(dt)[0], position[1] + velocity_step(dt)[1]]
  end
  
  def velocity_step( dt )
    [clamped_velocity[0] * dt, clamped_velocity[1] * dt]
  end

  def clamped_velocity
    x, y = self.velocity[0], self.velocity[1]
    x = 120 if x > 120
    x = -120 if x < -120
    [x, y]
  end

  def animate_action( name, options = {} )
    delay = 1.0 / (options[:speed] || 12)
    repeat = options[:repeat] || true

    action_frames = SpriteFrameCache.frames.where prefix: name, suffix: '.png', from: 0
    animation = Animation.new frames: action_frames, delay: delay
    repeat ? Repeat.forever(action: animation.action) : Animate.with(action: animation.action)
  end

end
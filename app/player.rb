class Player

  STATES = %w( idle walking jumping falling ).map(&:to_sym)

  attr_reader :options
  attr_accessor :state, :on_ground, :velocity, :desired_position, :character

  def initialize( options = {} )
    @options = options
    @character = options[:character]

    @state = nil
    @on_ground = false
    @velocity = CGPointZero
    @desired_position = nil
  end

  def sprite
    @sprite ||= Sprite.new frame_name: "#{ character }-character-idle0.png", position: options[:position]
  end

  def position
    @sprite.position
  end

  def position=( position )
    @sprite.position = position
  end

  def update( dt )
    gravity = GameWorld.gravity
    gravity_step = jbpMult(gravity, dt)
    self.velocity = jbpAdd(self.velocity, gravity_step)
    step_velocity = jbpMult(self.velocity, dt)
    self.desired_position = jbpAdd(self.position, step_velocity)
  end

  # Actions
  def idle
    unless idle?
      puts '>> Idle'
      sprite.stop_all_actions# and animate_idle
      state = :idle
      on_ground = true
    end
  end

  def walk_with_direction( direction )
    if idle?
      sprite.stop_all_actions# and animate_walk
      state = :walking
    end

    if walking?
    end
  end

  def fall
    unless falling?
      @velocity = [@velocity.x, 0].to_point
      state = :falling
    end
  end

  def land
    @on_ground = true
    @velocity = [@velocity.x, 0].to_point
    idle
  end

  def grounded?
    @on_ground
  end

  STATES.each do |state_name|
    define_method "#{ state_name }?" do
      self.state == state_name
    end
  end

end

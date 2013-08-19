class Player

  STATES = %w( idle walking jumping falling ).map(&:to_sym)

  attr_reader :options
  attr_accessor :state, :on_ground, :velocity, :desired_position, :character

  def initialize( options = {} )
    @options = options
    @character = options[:character]
    @state = nil
    @on_ground = false
    
    zero_out
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
    GameWorld.apply_gravity(self, dt)
  end

  def zero_out
    @velocity = [0, 0]
  end

  # Actions
  def idle
    unless idle?
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
      state = :falling
    end
  end

  def land
    @on_ground = true
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
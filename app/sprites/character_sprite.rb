class CharacterSprite < Joybox::Physics::PhysicsSprite

  STATES = %w( idle walking jumping attacking falling )
  DEFAULT_STATS =
  {
    jump: [0, 300],
    speed: [800, 0]
  }

  # include GameWorldObject

  class << self

    def with_name( name, options = {} )
      name = name.to_s.downcase
      character = new options.merge frame_name: "#{ name }-character-idle0.png"
      character.name = name
      character.velocity = [0, 0]
      character.destination = character.position
      character.fall
      character.stats = DEFAULT_STATS
      character
    end

  end

  attr_accessor :name, :state, :velocity, :destination, :stats

  def update
    @is_falling = body.linear_velocity.y < 0
    self.state = :falling if @is_falling

    idle if falling? && grounded?
  end

  def grounded?
    body.linear_velocity.y == 0
  end

  def idle
    unless idle?
      # animate :idle
      self.state = :idle
    end
  end

  def jump
    if grounded?
      stop_all_actions
      self.state = :jumping
      body.apply_force force: stats[:jump]
    end
  end

  def fall
    self.state = :falling
  end

  def left( dt )
    move -1, dt
  end

  def right( dt )
    move 1, dt
  end

  def move( direction, dt )
    if idle?
      # animate :walk
      self.state = :walking
    end

    if walking? || jumping? || falling?
      self.flip x: (direction < 0)
      move_step = stats[:speed].multiply_by(direction * dt)
      body.apply_force force: move_step
    end
  end

  def attack
    unless attacking?
      # animate :attack
      self.state = :attacking
    end
  end

  STATES.each do |state_name|
    define_method "#{ state_name }?" do
      self.state == state_name.to_sym
    end
  end

  private

  def animate( action )
    stop_all_actions and self.run_action animations[action]
  end

  def animations
    {
      idle: animation_for(:idle),
      walk: animation_for(:walk),
      attack: animation_for(:attack, repeat: false, speed: 18)
    }
  end

  def animation_for( action, options = {} )
    delay = 1.0 / (options[:speed] || 12)
    repeat = options.key?(:repeat) ? options[:repeat] : true
    prefix = '%s-character-%s' % [name, action]

    action_frames = SpriteFrameCache.frames.where prefix: prefix, suffix: '.png', from: 0
    animation = Animation.new frames: action_frames, delay: delay
    repeat ? Repeat.forever(action: animation.action) : Animate.with(action: animation.action)
  end

end

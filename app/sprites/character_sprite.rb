class CharacterSprite < Joybox::Physics::PhysicsSprite

  STATES = %w( idle walking jumping attacking falling )

  attr_accessor :state

  def self.with_name( name )
    name = name.to_s.downcase
    options = {
      body: Level.new_character_body,
      frame_name: "#{ name }-character-idle0.png",
      jump_force: [0, 300],
      name: name,
      powerup: nil,
      speed: [800, 0],
      state: :idle
    }
    character = new options
    character.fall
    character
  end

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
      body.apply_force force: self[:jump_force]
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
      move_step = self[:speed].multiply_by(direction * dt)
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
    prefix = '%s-character-%s' % [self[:name], action]

    action_frames = SpriteFrameCache.frames.where prefix: prefix, suffix: '.png', from: 0
    animation = Animation.new frames: action_frames, delay: delay
    repeat ? Repeat.forever(action: animation.action) : Animate.with(action: animation.action)
  end

end

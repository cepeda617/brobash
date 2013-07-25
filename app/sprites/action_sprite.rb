class ActionSprite < Joybox::Core::Sprite

  ACTION_STATES = {
    idle: 1,
    walking: 2,
    attacking: 3
  }

  attr_accessor :center, :damage, :power, :walk_speed, :jump_force, :velocity, :state

  def initialize( options = {}, &block )
    puts '>>> on enter ActionSprite: %s' % options
    @center = [16, 16]
    @damage = 0
    @power = 20
    @walk_speed = 150
    @jump_force = 300
    @velocity = CGPointZero
    @state = action_states[:idle]
  end

  def action_states
    ACTION_STATES
  end

  # Creating methods for checking specific states
  ACTION_STATES.keys.each do |state_name|
    define_method "#{ state_name.to_s }?" do
      @state == ACTION_STATES[state_name.to_sym]
    end
  end

  alias_method :stop, :stop_all_actions

  def update( dt )
    self.position = jbpAdd(self.position, jbpMult(@velocity, dt)) if walking?
  end

  def idle
    unless idle?
      # puts 'Character idle'
      # stop and run_action idle_animation
      @state = action_states[:idle]
    end
  end

  def attack
    # self.run_action attack_animation
  end

  def hurt_with_damage(damage)
  end

  def dizzy_for_time(seconds)
  end

  def walk_left
    walk_with_direction(-1)
  end

  def walk_right
    walk_with_direction(1)
  end

  def jump
  end

  def fall
  end

  def land
  end

  def animate_action( name, options = {} )
    delay = 1.0 / (options[:speed] || 12)
    repeat = options[:repeat] || true

    action_frames = SpriteFrameCache.frames.where prefix: name, suffix: '.png', from: 0
    animation = Animation.new frames: action_frames, delay: delay
    repeat ? Repeat.forever(action: animation.action) : Animate.with(action: animation.action)
  end

  private

  def walk_with_direction( direction )
    if idle?
      # stop and run_action walk_animation
      @state = action_states[:walking]
    end

    if walking?
      # puts 'Keep walking %s' % @walk_speed
      @velocity = jbp(direction * @walk_speed, @velocity.y)
      self.flip x: (@velocity.x >= 0) ? false : true
    end
  end

end

class Character

  attr_reader :name
  attr_accessor :sprite

  def initialize( name, options = {} )
    @name = name
    @sprite = ActionSprite.new frame_name: '%s-character-idle0.png' % name
    @sprite.position = options[:position] if options.key? :position

    @sprite.idle_animation = animate_action '%s-character-idle' % name
    @sprite.walk_animation = animate_action '%s-character-walk' % name
    @sprite.attack_animation = animate_action '%s-character-attack' % name, repeat: false, speed: 18
  end

  private

  def animate_action( name, options = {} )
    delay = 1.0 / (options[:speed] || 12)
    repeat = options[:repeat] || true

    action_frames = SpriteFrameCache.frames.where prefix: name, suffix: '.png', from: 0
    animation = Animation.new frames: action_frames, delay: delay
    repeat ? Repeat.forever(action: animation.action) : Animate.with(action: animation.action)
  end

end
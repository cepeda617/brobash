class Character

  include Actions

  STATS = {
    pete: { power: 20, speed: 150, vertical: 300 }
  }

  attr_reader :name, :idle_animation, :walk_animation
  attr_accessor :sprite, :velocity, :state, :damage

  def initialize( name, options = {} )
    @name = name
    @sprite = PhysicsSprite.new body: options[:body], frame_name: '%s-character-idle0.png' % name
    @sprite.position = options[:position] if options.key? :position

    @velocity = CGPointZero
    @damage = 0

    @idle_animation = animate_action '%s-character-idle' % name
    @walk_animation = animate_action '%s-character-walk' % name
  end

  def stats
    STATS[name.to_sym]
  end

  # Defines accessor for each stat
  %w( power speed vertical ).each do |stat|
    define_method stat do
      stats[stat.to_sym]
    end
  end

end
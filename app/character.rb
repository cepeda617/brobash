class Character

  include Actions

  STATS = {
    pete: { power: 20, speed: 50, vertical: 1000 }
  }

  attr_reader :name, :idle_animation, :walk_animation
  attr_accessor :sprite, :velocity, :state, :damage, :on_ground

  def initialize( name, options = {} )
    @name = name
    @sprite = PhysicsSprite.new body: options[:body], frame_name: '%s-character-idle0.png' % name
    @sprite.position = options[:position] if options.key? :position

    @velocity = CGPointZero
    @damage = 0
    @on_ground = false

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
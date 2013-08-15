class Character

  include Actions

  STATS = {
    pete: { power: 16, speed: 64, vertical: 640 }
  }

  attr_reader :name
  attr_accessor :sprite, :velocity, :state, :damage, :on_ground, :force

  def initialize( name, options = {} )
    @name = name
    @options = options
    @world = options[:world] if options.key? :world

    @velocity = zero
    @damage = 0
    @on_ground = false
    @force = [0, 0]
  end

  def sprite
    @sprite ||= PhysicsSprite.new body: body, frame_name: '%s-character-idle0.png' % name
  end

  def body
    @body ||= @world.new_body(body_defaults.merge position: @options[:position]) do
      polygon_fixture box: [32, 32], friction: 0.8, density: 1.0
    end
  end

  def body_defaults
    {
      fixed_rotation: true,
      # linear_damping: 100,
      position: [0, 0],
      type: Body::Dynamic
    }
  end

  def idle_animation
    @idle_animation ||= animate_action '%s-character-idle' % name
  end

  def walk_animation
    @walk_animation ||= animate_action '%s-character-walk' % name
  end

  def stats( stat_name = nil )
    character_stats = STATS[name.to_sym]
    stat_name ? character_stats[stat_name] : character_stats
  end

end
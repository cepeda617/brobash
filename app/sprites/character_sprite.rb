class CharacterSprite < Joybox::Core::Sprite

  STATES = %w( idle walking jumping falling )
  DEFAULT_STATS =
  {
    jump: [0, 300],
    speed: [800, 0]
  }

  include GameWorldObject

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

  attr_accessor :name, :state, :on_ground, :velocity, :destination, :stats

  def idle
    unless idle?
      stop_all_actions# and animate_idle
      self.state = :idle
    end
  end

  def jump
    if grounded?
      stop_all_actions
      self.on_ground = false
      self.state = :jumping
      apply_force stats[:jump]
    end
  end

  def fall
    unless falling?
      self.state = :falling
    end
  end

  def left( dt )
    move -1, dt
  end

  def right( dt )
    move 1, dt
  end

  def move( direction, dt )
    if idle?
      stop_all_actions #and animate walk
      self.state = :walking
    end

    if walking? || jumping? || falling?
      self.flip x: (direction < 0)
      move_step = stats[:speed].multiply_by(direction * dt)
      puts move_step
      apply_force move_step
    end
  end

  STATES.each do |state_name|
    define_method "#{ state_name }?" do
      self.state == state_name.to_sym
    end
  end

end

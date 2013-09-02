class CharacterSprite < Joybox::Core::Sprite

  STATES = %w( idle walking jumping falling )
  JUMP_FORCE = [0, 300]

  include GameWorldObject

  class << self

    def with_name( name, options = {} )
      name = name.to_s.downcase
      character = new options.merge frame_name: "#{ name }-character-idle0.png"
      character.name = name
      character.velocity = [0, 0]
      character.destination = character.position
      character.fall
      character
    end

  end

  attr_accessor :name, :state, :on_ground, :velocity, :destination

  def idle
    unless idle?
      stop_all_actions# and animate_idle
      self.state = :idle
    end
  end

  def walk_with_direction( direction )
    if idle?
      stop_all_actions# and animate_walk
      self.state = :walking
    end

    if walking?
    end
  end

  def jump
    if grounded?
      puts 'JUMP!'
      stop_all_actions
      self.on_ground = false
      self.state = :jumping
      apply_force JUMP_FORCE
    end
  end

  def fall
    unless falling?
      self.state = :falling
    end
  end

  def land
    puts 'LANDED!'
    self.on_ground = true
    idle
  end

  STATES.each do |state_name|
    define_method "#{ state_name }?" do
      self.state == state_name.to_sym
    end
  end

end

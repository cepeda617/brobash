class CharacterSprite < Joybox::Core::Sprite

  STATES = %w( idle walking falling )

  class << self

    def with_name( name, options = {} )
      name = name.to_s.downcase
      character = new options.merge frame_name: "#{ name }-character-idle0.png"
      character.name = name
      character.destination = character.position
      character.velocity = [0, 0]
      character.fall
      character
    end

  end

  attr_accessor :name, :state, :on_ground, :velocity, :destination

  def idle
    unless idle?
      stop_all_actions# and animate_idle
      state = :idle
    end
  end

  def walk_with_direction( direction )
    if idle?
      stop_all_actions# and animate_walk
      state = :walking
    end

    if walking?
    end
  end

  def fall
    unless falling?
      self.state = :falling
    end
  end

  def land
    self.velocity = [self.velocity.first, 0]
    idle
  end

  STATES.each do |state_name|
    define_method "#{ state_name }?" do
      self.state == state_name
    end
  end

end

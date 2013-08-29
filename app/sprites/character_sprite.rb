class CharacterSprite < Joybox::Core::Sprite

  STATES = %w( idle walking falling )

  class << self

    def with_name( name, options = {} )
      name = name.to_s.downcase
      character = new options.merge frame_name: "#{ name }-character-idle0.png"
      character.name = name
      character.velocity = [0, 0]
      character
    end

  end

  attr_accessor :name, :state, :on_ground, :velocity, :destination

  def move_to_destination
    self.position = destination
  end

  def idle
    unless idle?
      stop_all_actions# and animate_idle
      state = :idle
      on_ground = true
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
      @velocity = [@velocity.x, 0].to_point
      state = :falling
    end
  end

  def land
    @on_ground = true
    @velocity = [@velocity.x, 0].to_point
    idle
  end

  def grounded?
    @on_ground
  end

  STATES.each do |state_name|
    define_method "#{ state_name }?" do
      self.state == state_name
    end
  end

end

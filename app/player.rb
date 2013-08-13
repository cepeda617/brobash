class Player

  attr_reader :options
  attr_accessor :character

  def initialize( options = {} )
    @options = options
    @world = options[:world].world
    @ground = options[:world].ground
    # character.idle
  end

  def character
    @character ||= Character.new options[:character], position: options[:position], world: @world
  end

  def sprite
    character.sprite
  end

  def update( dt )
    character.update(dt)
  end

  def input( controller )
    if controller.left_button.held?
      character.move_left
    elsif controller.right_button.held?
      character.move_right
    end

    if controller.jump_button.held?
      character.jump
    end

    (character.grounded? ? character.idle : character.fall) unless controller.input?
  end

end
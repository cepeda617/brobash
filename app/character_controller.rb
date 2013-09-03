class CharacterController

  TOUCH_WIDTH = 80

  attr_reader :character
  attr_accessor :current_touches

  def initialize( character )
    @character = character
    @current_touches = []
  end

  def interpret( dt )
    character.jump if jump?
    character.left(dt) if left?
    character.right(dt) if right?
    character.idle if no_input?
  end

  def begin( touches )
    self.current_touches = touches.allObjects
  end

  def end( touches )
    self.current_touches -= touches.allObjects
  end

  def move( touches )
    self.current_touches = touches.allObjects
  end

  def no_input?
    current_touches.empty? || not_recognized?
  end

  def not_recognized?
    !(jump? || left? || right?)
  end

  def jump?
    current_touches.any? { |touch| jump_range? touch  }
  end

  def left?
    current_touches.any? { |touch| left_range? touch }
  end

  def right?
    current_touches.any? { |touch| right_range? touch }
  end

  private

  def jump_range?( touch )
    (Screen.width - TOUCH_WIDTH * 2) < touch.location.x && touch.location.x < (Screen.width - TOUCH_WIDTH)
  end

  def left_range?( touch )
    0 < touch.location.x && touch.location.x <= TOUCH_WIDTH
  end

  def right_range?( touch )
    TOUCH_WIDTH < touch.location.x && touch.location.x <= (TOUCH_WIDTH * 2)
  end

end

class CharacterController

  TOUCH_WIDTH = 80

  attr_reader :character
  attr_accessor :began, :ended, :moved

  def initialize( character )
    @character = character
    @began = []
    @ended = []
    @moved = []
  end

  def interpret
    character.jump if jump?
    character.fall if fall?
    character.left if left?
  end

  def begin( touches )
    self.began = touches.allObjects
  end

  def end( touches )
    self.ended = touches.allObjects
  end

  def move( touches )
    self.moved = touches.allObjects
  end

  def all
    began & ended & moved
  end

  def input?
    !all.empty?
  end

  def jump?
    began.any? { |touch| jump_range? touch  }
  end

  def fall?
    ended.any? { |touch| jump_range? touch }
  end

  def left?
    (began & moved).any? { |touch| left_range? touch }
  end

  private

  def jump_range?( touch )
    (Screen.width - TOUCH_WIDTH * 2) < touch.location.x && touch.location.x < (Screen.width - TOUCH_WIDTH)
  end

  def left_range?( touch )
    0 < touch.location.x && touch.location.x < TOUCH_WIDTH
  end

end

class MenuImageHoldable < Joybox::UI::MenuImage

  attr_accessor :held

  def selected
    super
    @held = true
    self.opacity = 128
  end

  def unselected
    super
    @held = false
    self.opacity = 64
  end

  def held?
    @held
  end

end
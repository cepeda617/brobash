class GameController < Joybox::Core::Layer

  # def init_dpad
  #   @input = false
  #   @direction = 0

  #   on_touches_began do |touches, event|
  #     update_inputs_from_touches(touches)
  #   end

  #   on_touches_moved do |touches, event|
  #     update_inputs_from_touches(touches)
  #   end

  #   on_touches_ended do |touches, event|
  #     no_input
  #   end

  #   # on_touches_cancelled do |touches, event|
  #   # end
  # end

  # def update_inputs_from_touches( touches )
  #   for touch in touches do
  #     @holding_left = left?(touch)
  #     @holding_right = right?(touch)
  #     @holding_jump = jump?(touch)
  #   end

  #   @input = touches.nil? ? false : true
  # end

  # def no_input
  #   self.player.idle if self.player.moving?
  #   @direction = 0
  #   @input = false
  #   @holding_left = false
  #   @holding_right = false
  #   @holding_jump = false
  # end

  # def left?( touch )
  #   touch.location.x.between? 0, 80
  # end

  # def right?( touch )
  #   touch.location.x.between? 81, 160
  # end

  # def jump?( touch )
  #   touch.location.x.between? Screen.width - 160, Screen.width
  # end

  # def input?
  #   @input
  # end

  # def holding_left?
  #   @holding_left
  # end

  # def holding_right?
  #   @holding_right
  # end

  # def holding_jump?
  #   @holding_jump
  # end

  # def move_player
  #   self.player.move_left if holding_left?
  #   self.player.move_right if holding_right?
  #   self.player.jump if holding_jump?
  # end

  def on_enter
    @directional_buttons = [left_button, right_button]
    dpad = Menu.new items: @directional_buttons, position: [60,30]
    dpad.align_items_horizontally
    self << dpad

    @action_buttons = [jump_button, attack_button]
    dpad = Menu.new items: @action_buttons, position: [Screen.width - 60, 30]
    dpad.align_items_horizontally
    self << dpad

    all_buttons.each { |button| button.opacity = 64 }
  end

  def all_buttons
    @directional_buttons + @action_buttons
  end

  def input?
    (@directional_buttons + @action_buttons).any?(&:held?)
  end

  def left_button
    @left_button ||= MenuImageHoldable.new image_file_name:'dpad-left.png' do |menu_item|
      # puts 'Touching left button!!!'
    end
  end

  def right_button
    @right_button ||= MenuImageHoldable.new image_file_name:'dpad-right.png' do |menu_item|
      # puts 'Touching right button!!!'
    end
  end

  def jump_button
    @jump_button ||= MenuImageHoldable.new image_file_name:'dpad-jump.png' do |menu_item|
    end
  end

  def attack_button
    @attack_button ||= MenuImageHoldable.new image_file_name:'dpad-attack.png' do |menu_item|
    end
  end

end
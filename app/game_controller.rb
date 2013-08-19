class GameController < Joybox::Core::Layer

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

  def control( player )
    if left_button.held?
      player.move_left
    elsif right_button.held?
      player.move_right
    end

    if jump_button.held?
      player.jump
    end

    (player.grounded? ? player.idle : player.fall) unless input?
  end

end
module GameController

  def init_dpad
    @directional_buttons = [left_button, right_button]
    dpad = Menu.new items: @directional_buttons, position: [60,30]
    dpad.align_items_horizontally
    self << dpad

    @action_buttons = [jump_button, attack_button]
    dpad = Menu.new items: @action_buttons, position: [Screen.width - 60, 30]
    dpad.align_items_horizontally
    self << dpad
  end

  def control_player
    if left_button.held?
      self.player.walk_left
    elsif right_button.held?
      self.player.walk_right
    end

    if jump_button.held?
      self.player.jump
    end

    self.player.idle unless input?
  end

  def input?
    (@directional_buttons + @action_buttons).any?(&:held?)
  end

  def left_button
    @left_button ||= MenuImage.new image_file_name: 'dpad-left.png' do |menu_item|
      # puts 'Touching left button!!!'
    end
  end

  def right_button
    @right_button ||= MenuImage.new image_file_name: 'dpad-right.png' do |menu_item|
      # puts 'Touching right button!!!'
    end
  end

  def jump_button
    @jump_button ||= MenuImage.new image_file_name: 'dpad-jump.png' do |menu_item|
      # self.player.jump
    end
  end

  def attack_button
    @attack_button ||= MenuImage.new image_file_name: 'dpad-attack.png' do |menu_item|
    end
  end

end
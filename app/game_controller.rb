module GameController

  def init_dpad
    buttons = [left_button, right_button]
    dpad = Menu.new items: buttons, position: [60,30]
    dpad.align_items_horizontally
    self << dpad

    buttons = [jump_button, attack_button]
    dpad = Menu.new items: buttons, position: [Screen.width - 60, 30]
    dpad.align_items_horizontally
    self << dpad
  end

  def control_player
    if left_button.held?
      self.player.walk_left
    elsif right_button.held?
      self.player.walk_right
    else
      self.player.idle
    end

    if jump_button.held?
      self.player.jump
    end
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
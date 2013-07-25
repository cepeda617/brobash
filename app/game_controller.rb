module GameController

  def init_dpad
    buttons = [left_button, right_button]
    dpad = Menu.new items: buttons, position: [60,30]
    dpad.align_items_horizontally
    self << dpad
  end

  def control_player( player )
    if left_button.held?
      player.walk_left
    elsif right_button.held?
      player.walk_right
    else
      player.idle
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

end
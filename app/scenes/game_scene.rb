class GameScene < Joybox::Core::Scene

  def on_enter
    # Set up
    self << GameLayer.new
    self << HudLayer.new
    self << ControllerLayer.new
  end

  def on_exit
    # Tear down
  end

end

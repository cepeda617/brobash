class GameScene < Joybox::Core::Scene

  attr_accessor :game, :hud, :controller

  def on_enter
    @game = GameLayer.new
    @hud = HudLayer.new
    @controller = GameController.new

    self << game
    self << hud
    self << controller

    game.controller = controller
  end

  def on_exit
    # Tear down
  end

end

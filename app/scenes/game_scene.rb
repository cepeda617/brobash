class GameScene < Joybox::Core::Scene

  attr_accessor :game, :hud, :game_pad

  def on_enter
    @game = GameLayer.new
    @hud = HudLayer.new

    self << @game
    self << @hud
  end

  def on_exit
    # Tear down
  end

end

class AppDelegate

  def application(application, didFinishLaunchingWithOptions:launchOptions)

    @director = Joybox::Configuration.setup do
      director display_stats: true, enable_retina_display: false
      debug repl:true # interactive console support for joybox (turn off for deployment!)
    end

    @navigation_controller = UINavigationController.alloc.initWithRootViewController(@director)
    @navigation_controller.navigationBarHidden = true

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.setRootViewController(@navigation_controller)
    @window.makeKeyAndVisible

    # Hide status bar
    UIApplication.sharedApplication.setStatusBarHidden true, animated:false

    @director << GameScene.new

    true
  end

  def applicationWillResignActive(app)
    @director.pause if @navigation_controller.visibleViewController == @director
  end

  def applicationDidBecomeActive(app)
    @director.resume if @navigation_controller.visibleViewController == @director
  end

  def applicationDidEnterBackground(app)
    @director.stop_animation if @navigation_controller.visibleViewController == @director
  end

  def applicationWillEnterForeground(app)
    @director.start_animation if @navigation_controller.visibleViewController == @director
  end

  def applicationWillTerminate(app)
    @director.end
  end

  def applicationDidReceiveMemoryWarning(app)
    @director.purge_cached_data
  end

  def applicationSignificantTimeChange(app)
    @director.set_next_delta_time_zero true
  end
end

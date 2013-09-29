class AppDelegate
  include RMSettable

  BAR_TINT_COLOR = ColorFactory::str_to_color('#cee4ae') #夏虫色

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    rm_settable :volume, :poems_num, :wrong_asap, :main_button_sound, selected_status: {type: :array}

    AudioPlayerFactory.prepare_embedded_players

    if RUBYMOTION_ENV == 'test'
      return true
    end

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @start_view_controller = StartViewController.alloc.initWithNibName(nil, bundle: nil)
    @nav_controller = UINavigationController.alloc.
        initWithRootViewController(@start_view_controller)
    @nav_controller.navigationBar.barTintColor = BAR_TINT_COLOR
    @nav_controller.toolbar.barTintColor = BAR_TINT_COLOR

    @window.rootViewController= @nav_controller
    @window.makeKeyAndVisible

    true
  end
end

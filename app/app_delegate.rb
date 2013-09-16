class AppDelegate
  include RMSettable

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    rm_settable :volume, :poems_num, :wrong_asap, :main_button_sound, selected_status: {type: :array}

    AudioPlayerFactory.prepare_embedded_players

    if RUBYMOTION_ENV == 'test'
      return true
    end

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
#    @exam_controller = ExamController.alloc.initWithNibName(nil, bundle: nil)
    @start_view_controller = StartViewController.alloc.initWithNibName(nil, bundle: nil)
    @nav_controller = UINavigationController.alloc.
#        initWithRootViewController(@exam_controller)
        initWithRootViewController(@start_view_controller)
#    @nav_controller.setNavigationBarHidden(true, animated: true)
    @window.rootViewController= @nav_controller
    @window.makeKeyAndVisible

    true
  end
end

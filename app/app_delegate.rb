class AppDelegate
  include RMSettable

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    rm_settable :volume
=begin
    if RUBYMOTION_ENV == 'test'
      return true
    end
=end
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @exam_controller = ExamController.alloc.initWithNibName(nil, bundle: nil)
    @nav_controller = UINavigationController.alloc.
        initWithRootViewController(@exam_controller)
    @nav_controller.setNavigationBarHidden(true, animated: true)
    @window.rootViewController= @nav_controller
    @window.makeKeyAndVisible

    true
  end
end

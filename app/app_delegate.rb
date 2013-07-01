class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    if RUBYMOTION_ENV == 'test'
      return true
    end
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController= ExamController.alloc.initWithNibName(nil, bundle: nil)
    @window.makeKeyAndVisible

    true
  end
end

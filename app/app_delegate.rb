class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    puts "--- #{App.name} (#{App.documents_path})"
    puts " ---- #{BubbleWrap.create_uuid}"
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.makeKeyAndVisible

    true
  end
end

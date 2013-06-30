class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    if RUBYMOTION_ENV == 'test'
      return true
    end
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.makeKeyAndVisible

    true
  end
end

class NSString
  def to_color
    # string like a "#0c92f2"
    raise "Unknown color scheme" if (self[0] != '#') || (self.length != 7)
    color = self[1..-1]
    r = color[0..1]
    g = color[2..3]
    b = color[4..5]
    UIColor.colorWithRed((r.hex/255.0), green:(g.hex/255.0), blue:(b.hex/255.0), alpha:1)
  end
end
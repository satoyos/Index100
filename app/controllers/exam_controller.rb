class ExamController < UIViewController
  FUDA_INITIAL_STRING = 'これから札に歌を設定します。'
#  TATAMI_COLOR = ColorFactory.str_to_color('#deb068')
  TATAMI_JPG_FILE = 'tatami_moved.jpg'
  FUDA_HEIGHT_POWER = 0.95 # 札ビューの高さは、畳ビューの何倍にするか

  PROPERTIES = [:fuda_view, :tatami_view]
  PROPERTIES.each do |prop|
    attr_reader prop
  end

  def viewDidLoad
    super

    create_tatami_view()
    create_fuda_view()
    @fuda_view.rewrite_string('たつたのかはのにしきなりけり')
  end

  def create_fuda_view
    @fuda_view = FudaView.alloc.initWithString(FUDA_INITIAL_STRING)
    @fuda_view.tap do |f_view|
      f_view.set_all_sizes_by(@tatami_view.frame.size.height * FUDA_HEIGHT_POWER)
      f_view.center= @tatami_view.center
      @tatami_view.addSubview(f_view)
    end
  end

  def create_tatami_view
    @tatami_view = UIImageView.alloc.initWithImage(UIImage.imageNamed(TATAMI_JPG_FILE))
    @tatami_view.tap do |t_view|
      t_view.frame = [CGRectZero.origin,
                      CGSizeMake(self.view.frame.size.width,
                                 self.view.frame.size.height/2)]
      t_view.clipsToBounds= true
      self.view.addSubview(t_view)
    end
  end

end
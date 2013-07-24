class ExamController < RMViewController
  FUDA_INITIAL_STRING = 'これから札に歌を設定します。'
#  TATAMI_COLOR = ColorFactory.str_to_color('#deb068')
  TATAMI_JPG_FILE = 'tatami_moved.jpg'
  FUDA_HEIGHT_POWER = 0.95 # 札ビューの高さは、畳ビューの何倍にするか
  VOLUME_ICON_MARGIN = 10

  INITIAL_VOLUME = 0.5
  VOLUME_VIEW_HEIGHT = 60
  VOLUME_VIEW_COLOR = ColorFactory.str_to_color('#68be8d')
  VOLUME_VIEW_ALPHA = 0.7
  VOLUME_ANIMATE_DURATION = 0.3
  VOLUME_VIEW_WIDTH_MARGIN = 10

  SLIDER_X_MARGIN = 10
  SLIDER_HEIGHT = 20


  PROPERTIES = [:fuda_view, :tatami_view, :input_view]
  PROPERTIES.each do |prop|
    attr_reader prop
  end

  def viewDidLoad
    super

    create_tatami_view()
    create_fuda_view()
    @fuda_view.rewrite_string('たつたのかはのにしきなりけり')
    create_input_view()
    set_hidden_volume_view_on_me()
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
                      CGSizeMake(self_size.width, self_size.height/2)]
      t_view.clipsToBounds= true
      t_view.userInteractionEnabled = true
      create_volume_icon_on_tatami
      self.view.addSubview(t_view)
    end
  end


  def create_input_view
    @input_view = InputView.alloc.initWithFrame(
        CGRectMake(0, tatami_origin.y + tatami_size.height,
                   tatami_size.width, self_size.height - tatami_size.height),
        supplier: CharSupplier.new({deck: Deck.new}))
    self.view.addSubview(@input_view)
  end

  :private

  def create_volume_icon_on_tatami
    @volume_icon = VolumeIcon.alloc.init
    @volume_icon.init_icon
    @volume_icon.tap do |v_icon|
      v_icon.frame = [CGPointMake(tatami_size.width -
                                      v_icon.frame.size.width - VOLUME_ICON_MARGIN,
                                  VOLUME_ICON_MARGIN),
                      v_icon.frame.size]
      v_icon.addTarget(self, action: :volume_icon_tapped, forControlEvents: UIControlEventTouchUpInside)
      @tatami_view.addSubview(v_icon)
    end
  end

  def volume_icon_tapped
    puts '(^^)/ volume_icon_is_tapped!'
    show_or_hide_volume_view
  end

  def set_hidden_volume_view_on_me
    @volume_view ||= UIView.alloc.initWithFrame(volume_view_initial_frame)
    @volume_view.tap do |v_view|
      v_view.backgroundColor= VOLUME_VIEW_COLOR
      v_view.alpha= VOLUME_VIEW_ALPHA
      v_view.addSubview(volume_slider)
      self.view.addSubview(v_view)
    end
  end

  def volume_view_initial_frame
    [CGPointMake(volume_icon_width + VOLUME_VIEW_WIDTH_MARGIN,
                 -1*VOLUME_VIEW_HEIGHT),
     CGSizeMake(self.view.frame.size.width - 2*(volume_icon_width+VOLUME_VIEW_WIDTH_MARGIN),
                VOLUME_VIEW_HEIGHT)]
  end


  def volume_slider
    slider = UISlider.alloc.initWithFrame(volume_slider_frame)
    slider.value= settings.volume || INITIAL_VOLUME
    slider.addTarget(self, action: :slider_changed, forControlEvents: UIControlEventValueChanged)
    @slider = slider
  end

  def slider_changed
#    @player.volume= @slider.value
    settings.volume = @slider.value
  end


  def self_size
    self.view.frame.size
  end

  def tatami_origin
    @tatami_view.frame.origin
  end

  def tatami_size
    @tatami_view.frame.size
  end

  def volume_slider_frame
    [CGPointMake(SLIDER_X_MARGIN,
                 (@volume_view.frame.size.height - SLIDER_HEIGHT)/2),
     CGSizeMake(@volume_view.frame.size.width - 2 * SLIDER_X_MARGIN,
                SLIDER_HEIGHT)
    ]
  end

  def volume_icon_width
    @volume_icon.frame.size.width
  end

  def show_or_hide_volume_view
    case @volume_view.frame.origin.y
      when 0; sweep_volume_view
      else  ; show_volume_view
    end
  end

  def show_volume_view
    UIView.animateWithDuration(VOLUME_ANIMATE_DURATION,
                               animations: lambda{set_volume_view_appear})
  end

  def sweep_volume_view
    UIView.animateWithDuration(VOLUME_ANIMATE_DURATION,
                               animations: lambda{set_volume_view_disappear})
  end

  def set_volume_view_appear
    @volume_view.frame= [CGPointMake(@volume_view.frame.origin.x, 0),
                         @volume_view.frame.size]
  end

  def set_volume_view_disappear
    @volume_view.frame= volume_view_initial_frame
  end

end
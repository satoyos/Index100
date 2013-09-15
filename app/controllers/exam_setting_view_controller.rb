class ExamSettingViewController < RMViewController
  INITIAL_VOLUME = 0.5
  BUTTON_MARGIN = 20
  BUTTON_HEIGHT = 40

  BACK_BUTTON_TITLE = 'ゲームに戻る'
  EXIT_BUTTON_TITLE = 'ゲーム終了'


  def viewDidLoad
    super
    set_volume_view()
    set_back_button()
    set_exit_button()
  end

  def set_volume_view
    @volume_view = VolumeView.alloc.initWithSuperViewSize(self.view.frame.size)
    self.view.addSubview(@volume_view)
    set_volume_slider()
    set_play_button()
  end

  def set_volume_slider
    slider = UISlider.alloc.initWithFrame(@volume_view.volume_slider_frame)
    slider.value= settings.volume || INITIAL_VOLUME
    AudioPlayerFactory.set_volume(slider.value)
    slider.addTarget(self, action: :slider_changed, forControlEvents: UIControlEventValueChanged)
    @volume_view.addSubview(slider)
    @slider = slider
  end

  def set_play_button
    p_button = UIButton.alloc.init
    p_button.setBackgroundImage(@volume_view.play_button_image,
                                forState: UIControlStateNormal)
    p_button.frame = @volume_view.play_button_frame
    p_button.addTarget(self, action: 'play_button_tapped', forControlEvents: UIControlEventTouchUpInside)
    @volume_view.addSubview(p_button)
  end

  def set_back_button
    b_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    b_button.frame = back_button_frame
    b_button.setTitle(BACK_BUTTON_TITLE, forState: UIControlStateNormal)
    b_button.addTarget(self, action: 'back_button_tapped', forControlEvents: UIControlEventTouchUpInside)
    self.view.addSubview(b_button)
    @back_button = b_button
  end
  
  def set_exit_button
    e_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    e_button.frame = exit_button_frame
    e_button.setTitle(EXIT_BUTTON_TITLE, forState: UIControlStateNormal)
    e_button.setTitleColor(UIColor.redColor, forState: UIControlStateNormal)
    e_button.addTarget(self, action: 'exit_button_tapped', forControlEvents: UIControlEventTouchUpInside)
    self.view.addSubview(e_button)
    
  end

  def exit_button_frame
    [CGPointMake(BUTTON_MARGIN,
                 @back_button.frame.origin.y + @back_button.frame.size.height + BUTTON_MARGIN),
     CGSizeMake(self.view.frame.size.width - 2 * BUTTON_MARGIN,
                BUTTON_HEIGHT)]
  end

  def back_button_frame
    [CGPointMake(BUTTON_MARGIN, @volume_view.frame.size.height + BUTTON_MARGIN),
     CGSizeMake(self.view.frame.size.width - 2 * BUTTON_MARGIN,
                BUTTON_HEIGHT)]
  end

  def back_button_tapped
    stop_player()
    self.dismissModalViewControllerAnimated(true)
  end

  def play_button_tapped
    AudioPlayerFactory.players[:test].play
  end

  def slider_changed
    AudioPlayerFactory.set_volume(@slider.value)
    settings.volume = @slider.value
  end

  def exit_button_tapped
    stop_player()
#    puts "presentingViewController => #{self.presentingViewController}"
    self.dismissModalViewControllerAnimated(true)
    self.presentingViewController.popViewControllerAnimated(false)
  end

  def stop_player
    AudioPlayerFactory.players[:test].stop
  end
end

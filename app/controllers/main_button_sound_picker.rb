class MainButtonSoundPicker < UIViewController

  PICKER_TITLE = '字を選んだ時の音'
  PROMPT = StartViewController::PROMPT
  PICKER_VIEW_WIDTH = 180
  INITIAL_SOUND = ButtonSound.sounds.first.id
  COMPONENT_ID = 0

  PLAY_BUTTON_TITLE = '聞いてみる'
  PLAY_BUTTON_TOP_MARGIN = 30

  class << self
    def button_sound_id
      saved_data = UIApplication.sharedApplication.delegate.settings.main_button_sound
      case saved_data
        when nil, false ; ButtonSound.sounds.first.id
        else ; saved_data.to_sym
      end
    end

    def button_sound_id=(sound_id)
      UIApplication.sharedApplication.delegate.settings.main_button_sound = sound_id
    end

    def label_name(sound_id)
      sound = ButtonSound.sounds.find{|sound| sound.id == sound_id} ||
          ButtonSound.sounds.first
      sound.label
    end

    def current_label_name
      label_name(button_sound_id)
    end
  end

  def viewDidLoad
    set_title()
    set_own_view()
    set_button_sounds()
    set_picker_view()
    set_play_button()
  end

  def set_own_view
    self.view.backgroundColor = UIColor.whiteColor
  end

  :private

  def set_title
    self.title = PICKER_TITLE
    self.navigationItem.prompt = PROMPT
  end

  def set_button_sounds
    @button_sounds = ButtonSound.sounds
  end

  def set_play_button
    @play_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @play_button.tap do |b|
      b.setTitle('聞いてみる', forState: UIControlStateNormal)
      b.sizeToFit
      b.center = self.view.center
      b.frame = play_button_frame(b)
      b.addTarget(self,
                  action: 'play_current_sound',
                  forControlEvents: UIControlEventTouchUpInside)
      self.view.addSubview(b)
    end
  end

  # @param [UIButton] button
  def play_button_frame(button)
    [CGPointMake(button.frame.origin.x,
                 @picker_view.frame.size.height + PLAY_BUTTON_TOP_MARGIN),
     button.frame.size
    ]
  end


  def set_picker_view
    @picker_view = UIPickerView.alloc.init
    @picker_view.tap do |p_view|
      p_view.delegate = self
      p_view.dataSource = self
      p_view.showsSelectionIndicator = true
      p_view.selectRow(@button_sounds.find_index{|sound|
                           sound.id == self.class.button_sound_id} || 0,
                       inComponent: COMPONENT_ID,
                       animated: false)
      self.view.addSubview(p_view)
    end
  end


  def viewWillDisappear(animated)
    MainButtonSoundPicker.button_sound_id = current_selected_sound_id()
  end

  def current_selected_sound_id
    @button_sounds[@picker_view.selectedRowInComponent(COMPONENT_ID)].id
  end

  def numberOfComponentsInPickerView(pickerView)
    1
  end

  def pickerView(pickerView, numberOfRowsInComponent: component)
    @button_sounds.size
  end

  def pickerView(pickerView, titleForRow: row, forComponent: component)
    @button_sounds[row].label
  end

  def pickerView(pickerView, widthForComponent: component)
    PICKER_VIEW_WIDTH
  end

  def play_current_sound
    AudioPlayerFactory.players[current_selected_sound_id].tap do |player|
      player.stop
      player.prepareToPlay
      player.play
    end
  end
end


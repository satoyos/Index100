class MainButtonSoundPicker < UIViewController

  PICKER_VIEW_WIDTH = 180
  INITIAL_SOUND = :button5
  COMPONENT_ID = 0
  MAIN_BUTTON_SOUND_CANDIDATES = AudioPlayerFactory::BUTTON_AUDIO_PATH.keys

  PLAY_BUTTON_TITLE = '聞いてみる'
  PLAY_BUTTON_TOP_MARGIN = 30

  class << self
    def button_sound
      saved_data = UIApplication.sharedApplication.delegate.settings.main_button_sound
      case saved_data
        when nil ; INITIAL_SOUND
        else ; saved_data.to_sym
      end
    end

    def button_sound=(sound_sym)
      UIApplication.sharedApplication.delegate.settings.main_button_sound = sound_sym
    end

    def label_name(button_sym)
      m = /([0-9]+)\z/.match(button_sym.to_s)
      if m
        "ボタン音#{m[1]}"
      else
        button_name.to_s
      end
    end

    def current_label_name
      label_name(button_sound)
    end
  end

  def viewDidLoad
    set_picker_view()
    set_play_button()
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
      puts '- 設定されている音は[%s]です' % self.class.button_sound
      p_view.selectRow(MAIN_BUTTON_SOUND_CANDIDATES.find_index(
                           self.class.button_sound),
                       inComponent: COMPONENT_ID,
                       animated: false)
      self.view.addSubview(p_view)
    end
  end


  def viewWillDisappear(animated)
    MainButtonSoundPicker.button_sound = current_selected_sound()
    puts "- 永続化データ[button_sound]の値を[#{MainButtonSoundPicker.button_sound}]に書き換えました。"
  end

  def current_selected_sound
    MAIN_BUTTON_SOUND_CANDIDATES[@picker_view.selectedRowInComponent(COMPONENT_ID)]
  end

  def numberOfComponentsInPickerView(pickerView)
    1
  end

  def pickerView(pickerView, numberOfRowsInComponent: component)
    MAIN_BUTTON_SOUND_CANDIDATES.size
  end

  def pickerView(pickerView, titleForRow: row, forComponent: component)
    self.class.label_name(MAIN_BUTTON_SOUND_CANDIDATES[row])
  end

  def pickerView(pickerView, widthForComponent: component)
    PICKER_VIEW_WIDTH
  end

  def play_current_sound
    AudioPlayerFactory.players[current_selected_sound].play
  end
end


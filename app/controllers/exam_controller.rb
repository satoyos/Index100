class ExamController < RMViewController
  FUDA_INITIAL_STRING = 'これから札に歌を設定します。'
  TATAMI_JPG_FILE = 'tatami_moved.jpg'
  FUDA_HEIGHT_POWER = 0.95 # 札ビューの高さは、畳ビューの何倍にするか

  MAIN_BUTTON_NUM = 4
  MAIN_BUTTON_TYPE = UIButtonTypeRoundedRect

  KIMARI_JI_MAX = 6 # 決まり字は、最長で6文字

  A_LABEL_CLEAR_BUTTON     = 'clear_button'
  A_LABEL_CHALLENGE_BUTTON = 'challenge_button'

  CALLBACK_AFTER_BUTTON_MOVED = 'exchange_main_buttons'
  CALLBACK_AFTER_EXCHANGE     = 'remove_prev_main_buttons'

  VOLUME_ICON_MARGIN = 10
  INITIAL_VOLUME = 0.5
  VOLUME_VIEW_HEIGHT = 60
  VOLUME_VIEW_COLOR = ColorFactory.str_to_color('#68be8d')
  VOLUME_VIEW_ALPHA = 0.7
  VOLUME_ANIMATE_DURATION = 0.3
  VOLUME_VIEW_WIDTH_MARGIN = 10

  SLIDER_X_MARGIN = 10
  SLIDER_HEIGHT = 20

  PROPERTIES = [:fuda_view, :tatami_view, :input_view, :supplier,
                :challenge_button, :clear_button, :main_buttons,
                :pushed_button, :current_challenge_string]
  PROPERTIES.each do |prop|
    attr_reader prop
  end

  PROPERTIES_ACCESSOR = [:button_is_moved]
  PROPERTIES_ACCESSOR.each do |prop|
    attr_accessor prop
  end


  def viewDidLoad
    super

    create_tatami_view()
    create_fuda_view()
    @fuda_view.rewrite_string('たつたのかはのにしきなりけり')

    set_char_supplier()
    create_input_view()
    set_clear_button()
    set_challenge_button()
    set_main_buttons(@supplier.get_4strings)
    make_main_buttons_appear()
    set_hidden_volume_view_on_me()
    init_challenge_status()
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
        controller: self)
    self.view.addSubview(@input_view)
  end

  def get_result_type
    case @supplier.test_challenge_string(@current_challenge_string)
      when true; :right
      else     ; :wrong
    end
  end

  :private

  def set_char_supplier
    @supplier = CharSupplier.new({deck: Deck.new})
  end

  def set_main_buttons(strings)
    @main_buttons = ButtonSlot.new(MAIN_BUTTON_NUM)
    (0..MAIN_BUTTON_NUM-1).each do |idx|
      button = create_a_main_button_at(idx, title: strings[idx])
    end
    @input_view.set_main_buttons(@main_buttons)
  end

  def create_a_main_button_at(idx, title: title)
    button = UIButton.buttonWithType(MAIN_BUTTON_TYPE)
    button.tap do |b|
      b.setTitle(title, forState: UIControlStateNormal) if title
      b.accessibilityLabel = title if title
      b.addTarget(self,
                  action: "main_button_pushed:",
                  forControlEvents: UIControlEventTouchUpInside)
      @main_buttons[idx] = b
      @input_view.addSubview(b)
    end
    button
  end

  def make_main_buttons_appear
    @input_view.make_main_buttons_appear(@main_buttons)
  end

  def make_main_buttons_disabled
    @main_buttons.each do |m_button|
      next unless m_button
      m_button.enabled = false
    end
  end

  def main_button_pushed(sender)
    sweep_volume_view if volume_view_is_coming_out?
    @current_challenge_string += sender.currentTitle
    @pushed_button = sender
    @main_buttons[pushed_button_index] = nil
    @input_view.main_button_pushed(sender, callback: CALLBACK_AFTER_BUTTON_MOVED)
  end

  def exchange_main_buttons
    self.button_is_moved = true
    @prev_main_buttons = @main_buttons.dup
    set_main_buttons(@supplier.get_4strings)
    if RUBYMOTION_ENV == 'test'
      make_main_buttons_appear()
      remove_prev_main_buttons()
    else
      @input_view.main_buttons_appearing_motion(@main_buttons,
                                                callback: CALLBACK_AFTER_EXCHANGE)
    end
  end

  def remove_prev_main_buttons
    remove_buttons_from_super_view(@prev_main_buttons)
    @prev_main_buttons = nil
  end


  def has_room_for_new_string?
    @supplier.counter < KIMARI_JI_MAX
  end

  def remove_buttons_from_super_view(slot)
    slot.each do |button|
      next unless button.is_a?(UIButton)
      button.removeFromSuperview
    end
  end

  def pushed_button_index
    @main_buttons.find_index(@pushed_button)
  end

  def i_view_animation_has_finished(animation_id)
    case animation_id
      when 'move_selected_button'
        if has_room_for_new_string?
          self.send("#{CALLBACK_AFTER_BUTTON_MOVED}")
        else
          disable_main_buttons
        end
      when 'make_main_buttons_appear'
        remove_buttons_from_super_view(@prev_main_buttons) if @prev_main_buttons
        @prev_main_buttons = nil
        @pushed_button = nil
      else
        puts "/////// このアニメーションの後処理はありません。 ///////"
    end
  end

  def disable_main_buttons
    @main_buttons.each do |button|
      button.enabled = false if button
    end
  end

  def set_clear_button
    @clear_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @clear_button.addTarget(self,
                            action: 'clear_button_pushed',
                            forControlEvents: UIControlEventTouchUpInside)
    @clear_button.accessibilityLabel = A_LABEL_CLEAR_BUTTON
    @input_view.set_clear_button(@clear_button)
  end

  def set_challenge_button
    @challenge_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @challenge_button.addTarget(self,
                            action: 'challenge_button_pushed',
                            forControlEvents: UIControlEventTouchUpInside)
    @challenge_button.accessibilityLabel = A_LABEL_CHALLENGE_BUTTON
    @input_view.set_challenge_button(@challenge_button)

  end

  def clear_button_pushed
    sweep_volume_view if volume_view_is_coming_out?
    remove_buttons_from_super_view(@main_buttons)
    @input_view.clear_button_pushed
    remove_prev_main_buttons if @prev_main_button
    set_main_buttons(@supplier.clear.get_4strings)
    make_main_buttons_appear
    init_challenge_status()
  end

  def init_challenge_status
    @challenge_button.enabled = true
    @current_challenge_string = ''
  end

  def challenge_button_pushed
    sweep_volume_view if volume_view_is_coming_out?
    @challenge_button.enabled = false
    make_main_buttons_disabled
    @input_view.display_result_view(get_result_type)
    AudioPlayerFactory.players[get_result_type].play
  end

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
    AudioPlayerFactory.set_volume(slider.value)
    slider.addTarget(self, action: :slider_changed, forControlEvents: UIControlEventValueChanged)
    @slider = slider
  end

  def slider_changed
    AudioPlayerFactory.set_volume(@slider.value)
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
    case volume_view_is_coming_out?
      when true; sweep_volume_view
      else     ; show_volume_view
    end
  end

  def volume_view_is_coming_out?
    @volume_view.frame.origin.y == 0
  end

  def show_volume_view
    AudioPlayerFactory.rewind_to_start_point
    AudioPlayerFactory.players[:test].play
    if RUBYMOTION_ENV == 'test'
      set_volume_view_appear
    else
      UIView.animateWithDuration(VOLUME_ANIMATE_DURATION,
                                 animations: lambda{set_volume_view_appear})
    end
  end

  def sweep_volume_view
    AudioPlayerFactory.players[:test].stop
    if RUBYMOTION_ENV == 'test'
      set_volume_view_disappear
    else
      UIView.animateWithDuration(VOLUME_ANIMATE_DURATION,
                                 animations: lambda{set_volume_view_disappear})
    end
  end

  def set_volume_view_appear
    @volume_view.frame= [CGPointMake(@volume_view.frame.origin.x, 0),
                         @volume_view.frame.size]
  end

  def set_volume_view_disappear
    @volume_view.frame= volume_view_initial_frame
  end

end

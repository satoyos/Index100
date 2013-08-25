class ExamController < RMViewController

  MAIN_BUTTON_NUM = 4
  MAIN_BUTTON_TYPE = UIButtonTypeRoundedRect

  A_LABEL_CLEAR_BUTTON     = 'clear_button'
  A_LABEL_CHALLENGE_BUTTON = 'challenge_button'

  CALLBACK_AFTER_BUTTON_MOVED = 'check_if_right_button_pushed'
  CALLBACK_AFTER_EXCHANGE     = 'remove_prev_main_buttons'

  INITIAL_VOLUME = 0.5
  VOLUME_ANIMATE_DURATION = 0.3

  PROPERTIES = [:game_view, :fuda_view, :tatami_view, :volume_view,
                :challenge_button, :clear_button, :main_buttons,
                :supplier, :pushed_button, :current_challenge_string]
  PROPERTIES.each do |prop|
    attr_reader prop
  end

  PROPERTIES_ACCESSOR = [:button_is_moved, :challenge_button_is_pushed]
  PROPERTIES_ACCESSOR.each do |prop|
    attr_accessor prop
  end

  def viewDidLoad
    super

    set_char_supplier()
    set_game_view()

    set_clear_button()
    set_challenge_button()
    set_main_buttons(@supplier.get_4strings)
    make_main_buttons_appear()
    set_hidden_volume_view_on_me()
    init_challenge_status()
  end

  def set_game_view
    @game_view = GameView.alloc.initWithFrame(game_view_frame,
                                              withPoem: @supplier.current_poem,
                                              controller: self)
    create_volume_icon()
    self.view.addSubview(@game_view)
  end

  def get_result_type
    case @supplier.test_challenge_string(@current_challenge_string)
      when true; :right
      else     ; :wrong
    end
  end

  def get_wrong_type
    @supplier.length_check(@current_challenge_string)
  end

  :private

  def game_view_frame
    [
        CGPointZero,
        CGSizeMake(self_size.width, self_size.height)
    ]
  end

  def set_char_supplier
    @supplier = CharSupplier.new({deck: Deck.new})
  end

  def set_main_buttons(strings)
    @main_buttons = ButtonSlot.new(MAIN_BUTTON_NUM)
    (0..MAIN_BUTTON_NUM-1).each do |idx|
      button = create_a_main_button_at(idx, title: strings[idx])
    end
    @game_view.draw_main_buttons(@main_buttons)
  end

  def create_a_main_button_at(idx, title: title)
    button = UIButton.buttonWithType(MAIN_BUTTON_TYPE)
    button.tap do |b|
      if title
        b.setTitle(title, forState: UIControlStateNormal) if title
        b.accessibilityLabel = title if title
        b.addTarget(self,
                    action: "main_button_pushed:",
                    forControlEvents: UIControlEventTouchUpInside)
      else
        b.enabled = false
      end
      @main_buttons[idx] = b
    end
    button
  end

  def make_main_buttons_appear
    @game_view.make_main_buttons_appear(@main_buttons)
  end

  def make_main_buttons_disabled
    @main_buttons.each do |m_button|
      next unless m_button
      m_button.enabled = false
    end
  end

  def main_button_pushed(sender)
    sweep_volume_view if @volume_view.is_coming_out?
    @current_challenge_string += sender.currentTitle
    @pushed_button = sender
    @main_buttons[pushed_button_index] = nil
    @game_view.main_button_pushed(sender, callback: CALLBACK_AFTER_BUTTON_MOVED)
  end

  def check_if_right_button_pushed
    self.button_is_moved = true
    case @supplier.on_the_correct_line?(@current_challenge_string)
      when true; exchange_main_buttons
      else     ; challenge_button_pushed
    end
  end

  def exchange_main_buttons
    @prev_main_buttons = @main_buttons.dup
    set_main_buttons(@supplier.get_4strings)
    if RUBYMOTION_ENV == 'test'
      make_main_buttons_appear()
      remove_prev_main_buttons()
    else
      @game_view.main_buttons_appearing_motion(@main_buttons,
                                               callback: CALLBACK_AFTER_EXCHANGE)
    end
  end

  def remove_prev_main_buttons
    remove_buttons_from_super_view(@prev_main_buttons)
    @prev_main_buttons = nil
  end

  def has_room_for_new_string?
    @supplier.counter < CharSupplier::COUNTER_MAX
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
    @game_view.draw_clear_button(@clear_button)
  end

  def set_challenge_button
    @challenge_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @challenge_button.addTarget(self,
                            action: 'challenge_button_pushed',
                            forControlEvents: UIControlEventTouchUpInside)
    @challenge_button.accessibilityLabel = A_LABEL_CHALLENGE_BUTTON
    @game_view.draw_challenge_button(@challenge_button)
  end

  def clear_button_pushed
    sweep_volume_view if @volume_view.is_coming_out?
    remove_buttons_from_super_view(@main_buttons)
    @game_view.clear_button_pushed
    remove_prev_main_buttons if @prev_main_button
    set_main_buttons(@supplier.clear.get_4strings)
    make_main_buttons_appear
    init_challenge_status()
  end

  def init_challenge_status
    @challenge_button.enabled = true
    @current_challenge_string = ''
    self.challenge_button_is_pushed = false
  end

  def challenge_button_pushed
    self.challenge_button_is_pushed = true
    sweep_volume_view if @volume_view.is_coming_out?
    @challenge_button.enabled = false
    make_main_buttons_disabled
    @game_view.display_result(get_result_type)
    audio_type = case get_result_type
                   when :right  ; :right
                   else
                     case @supplier.on_the_correct_line?(@current_challenge_string)
                       when true ; get_wrong_type
                       else      ; :wrong
                     end
                 end
    AudioPlayerFactory.players[audio_type].play
  end

  def create_volume_icon
    @volume_icon = VolumeIcon.alloc.init
    @volume_icon.init_icon
    @volume_icon.tap do |v_icon|
      v_icon.frame = @game_view.volume_icon_frame_with_size(v_icon.frame.size)
      v_icon.addTarget(self, action: :volume_icon_tapped, forControlEvents: UIControlEventTouchUpInside)
      @game_view.addSubview(v_icon)
    end
  end

  def volume_icon_tapped
    show_or_hide_volume_view
  end

  def set_hidden_volume_view_on_me
    @volume_view ||=
        VolumeView.alloc.initWithGameView(@game_view,
                                          volume_icon: @volume_icon)
    @volume_view.tap do |v_view|
      v_view.addSubview(volume_slider)
      self.view.addSubview(v_view)
    end
  end

  def volume_slider
    slider = UISlider.alloc.initWithFrame(@volume_view.volume_slider_frame)
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

  def show_or_hide_volume_view
    case @volume_view.is_coming_out?
      when true; sweep_volume_view
      else     ; show_volume_view
    end
  end

  def show_volume_view
    AudioPlayerFactory.rewind_to_start_point
    AudioPlayerFactory.players[:test].play
    if RUBYMOTION_ENV == 'test'
      @volume_view.make_appear
    else
      UIView.animateWithDuration(
          VOLUME_ANIMATE_DURATION,
          animations: lambda{@volume_view.make_appear})
    end
  end

  def sweep_volume_view
    AudioPlayerFactory.players[:test].stop
    if RUBYMOTION_ENV == 'test'
      @volume_view.make_disappear
    else
      UIView.animateWithDuration(
          VOLUME_ANIMATE_DURATION,
          animations: lambda{@volume_view.make_disappear})
    end
  end
end

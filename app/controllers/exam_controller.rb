class ExamController < UIViewController
  include SettingWindowCalling

  MAIN_BUTTON_NUM = 4
  MAIN_BUTTON_TYPE = UIButtonTypeRoundedRect
  MAIN_BUTTON_COLOR = UIColor.whiteColor.colorWithAlphaComponent(0.8)

  A_LABEL_CLEAR_BUTTON     = 'clear_button'
  A_LABEL_CHALLENGE_BUTTON = 'challenge_button'

  GAME_VIEW_EXCHANGE_TRANSITION = UIViewAnimationTransitionFlipFromLeft
  MOVE_SELECTED_DURATION = 0.1
  EXCHANGE_MAIN_BUTTONS_DURATION = 0.15
  EXCHANGE_GAME_VIEW_DURATION = 0.5

  CALLBACK_AFTER_BUTTON_MOVED = 'check_if_right_button_pushed'
  CALLBACK_AFTER_EXCHANGE     = 'remove_prev_main_buttons'

  attr_reader :game_view
  attr_reader :challenge_button, :clear_button, :main_buttons
  attr_reader :supplier, :pushed_button

  attr_accessor :current_challenge_string
  attr_accessor :wrong_char_allowed
  attr_accessor :button_is_moved, :challenge_button_is_pushed
  attr_accessor :game_is_completed

  def initWithHash(init_hash)
    init_hash.each do |key, value|
      unless self.respond_to?("#{key}=")
        puts "ExamControllerにはメソッド[#{key}=]がありません"
        next
      end
      self.send("#{key}=", value)
    end

    self.hidesBottomBarWhenPushed = true

    self
  end

  def viewDidLoad
    super
    set_char_supplier
    set_game_view_of_poem(@supplier.current_poem)
    draw_sub_view(@game_view)
  end

  def viewWillAppear(animated)
    unless RUBYMOTION_ENV == 'test'
      if self.navigationController
        self.navigationController.navigationBar.translucent = true
        self.navigationController.navigationBar.alpha = 0.0
      end
    end
  end

  def prefersStatusBarHidden
    true
  end

  def viewWillDisappear(animated)
    UIApplication.sharedApplication.setStatusBarHidden(false, animated: true)
  end

  def set_game_view_of_poem(poem)
    create_game_view(poem)
    create_gear_icon()
    set_clear_button()
    set_challenge_button()
    set_main_buttons(@supplier.get_4strings)
    make_main_buttons_appear()
    init_challenge_status()
  end

  def create_game_view(poem)
    @game_view = GameView.alloc.initWithFrame(self.view.bounds,
                                              withPoem: poem,
                                              controller: self)
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

  def challenge_button_pushed
    self.challenge_button_is_pushed = true
    @challenge_button.enabled = false
    make_main_buttons_disabled
    @game_view.display_result(get_result_type)
    AudioPlayerFactory.players[audio_type].play

    return if get_result_type == :wrong
    return game_is_finished unless @supplier.draw_next_poem
    @game_view.removeFromSuperview
    set_game_view_of_poem(@supplier.current_poem)
    if RUBYMOTION_ENV == 'test'
      draw_sub_view(@game_view)
    else
#      @game_view.view_animation_def(
      view_animation_def(
          'draw_sub_view',
          arg: @game_view,
          duration: EXCHANGE_GAME_VIEW_DURATION,
          transition: GAME_VIEW_EXCHANGE_TRANSITION)
    end
  end

  :private

  def deck=(deck)
    @deck = deck
  end

  def set_char_supplier
    @deck ||= Deck.new
    @supplier = CharSupplier.new({deck: @deck})
  end

  def set_main_buttons(strings)
    @main_buttons = ButtonSlot.new(MAIN_BUTTON_NUM)
    (0..MAIN_BUTTON_NUM-1).each do |idx|
      create_a_main_button_at(idx, title: strings[idx]) if strings[idx]
    end
    @game_view.draw_main_buttons(@main_buttons)
  end

  def create_a_main_button_at(idx, title: title)
    button = InputViewButton.create_button
    button.tap do |b|
      b.backgroundColor = MAIN_BUTTON_COLOR
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
    @current_challenge_string += sender.currentTitle
    @pushed_button = sender
    @main_buttons[pushed_button_index] = nil
    AudioPlayerFactory.players[MainButtonSoundPicker.button_sound_id].play
#    @game_view.main_button_pushed(sender, callback: CALLBACK_AFTER_BUTTON_MOVED)
    if RUBYMOTION_ENV == 'test'
      @game_view.move_selected_button(@pushed_button)
      self.send(CALLBACK_AFTER_BUTTON_MOVED)
    else
      i_view_animation_def('move_selected_button',
                           arg: @pushed_button,
                           duration: MOVE_SELECTED_DURATION)
    end
  end

  def view_animation_def(method_name, arg: arg, duration: duration, transition: transition)
    UIView.beginAnimations(method_name, context: nil)
    UIView.setAnimationDelegate(self)
    UIView.setAnimationDuration(duration)
    if transition
      UIView.setAnimationTransition(transition,
                                    forView: self.view,
                                    cache: true)

    end
    if arg
      self.send("#{method_name}", arg)
    else
      self.send("#{method_name}")
    end
    UIView.setAnimationDidStopSelector('i_view_animation_has_finished:')
    UIView.commitAnimations
  end

  def i_view_animation_def(method_name, arg: arg, duration: duration)
    UIView.beginAnimations(method_name, context: nil)
    UIView.setAnimationDelegate(self)
    UIView.setAnimationDuration(duration)
    if arg
      @game_view.send("#{method_name}", arg)
    else
      @game_view.send("#{method_name}")
    end
    UIView.setAnimationDidStopSelector('i_view_animation_has_finished:')
    UIView.commitAnimations
  end


  def check_if_right_button_pushed
    self.button_is_moved = true
    case self.wrong_char_allowed ||
        @supplier.on_the_correct_line?(@current_challenge_string)
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
      i_view_animation_def('make_main_buttons_appear',
                           arg: @main_buttons,
                           duration: EXCHANGE_MAIN_BUTTONS_DURATION)
=begin
      @game_view.main_buttons_appearing_motion(@main_buttons,
                                               callback: CALLBACK_AFTER_EXCHANGE)
=end
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
      when 'draw_sub_view'
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
    @clear_button = InputViewButton.create_button
    @clear_button.addTarget(self,
                            action: 'clear_button_pushed',
                            forControlEvents: UIControlEventTouchUpInside)
    @clear_button.accessibilityLabel = A_LABEL_CLEAR_BUTTON
    @game_view.draw_clear_button(@clear_button)
  end

  def set_challenge_button
    @challenge_button = InputViewButton.create_button
    @challenge_button.addTarget(self,
                            action: 'challenge_button_pushed',
                            forControlEvents: UIControlEventTouchUpInside)
    @challenge_button.accessibilityLabel = A_LABEL_CHALLENGE_BUTTON
    @game_view.draw_challenge_button(@challenge_button)
  end

  def clear_button_pushed
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

  def game_is_finished
    self.game_is_completed = true
    comp_view =
        CompleteView.alloc.initWithFrame(self.view.frame,
                                         controller: self)
    # 自分自身を引数で渡しているが、                     ↑↑↑
    # 相手からは弱参照で参照しているため、循環参照は避けている。
    @game_view.removeFromSuperview
    if RUBYMOTION_ENV == 'test'
      draw_sub_view(comp_view)
    else
#      @game_view.view_animation_def(
      view_animation_def(
          'draw_sub_view',
          arg: comp_view,
          duration: EXCHANGE_GAME_VIEW_DURATION,
          transition: GAME_VIEW_EXCHANGE_TRANSITION)
    end
  end

  def draw_sub_view(sub_view)
    self.view.addSubview(sub_view)
  end

  def audio_type
    case get_result_type
      when :right  ; :right
      else
        case @supplier.on_the_correct_line?(@current_challenge_string)
          when true ; get_wrong_type
          else      ; :wrong
        end
    end
  end

end

class InputView < UIView
  BG_COLOR = UIColor.darkGrayColor # InputViewの背景色(backgroundColor)
  MAIN_BUTTON_SIZE  = CGSizeMake(60, 60)
  SUB_BUTTON_SIZE   = CGSizeMake(40, 40)
  CLEAR_BUTTON_HEIGHT = 40
  CLEAR_BUTTON_TITLE = 'やり直し'
  CLEAR_BUTTON_COLOR = ColorFactory.str_to_color('#007bbb') #紺碧
  CHALLENGE_BUTTON_HEIGHT = CLEAR_BUTTON_HEIGHT
  CHALLENGE_BUTTON_TITLE = 'これで決まり！'
  CHALLENGE_BUTTON_COLOR = ColorFactory.str_to_color('#e95295') #ツツジ色
  MAIN_BUTTON_TYPE = UIButtonTypeRoundedRect
  MAIN_BUTTON_NUM = 4
  SUB_BUTTON_NUM  = 6
  MOVE_SELECTED_DURATION = 0.1
  EXCHANGE_MAIN_BUTTONS_DURATION = 0.15

  SELECTED_BUTTON_TITLE_COLOR = ColorFactory.str_to_color('#c85179') #中紅

  A_LABEL_CELAR_BUTTON = 'clear_button'

  PROPERTIES_READER = [:main_4frames, :main_buttons, :clear_button, :challenge_button,
                :sub_buttons, :sub_6frames, :selected_num, :supplier,
                :pushed_button, :result_view]
  PROPERTIES_READER.each do |prop|
    attr_reader prop
  end

  PROPERTIES_ACCESSOR = [:button_moved, :new_buttons_set,
                         :new_buttons_are_being_created]
  PROPERTIES_ACCESSOR.each do |prop|
    attr_accessor prop
  end

  # @param [CharSupplier] supplier
  def initWithFrame(frame, supplier: supplier)
    super.initWithFrame(frame)

    @supplier = supplier
    self.backgroundColor = BG_COLOR
    @selected_num = 0
=begin
    set_clear_button()
=end
    set_challenge_button()
    create_main_4frames()
    set_main_buttons(supplier.get_4strings)
    make_main_buttons_appear
    create_sub_6frames()
    setup_sub_button_slot()
    clear_prove_variable

    self
  end

  def main_button_pushed(sender)
    clear_prove_variable
#    puts "#{@selected_num}番目の文字として[#{sender.currentTitle}]が押されました!"
    return unless sender.is_a?(UIButton)
    @pushed_button = sender
#      puts '!!! テストモードでボタンを押しました !!!'
    if RUBYMOTION_ENV == 'test'
      move_selected_button
    else
      i_view_animation_def('move_selected_button',
                           duration: MOVE_SELECTED_DURATION)
    end
  end

  def clear_prove_variable
    @pushed_button = nil
    self.button_moved = false
    self.new_buttons_set = false
    self.new_buttons_are_being_created = false
  end

  def clear_button_pushed
    remove_buttons_from_super_view(@main_buttons)
    remove_buttons_from_super_view(@sub_buttons)
    set_main_buttons(@supplier.clear.get_4strings)
    make_main_buttons_appear
    setup_sub_button_slot()
    @selected_num = 0
    clean_up_result_view()
    clean_up_result_view()
    clean_before_next_push()
  end

  def test_pushed_sequence(button)
    main_button_pushed(button)
    if can_create_new_button?
      exchange_main_buttons()
      clean_before_next_push()
    end
  end

  def get_result_type
    case @supplier.test_challenge_string(challenge_strings)
      when true; :right
      else     ; :wrong
    end
  end

  def display_result_view(result_type)
    @result_view = ChallengeResultView.alloc.initWithResult(result_type)
    @result_view.center = self.center
    @result_view.frame =
        [CGPointMake(@result_view.frame.origin.x,
                     0 - ChallengeResultView::RESULT_VIEW_SIZE.height/2),
         @result_view.frame.size]
    self.addSubview(@result_view)
  end

  def challenge_strings
    sub_buttons.inject(''){|str, b| str += b.currentTitle if b}
  end

  def ratio_of_sub_to_main
    SUB_BUTTON_SIZE.width / MAIN_BUTTON_SIZE.width
  end


  :private

  def can_create_new_button?
    @selected_num < @sub_buttons.limit_size
  end

  def clean_before_next_push
    remove_buttons_from_super_view(@prev_main_button) if @prev_main_button
    @prev_main_button = nil
    @pushed_button = nil
  end

  def clean_up_result_view
    return unless @result_view
    @result_view.clean_up_subviews
    @result_view.removeFromSuperview
    @result_view = nil
  end


  def remove_buttons_from_super_view(slot)
#    puts "--- 不要なボタンの消去を開始 (スロットのサイズ=[#{slot.size}])"
    slot.each do |button|
      next unless button.is_a?(UIButton)
      button.removeFromSuperview
#      puts "--- ボタン[#{button.currentTitle}]を削除 => 現在のSubViewの数 = [#{self.subviews.size}]"
    end
  end

  def setup_sub_button_slot
    @sub_buttons = ButtonSlot.new(SUB_BUTTON_NUM)
  end

  def set_challenge_button
    @challenge_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @challenge_button.setFrame(challenge_button_frame)
    set_stable_button(@challenge_button,
                      title: CHALLENGE_BUTTON_TITLE,
                      bg_color: CHALLENGE_BUTTON_COLOR)
    @challenge_button.addTarget(self,
                       action: 'challenge_button_pushed',
                       forControlEvents: UIControlEventTouchUpInside)

    self.addSubview(@challenge_button)
  end

  def challenge_button_pushed
    # 本来は、チャレンジボタンが押されたら、一旦チャレンジボタンをdisabledにしたかった。
    # しかし、今の実装ではなぜかこのボタンがenabledメソッドを受けてくれない。
    # 仕方ないので、ここで「既にChallengeResultViewがある場合には何もしない」処理を入れ、
    # 擬似的に上記動作に近い挙動をするようにしてみる。
    return if subviews.find { |view| view.is_a?(ChallengeResultView) }
    make_main_buttons_disabled
    display_result_view(get_result_type)
    AudioPlayerFactory.players[get_result_type].play
  end

  def make_main_buttons_disabled
    @main_buttons.each do |m_button|
      next unless m_button
      m_button.enabled = false
    end
  end

  def set_main_buttons(strings)
    @main_buttons = ButtonSlot.new(MAIN_BUTTON_NUM)
    (0..MAIN_BUTTON_NUM-1).each do |idx|
      button = create_a_main_button_at(idx, title: strings[idx])
    end
    self.new_buttons_set = true
  end

  def make_main_buttons_appear
    @main_buttons.each_with_index do |button, idx|
      button.frame = @main_4frames[idx]
    end
  end

  def challenge_button_frame()
    CGRectMake(clear_button_frame.origin.x + clear_button_frame.size.width,
               self_height - CHALLENGE_BUTTON_HEIGHT,
               self_width/2, CHALLENGE_BUTTON_HEIGHT)
  end

  def set_clear_button(c_button)
=begin
      c_button.addTarget(self,
                         action: 'clear_button_pushed',
                         forControlEvents: UIControlEventTouchUpInside)
=end
    c_button.setFrame(clear_button_frame)
    set_stable_button(c_button,
                      title: CLEAR_BUTTON_TITLE,
                      bg_color: CLEAR_BUTTON_COLOR)
    self.addSubview(c_button)
    c_button.accessibilityLabel = A_LABEL_CELAR_BUTTON
    @clear_button = c_button
  end

  def set_stable_button(button, title: text, bg_color: bg_color)
    button.setTitle(text, forState: UIControlStateNormal)
    button.setTitleColor(UIColor.whiteColor, forState: UIControlStateNormal)
    button.setBackgroundColor(bg_color, forState: UIControlStateNormal)
  end

  def clear_button_frame
    CGRectMake(0, self_height - CLEAR_BUTTON_HEIGHT,
               self_width/2, CLEAR_BUTTON_HEIGHT)
  end

  def create_a_main_button_at(idx, title: title)
    button = UIButton.buttonWithType(MAIN_BUTTON_TYPE)
    button.setFrame(hidden_main_frame_at(idx))
    button.tap do |b|
      b.setTitle(title, forState: UIControlStateNormal) if title
      b.titleLabel.font = UIFont.systemFontOfSize(MAIN_BUTTON_SIZE.height/2)
      b.addTarget(self,
                  action: "main_button_pushed:",
                  forControlEvents: UIControlEventTouchUpInside)
      @main_buttons[idx] = b
      self.addSubview(b)
    end
    button
  end

  def hidden_main_frame_at(idx)
    CGRectMake(nth_main_frame(idx).origin.x,
               self.frame.size.height,
               nth_main_frame(idx).size.width,
               nth_main_frame(idx).size.height)
  end

  # @param [CGRect] frame
  def center_of_frame(frame)
    CGPointMake(frame.origin.x + frame.size.width / 2,
                frame.origin.y + frame.size.height / 2)
  end

  def exchange_main_buttons
    @prev_main_button = @main_buttons.dup
    self.new_buttons_are_being_created = true
#    puts '==== ボタンを作る直前まで来ました！'
    set_main_buttons(@supplier.get_4strings)
    if RUBYMOTION_ENV == 'test'
#      puts '!!! テストモードで次のボタン群を生成しました !!!'
      make_main_buttons_appear
    else
      i_view_animation_def('make_main_buttons_appear',
                           duration: EXCHANGE_MAIN_BUTTONS_DURATION)
    end

  end

  def i_view_animation_def(method_name, duration: duration)
    UIView.beginAnimations(method_name, context: nil)
    UIView.setAnimationDelegate(self)
    UIView.setAnimationDuration(duration)
    self.send("#{method_name}")
    UIView.setAnimationDidStopSelector('i_view_animation_has_finished:')
    UIView.commitAnimations
  end


  def i_view_animation_has_finished(animation_id)
    case animation_id
      when 'move_selected_button'
        if can_create_new_button?
          exchange_main_buttons
        else
          disable_main_buttons
        end
      when 'make_main_buttons_appear'
        clean_before_next_push
      else
        puts "/////// このアニメーションの後処理はありません。 ///////"
    end
  end


  def move_selected_button
    @pushed_button.tap do |button|
      button.frame = @sub_6frames[@selected_num]
      button.titleLabel.font = UIFont.systemFontOfSize(SUB_BUTTON_SIZE.height/2)
      button.enabled = false
      @main_buttons.transfer(button, to: @sub_buttons)
      self.button_moved = true
    end

    change_color_of_button(@pushed_button)
    @selected_num += 1

  end

  # @param [UIButton] button
  def change_color_of_button(button)
    button.setTitleColor(SELECTED_BUTTON_TITLE_COLOR,
                         forState: UIControlStateDisabled)
  end

  def disable_main_buttons
    @main_buttons.each do |button|
      button.enabled = false if button
    end
  end

  def create_sub_6frames
    @sub_6frames = []
    (0..5).each do |idx|
      @sub_6frames << nth_sub_frame(idx)
    end
  end


  def create_main_4frames
    @main_4frames = []
    (0..3).each do |idx|
      @main_4frames << nth_main_frame(idx)
    end

  end

  def x_gap
    (self.frame.size.width - MAIN_BUTTON_SIZE.width*4) / 5
  end

  def bottom_margin
    x_gap
  end

  def nth_sub_frame(idx)
    CGRectMake(x_gap +
                   (x_gap * ratio_of_sub_to_main + SUB_BUTTON_SIZE.width) * idx,
               x_gap,
               SUB_BUTTON_SIZE.width,
               SUB_BUTTON_SIZE.height)
  end


  def nth_main_frame(idx)
    CGRectMake(x_gap + (MAIN_BUTTON_SIZE.width + x_gap) * idx,
               self_height - CLEAR_BUTTON_HEIGHT - bottom_margin - MAIN_BUTTON_SIZE.height,
               MAIN_BUTTON_SIZE.width,
               MAIN_BUTTON_SIZE.height)
  end

  def self_size
    self.frame.size
  end

  def self_height
    self_size.height
  end

  def self_width
    self_size.width
  end
end

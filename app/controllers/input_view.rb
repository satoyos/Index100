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
  MOVE_SELECTED_DURATION = 0.2
  SHRINK_UNSELECTED_DURATION = 0.2

  PROPERTIES = [:main_4frames, :main_buttons, :clear_button, :challenge_button,
                :sub_buttons, :sub_6frames, :selected_num]
  PROPERTIES.each do |prop|
    attr_reader prop
  end

  def initWithFrame(frame, strings: strings)
    @strings = strings
    super.initWithFrame(frame)
    self.backgroundColor = BG_COLOR
    @selected_num = 0
    @pushed_button = nil
    set_clear_button()
    set_challenge_button()
    create_main_4frames()
    set_main_buttons(@strings)
    create_sub_6frames()
    setup_sub_button_slot()

    self
  end

  def ratio_of_sub_to_main
    SUB_BUTTON_SIZE.width / MAIN_BUTTON_SIZE.width
  end

  def main_button_pushed(sender)
    puts "#{sender.to_s} is pushed!"
    return unless sender.is_a?(UIButton)
    @pushed_button = sender
    i_view_animation_def('move_selected_button')
  end
  
  def clear_button_pushed
    remove_buttons_from_super_view(@main_buttons)
    remove_buttons_from_super_view(@sub_buttons)
    set_main_buttons(@strings)
    setup_sub_button_slot()
    @selected_num = 0
    @pushed_button = nil
  end


  :private


  def remove_buttons_from_super_view(slot)
    slot.each{|button| button.removeFromSuperview if button}
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
    self.addSubview(@challenge_button)
  end

  def challenge_button_frame()
    CGRectMake(clear_button_frame.origin.x + clear_button_frame.size.width,
               self_height - CHALLENGE_BUTTON_HEIGHT,
               self_width/2, CHALLENGE_BUTTON_HEIGHT)
  end

  def set_clear_button
    @clear_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @clear_button.addTarget(self,
                            action: 'clear_button_pushed',
                            forControlEvents: UIControlEventTouchUpInside)
    @clear_button.setFrame(clear_button_frame)
    set_stable_button(@clear_button,
                      title: CLEAR_BUTTON_TITLE,
                      bg_color: CLEAR_BUTTON_COLOR)
    self.addSubview(@clear_button)
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

  def set_main_buttons(strings)
    @main_buttons = ButtonSlot.new(MAIN_BUTTON_NUM)
    (0..MAIN_BUTTON_NUM-1).each do |idx|
      create_a_main_button_at(idx, title: strings[idx])
    end
  end

  def create_a_main_button_at(idx, title: title)
    button = UIButton.buttonWithType(MAIN_BUTTON_TYPE).setFrame(main_4frames[idx])
    button.tap do |b|
      b.setTitle(title, forState: UIControlStateNormal) if title
      b.titleLabel.font = UIFont.systemFontOfSize(MAIN_BUTTON_SIZE.height/2)
      b.addTarget(self,
                  action: "main_button_pushed:",
                  forControlEvents: UIControlEventTouchUpInside)
      @main_buttons[idx] = b
      self.addSubview(b)
    end
  end

  def i_view_animation_def(method_name)
    UIView.beginAnimations(method_name, context: nil)
    UIView.setAnimationDelegate(self)
    UIView.setAnimationDuration(MOVE_SELECTED_DURATION)
    self.send("#{method_name}")
    UIView.setAnimationDidStopSelector('i_view_animation_has_finished:')
    UIView.commitAnimations
  end

  def i_view_animation_has_finished(animation_id)
    case animation_id
      when 'move_selected_button'
        i_view_animation_def('shrink_unselected_buttons')
      else
        puts "/////// Matching 失敗 ///////"
    end
  end


  def move_selected_button
    @pushed_button.tap do |button|
      button.frame = @sub_6frames[@selected_num]
      button.titleLabel.font = UIFont.systemFontOfSize(SUB_BUTTON_SIZE.height/2)
      button.enabled = false
      @main_buttons.transfer(button, to: @sub_buttons)
    end
    @selected_num += 1
    @pushed_button = nil
  end

  def shrink_unselected_buttons
    @main_buttons.each do |button|
      next unless button
      center = button.center
      button.frame = CGRectMake(center.x, center.y, 0, 0)
    end
  end

  def pop_a_new_main_button
    idx = @main_buttons.index(nil)
    create_a_main_button_at(idx, title: nil)
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
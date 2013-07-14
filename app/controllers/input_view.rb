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
  CHAR_SELECTED_DURATION = 0.1

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
    UIView.animateWithDuration(CHAR_SELECTED_DURATION,
                               animations: lambda{move_selected_button(sender)})
  end


  :private

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

  def clear_button_pushed
    @main_buttons.each{|button| button.removeFromSuperview}
    set_main_buttons(@strings)
    @selected_num = 0
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
      button = UIButton.buttonWithType(MAIN_BUTTON_TYPE).setFrame(main_4frames[idx])
      button.setTitle(strings[idx], forState: UIControlStateNormal)
      button.titleLabel.font = UIFont.systemFontOfSize(MAIN_BUTTON_SIZE.height/2)
      button.addTarget(self,
                       action: "main_button_pushed:",
                       forControlEvents: UIControlEventTouchUpInside)
      @main_buttons << button
      self.addSubview(button)
    end
  end

  def move_selected_button(button)
    button.frame = @sub_6frames[@selected_num]
    button.titleLabel.font = UIFont.systemFontOfSize(SUB_BUTTON_SIZE.height/2)
    button.enabled = false
    @selected_num += 1
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
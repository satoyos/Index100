class InputView < UIView
  BG_COLOR = UIColor.darkGrayColor # InputViewの背景色(backgroundColor)
  MAIN_BUTTON_SIZE  = CGSizeMake(60, 60)
  CLEAR_BUTTON_HEIGHT = 40
  CLEAR_BUTTON_TITLE = 'やり直し'
  CLEAR_BUTTON_COLOR = ColorFactory.str_to_color('#007bbb') #紺碧
  CHALLENGE_BUTTON_HEIGHT = CLEAR_BUTTON_HEIGHT
  CHALLENGE_BUTTON_TITLE = 'これで決まり！'
  CHALLENGE_BUTTON_COLOR = ColorFactory.str_to_color('#e95295') #ツツジ色
  MAIN_BUTTON_TYPE = UIButtonTypeRoundedRect
  MAIN_BUTTON_NUM = 4

  PROPERTIES = [:main_4frames, :main_buttons, :clear_button, :challenge_button]
  PROPERTIES.each do |prop|
    attr_reader prop
  end

  def initWithFrame(frame, strings: strings)
    super.initWithFrame(frame)
    self.backgroundColor = BG_COLOR
    set_clear_button()
    set_challenge_button()
    create_main_4frames()
    set_main_buttons(strings)

    self
  end


  :private

  def set_challenge_button
    @challenge_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @challenge_button.setFrame(challenge_button_frame)
    @challenge_button.setTitle(CHALLENGE_BUTTON_TITLE, forState: UIControlStateNormal)
    @challenge_button.setTitleColor(UIColor.whiteColor, forState: UIControlStateNormal)
    @challenge_button.setBackgroundColor(CHALLENGE_BUTTON_COLOR, forState: UIControlStateNormal)
    self.addSubview(@challenge_button)
  end

  def challenge_button_frame()
    CGRectMake(clear_button_frame.origin.x + clear_button_frame.size.width,
               self_height - CHALLENGE_BUTTON_HEIGHT,
               self_width/2, CHALLENGE_BUTTON_HEIGHT)
  end

  def set_clear_button
    @clear_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @clear_button.setFrame(clear_button_frame)
    @clear_button.setTitle(CLEAR_BUTTON_TITLE, forState: UIControlStateNormal)
    @clear_button.setTitleColor(UIColor.whiteColor, forState: UIControlStateNormal)
    @clear_button.setBackgroundColor(CLEAR_BUTTON_COLOR, forState: UIControlStateNormal)
    self.addSubview(@clear_button)
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
      @main_buttons << button
      self.addSubview(button)
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

  def nth_main_frame(idx)
    CGRectMake(x_gap * (idx+1) + MAIN_BUTTON_SIZE.width * idx,
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
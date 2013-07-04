class InputView < UIView
  BG_COLOR = UIColor.darkGrayColor # InputViewの背景色(backgroundColor)
  MAIN_BUTTON_SIZE  = CGSizeMake(40, 40)
  CLEAR_BUTTON_SIZE = CGSizeMake(40, 20)

  PROPERTIES = [:main_4frames]
  PROPERTIES.each do |prop|
    attr_reader prop
  end

  def initWithFrame(frame)
    super
    self.backgroundColor = BG_COLOR
    create_main_4frames()

    self
  end

  def create_main_4frames
    @main_4frames = []
    (0..3).each do |idx|
      @main_4frames << nth_main_frame(idx)
    end

  end

  :private

  def x_gap
    (self.frame.size.width - MAIN_BUTTON_SIZE.width*4 + CLEAR_BUTTON_SIZE.width) / 6
  end

  def bottom_margin
    x_gap
  end

  def nth_main_frame(idx)
    CGRectMake(x_gap * (idx+1) + MAIN_BUTTON_SIZE.width * idx,
               self.frame.size.height - bottom_margin - MAIN_BUTTON_SIZE.height,
               MAIN_BUTTON_SIZE.width,
               MAIN_BUTTON_SIZE.height)
  end
end
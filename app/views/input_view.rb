class InputView < UIView
  BG_COLOR = UIColor.darkGrayColor # InputViewの背景色(backgroundColor)
  MAIN_BUTTON_SIZE  = CGSizeMake(60, 60)
  SUB_BUTTON_SIZE   = CGSizeMake(40, 40)
  CLEAR_BUTTON_HEIGHT = 40
  CLEAR_BUTTON_TITLE = 'やり直し'
  CLEAR_BUTTON_COLOR = '#007bbb'.uicolor #紺碧
  CHALLENGE_BUTTON_HEIGHT = CLEAR_BUTTON_HEIGHT
  CHALLENGE_BUTTON_TITLE = 'これで決まり！'
  CHALLENGE_BUTTON_COLOR = '#e95295'.uicolor #ツツジ色
  SUB_BUTTON_NUM  = 6

  SELECTED_BUTTON_TITLE_COLOR = '#c85179'.uicolor #中紅

  PROPERTIES_READER = [:main_4frames,
                :sub_buttons, :sub_6frames, :result_view, :controller]
  PROPERTIES_READER.each do |prop|
    attr_reader prop
  end


  def initWithFrame(frame)
    super

    self.backgroundColor = BG_COLOR
    create_main_4frames()
    create_sub_6frames()
    setup_sub_button_slot()

    self
  end

  def clear_button_pushed
    remove_buttons_from_super_view(@sub_buttons)
    setup_sub_button_slot()
    clean_up_result_view()
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

  def ratio_of_sub_to_main
    SUB_BUTTON_SIZE.width / MAIN_BUTTON_SIZE.width
  end

  :private

  def clean_up_result_view
    return unless @result_view
    @result_view.clean_up_subviews
    @result_view.removeFromSuperview
    @result_view = nil
  end


  def remove_buttons_from_super_view(slot)
    slot.each do |button|
      next unless button.is_a?(UIButton)
      button.removeFromSuperview
    end
  end

  def setup_sub_button_slot
    @sub_buttons = ButtonSlot.new(SUB_BUTTON_NUM)
  end

  def set_challenge_button(button)
    button.setFrame(challenge_button_frame)
    set_stable_button(button,
                      title: CHALLENGE_BUTTON_TITLE,
                      bg_color: CHALLENGE_BUTTON_COLOR)
    self.addSubview(button)
  end

  def set_main_buttons(main_buttons)
    main_buttons.each_with_index do |button, idx|
      button.setFrame(hidden_main_frame_at(idx))
#      button.titleLabel.font = UIFont.systemFontOfSize(MAIN_BUTTON_SIZE.height/2)
      button.titleLabel.font =
          FontFactory.create_font_with_type(:japaneseW6,
                                            size: MAIN_BUTTON_SIZE.height/2)
      self.addSubview(button)
    end
  end

  def make_main_buttons_appear(buttons)
    buttons.each_with_index do |button, idx|
      button.frame = @main_4frames[idx]
    end
  end

  def challenge_button_frame()
    CGRectMake(clear_button_frame.origin.x + clear_button_frame.size.width,
               self_height - CHALLENGE_BUTTON_HEIGHT,
               self_width/2, CHALLENGE_BUTTON_HEIGHT)
  end

  def set_clear_button(c_button)
    c_button.setFrame(clear_button_frame)
    set_stable_button(c_button,
                      title: CLEAR_BUTTON_TITLE,
                      bg_color: CLEAR_BUTTON_COLOR)
    self.addSubview(c_button)
  end

  def set_stable_button(button, title: text, bg_color: bg_color)
    button.setTitle(text, forState: UIControlStateNormal)
    button.setTitleColor(UIColor.whiteColor, forState: UIControlStateNormal)
    button.backgroundColor = bg_color
  end

  def clear_button_frame
    CGRectMake(0, self_height - CLEAR_BUTTON_HEIGHT,
               self_width/2, CLEAR_BUTTON_HEIGHT)
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


  def move_selected_button(pushed_button)
    pushed_button.tap do |button|
      button.frame = @sub_6frames[selected_num]
#      button.titleLabel.font = UIFont.systemFontOfSize(SUB_BUTTON_SIZE.height/2)
      button.titleLabel.font =
          button.titleLabel.font.fontWithSize(SUB_BUTTON_SIZE.height/1.5)
      button.enabled = false
      @sub_buttons << button
    end
    change_color_of_button(pushed_button)
  end

  def selected_num
    @sub_buttons.size
  end

  # @param [UIButton] button
  def change_color_of_button(button)
    button.setTitleColor(SELECTED_BUTTON_TITLE_COLOR,
                         forState: UIControlStateDisabled)
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

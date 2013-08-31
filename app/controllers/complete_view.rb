class CompleteView < RMView

  COMPLETE_MSG = 'お疲れ様でした！'
  COMPLETE_MSG_TOP_MARGIN = 100

  RETURN_BUTTON_TITLE = '終了'
  RETURN_BUTTON_BOTTOM_MARGIN = 100

  def initWithFrame(frame, controller: controller)
    super.initWithFrame(frame)

    @controller = controller
    self.backgroundColor = UIColor.whiteColor
    set_complete_msg_label()
    set_return_button()
    self
  end

  :private

  def set_complete_msg_label
    label = UILabel.alloc.initWithFrame(CGRectZero)
    label.text = COMPLETE_MSG
    label.sizeToFit
    label.frame = complete_msg_frame(label.frame.size)
    self.addSubview(label)
  end


  # @param [CGSize] msg_size
  def complete_msg_frame(msg_size)
    [CGPointMake((self.size.width - msg_size.width)/2,
                 COMPLETE_MSG_TOP_MARGIN),
    msg_size]
  end

  def set_return_button
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)

    # @param [UIButton] b
    button.tap do |b|
      b.setTitle(RETURN_BUTTON_TITLE, forState: UIControlStateNormal)
      b.sizeToFit
      b.frame = return_button_frame(b.frame.size)
      b.addTarget(@controller,
                  action: 'back_to_the_beginning',
                  forControlEvents: UIControlEventTouchUpInside)
      self.addSubview(b)
    end
  end

  # @param [CGSize] button_size
  def return_button_frame(button_size)
    [CGPointMake((self.size.width - button_size.width)/2,
                 self_height - RETURN_BUTTON_BOTTOM_MARGIN - button_size.height),
     button_size]
  end

  def self_height
    self.frame.size.height
  end


end
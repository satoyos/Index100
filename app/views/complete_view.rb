class CompleteView < UIView

  COMPLETE_MSG = 'お疲れ様でした！'
  COMPLETE_MSG_TOP_MARGIN = 100

  RETURN_BUTTON_TITLE = '終了'
  RETURN_BUTTON_BOTTOM_MARGIN = 100

  A_LABEL_COMPLETE_VIEW = 'complete_view'
  A_LABEL_MESSAGE_LABEL = 'message_label'
  A_LABEL_RETURN_BUTTON = 'return_button'

  attr_reader :msg_label, :return_button
  
  def initWithFrame(frame, controller: controller)
    super.initWithFrame(frame)

    @controller = WeakRef.new(controller) # 循環参照を避けるため、弱参照を使う。
    self.backgroundColor = UIColor.whiteColor
    self.accessibilityLabel = A_LABEL_COMPLETE_VIEW
    set_complete_msg_label
    set_return_button
    self
  end

  :private

  def set_complete_msg_label
    @msg_label = UILabel.alloc.initWithFrame(CGRectZero)
    @msg_label.tap do |label|
      label.text = COMPLETE_MSG
      label.sizeToFit
      label.frame = complete_msg_frame(label.frame.size)
      label.accessibilityLabel = A_LABEL_MESSAGE_LABEL
      self.addSubview(label)
    end
  end


  # @param [CGSize] msg_size
  def complete_msg_frame(msg_size)
    [CGPointMake((self.size.width - msg_size.width)/2,
                 COMPLETE_MSG_TOP_MARGIN),
    msg_size]
  end

  def set_return_button
    @return_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)

    @return_button.tap do |b|
      b.setTitle(RETURN_BUTTON_TITLE, forState: UIControlStateNormal)
      b.sizeToFit
      b.frame = return_button_frame(b.frame.size)
      b.addTarget(self,
                  action: 'back_to_the_beginning',
                  forControlEvents: UIControlEventTouchUpInside)
      b.accessibilityLabel = A_LABEL_RETURN_BUTTON
      self.addSubview(b)
    end
  end

  def back_to_the_beginning
    @controller.navigationController.popViewControllerAnimated(true)
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
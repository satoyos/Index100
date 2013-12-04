class InputViewButton < UIButton
  TEXT_COLOR = UIColor.blackColor
  TAPPED_COLOR = UIColor.redColor
  CORNER_RADIOS = 8.0

  class << self
    def create_button
      button = self.buttonWithType UIButtonTypeCustom
      button.layer.tap do |l|
        l.cornerRadius = CORNER_RADIOS
        l.masksToBounds = true
        l.borderWidth = 0.0
      end
      button.setTitleColor(TEXT_COLOR,   forState: UIControlStateNormal)
      button.setTitleColor(TAPPED_COLOR, forState: UIControlStateHighlighted)
      button
    end
  end

  # return color as a CGColorRef
  def backgroundColor
    self.layer.backgroundColor
  end

  # set color as a CGColorRef
  def backgroundColor=(color)
    self.layer.backgroundColor = case color.is_a?(UIColor)
                                   when true ; color.CGColor
                                   else      ; color
                                 end
  end

end
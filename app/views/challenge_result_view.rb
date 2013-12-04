class ChallengeResultView < UIView
  RESULT_VIEW_SIZE  = CGSizeMake(300, 300)
  RESULT_FONT_SIZE = 250
  RESULT_VIEW_ALPHA = 0.5
  RESULT_TEXT = {right: '○',
                 wrong:   '×'}
  RESULT_TEXT_COLOR = {right: UIColor.redColor,
                       wrong: UIColor.blueColor}

  PROPERTIES_READER = [:label]
  PROPERTIES_READER.each do |prop|
    attr_reader prop
  end

  def initWithResult(sym)
    unless RESULT_TEXT.keys.include?(sym)
=begin
      puts "xxx ChallengeResultViewの初期化に使われたシンボル[#{sym}]は、サポートしていません。"
      return
=end
      raise "invalid symbol [#{sym}] to initialize #{self}"
    end
    initWithFrame([CGPointMake(0, 0), RESULT_VIEW_SIZE])
    self.alpha = RESULT_VIEW_ALPHA
    self.backgroundColor = UIColor.whiteColor
    set_label(sym)

    self
  end

  def set_label(result_type)
    @label = UILabel.alloc.init
    @label.tap do |l|
      l.text = RESULT_TEXT[result_type]
      l.font = l.font.fontWithSize(RESULT_FONT_SIZE)
      l.sizeToFit
      l.center = self.center
      l.textColor = RESULT_TEXT_COLOR[result_type]
      l.backgroundColor = UIColor.clearColor
      self.addSubview(l)
    end
  end

  def clean_up_subviews
    self.subviews.each do |s_view|
      s_view.removeFromSuperview
    end
  end
end
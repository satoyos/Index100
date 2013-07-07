class UIButton
  def setBackgroundColor(color, forState: state)
    button_size = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
    bg_view = UIView.alloc.initWithFrame(button_size)
    bg_view.layer.cornerRadius = 5
    bg_view.clipsToBounds = true
    bg_view.backgroundColor = color
    UIGraphicsBeginImageContext(self.frame.size)
    bg_view.layer.renderInContext(UIGraphicsGetCurrentContext())
    screen_image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    self.setBackgroundImage(screen_image, forState: state)
  end
end
class GearButton < UIButton
  GEAR_ICON_PNG = 'gear_256.png'
  GEAR_ICON_SIZE = CGSizeMake(30, 30)
  GEAR_ICON_IMG =
      ResizeUIImage.resizeImage(UIImage.imageNamed(GEAR_ICON_PNG),
                                newSize: GEAR_ICON_SIZE)
  A_LABEL = 'volume_icon'

  def init_icon
    setBackgroundImage(GEAR_ICON_IMG, forState: UIControlStateNormal)
    self.frame = [CGPointZero, GEAR_ICON_SIZE]
#    self.setTitle(' ', forState: UIControlStateNormal)
#    self.accessibilityLabel = A_LABEL
  end
end

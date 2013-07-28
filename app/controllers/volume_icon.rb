class VolumeIcon < UIButton
  VOLUME_ICON_PNG = 'speaker_640.png'
  VOLUME_ICON_SIZE = CGSizeMake(30, 30)
  VOLUME_ICON_IMG =
      ResizeUIImage.resizeImage(UIImage.imageNamed(VOLUME_ICON_PNG),
                                newSize: VOLUME_ICON_SIZE)
  A_LABEL = 'volume_icon'

  def init_icon
    setBackgroundImage(VOLUME_ICON_IMG, forState: UIControlStateNormal)
    self.frame = [CGPointZero, VOLUME_ICON_SIZE]
    self.setTitle(' ', forState: UIControlStateNormal)
    self.accessibilityLabel = A_LABEL
  end
end

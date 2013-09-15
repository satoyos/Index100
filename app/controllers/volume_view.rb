class VolumeView < UIView
  VOLUME_VIEW_HEIGHT = 60
  VOLUME_VIEW_COLOR = ColorFactory.str_to_color('#68be8d')
  VOLUME_VIEW_ALPHA = 0.7
  VOLUME_VIEW_WIDTH_MARGIN = 10

  X_MARGIN = 10
  Y_MARGIN = 10
  SLIDER_HEIGHT = 30
  PLAY_BUTTON_HEIGHT = 30
  PLAY_BUTTON_WIDTH = PLAY_BUTTON_HEIGHT

  PLAY_ICON_IMG_FILE = 'Restart@2x-reverse.png'

  def initWithFrame(frame)
    super

    self
  end

  # @param [CGSize] super_view_size
  def initWithSuperViewSize(super_view_size)
    initWithFrame([CGPointZero,
                   CGSizeMake(super_view_size.width, VOLUME_VIEW_HEIGHT)])
    self.backgroundColor= VOLUME_VIEW_COLOR
    self.alpha= VOLUME_VIEW_ALPHA
    self

  end

  def volume_slider_frame
    [CGPointMake(X_MARGIN * 2 + PLAY_BUTTON_WIDTH ,
                 (self.frame.size.height - SLIDER_HEIGHT)/2),
     CGSizeMake(self.frame.size.width - 3 * X_MARGIN - PLAY_BUTTON_WIDTH,
                SLIDER_HEIGHT)
    ]
  end


  def play_button_frame
    [CGPointMake(X_MARGIN,
                 (self.frame.size.height - PLAY_BUTTON_HEIGHT)/2),
     CGSizeMake(PLAY_BUTTON_HEIGHT, PLAY_BUTTON_HEIGHT)]
  end

  def play_button_image
    ResizeUIImage.resizeImage(UIImage.imageNamed(PLAY_ICON_IMG_FILE),
                              newSize: CGSizeMake(PLAY_BUTTON_WIDTH,
                                                  PLAY_BUTTON_HEIGHT))
  end


  :private



end
class VolumeView < UIView
  VOLUME_VIEW_HEIGHT = 60
  VOLUME_VIEW_COLOR = ColorFactory.str_to_color('#68be8d')
  VOLUME_VIEW_ALPHA = 0.7
  VOLUME_VIEW_WIDTH_MARGIN = 10

  SLIDER_X_MARGIN = 10
  SLIDER_HEIGHT = 20

  def initWithFrame(frame)
    super

    self.backgroundColor= VOLUME_VIEW_COLOR
    self.alpha= VOLUME_VIEW_ALPHA

    self
  end

# @param [GameView] game_view
# @param [VolumeIcon] volume_icon
  def initWithGameView(game_view, volume_icon: volume_icon)
    @initial_frame = volume_view_initial_frame(game_view.frame.size.width,
                                               volume_icon.frame.size.width)
    self.initWithFrame(@initial_frame)
  end

  def make_appear
    self.frame= [CGPointMake(self.frame.origin.x, 0), self.frame.size]
  end

  def make_disappear
    self.frame= @initial_frame
  end

  def is_coming_out?
    self.frame.origin.y == 0
  end

  def volume_slider_frame
    [CGPointMake(SLIDER_X_MARGIN,
                 (self.frame.size.height - SLIDER_HEIGHT)/2),
     CGSizeMake(self.frame.size.width - 2 * SLIDER_X_MARGIN,
                SLIDER_HEIGHT)
    ]
  end

  :private

  def volume_view_initial_frame(game_view_width, volume_icon_width)
    [CGPointMake(volume_icon_width + VOLUME_VIEW_WIDTH_MARGIN,
                 -1*VOLUME_VIEW_HEIGHT),
     CGSizeMake(game_view_width - 2*(volume_icon_width+VOLUME_VIEW_WIDTH_MARGIN),
                VOLUME_VIEW_HEIGHT)]
  end


end
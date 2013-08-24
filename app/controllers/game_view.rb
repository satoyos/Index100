class GameView < UIView
  TATAMI_JPG_FILE = 'tatami_moved.jpg'
  FUDA_INITIAL_STRING = 'これから札に歌を設定します。'
  FUDA_HEIGHT_POWER = 0.95 # 札ビューの高さは、畳ビューの何倍にするか

  VOLUME_ICON_MARGIN = 10

  PROPERTIES = [:poem, :tatami_view, :fuda_view, :input_view, :controller]
  PROPERTIES.each do |prop|
    attr_reader prop
  end

  def initWithFrame(frame, withPoem: poem, controller: controller)
    super.initWithFrame(frame)
    @poem = poem
    @conroller = controller
    create_tatami_view()
    create_fuda_view()
    @fuda_view.rewrite_string(@poem.in_hiragana.shimo)

    create_input_view()

    self
  end

  def create_tatami_view
    @tatami_view = UIImageView.alloc.initWithImage(UIImage.imageNamed(TATAMI_JPG_FILE))
    @tatami_view.tap do |t_view|
      t_view.frame = [CGRectZero.origin,
                      CGSizeMake(self_size.width, self_size.height/2)]
      t_view.clipsToBounds= true
      t_view.userInteractionEnabled = true
#      create_volume_icon_on_tatami
      self.addSubview(t_view)
    end
  end

  def create_fuda_view
    @fuda_view = FudaView.alloc.initWithString(FUDA_INITIAL_STRING)
    @fuda_view.tap do |f_view|
      f_view.set_all_sizes_by(@tatami_view.frame.size.height * FUDA_HEIGHT_POWER)
      f_view.center= @tatami_view.center
      @tatami_view.addSubview(f_view)
    end
  end

  def volume_icon_frame_with_size(v_size)
    [CGPointMake(tatami_size.width -
                     v_size.width - VOLUME_ICON_MARGIN,
                 VOLUME_ICON_MARGIN),
     v_size]
  end

  def draw_main_buttons(main_buttons)
    @input_view.set_main_buttons(main_buttons)
  end

  def draw_clear_button(button)
    @input_view.set_clear_button(button)
  end

  def draw_challenge_button(button)
    @input_view.set_challenge_button(button)
  end

  def make_main_buttons_appear(main_buttons)
    @input_view.make_main_buttons_appear(main_buttons)
  end

  def main_button_pushed(main_button, callback: callback_name)
    @input_view.main_button_pushed(main_button,
                                   callback: callback_name)
  end

  def main_buttons_appearing_motion(main_buttons, callback: callback_name)
    @input_view.main_buttons_appearing_motion(main_buttons,
                                              callback: callback_name)
  end

  def clear_button_pushed
    @input_view.clear_button_pushed
  end

  def display_result(result_type)
    @input_view.display_result_view(result_type)
  end

  :private

  def create_input_view
    @input_view = InputView.alloc.initWithFrame(input_view_frame,
                                                controller: @conroller)
    self.addSubview(@input_view)
  end

  def input_view_frame
    CGRectMake(0, tatami_origin.y + tatami_size.height,
               tatami_size.width, self_size.height - tatami_size.height)
  end

  def self_size
    self.frame.size
  end

  def tatami_origin
    @tatami_view.frame.origin
  end

  def tatami_size
    @tatami_view.frame.size
  end

end
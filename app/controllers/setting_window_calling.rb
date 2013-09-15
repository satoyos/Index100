module SettingWindowCalling
  def create_volume_icon
    @volume_icon = VolumeIcon.alloc.init
    @volume_icon.init_icon
    @volume_icon.tap do |v_icon|
      v_icon.frame = @game_view.volume_icon_frame_with_size(v_icon.frame.size)
      v_icon.addTarget(self, action: :volume_icon_tapped, forControlEvents: UIControlEventTouchUpInside)
      @game_view.addSubview(v_icon)
    end
  end

  def volume_icon_tapped
    modal_controller = ExamSettingViewController.alloc.init
    modal_controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve
    self.presentModalViewController(modal_controller, animated: true)
  end

end
module SettingWindowCalling
  def create_gear_icon
    @gear_icon = GearButton.alloc.init
    @gear_icon.init_icon
    @gear_icon.tap do |g_icon|
      g_icon.frame = @game_view.volume_icon_frame_with_size(g_icon.frame.size)
      g_icon.addTarget(self, action: :gear_icon_tapped, forControlEvents: UIControlEventTouchUpInside)
      @game_view.addSubview(g_icon)
    end
  end

  def gear_icon_tapped
    modal_controller = ExamSettingViewController.alloc.init
    modal_controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve
    self.presentModalViewController(modal_controller, animated: true)
  end

end
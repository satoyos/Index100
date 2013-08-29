class TatamiView < UIImageView
  TATAMI_JPG_FILE = 'tatami_moved.jpg'

  def initWithFrame(frame, controller: controller)
    super.initWithImage(UIImage.imageNamed(TATAMI_JPG_FILE))
    self.frame = frame
    @controller = controller
    self
  end

  def touchesBegan(touches, withEvent:event)
    puts 'touched!'
    @controller.switch_full_screen
  end
end
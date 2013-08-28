class StartViewController < UIViewController
  GAME_START_BUTTON_TITLE = '決まり字テスト開始！'

  def viewDidLoad
    super

    setToolbarItems([game_start_button], animated: false)
  end

  :private

  def game_start_button
    UIBarButtonItem.alloc.initWithTitle(
        GAME_START_BUTTON_TITLE,
        style: UIBarButtonItemStylePlain,
        target: nil,
        action: nil)
  end
end
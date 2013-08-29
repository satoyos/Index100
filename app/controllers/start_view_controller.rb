class StartViewController < UIViewController
  GAME_START_BUTTON_TITLE = '決まり字テスト開始！'

  READ_PROPERTIES = []
  READ_PROPERTIES.each do |prop|
    attr_reader prop
  end

  ACCESS_PROPERTIES = []
  ACCESS_PROPERTIES.each do |prop|
    attr_accessor prop
  end

  def viewDidLoad
    super

    setToolbarItems(tool_bar_items, animated: false)
    unless RUBYMOTION_ENV == 'test'
      navigationController.navigationBar.barStyle = UIBarStyleBlack
      navigationController.toolbarHidden = false
      navigationController.toolbar.barStyle = UIBarStyleBlack
    end
  end

  def viewWillAppear(animated)
    super
    unless RUBYMOTION_ENV == 'test'
      navigationController.navigationBar.translucent = false
    end
  end

  :private

  def tool_bar_items
    [
        tool_bar_flexible_space(),
        game_start_button,
        tool_bar_flexible_space()
    ]
  end

  def tool_bar_flexible_space
    UIBarButtonItem.alloc.initWithBarButtonSystemItem(
        UIBarButtonSystemItemFlexibleSpace, target: nil, action: nil)
  end

  def game_start_button
    UIBarButtonItem.alloc.initWithTitle(
        GAME_START_BUTTON_TITLE,
        style: UIBarButtonItemStylePlain,
        target: self,
        action: 'start_button_pushed')
  end

  def start_button_pushed
    navigationController.pushViewController(
        ExamController.alloc.initWithNibName(nil, bundle: nil),
        animated: true)
  end
end
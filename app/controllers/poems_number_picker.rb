class PoemsNumberPicker < UIViewController

  PICKER_TITLE = '使う枚数'
  PROMPT = StartViewController::PROMPT
  PICKER_VIEW_WIDTH = 100
  INITIAL_POEMS_NUM = 0
  COMPONENT_ID = 0
  POEM_NUM_CANDIDATES = [0,
      1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
      15, 20, 25, 30, 35, 40, 45, 50,
      60, 70, 80, 90, 100
  ]
  ALL_LABEL = '全て'

  class << self
    def poems_num
      NSUserDefaults[:poems_num] || INITIAL_POEMS_NUM
    end

    def poems_num=(num)
      NSUserDefaults[:poems_num] = num
    end
  end

  def viewDidLoad
    self.title = PICKER_TITLE
    self.navigationItem.prompt = PROMPT
    @picker_view = UIPickerView.alloc.init
    @picker_view.tap do |p_view|
      p_view.delegate = self
      p_view.dataSource = self
      p_view.showsSelectionIndicator = true
      p_view.selectRow(POEM_NUM_CANDIDATES.find_index(
                           PoemsNumberPicker.poems_num),
                       inComponent: COMPONENT_ID,
                       animated: false)
      self.view.addSubview(p_view)
    end
    self.view.backgroundColor = UIColor.whiteColor
  end

  def viewWillDisappear(animated)
    PoemsNumberPicker.poems_num =
        POEM_NUM_CANDIDATES[@picker_view.selectedRowInComponent(COMPONENT_ID)]
#    puts "- 永続化データ[poems_num]の値を[#{PoemsNumberPicker.poems_num}]に書き換えました。"
  end

  def numberOfComponentsInPickerView(pickerView)
    1
  end

  def pickerView(pickerView, numberOfRowsInComponent: component)
    POEM_NUM_CANDIDATES.size
  end

  def pickerView(pickerView, titleForRow: row, forComponent: component)
    case POEM_NUM_CANDIDATES[row]
      when 0 ; ALL_LABEL
      else   ; "#{POEM_NUM_CANDIDATES[row]}"
    end
  end

  def pickerView(pickerView, widthForComponent: component)
    PICKER_VIEW_WIDTH
  end

end


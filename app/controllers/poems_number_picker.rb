#####
# To get selected [Number of Poems],
# call class method of this class; 'poems_num'
#####

class PoemsNumberPicker < RMViewController

  INITIAL_POEMS_NUM = 100
  COMPONENT_ID = 0
  POEM_NUM_CANDIDATES = [
      1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
      15, 20, 25, 30, 35, 40, 45, 50,
      60, 70, 80, 90, 100
  ]

  class << self
    def poems_num
      UIApplication.sharedApplication.delegate.settings.poems_num || INITIAL_POEMS_NUM
    end

    def poems_num=(num)
      UIApplication.sharedApplication.delegate.settings.poems_num = num
    end
  end

  def viewDidLoad
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
    "#{POEM_NUM_CANDIDATES[row]}"
  end

end


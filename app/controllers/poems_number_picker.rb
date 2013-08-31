class PoemsNumberPicker < RMViewController

  INITIAL_POEMS_NUM = 100
  COMPONENT_ID = 0

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
      p_view.selectRow(PoemsNumberPicker.poems_num-1,
                       inComponent: COMPONENT_ID,
                       animated: false)
      self.view.addSubview(p_view)
    end
  end

  def viewWillDisappear(animated)
    PoemsNumberPicker.poems_num =
        @picker_view.selectedRowInComponent(COMPONENT_ID)+1
#    puts "- 永続化データ[poems_num]の値を[#{PoemsNumberPicker.poems_num}]に書き換えました。"
  end

  def numberOfComponentsInPickerView(pickerView)
    1
  end

  def pickerView(pickerView, numberOfRowsInComponent: component)
    100
  end

  def pickerView(pickerView, titleForRow: row, forComponent: component)
    "#{row+1}"
  end

end


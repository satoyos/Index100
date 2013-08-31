describe 'PoemsNumberPicker' do
  describe '初期化' do
    tests PoemsNumberPicker

    it 'should not be nil' do
      controller.should.not.be.nil
    end

    it 'サブビューはPickerView' do
      controller.view.subviews.first.tap do |p_view|
        p_view.is_a?(UIPickerView).should.be.true
        p_view.showsSelectionIndicator.should.be.true
      end
    end
  end

  describe 'クラスメソッド: poems_num' do
    before do
      @poems_num = PoemsNumberPicker.poems_num
    end
    it 'should not be nil' do
      @poems_num.should.not.be.nil
    end
    it 'should be a Fixnum' do
      @poems_num.is_a?(Fixnum).should.be.true
    end
  end
end
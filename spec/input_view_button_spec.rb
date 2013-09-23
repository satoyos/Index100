describe 'InputViewButton' do
  describe '初期化' do
    before do
      @button = InputViewButton.create_button
    end

    it 'should not be nil' do
      @button.should.not.be.nil
    end

    it '正しく初期化されている' do
      @button.layer.cornerRadius.should == InputViewButton::CORNER_RADIOS
    end

  end

  describe 'backgroundColor' do
    TEST_CG_COLOR = UIColor.whiteColor.CGColor
    TEST_UI_COLOR = UIColor.blueColor
    before do
      @button = InputViewButton.create_button
      @button.backgroundColor = TEST_CG_COLOR
    end

    it 'backgroundColorが正しく設定されている' do
      @button.backgroundColor.should == TEST_CG_COLOR
    end

    it 'setterは色指定がUIColorでも受け入れ可能' do
      @button.backgroundColor = TEST_UI_COLOR
      @button.backgroundColor.should == TEST_UI_COLOR.CGColor
    end

  end
end
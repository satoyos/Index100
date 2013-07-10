describe 'InputView' do
  TEST_INPUT_VIEW_FRAME = CGRectMake(0, 300, 320, 240)
  before do
    @input_view = InputView.alloc.initWithFrame(TEST_INPUT_VIEW_FRAME,
                                                strings: ['あ', 'い', 'う', 'え'])
  end

  it 'should not be nil' do
    @input_view.should.not.be.nil
    @input_view.is_a?(InputView).should.be.true
  end

  it 'このViewの初期化に使ったFrameと同じFrameを持つ' do
    @input_view.frame.should == TEST_INPUT_VIEW_FRAME
  end

  it 'クリアボタンが設置されている' do
    @input_view.clear_button.should.not.be.nil
    @input_view.clear_button.frame.size.height.should == InputView::CLEAR_BUTTON_HEIGHT
  end

  it 'チャレンジボタンが設置されている' do
    @input_view.challenge_button.should.not.be.nil
    @input_view.challenge_button.frame.size.height.should == InputView::CHALLENGE_BUTTON_HEIGHT
    @input_view.challenge_button.currentTitle.should == InputView::CHALLENGE_BUTTON_TITLE
  end

  it '四つのメイン文字ボタン用のFrameを持つ' do
    @input_view.main_4frames.should.not.be.nil
    @input_view.main_4frames.size.should == 4
    @input_view.main_4frames.each do |elem|
      elem.is_a?(CGRect).should.be.true
    end
  end

  it 'メイン文字ボタン間のギャップが適切に設定されている' do
    first_frame  = @input_view.main_4frames[0]
    second_frame = @input_view.main_4frames[1]
    third_frame  = @input_view.main_4frames[2]
    @gap = third_frame.origin.x - second_frame.origin.x - InputView::MAIN_BUTTON_SIZE.width
    first_frame.origin.x.should.be.close(@gap, 0.1)
  end

  it 'main_4framesを描画領域とするボタンを4つ持つ' do
    @input_view.main_buttons.tap do |buttons|
      buttons.should.not.be.nil
      buttons.is_a?(ButtonSlot).should.be.true
      buttons.size.should == 4
      buttons.each do |button|
        button.should.not.be.nil
        button.buttonType.should == InputView::MAIN_BUTTON_TYPE
      end
    end

  end

  it '6つのサブボタン用のFrameを持つ' do
    @input_view.sub_6frames.should.not.be.nil
    @input_view.sub_6frames.size.should == 6
    @input_view.sub_6frames.each do |elem|
      elem.is_a?(CGRect).should.be.true
    end
  end

  it 'origin of 3rd sub_button is properly set' do
    first_frame = @input_view.sub_6frames[0]
    third_frame = @input_view.sub_6frames[2]
    x_gap = first_frame.origin.x
    expected_third_x = x_gap +
        (x_gap * @input_view.ratio_of_sub_to_main + third_frame.size.width) * 2
    expected_third_y = x_gap
    third_frame.origin.x.should.be.close(expected_third_x, 0.1)
    third_frame.origin.y.should.be.close(expected_third_y, 0.1)
  end

end
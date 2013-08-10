describe 'InputView' do
  TEST_INPUT_VIEW_FRAME = CGRectMake(0, 300, 320, 240)
  before do
    @input_view =
        InputView.alloc.initWithFrame(TEST_INPUT_VIEW_FRAME, controller: nil)
  end

  it 'should not be nil' do
    @input_view.should.not.be.nil
    @input_view.is_a?(InputView).should.be.true
  end

  it 'このViewの初期化に使ったFrameと同じFrameを持つ' do
    @input_view.frame.should == TEST_INPUT_VIEW_FRAME
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


  it '6つのサブボタン用のFrameを持つ' do
    @input_view.sub_6frames.should.not.be.nil
    @input_view.sub_6frames.size.should == 6
    @input_view.sub_6frames.each do |elem|
      elem.is_a?(CGRect).should.be.true
    end
  end

  it '容量6のサブボタン用スロットを持つ' do
    @input_view.sub_buttons.should.not.be.nil
    @input_view.sub_buttons.limit_size.should == 6
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

  describe 'move_selected_button' do
    before do
      @button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
      @input_view.pushed_button = @button
      @input_view.move_selected_button
    end

    it '@pushed_button is set' do
      @input_view.pushed_button.should.not.be.nil
      @input_view.pushed_button.is_a?(UIButton).should.be.true
      @input_view.pushed_button.should == @button
    end

    it '押されたボタンは、サブボタン用スロットに入る' do
      @input_view.sub_buttons.size.should == 1
      @input_view.sub_buttons.last.should == @button
    end

    it '押されたボタンの文字色は、指定された色に変わる' do
      @input_view.sub_buttons[0].currentTitleColor.should ==
          InputView::SELECTED_BUTTON_TITLE_COLOR
    end

  end

  describe 'clear_button_pushed' do
    before do
      @button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
      @input_view.pushed_button = @button
      @input_view.move_selected_button
    end

    it 'この時点では、サブボタン用スロットに入っているボタンは1個' do
      @input_view.sub_buttons.size.should == 1
    end

    it 'クリアボタンが押されたら、各スロットは元に戻る' do
      @input_view.clear_button_pushed
      @input_view.sub_buttons.size.should == 0
    end

    it 'クリアボタンが押されたら、selected_numは初期化される' do
      # この時点では、「選択されている文字数」は1
      @input_view.selected_num.should == 1

      # クリアボタンがタップされたら0に戻る
      @input_view.clear_button_pushed
      @input_view.selected_num.should == 0
    end
  end

=begin
  describe 'チャレンジボタンが押されるときの動作[正解編]' do
    before do
      # まず、正解の状態を作る！
      first_button = @input_view.main_buttons[2]
      @first_str = first_button.currentTitle

      # 1文字目の入力
      @input_view.test_pushed_sequence(first_button)

      second_button = @input_view.main_buttons[0]
      @second_str = second_button.currentTitle

      # 2文字目の入力
      @input_view.test_pushed_sequence(second_button)

      third_button = @input_view.main_buttons[3]
      @third_str = third_button.currentTitle

      # 3文字目の入力
      @input_view.test_pushed_sequence(third_button)

      # チャレンジボタンを押す
      @input_view.challenge_button_pushed
    end

    it '@input_view should not be nil' do
      @input_view.should.not.be.nil
    end

    it '最初のボタンは「あ」' do
      @first_str.should == 'あ'
      @second_str.should == 'ら'
      @third_str.should == 'し'
    end

    it 'サブボタンスロットには「あ」「ら」「し」が入っている' do
      @input_view.challenge_strings.should == 'あらし'
    end

    it '一番上に載っているsubviewは、ChallengeResultView' do
      @input_view.subviews.last.is_a?(ChallengeResultView).should.be.true
    end
    it 'そのビューは、result_viewメソッドで参照できる' do
      @input_view.result_view.is_a?(ChallengeResultView).should.be.true
    end
  end

  describe 'チャレンジボタンが押されるときの動作[間違い編]' do
    before do
      # まず、正解の状態を作る！
      first_button = @input_view.main_buttons[2]
      @first_str = first_button.currentTitle

      # 1文字目の入力
      @input_view.test_pushed_sequence(first_button)

      second_button = @input_view.main_buttons[0]
      @second_str = second_button.currentTitle

      # 2文字目の入力
      @input_view.test_pushed_sequence(second_button)

      # 2文字目しか入れてない状態でチャレンジボタンを押す
      @input_view.challenge_button_pushed
    end

    it '一番上に載っているsubviewは、ChallengeResultView' do
      @input_view.subviews.last.is_a?(ChallengeResultView).should.be.true
    end

    it '一番上に載っているsubviewのテキストは、間違い時の表示文字列' do
      @input_view.result_view.label.text.should == ChallengeResultView::RESULT_TEXT[:wrong]
    end

    it 'チャレンジボタンをもう1回押しても、ChallengeResultViewは1枚のまま増えない' do
      @input_view.challenge_button_pushed
      @input_view.subviews.select{|view| view.is_a?(ChallengeResultView)}.size.should == 1
    end


  end
=end

end
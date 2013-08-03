describe 'ExamController' do
  describe '初期化' do
    tests ExamController

    it 'should not be nil' do
      controller.should.not.be.nil
    end

    it '畳ビューを一枚もつ' do
      controller.tatami_view.should.not.be.nil
      controller.tatami_view.is_a?(UIView).should.be.true
    end

    it '札ビューを一枚もつ' do
      controller.fuda_view.should.not.be.nil
      controller.fuda_view.is_a?(FudaView).should.be.true
    end

    it '畳ビューと札ビューのcenterは一致！' do
      controller.fuda_view.center.is_a?(CGPoint).should.be.true
      controller.fuda_view.center.eql?(controller.tatami_view.center).should.be.true
    end


    it 'チャレンジボタンを管理している' do
      controller.challenge_button.should.not.be.nil
      controller.challenge_button.is_a?(UIButton).should.be.true
      controller.challenge_button.frame.size.height.should ==
          InputView::CHALLENGE_BUTTON_HEIGHT
    end

    it 'クリアボタンを管理している' do
      controller.clear_button.should.not.be.nil
      controller.clear_button.is_a?(UIButton).should.be.true
      controller.clear_button.frame.size.height.should == InputView::CLEAR_BUTTON_HEIGHT
    end

=begin

    it 'クリアボタンをタップすると、InputViewの状態が元に戻る' do
      i_view = controller.input_view
      i_view.main_button_pushed(i_view.main_buttons[0])
      i_view.sub_buttons.size.should == 1
      #noinspection RubyArgCount
      tap(controller.clear_button)
      i_view.sub_buttons.empty?.should.be.true
    end
    it '四つのメインボタンの文字が、適切に初期設定されている' do
      initial_strings = controller.supplier.clear.get_4strings
      controller.main_buttons.each_with_index do |button, idx|
        button.currentTitle.should == initial_strings[idx]
      end
    end

=end

    it 'input_viewのmain_4framesを描画領域とするボタンを4つ持つ' do
      controller.main_buttons.tap do |buttons|
        buttons.should.not.be.nil
        buttons.is_a?(ButtonSlot).should.be.true
        buttons.size.should == 4
        buttons.each do |button|
          button.should.not.be.nil
          button.buttonType.should == ExamController::MAIN_BUTTON_TYPE
        end
      end

    end


    it '最初、ボリュームアイコンは隠れている。' do
      controller.volume_view_is_coming_out?.should.be.false
    end

    it 'ボリュームアイコンをタップすると、ボリュームビューが出現する。' do
      #noinspection RubyArgCount
      tap VolumeIcon::A_LABEL
      controller.volume_view_is_coming_out?.should.be.true
    end

    it 'ボリュームビューが出ているときに、クリアボタンをタップすると、ボリュームビューも隠れる' do
      #noinspection RubyArgCount
      tap VolumeIcon::A_LABEL
      controller.volume_view_is_coming_out?.should.be.true
      #noinspection RubyArgCount
      tap InputView::A_LABEL_CLEAR_BUTTON
      controller.volume_view_is_coming_out?.should.be.false
    end

    it 'ボリュームビューが出ているときに、チャレンジボタンをタップすると、ボリュームビューも隠れる' do
      #noinspection RubyArgCount
      tap VolumeIcon::A_LABEL
      controller.volume_view_is_coming_out?.should.be.true
      #noinspection RubyArgCount
      tap InputView::A_LABEL_CHALLENGE_BUTTON
      controller.volume_view_is_coming_out?.should.be.false
    end

  end


=begin
  describe 'あるMainButtonが押されたときの動作' do
    tests ExamController

    before do
      @tap_button = controller.main_buttons[0]
      #noinspection RubyArgCount
      #tap(@tap_button)
    end

    it '押されたボタンをちゃんと把握できている' do
      @tap_button.should.not.be.nil
      #controller.pushed_button.should.not.be.nil
    end

      it '押されたボタンは、サブボタン用スロットへと移る' do
        @input_view.main_buttons.include?(@button).should.be.false
        @input_view.sub_buttons.size == 1
        @input_view.sub_buttons.last == @button
      end

  end
=end



end
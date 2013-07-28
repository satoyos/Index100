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

    it 'クリアボタンを管理している' do
      controller.clear_button.should.not.be.nil
      controller.clear_button.is_a?(UIButton).should.be.true
      controller.clear_button.frame.size.height.should == InputView::CLEAR_BUTTON_HEIGHT
    end

    it 'クリアボタンをタップすると、InputViewの状態が元に戻る' do
      i_view = controller.input_view
      i_view.main_button_pushed(i_view.main_buttons[0])
      i_view.sub_buttons.size.should == 1
      #noinspection RubyArgCount
      tap(controller.clear_button)
      i_view.sub_buttons.empty?.should.be.true
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
      tap InputView::A_LABEL_CELAR_BUTTON
      controller.volume_view_is_coming_out?.should.be.false
    end
  end


end
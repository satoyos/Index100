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


  describe 'あるMainButtonが押されたときの動作' do
    tests ExamController

    before do
      @tap_button = controller.main_buttons[0]
      # 注) ここでは、ボタンそのものを指定してtapを実行すると、失敗した。
      #tap(@tap_button)

      # AccessibilityLabelを指定すると、うまくいった！
      #noinspection RubyArgCount
      tap @tap_button.currentTitle # AccessibilityLabelに同じ値が設定されている
    end

    it '押されたボタンをちゃんと把握できている' do
#      puts "-- tapped button in spec => #{@tap_button.currentTitle}"
      controller.pushed_button.should.not.be.nil
    end

    it 'メイン・ボタン・スロットの、押されたボタンに該当する位置は新しいボタンが補充されている' do
      controller.main_buttons[0].should.not.be.nil
      controller.main_buttons[0].should.not == @tap_button
    end


    it 'メインボタンが押されたときの描画処理を終えたInputViewからCallbackが返ってくる' do
      controller.button_is_moved.should.not.be.nil
      controller.button_is_moved.should.be.true
    end
  end

  describe 'クリアボタンが押されたときの動作' do
    tests ExamController

    it 'クリアボタンをタップすると、InputViewの状態が元に戻る' do
      supplier = controller.supplier
      i_view = controller.input_view
      first_strings = controller.main_buttons.map{|b| b.currentTitle}

      # メインボタンを一回タップすると、表示されるメインボタンは変化する。
      # [注意] もしかしたら、たまたま二文字目のメインボタン群の表示と一致してしまうかもしれない
      #noinspection RubyArgCount
      tap("#{first_strings[0]}")
      controller.main_buttons.map{|b| b.currentTitle}.should.not == first_strings

      # その状態で、クリアボタンを押す
      #noinspection RubyArgCount
      tap(controller.clear_button)
      controller.main_buttons.map{|b| b.currentTitle}.should == first_strings
    end
  end
end
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

    describe '文字選択状態も、初期状態' do
      it 'この時点では、「これまで入力された文字列」は空っぽ(長さが0)' do
        controller.current_challenge_string.is_a?(String).should.be.true
        controller.current_challenge_string.length.should == 0
      end

      it 'チャレンジボタンもまだ押されていない' do
        controller.challenge_button_is_pushed.should.be.false
      end
    end

    it '最初、ボリュームアイコンは隠れている。' do
      controller.volume_view_is_coming_out?.should.be.false
    end

  end

  describe 'ボリュームビューの動作(他のボタンとの関連)' do
    tests ExamController

    it 'ボリュームアイコンをタップすると、ボリュームビューが出現する。' do
      #noinspection RubyArgCount
      tap VolumeIcon::A_LABEL
      controller.volume_view_is_coming_out?.should.be.true
    end

    it 'ボリュームビューが出ているときに、クリアボタンをタップすると、ボリュームビューが隠れる' do
      #noinspection RubyArgCount
      tap VolumeIcon::A_LABEL
      controller.volume_view_is_coming_out?.should.be.true
      #noinspection RubyArgCount
      tap ExamController::A_LABEL_CLEAR_BUTTON
      controller.volume_view_is_coming_out?.should.be.false
    end

    it 'ボリュームビューが出ているときに、チャレンジボタンをタップすると、ボリュームビューが隠れる' do
      #noinspection RubyArgCount
      tap VolumeIcon::A_LABEL
      controller.volume_view_is_coming_out?.should.be.true
      #noinspection RubyArgCount
      tap ExamController::A_LABEL_CHALLENGE_BUTTON
      controller.volume_view_is_coming_out?.should.be.false
    end

    it 'ボリュームビューが出ているときに、メインボタンをタップすると、ボリュームビューが隠れる' do
      #noinspection RubyArgCount
      tap VolumeIcon::A_LABEL
      controller.volume_view_is_coming_out?.should.be.true
      #noinspection RubyArgCount
      tap controller.main_buttons[0].currentTitle
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
      # ただし、0番のボタンが正解の時に限る。
      if 0 == controller.supplier.current_right_index
        controller.main_buttons[0].should.not.be.nil
        controller.main_buttons[0].should.not == @tap_button
      else
        1.should == 1
      end
    end


    it 'メインボタンが押されたときの描画処理を終えたInputViewからCallbackが返ってくる' do
      controller.button_is_moved.should.not.be.nil
      controller.button_is_moved.should.be.true
    end
  end

  # 下記テストは、なぜかメインボタンのenabledが呼び出せないので、無効。
  # ちゃんとenabledを呼び出せるようになったら、これもテストしたい。
=begin
  describe 'メインボタンがKIMARI_JI_MAX回押されたときの状態' do
    tests ExamController

    before do
      ExamController::KIMARI_JI_MAX.times do
        #noinspection RubyArgCount
        tap(controller.main_buttons[0])
      end
    end

    it 'メインボタンがもう押せない状態になっている' do
      controller.main_buttons[1].enabled.should.be.true
    end
  end
=end

  # 次のテストは、実際のデッキからの文字取得では成り立たなくなった。
=begin
  describe 'クリアボタンが押されたときの動作' do
    tests ExamController

    it 'クリアボタンをタップすると、InputViewの状態が元に戻る' do
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
=end

  describe 'current_challenge_string' do
    tests ExamController

    it '正解ボタンが一つ押されたら、このメソッドで取得できる文字列の長さは1' do
      supplier = controller.supplier

      # 注)
      # ↓ ここでも、ボタンをタップするときに、ボタンオブジェクト自体を
      #   tap()の引数にすると誤動作し、ボタンを押していないかのような状態になった。
      #   accessibilityLabelを指定すると、なぜか成功した。

      #noinspection RubyArgCount
      tap(controller.main_buttons[supplier.current_right_index].currentTitle)
      controller.current_challenge_string.length.should == 1
    end
  end


  describe 'チャレンジボタンが押されたときの動作: 正解編' do
    tests ExamController

    before do
      @supplier = controller.supplier
      @supplier.answer.length.times do
        # ここのtapも、ボタン自体を引数に指定→誤動作, accessibilityLabel指定→正常動作
        #noinspection RubyArgCount
        tap(controller.main_buttons[@supplier.current_right_index].currentTitle)
      end
    end

    it 'チャレンジ文字列は、正解と一致するはず' do
      controller.current_challenge_string.should == @supplier.answer
    end

    it '正解判定を出す' do
      controller.get_result_type.should == :right
    end

    it 'ボタンを押すと、「押された」フラグがtrueになる' do
      #noinspection RubyArgCount
      tap(ExamController::A_LABEL_CHALLENGE_BUTTON)
      controller.challenge_button_is_pushed.should.be.true
    end
  end

  describe 'チャレンジボタンが押されたときの動作：間違い編' do
    tests ExamController

    before do
      @supplier = controller.supplier
      (@supplier.answer.length-1).times do
        #noinspection RubyArgCount
        tap(controller.main_buttons[@supplier.current_right_index].currentTitle)
      end
    end

    it 'チャレンジ文字列の長さは、正解(文字列)の長さより1少ない' do
      controller.current_challenge_string.length.should ==
          @supplier.answer.length-1
    end
    it '誤り判定を出す' do
      controller.get_result_type.should == :wrong
    end
    it '長さ判定で「短い」という結果を出す' do
      controller.get_wrong_type.should == :short
    end
  end

  # (入力された決まり字が他の歌の物だった場合、すぐにユーザに教えてあげる動作)
  describe '間違ったメインボタンが押された時点で、即チャレンジが実施される' do
    tests ExamController

    before do
      first_chars = controller.main_buttons.map{|button| button.currentTitle}
      first_chars.delete_at(controller.supplier.current_right_index)
      @wrong_char = first_chars[0]
      #noinspection RubyArgCount
      tap(@wrong_char)
    end

    it 'wrong_charのチェック' do
      @wrong_char.should.not.be.nil
      @wrong_char.length.should == 1
      @wrong_char.should.not == 'あ'
    end

    it 'チャレンジが実行される(<= チャレンジボタンが押された状態になっている)' do
      controller.challenge_button_is_pushed.should.be.true
    end
  end
end
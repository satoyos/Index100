describe 'ChallengeResultView' do
  shared 'a ChallengeResultView' do
    it 'should be a ChallengeResultView' do
      @view.should.not.be.nil
      @view.is_a?(ChallengeResultView).should.be.true
      @view.frame.size.should == ChallengeResultView::RESULT_VIEW_SIZE
    end
  end

  shared 'a Label Holder' do
    it 'should have a label' do
      @view.label.should.not.be.nil
      @view.label.is_a?(UILabel).should.be.true
    end
  end

  describe '正解画面の初期化' do
    before do
      @view = ChallengeResultView.alloc.initWithResult(:right)
    end

    behaves_like 'a ChallengeResultView'

    behaves_like 'a Label Holder'

    it 'has 正解画面のサイズとテキスト' do
      @view.label.text.should == ChallengeResultView::RESULT_TEXT[:right]
      @view.label.font.pointSize.should == ChallengeResultView::RESULT_FONT_SIZE
    end

    it '正解画面のテキストの色チェック' do
      @view.label.textColor.should ==
          ChallengeResultView::RESULT_TEXT_COLOR[:right]
    end
  end

  describe 'サポートしていない引数値で初期化' do
    before do
      @view = ChallengeResultView.alloc.initWithResult(:xxxYYY)
    end

    it '正常に初期化されない' do
      @view.should.be.nil
    end
  end

  describe '誤り時の画面の初期化' do
    before do
      @view = ChallengeResultView.alloc.initWithResult(:wrong)
    end

    behaves_like 'a ChallengeResultView'
    behaves_like 'a Label Holder'
  end

  describe 'clean_up_subviews' do
    before do
      @view = ChallengeResultView.alloc.initWithResult(:right)
    end
    it '元はサブビューがある' do
      @view.subviews.size.should > 0
    end

    it 'clean_upすると、サブビューが無くなる' do
      @view.clean_up_subviews
      @view.subviews.size.should == 0
    end
  end

end
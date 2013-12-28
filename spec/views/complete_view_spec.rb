describe 'CompleteView' do
  describe '初期化' do
    before do
      @c_view = CompleteView.alloc.initWithFrame([[0, 0], [100, 100]],
                                                 controller: nil)
    end
    it 'should not be nil' do
      @c_view.should.not.be.nil
    end
    it 'accessibilityLabelが設定されている' do
      @c_view.accessibilityLabel.should == CompleteView::A_LABEL_COMPLETE_VIEW
      @c_view.msg_label.accessibilityLabel.should ==
          CompleteView::A_LABEL_MESSAGE_LABEL
      @c_view.return_button.accessibilityLabel.should ==
          CompleteView::A_LABEL_RETURN_BUTTON
    end
  end


end
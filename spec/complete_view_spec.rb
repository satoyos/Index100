describe 'CompleteView' do
  describe '初期化' do
    before do
      @c_view = CompleteView.alloc.initWithFrame([[0, 0], [100, 100]],
                                                 controller: nil)
    end
    it 'should not be nil' do
      @c_view.should.not.be.nil
    end
  end


end
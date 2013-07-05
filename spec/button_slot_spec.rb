describe 'ButtonSlot' do
  describe '初期化' do
    before do
      @button_slot = ButtonSlot.new(4)
    end

    it 'should not be nil' do
      @button_slot.should.not.be.nil
    end

    it 'should have limit_size' do
      @button_slot.limit_size.should.not.be.nil
    end
  end

  describe 'add' do
    #ToDo: limit_sizeで要素の追加を打ち切ることができる追加メソッド"add"を作ろう！
  end

end
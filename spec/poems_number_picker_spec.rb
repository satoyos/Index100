describe 'PoemsNumberPicker' do
  describe '初期化' do
    tests PoemsNumberPicker

    it 'should not be nil' do
      controller.should.not.be.nil
    end

    it 'タイトルが設定されている' do
      controller.title.should.not.be.nil
    end
  end
end
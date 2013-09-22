describe 'MainButtonSoundPicker' do
  describe '初期化' do
    tests MainButtonSoundPicker

    it 'should not be nil' do
      controller.should.not.be.nil
    end

    it 'タイトルが設定されている' do
      controller.title.should.not.be.nil
    end
  end

  describe 'クラスメソッド: button_sound_id' do
    before do
      @button_sound_id = MainButtonSoundPicker.button_sound_id
    end
    it 'should not be nil' do
      @button_sound_id.should.not.be.nil
    end

    it '戻り値に対応するAudioPlayerがある' do
      AudioPlayerFactory.players[@button_sound_id].should.not.be.nil
    end
  end
end
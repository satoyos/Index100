describe 'AudioPlayerFactory' do
  VALID_BASENAME   = 'audio/0000_正解です！'
  INVALID_BASENAME = 'audio/120'
  AUDIO_TYPE = 'm4a'

  shared 'creator of playable AVAudioPlayer' do
    it 'should create non-nil-object' do
      @reader.should.not.be.nil
    end
    it 'should create a playable AVAudioPlayer' do
      @reader.is_a?(AVAudioPlayer).should.be.true
      @reader.play.should.be.true
    end
  end
  describe 'create reader by valid file path' do
    before do
      @reader = AudioPlayerFactory.create_player_by_path(VALID_BASENAME, ofType: AUDIO_TYPE)
    end

    behaves_like 'creator of playable AVAudioPlayer'
  end
  describe 'create reader by invalid file path' do
    it 'should raise RuntimeError' do
      should.raise(RuntimeError){AudioPlayerFactory.create_player_by_path(INVALID_BASENAME, ofType: AUDIO_TYPE)}
    end
  end
end
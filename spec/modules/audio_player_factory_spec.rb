# -*- coding: utf-8 -*-

describe 'AudioPlayerFactory' do
  VALID_BASENAME   = 'audio/voice/0000_正解です！'
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
      should.raise{AudioPlayerFactory.create_player_by_path(INVALID_BASENAME, ofType: AUDIO_TYPE)}
    end
  end

  describe 'クラスで用意されたplayerへのアクセス' do
    before do
      AudioPlayerFactory.prepare_embedded_players
      @players = AudioPlayerFactory.players
    end
    it 'AudioPlayerFactory class has a member "players"' do
      @players.should.not.be.nil
    end
    it 'all voice player can be played' do
      AudioPlayerFactory::VOICE_AUDIO_PATH.keys.each do |key|
        @players[key].play.should.be.true
      end
    end
    it 'all button player can be played' do
      ButtonSound.sounds.each do |sound|
        @players[sound.id].play.should.be.true
      end
    end
  end
end
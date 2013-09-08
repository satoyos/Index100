class AudioPlayerFactory
  BASENAME_OF_SORRY = 'audio/not_recorded_yet'
  VOICE_AUDIO_PATH = {
      right: 'audio/voice/0000_正解です！',
      wrong: 'audio/voice/0002_違います！',
      test:  'audio/voice/0004_ボリューム調整用音声',
      short: 'audio/voice/1003_まだ決まりません',
      long:  'audio/voice/1004_長すぎます'
  }

  BUTTON_AUDIO_PATH = {
      button1: 'audio/button/button1',
      button2: 'audio/button/button2',
      button3: 'audio/button/button3',
      button4: 'audio/button/button4',
      button5: 'audio/button/button5',
      button6: 'audio/button/button6',
      button7: 'audio/button/button7',
      button8: 'audio/button/button8',
      button9: 'audio/button/button9',
      button10: 'audio/button/button10',
  }

  class << self
    attr_reader :players

    def prepare_embedded_players
      @players = {}
      VOICE_AUDIO_PATH.each do |key, path|
        @players[key] = create_player_by_path(path, ofType: 'm4a')
      end
      BUTTON_AUDIO_PATH.each do |key, path|
        @players[key] = create_player_by_path(path, ofType: 'wav')
      end
    end

    def set_volume(val)
      @players.values.each do |player|
        player.volume = val
      end
    end

    def rewind_to_start_point
      @players.values.each do |player|
        player.currentTime = 0.0
      end
    end

    def create_player_by_path(basename, ofType: type)
      url = NSURL.fileURLWithPath(bundle_by_basename(basename, ofType: type))
      er = Pointer.new(:object)
      AVAudioPlayer.alloc.initWithContentsOfURL(url, error: er)
    end

    def bundle_by_basename(basename, ofType: type)
      unless (bundle = NSBundle.mainBundle.pathForResource(basename, ofType: type))
        bundle = NSBundle.mainBundle.pathForResource(BASENAME_OF_SORRY, ofType: type)
      end
      bundle
    end
  end
end
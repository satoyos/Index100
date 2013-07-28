class AudioPlayerFactory
  BASENAME_OF_SORRY = 'audio/not_recorded_yet'
  AUDIO_PATH = {
      right: 'audio/0000_正解です！',
      wrong: 'audio/0002_違います！',
      test:  'audio/0003_序歌朗読'
  }

  class << self
    attr_reader :players

    def prepare_embedded_players
      @players = {}
      AUDIO_PATH.each do |key, path|
        @players[key] = create_player_by_path(path, ofType: 'm4a')
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
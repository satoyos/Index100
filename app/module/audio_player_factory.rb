module AudioPlayerFactory
  BASENAME_OF_SORRY = 'audio/voice/0200_not_recorded_yet'
  VOICE_AUDIO_PATH = {
      right: 'audio/voice/0000_正解です！',
      wrong: 'audio/voice/0002_違います！',
      test:  'audio/voice/0004_ボリューム調整用音声',
      short: 'audio/voice/1003_まだ決まりません',
      long:  'audio/voice/1004_長すぎます'
  }


  module_function

  def players
    @players
  end

  def prepare_embedded_players
    @players = {}
    VOICE_AUDIO_PATH.each do |key, path|
      @players[key] = create_player_by_path(path, ofType: 'm4a')
    end
    buttons_sounds = ButtonSound.sounds
    buttons_sounds.each do |b_sound|
      @players[b_sound.id] = create_player_by_path(b_sound.path,
                                                   ofType: b_sound.type)
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
    audio_session = AVAudioSession.sharedInstance
    audio_session.setActive(true, error: nil)
    audio_session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)

    url = NSURL.fileURLWithPath(bundle_by_basename(basename, ofType: type))
    er = Pointer.new(:object)
    AVAudioPlayer.alloc.initWithContentsOfURL(url, error: er)
  end

  :private

  def bundle_by_basename(basename, ofType: type)
    unless (bundle = NSBundle.mainBundle.pathForResource(basename, ofType: type))
#      bundle = NSBundle.mainBundle.pathForResource(BASENAME_OF_SORRY, ofType: 'm4a')
       raise "Invalid Audio File Path [#{basename}.#{type}]"
    end
    bundle
  end
end

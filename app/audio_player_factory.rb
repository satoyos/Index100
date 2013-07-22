class AudioPlayerFactory
  BASENAME_OF_SORRY = 'audio/not_recorded_yet'

  class << self
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
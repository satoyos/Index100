class ButtonSound

  JSON_FILE = 'button_sounds.json'

  PROPERTIES = [:id, :path, :type, :label]
  PROPERTIES.each do |prop|
    attr_accessor prop
  end

  class << self
    attr_reader :sounds

    def create_sounds
      @sounds = JSONParser.parse_from_file(JSON_FILE).map{|sounds_hash|
        ButtonSound.new(sounds_hash)}
    end
  end

  def initialize(attributes = {})
    attributes.each do  |key, value|
      set_value = case key
                    when 'id' ; value.to_sym
                    else value
                  end
      self.send("#{key}=", set_value) if PROPERTIES.member? key.to_sym
    end

  end


end
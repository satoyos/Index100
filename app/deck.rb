class Deck
  PROPERTIES = [:poems]
  PROPERTIES.each do |prop|
    attr_accessor prop
  end

  JSON_FILE = '100.json'

  def initialize
    read_poems
  end

  def read_poems
    self.poems=[]
    JSONParser.parse_from_file(JSON_FILE).each do |poem_hash|
      self.poems << Poem.new(poem_hash)
    end
  end
end
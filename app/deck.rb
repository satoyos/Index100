class Deck
#  PROPERTIES = [:poems, :counter, :poems100]
  PROPERTIES = [:poems, :counter]
  PROPERTIES.each do |prop|
    attr_accessor prop
  end

  JSON_FILE = '100.json'

  class << self
    def original_deck
      @original_deck ||= self.new
    end
  end

  def initialize
    read_poems
    @counter = 0
  end

  def read_poems
    @poems = []
    JSONParser.parse_from_file(JSON_FILE).each do |poem_hash|
      @poems << Poem.new(poem_hash)
    end
  end

  def next_poem
    if @counter == @poems.size
      return nil
    end
    poem = @poems[@counter]
    @counter += 1
    poem
  end

  def size
    @poems.size
  end

  def shuffle_with_size(new_size)
    return nil if new_size > self.size
    @poems = @poems.shuffle[0..new_size-1]
    self
  end

end
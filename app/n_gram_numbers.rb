class NGramNumbers

  FIRST_CHARS = {
      mu:  'む', su:  'す', me:  'め', fu:  'ふ', sa:  'さ', ho:  'ほ', se:  'せ',
      u:   'う', tsu: 'つ', shi: 'し', mo:  'も', yu:  'ゆ',
      i:   'い', chi: 'ち', hi:  'ひ', ki:  'き',
      ha:  'は', ya:  'や', yo:  'よ', ka:  'か',
      mi:  'み',
      ta:  'た', ko:  'こ',
      o:   'お', wa:  'わ',
      na:  'な',
      a:   'あ'
  }

  class << self
    def of(char_sym)
      @numbers ||= NGramNumbers.new
      @numbers.list[char_sym]
    end
  end

  attr_reader :poems, :list

  def initialize
    @poems = Deck.original_poems
    @list = list_of_first_chars()
  end

  :private

  def list_of_first_chars
    list = {}
    FIRST_CHARS.each do |key, value|
      list[key] = @poems.select{|poem| poem.kimari_ji[0] == value}.map{|poem| poem.number}
    end
    list
  end
end
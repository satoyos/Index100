class CharSupplier
  PROPERTIES = [:deck, :counter]
  PROPERTIES.each do |prop|
    attr_reader prop
  end

  def initialize(init_hash)
    @deck = init_hash[:deck]
    @counter = 0
  end

  TEST_ARRAY = [
      ['A1', 'A2', 'あ', 'A4'],
      ['ら', 'B2', 'B3', 'B4'],
      ['C1', 'C2', 'C3', 'し'],
      ['D1', 'D2', 'ふ', 'D4'],
      ['E1', 'く', 'E3', 'E4'],
      ['F1', 'F2', 'み', 'F4']
  ]

  def get_4strings
    strings = TEST_ARRAY[@counter]
    @counter += 1
    strings
  end
  
  def clear
    @counter = 0
  end
end
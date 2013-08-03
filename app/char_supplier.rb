class CharSupplier
  PROPERTIES = [:deck, :counter, :answer]
  PROPERTIES.each do |prop|
    attr_reader prop
  end

  COUNTER_MAX = 6

  def initialize(init_hash)
    @deck = init_hash[:deck]
    @counter = 0

    ## テスト実装
    @answer = TEST_ANSWER
  end

  TEST_ARRAY = [
      ['A1', 'A2', 'あ', 'A4'],
      ['ら', 'B2', 'B3', 'B4'],
      ['C1', 'C2', 'C3', 'し'],
      ['D1', 'D2', 'ふ', 'D4'],
      ['E1', 'く', 'E3', 'E4'],
      ['F1', 'F2', 'み', 'F4']
  ]

  TEST_ANSWER = 'あらし'

  def get_4strings
    return nil if @counter == COUNTER_MAX
    strings = TEST_ARRAY[@counter]
    @counter += 1
    strings
  end
  
  def clear
    @counter = 0
    self
  end

  def test_challenge_string(str)
    str == TEST_ANSWER
  end

  def current_right_index
    if @counter == 0
      return nil
    end

    TEST_ARRAY[@counter-1].find_index(TEST_ANSWER[@counter-1])
  end
end
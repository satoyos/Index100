class CharSupplier
  PROPERTIES = [:deck, :current_poem, :counter, :answer]
  PROPERTIES.each do |prop|
    attr_reader prop
  end

  NUM_TO_SUPPLY = 4
  COUNTER_MAX   = 6

  def initialize(init_hash)
    @deck = init_hash[:deck]
    @current_poem = @deck.next_poem
    @counter = 0

    ## テスト実装
    @answer = TEST_ANSWER
  end

  def draw_next_poem
    case @current_poem = @deck.next_poem
      when nil; nil
      else    ; self
    end
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
    # 境界条件
    if @counter == 0 || @counter > @answer.length
      return nil
    end

    TEST_ARRAY[@counter-1].find_index(TEST_ANSWER[@counter-1])
  end

  def make_4strings_at(count)
    right_char = @current_poem.kimari_ji[count]
    all_candidates = char_candidate_at(count)
    all_candidates.delete(right_char)
    # 先頭に正解文字、その後ろは候補文字がシャッフルされた配列を作る
    shuffled_candidates = all_candidates.shuffle.unshift(right_char)
    # 先頭からNUM_TO_SUPPLY個を取得し、シャッフルして戻り値とする。
    shuffled_candidates[0..NUM_TO_SUPPLY-1].shuffle
#    ['か', 'い', right_char, 'す']
  end

  def char_candidate_at(count)
    @deck.poems.map{|poem|
      case count+1 <= poem.kimari_ji.length
        when true; poem.kimari_ji[count]
        else     ; poem.in_hiragana.kami[count]
      end
    }.uniq
  end

end
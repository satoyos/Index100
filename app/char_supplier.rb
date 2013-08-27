class CharSupplier
  PROPERTIES = [:deck, :current_poem, :counter, :difficulty, :mode,
                :supplying_strings]
  PROPERTIES.each do |prop|
    attr_reader prop
  end

  NUM_TO_SUPPLY = 4
  COUNTER_MAX   = 6

  DIFFICULTIES = [:easy, :normal]
  LENGTH_TYPES = [:short, :just, :long]

  TEST_MODE1 = :test_mode1

  def initialize(init_hash)
    @deck = init_hash[:deck]
    @current_poem = @deck.next_poem
    @counter = 0
    @supplying_strings = nil
    @mode = init_hash[:mode]

    # まずは、難易度はeasyモードのみ用意。
    @difficulty = :easy

    ## テスト実装
  end

  def answer
    case @mode
      when TEST_MODE1; TEST_ANSWER
      else           ; @current_poem.kimari_ji
    end
  end

  def draw_next_poem
    case @current_poem = @deck.next_poem
      when nil; nil
      else    ; self.clear
    end
  end

  TEST_ARRAY = [
      ['A1', 'A2', 'あ', 'A4'],
      ['ら', 'B2', 'B3', nil],
      ['C1', 'C2', 'C3', 'し'],
      ['D1', 'D2', 'ふ', 'D4'],
      ['E1', 'く', 'E3', 'E4'],
      ['F1', 'F2', 'み', 'F4']
  ]

  TEST_ANSWER = 'あらし'



  def get_4strings
    return nil if @counter == COUNTER_MAX
#    strings = TEST_ARRAY[@counter]
    strings = case @mode
                when TEST_MODE1; TEST_ARRAY[@counter]
                else           ; make_4strings_at(@counter)
              end
    @counter += 1
    @supplying_strings = strings
  end
  
  def clear
    @counter = 0
    @supplying_strings = nil
    self
  end

  def test_challenge_string(str)
    str == self.answer
  end

  def length_check(challenge_str)
    case challenge_str.length - self.answer.length
      when 1..5 ; :long
      when 0    ; :just
      else      ; :short
    end
  end

  def on_the_correct_line?(partial_challenge_str)
    regexp = Regexp.new("^#{partial_challenge_str}")
    line_string = @current_poem.kimari_ji +
        @current_poem.in_hiragana.kami[@current_poem.kimari_ji.length..5]
#    puts "regexp => #{regexp}"
#    puts "line_string => #{line_string}"
    (regexp =~ line_string) == 0 # 0文字目からマッチする、という意味
  end

  # 与えられた歌番号の歌をcurrent_poemに設定して、その歌(Poem)を返す
  # 現在のデッキにその歌が無い場合には、nilを返す
  def set_current_poem_to_number(poem_number)
    @current_poem = @deck.poems.find{|poem| poem.number == poem_number}
  end

  def current_right_index
    # 境界条件
    if @counter == 0 || @counter > answer.length
      return nil
    end
    case @mode
      when TEST_MODE1; TEST_ARRAY[@counter-1].find_index(TEST_ANSWER[@counter-1])
      else           ; @supplying_strings.find_index(self.answer[@counter-1])
    end

  end

  def make_4strings_at(count)
    if count >= @current_poem.kimari_ji.length
      return [@current_poem.in_hiragana.kami[count], nil, nil, nil]
    end
    shuffled_candidates = shuffled_candidates_at(count)
    # 先頭からNUM_TO_SUPPLY個を取得し、シャッフルして戻り値とする。
    shuffled_candidates[0..NUM_TO_SUPPLY-1].shuffle.fill(
        nil,
        shuffled_candidates.length..NUM_TO_SUPPLY-1
    )
  end

  #count番目(1文字目はcount=0)の候補となる文字群を、正解文字を先頭にして返す。
  #ただし、洗脳の正解文字以外はシャッフルする
  def shuffled_candidates_at(count)
    all_candidates = char_candidates_at(count)
    all_candidates.delete(right_char_at(count))
    # 先頭に正解文字、その後ろは候補文字がシャッフルされた配列を作る
    all_candidates.shuffle.unshift(right_char_at(count))
  end

  def right_char_at(count)
    right_char = @current_poem.kimari_ji[count]
  end

  def char_candidates_at(nth)
    case nth
      when 0 #一文字目
        @deck.poems.map{|poem|
          case nth+1 <= poem.kimari_ji.length
            when true; poem.kimari_ji[nth]
            else     ; poem.in_hiragana.kami[nth]
          end
        }.uniq
      else  #二文字目以降
        easy_candidates_at(nth)
    end
  end

  def easy_candidates_at(nth)
    regexp = Regexp.new("^#{current_selected(nth)}")
#    puts "regexp => #{regexp}"
    @deck.poems.select{|poem|
      poem.kimari_ji =~ regexp
    }.map{|poem|
      poem.kimari_ji[nth]
    }.uniq
  end

  def current_selected(when_supplying_nth)
    case when_supplying_nth
      when 0 ; ''
      else   ; @current_poem.kimari_ji[0..when_supplying_nth-1]
    end
  end

end
class CharSupplier
  PROPERTIES = [:deck, :current_poem, :counter, :difficulty,
                :supplying_strings]
  PROPERTIES.each do |prop|
    attr_reader prop
  end

  NUM_TO_SUPPLY = 4
  COUNTER_MAX   = 6

  DIFFICULTIES = [:easy, :normal]
  LENGTH_TYPES = [:short, :just, :long]

  def initialize(init_hash)
    @deck = init_hash[:deck]
    @current_poem = @deck.next_poem
    @counter = 0
    @supplying_strings = nil
    @mode = init_hash[:mode]

    # まずは、難易度はeasyモードのみ用意。
    @difficulty = :easy

  end

  def answer
    @current_poem.kimari_ji
  end

  def draw_next_poem
    case @current_poem = @deck.next_poem
      when nil; nil
      else    ; self.clear
    end
  end

  def get_4strings
    return nil if @counter == COUNTER_MAX
    @supplying_strings = make_4strings_at(@counter)
    @counter += 1
    @supplying_strings
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

  def on_the_correct_line?(partial_str)
    regexp = Regexp.new("^#{partial_str}")
    line_string = @current_poem.kimari_ji +
        @current_poem.in_hiragana.kami[@current_poem.kimari_ji.length..5]
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
    @supplying_strings.find_index(self.answer[@counter-1])
  end

  def make_4strings_at(count)
    if count >= @current_poem.kimari_ji.length
      return [@current_poem.in_hiragana.kami[count], nil, nil, nil]
    end
    shuffled_candidates = shuffled_candidates_at(count)
    shuffled_candidates[0..NUM_TO_SUPPLY-1].sort.fill(
        nil,
        shuffled_candidates.length..NUM_TO_SUPPLY-1
    )
  end

  #count番目(1文字目はcount=0)の候補となる文字群を、正解文字を先頭にして返す。
  #ただし、先頭の正解文字以外はシャッフルする
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
        Deck.original_deck.poems.map{|poem|
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
    Deck.original_deck.poems.select{|poem|
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

  def deck_size
    @deck.size
  end

  def poem_counter
    @deck.counter
  end

end
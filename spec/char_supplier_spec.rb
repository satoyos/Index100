describe 'CharSupplier' do
  shared 'a CharSupplier' do
    it 'should not be nil' do
      @supplier.should.not.be.nil
    end
    it 'should be a instance of CharSupplier' do
      @supplier.is_a?(CharSupplier).should.be.true
    end
  end

  FIRST_CHARS = %w(む す め ふ さ ほ せ う つ し も ゆ い ち ひ き は や よ か み た こ お わ な あ)
  CHARS_NEXT_TO_A = %w(わ ら き ま り さ し い け)

  describe 'first_chars' do
    it 'ひらがなの中で、歌の一文字目(=決まり字の一文字目)になりうる字は27文字' do
      FIRST_CHARS.size.should == 27
    end
  end

  describe 'initialize' do
    before do
      @supplier = CharSupplier.new({deck: Deck.new})
    end
    behaves_like 'a CharSupplier'

    it 'has a deck' do
      @supplier.deck.should.not.be.nil
      @supplier.deck.is_a?(Deck).should.be.true
    end

    it 'current_poemには最初の歌がセットされている' do
      @supplier.current_poem.should.not.be.nil
      # シャッフルも選別もされていないので、#1の歌が入っている
      @supplier.current_poem.number.should == 1
    end

    it 'has an answer' do
      @supplier.answer.should.not.be.nil
      @supplier.answer.is_a?(String).should.be.true
    end

    it '難易度が設定されていて、予め定められているもののいずれかである' do
      @supplier.difficulty.should.not.be.nil
      CharSupplier::DIFFICULTIES.include?(@supplier.difficulty).should.be.true
    end
  end

  describe 'draw_next_poem' do
    before do
      @supplier = CharSupplier.new({deck: Deck.new})
    end

    it '次の歌をDeckから読み込む (シャッフルも選別もしていないので、#2の歌になる)' do
      @supplier.draw_next_poem.should == @supplier
      @supplier.current_poem.number.should == 2
    end

    it '100首のDeckだと、さらに99首を読み込んでも大丈夫だが、その次はnilになる' do
      (@supplier.deck.size-1).times {@supplier.draw_next_poem}
      @supplier.current_poem.is_a?(Poem).should.be.true
      @supplier.draw_next_poem.should.be.nil
    end

  end

  describe 'make_4strings_at' do
    before do
      @supplier = CharSupplier.new({deck: Deck.new})
    end

    it '#1の札の一文字目を含む4つの文字を返す' do
      @supplier.make_4strings_at(0).tap do |first_strings|
        first_strings.should.not.be.nil
        first_strings.is_a?(Array).should.be.true
        first_strings.size.should == CharSupplier::NUM_TO_SUPPLY
        first_strings.include?(@supplier.current_poem.kimari_ji[0]).should.be.true
      end
    end

    it 'ちゃんと毎度ランダムな文字群を返す(二回このメソッドを読んだら違う配列を返す)' do
      #低い確率で本テストは失敗してしまう可能性があります。
      @supplier.make_4strings_at(0).should.not == @supplier.make_4strings_at(0)
    end

    #%Todo: 続きは、このテストを通すところから！
=begin
    it '歌#1の2文字目候補群は、「あ」で始まる歌の二文字目の中から四つ選んだもので、「き」を含む' do
      @supplier.make_4strings_at(1).tap do |second_strings|
        second_strings.should.not.be.nil
        second_strings.size.should == CharSupplier::NUM_TO_SUPPLY
        second_strings.include?(@supplier.current_poem.kimari_ji[1]).should.be.true
        (second_strings & CHARS_NEXT_TO_A).size.should == CharSupplier::NUM_TO_SUPPLY
      end
    end
=end
  end

  describe 'char_candidate_at' do
    before do
      @supplier = CharSupplier.new({deck: Deck.new})
    end

    it '選別していないDeckの一文字目の候補字群は、27文字' do
      @supplier.char_candidates_at(0).size.should == FIRST_CHARS.size
#      puts "一文字目候補 => #{@supplier.char_candidate_at(0)}"
    end

    it '#1の歌の二文字目候補字群は、CHARS_NEXT_TO_Aの文字群と一致する' do
#      puts "「あ」に続く二文字目候補字群 => #{@supplier.char_candidates_at(1)}"
      @supplier.char_candidates_at(1).tap do |second_strings|
        second_strings.size.should == CHARS_NEXT_TO_A.size
        second_strings.sort.should == CHARS_NEXT_TO_A.sort
      end

    end

  end

  describe 'current_selected' do
    before do
      @supplier = CharSupplier.new({deck: Deck.new})
    end

    it '1文字目の候補文字群を供給するときには、空文字列を返す' do
      @supplier.current_selected(0).length.should == 0
    end

    it '2文字目の候補文字群を供給するときには、決まり字の1文字目を返す' do
      @supplier.current_selected(1).length.should == 1
      @supplier.current_selected(1).should == @supplier.current_poem.kimari_ji[0]
    end

    it '3文字目の候補文字群を供給するときには、決まり字の冒頭2文字を返す' do
      @supplier.current_selected(2).length.should == 2
      @supplier.current_selected(2).should == @supplier.current_poem.kimari_ji[0..1]
    end
  end

  describe 'get_4strings' do
    before do
      @supplier = CharSupplier.new({deck: Deck.new})
    end

    it 'return 4 strings determined by called order' do
      first = @supplier.get_4strings
      first.should.not.be.nil
      first.is_a?(Array).should.be.true
      first[2].should == 'あ'
      second = @supplier.get_4strings
      second[0].should == 'ら'
      third = @supplier.get_4strings
      forth = @supplier.get_4strings
      fifth = @supplier.get_4strings
      sixth = @supplier.get_4strings
      sixth[2] == 'み'
      @supplier.get_4strings.should.be.nil
      @supplier.counter.should == 6


    end
  end

  describe 'test_challenge_string' do
    before do
      @supplier = CharSupplier.new({deck: Deck.new})
    end

    it '正しい文字列でのチャレンジ時はtrueを返す' do
      @supplier.test_challenge_string('あらし').should.be.true
    end

    it '間違った文字列でのチャレンジ時は、falseを返す' do
      @supplier.test_challenge_string('あっちょんぶりけ').should.be.false
    end
  end

  describe 'answer' do
    before do
      @supplier = CharSupplier.new({deck: Deck.new})
    end

    it 'この歌の決まり字を返す' do
      @supplier.answer.should.not.be.nil
      @supplier.answer.length.should > 0
    end
  end

  describe 'current_right_index' do
    before do
      @supplier = CharSupplier.new({deck: Deck.new})
    end

    it 'まだ文字列を供給していない場合には、nilを返す' do
      @supplier.current_right_index.should.be.nil
    end

    it '1回供給したら、最初に渡した文字列群の中で正しいもののindexを返す' do
      strings = @supplier.get_4strings
      @supplier.current_right_index.tap do |idx|
        idx.should.not.be.nil
        idx.is_a?(Fixnum).should.be.true
        strings[idx].should == @supplier.answer[0]
      end
    end

    it '2回供給しても、やっぱり正しいもののindexを返す' do
      if @supplier.answer.length == 1
        1.should == 1
      else
        strings1 = @supplier.get_4strings #1回目
        strings2 = @supplier.get_4strings #2回目
        @supplier.current_right_index.tap do |idx|
          idx.is_a?(Fixnum).should.be.true
          strings2[idx].should == @supplier.answer[1]
        end
      end
    end

    it 'テスト実装では正解は「あらし」固定なので、4回供給した後はnilを返す' do
      strings1 = @supplier.get_4strings #1回目
      strings2 = @supplier.get_4strings #2回目
      strings3 = @supplier.get_4strings #3回目
      strings4 = @supplier.get_4strings #4回目
      @supplier.current_right_index.should.be.nil
    end
  end

end
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

    it '歌#1の2文字目候補群は、「あ」で始まる歌の二文字目の中から四つ選んだもので、「き」を含む' do
      @supplier.make_4strings_at(1).tap do |second_strings|
        second_strings.should.not.be.nil
        second_strings.size.should == CharSupplier::NUM_TO_SUPPLY
        second_strings.include?(@supplier.current_poem.kimari_ji[1]).should.be.true
        (second_strings & CHARS_NEXT_TO_A).size.should == CharSupplier::NUM_TO_SUPPLY
      end
    end

    describe '歌#1の3文字目候補群は、「か」と「の」と二つのnilから構成される' do
      before do
        @third_strings =  @supplier.make_4strings_at(2)
      end

      it '3文字目の正解文字は「の」' do
        @supplier.right_char_at(2).should == 'の'
      end

      it '「あき」に続きうる文字は「か」と「の」' do
        @supplier.char_candidates_at(2).sort.should == ['か', 'の']
      end

      it '正解文字を先頭にしてあとはシャッフルした配列も、やはり「か」と「の」からなる配列' do
        @supplier.shuffled_candidates_at(2).sort.should == ['か', 'の']
      end

      it '大きさ4の配列を返す' do
        @third_strings.should.not.be.nil
        @third_strings.size.should == CharSupplier::NUM_TO_SUPPLY
      end

      it 'その配列は「の」を含む' do
        @supplier.char_candidates_at(2).size.should == 2
        @third_strings.include?(@supplier.current_poem.kimari_ji[2]).should.be.true
      end

      it 'その配列は2個のnilを含む' do
        @third_strings.count(nil).should == 2
      end
    end


    describe '決まり字の長さを超えても、上の句の文字列を正解文字として候補文字群を返す (#1の歌なら、4文字目も返す)' do
      before do
        @kimari_ji_length = @supplier.current_poem.kimari_ji.length
        @beyond_strings = @supplier.make_4strings_at(@kimari_ji_length)
      end
      it '大きさ4の配列を返す' do
        @beyond_strings.tap do |strings|
          strings.should.not.be.nil
          strings.size.should == CharSupplier::NUM_TO_SUPPLY
          strings.include?(@supplier.current_poem.in_hiragana.kami[@kimari_ji_length]).should.be.true
        end
      end

      it '正しい文字を含む' do
        char_in_kami = @supplier.current_poem.in_hiragana.kami[@kimari_ji_length]
        @beyond_strings.include?(char_in_kami).should.be.true
      end

      it '正しい文字以外の候補文字は無く、nilが入っている' do
        @beyond_strings.count(nil).should == CharSupplier::NUM_TO_SUPPLY-1
      end
    end
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
      @supplier.char_candidates_at(1).tap do |second_strings|
        second_strings.size.should == CHARS_NEXT_TO_A.size
        second_strings.sort.should == CHARS_NEXT_TO_A.sort
      end

    end

    describe '#76の大山札「わたのはらこ」でのチェック' do
      before do
        poem76 = @supplier.set_current_poem_to_number(76)
        @kimari = poem76.kimari_ji
      end

      it 'まず、正しく決まり字が取得できている' do
        @kimari.should == 'わたのはらこ'
      end

      it '2文字目候補群は、順不同で「た す が び」を含む4文字' do
        @supplier.char_candidates_at(1).tap do |second_strings|
          second_strings.sort.should == %w(た す が び).sort
        end
      end

      it '3文字目候補群は「の」のみ' do
        @supplier.char_candidates_at(2).should == %w(の)
      end

      it '4文字目候補群は「は」のみ' do
        @supplier.char_candidates_at(3).should == %w(は)
      end

      it '5文字目候補群は「ら」のみ' do
        @supplier.char_candidates_at(4).should == %w(ら)
      end

      it '6文字目候補は二文字あり、順不同で「や こ」' do
        @supplier.char_candidates_at(5).should == %w(や こ)
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

  describe 'set_current_poem_to_number' do
    before do
      @supplier = CharSupplier.new({deck: Deck.new})
    end

    it '与えられた歌番号の歌をcurrent_poem_numberにセットする' do
      @supplier.set_current_poem_to_number(4)
      @supplier.current_poem.number.should == 4
    end

    it '戻り値として、与えられた歌番号の歌(Poem)を返す' do
      @supplier.set_current_poem_to_number(10).tap do |poem|
        poem.should.not.be.nil
        poem.number.should == 10
      end
    end

    it '保持していない歌番号が引数で与えられたらnilを返す' do
      @supplier.set_current_poem_to_number(0).should.be.nil
      @supplier.set_current_poem_to_number(101).should.be.nil
    end
  end

  describe 'get_4strings' do
    describe 'Context: TEST_MODE1' do
      before do
        @supplier = CharSupplier.new({deck: Deck.new,
                                      mode: CharSupplier::TEST_MODE1})
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
        sixth[2].should == 'み'
        @supplier.get_4strings.should.be.nil
        @supplier.counter.should == 6
      end
    end

    describe 'Context: シャッフルしていない本番デッキから文字群を取得' do
      before do
        @supplier = CharSupplier.new({deck: Deck.new})
      end

      it '歌#1の4文字目まで確認' do
        @supplier.get_4strings.include?('あ').should.be.true
        @supplier.get_4strings.include?('き').should.be.true
        @supplier.get_4strings.include?('か').should.be.true #友札の文字
        @supplier.get_4strings.include?('た').should.be.true #決まり字over状態
      end

      it '歌#1の2文字目まで取得した後、歌を#2, #3に切り替える' do
        @supplier.get_4strings.include?('あ').should.be.true
        @supplier.get_4strings.include?('き').should.be.true

        # 歌#2へ
        @supplier.draw_next_poem.should.not.be.nil
        @supplier.get_4strings.tap do |poem2_strings1|
#          puts "poem2_strings1 => [#{poem2_strings1}]"
          poem2_strings1.include?('は').should.be.true
          poem2_strings1[@supplier.current_right_index].should == 'は'
        end
        @supplier.current_right_index.should.not.be.nil


        @supplier.get_4strings[0..1].sort.should == ['る', 'な'].sort #「は」に続く文字
        @supplier.current_right_index.should.not.be.nil
        @supplier.get_4strings[0..1].sort.should == ['す', 'の'].sort #「はる」に続く文字
        @supplier.current_right_index.should.not.be.nil
        @supplier.get_4strings[0].should == 'き' # これが「ぎ」になるように頑張る？


        # 歌#3へ
        @supplier.draw_next_poem.should.not.be.nil
        @supplier.get_4strings.include?('あ').should.be.true
        @supplier.get_4strings.include?('し').should.be.true

      end

    end
  end

  describe 'test_challenge_string' do
    before do
      @supplier = CharSupplier.new({deck: Deck.new})
    end

    it '正しい文字列でのチャレンジ時はtrueを返す' do
      @supplier.test_challenge_string(@supplier.answer).should.be.true
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
    describe 'Context: TEST_MODE1' do
      before do
        @supplier = CharSupplier.new({deck: Deck.new,
                                      mode: CharSupplier::TEST_MODE1})
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

  describe 'on_the_correct_line?' do
    before do
      @supplier = CharSupplier.new({deck: Deck.new})
    end

    it '「あき」は#1の歌に部分的に適合している' do
      @supplier.on_the_correct_line?('あき').should.be.true
    end

    it '「あきのたの」も決まり字overだけど、on_the_lineの状態と見なす' do
      @supplier.on_the_correct_line?('あきのたの').should.be.true
    end

    it '「あきか」は別の歌になるので、falseになる' do
      @supplier.on_the_correct_line?('あきか').should.be.false
    end
  end
end
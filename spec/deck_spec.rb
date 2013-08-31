describe 'Deck' do
  describe 'initialize' do
    before do
      @deck = Deck.new
    end

    it 'should be a valid Deck' do
      @deck.should.not.be.nil
      @deck.is_a?(Deck).should.be.true
    end
  end

  describe 'poems' do
    before do
      @poems = Deck.new.poems
    end

    it 'should be an array of poem object' do
      @poems.is_a?(Array).should.be.true
      @poems[0].is_a?(Poem).should.be.true
    end

    it 'should have 100 element' do
      @poems.size.should.be.equal 100
#      RubyMotionでは、この↓書き方はできない。(ERRORになる)
#      @poems.should.have(100).items
    end

    it 'has first Poem that is No.1 and made by "天智天皇"' do
      first_poem = @poems[0]
      first_poem.number.should.be.equal 1
      first_poem.poet.should.be.equal '天智天皇'
      first_poem.liner[1].should.be.equal 'かりほの庵の'
    end

    it 'has 2nd Poem that is No.2 and made by "持統天皇"' do
      second_poem = @poems[1]
      second_poem.number.should.be.equal 2
      second_poem.poet.should.be.equal '持統天皇'
      second_poem.in_hiragana.shimo.should.be.equal 'ころもほすてふあまのかくやま'
    end
  end

  describe 'size' do
    before do
      @deck = Deck.new
    end

    it '保持しているPoemの数を返す' do
      @deck.size.should.not.be.nil
      @deck.size.should == @deck.poems.size
    end
  end

  describe 'counter and next_poem' do
    before do
      @deck = Deck.new
    end

    it 'counterの初期値は0' do
      @deck.counter.should.not.be.nil
      @deck.counter.should == 0
    end

    it 'next_poemで次のPoemオブジェクトを取得できる' do
      @deck.next_poem.should.not.be.nil
      @deck.next_poem.is_a?(Poem).should.be.true
    end

    it 'シャッフルも選別もしていないDeckの場合、最初に#1の歌が、次に#2の歌が取得できる' do
      first_poem = @deck.next_poem
      first_poem.poet.should == "天智天皇"
      second_poem = @deck.next_poem
      second_poem.in_hiragana.shimo.should == 'ころもほすてふあまのかくやま'
    end

    it 'next_poemを呼ぶと、counterの値が一つ増えなければならない' do
      prev_counter = @deck.counter
      @deck.next_poem
      @deck.counter.should == prev_counter + 1
    end

    it 'next_poemによってPoemを取得し尽くした場合、next_poemはnilを返す' do
      @deck.size.times {@deck.next_poem}
      @deck.counter.should == @deck.size
      @deck.next_poem.should.be.nil
    end

  end

  describe 'shuffle_with_size:' do
    before do
      @deck = Deck.new.shuffle_with_size(10)
    end

    it 'should not be nil' do
      @deck.should.not.be.nil
      @deck.size.should == 10
    end
  end
end

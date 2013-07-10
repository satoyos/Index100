describe 'Deck' do
  describe 'initialize' do
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
end


__END__


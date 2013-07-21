describe 'CharSupplier' do
  shared 'a CharSupplier' do
    it 'should not be nil' do
      @supplier.should.not.be.nil
    end
    it 'should be a instance of CharSupplier' do
      @supplier.is_a?(CharSupplier).should.be.true
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

    it 'has an answer' do
      @supplier.answer.should.not.be.nil
      @supplier.answer.is_a?(String).should.be.true
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
end
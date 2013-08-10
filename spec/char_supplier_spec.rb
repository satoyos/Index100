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
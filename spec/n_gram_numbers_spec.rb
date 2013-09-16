describe 'NGramNumbers' do
  describe '初期化' do
    before do
      @numbers = NGramNumbers.new
    end

    it 'should not be nil' do
      @numbers.should.not.be.nil
    end

    it 'has 100 Poems' do
      @numbers.poems.size.should == 100
    end

    it 'has a list of numbers' do
      @numbers.list.size.should == NGramNumbers::FIRST_CHARS.keys.size
      @numbers.list[:a].is_a?(Array).should.be.true
    end

  end

  describe 'リストを正しく作っている' do
    before do
      @list = NGramNumbers.new.list
    end

    it '「は」に対応するリストは、[2, 9, 67, 96]' do
      @list[:ha].sort.should == [2, 9, 67, 96]
    end

    it 'リストを全部足したら、1〜100までの番号が揃った配列になる' do
      array = []
      @list.each do |key, value_array|
        array += value_array
      end
      array.sort.should == (1..100).to_a
    end
  end

  describe 'クラスメソッドのテスト' do
    it '「あ」から始まる歌は16首' do
      NGramNumbers.of(:a).size.should == 16
    end
    it '「む」で始まる歌は1首だけ' do
      NGramNumbers.of(:mu).should == [87]
    end
  end

end
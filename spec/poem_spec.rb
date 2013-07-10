describe Poem do
  POEM_INIT_JSON =<<'EOF'
{
    "number": 2,
    "poet": "持統天皇",
    "liner": [
    "春過ぎて",
    "夏来にけらし",
    "白妙の",
    "衣干すてふ",
    "天の香具山"
],
    "in_hiragana": {
    "kami": "はるすきてなつきにけらししろたへの",
    "shimo": "ころもほすてふあまのかくやま"
},
    "kimari_ji": "はるす"
}
EOF

  describe 'initialize' do
    before do
      @hash = JSONParser.parse(POEM_INIT_JSON)
      @poem = Poem.new(@hash)
    end

    it 'should be initialized by Hash data' do
      @hash.is_a?(Hash).should.be.true
    end
    it 'should not be nil' do
      @poem.should.not.be.nil
    end
    it 'should have"持統天皇" as poet' do
      @poem.poet.should.be.equal '持統天皇'
    end
    it 'should have liner data that consists of 5 parts' do
      @poem.liner.size.should.be.equal 5
    end
    it 'should have 決まり字「はるす」' do
      @poem.kimari_ji.should.be.equal 'はるす'
    end
  end
end
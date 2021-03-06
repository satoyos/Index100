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

  JSON_WITH_SPACE =<<'EOF'
{
    "number": 11,
    "poet": "参議篁",
    "liner": [
      "和田の原",
      "八十島かけて",
      "漕ぎ出ぬと",
      "人にはつげよ",
      "あまのつりぶね"
    ],
    "in_hiragana": {
      "kami": "わたのはらやそしまかけてこきいてぬと",
      "shimo": "ひとにはつけよあまのつりふね"
    },
    "kimari_ji": "わたのはら　や"
  }
EOF

  describe 'initialize' do
    describe 'Context: normal' do
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

    describe 'Context: 決まり字に全角スペースがある場合' do
      before do
        @poem2 = Poem.new(JSONParser.parse(JSON_WITH_SPACE))
      end

      it 'should be a Poem' do
        @poem2.should.not.be.nil
      end

      it '決まり字の全角スペースは、Poemオブジェクト生成時に消える' do
        @poem2.kimari_ji.should.not =~ /　/
      end
    end

  end
end
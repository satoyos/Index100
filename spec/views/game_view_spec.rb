describe 'GameView' do
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
      @game_view =
          GameView.alloc.initWithFrame([CGPointZero,
                                        CGSizeMake(320, 480)],
                                       withPoem: Poem.new(JSONParser.parse(POEM_INIT_JSON)),
                                       supplier: CharSupplier.new(deck: Deck.new))
    end

    it 'should not be nil' do
      @game_view.should.not.be.nil
    end

    it '歌が一つセットされている' do
      @game_view.poem.should.not.be.nil
      @game_view.poem.is_a?(Poem).should.be.true
    end

    it '畳ビューを一枚持つ' do
      @game_view.tatami_view.should.not.be.nil
      @game_view.tatami_view.is_a?(UIImageView).should.be.true
    end

    it '札ビューを一枚持つ' do
      @game_view.fuda_view.should.not.be.nil
      @game_view.fuda_view.is_a?(FudaView).should.be.true
    end

    it '畳ビューと札ビューのcenterは一致！' do
      @game_view.fuda_view.center.is_a?(CGPoint).should.be.true
      @game_view.fuda_view.center.eql?(@game_view.tatami_view.center).should.be.true
    end

    it 'カウンターラベルがある' do
      c_label = @game_view.subviews.find{|view| view.is_a?(UILabel)}
      c_label.should.not.be.nil
      c_label.text.should == '1/100'
      c_label.textColor.should == UIColor.whiteColor
    end

    it 'accessibilityLabelが設定されている' do
      @game_view.accessibilityLabel.should == GameView::A_LABEL_GAME_VIEW
    end

  end
end
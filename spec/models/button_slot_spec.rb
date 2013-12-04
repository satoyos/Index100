describe 'ButtonSlot' do
  describe '初期化' do
    before do
      @button_slot = ButtonSlot.new(4)
    end

    it 'should not be nil' do
      @button_slot.should.not.be.nil
    end

    it 'should have limit_size' do
      @button_slot.limit_size.should.not.be.nil
    end
  end

  describe '<<' do
    before do
      @slot = ButtonSlot.new(2)
    end

    it '配列のサブクラスなので、<<メソッドで要素を追加できる' do
      @slot << 1
      @slot.size.should == 1
    end

    # 2013/08/03時点では、raise関連のテストがうまく動作しないので、コメントアウトしておく。
=begin
    it 'should raise OverLimitError when fully stuffed' do
      2.times do
        @slot << 1
      end
      should.raise(OverLimitError){@slot << 1}
    end
=end
  end

  describe 'steal' do
    before do
      @slot = ButtonSlot.new(2)
      @liner1 = Liner_2_parts.new({kami: 'あきのたのかりほのいほのとまをあらみ',
                               shimo: 'わかころもてはつゆにぬれつつ'})
      @liner2 = Liner_2_parts.new(kami: 'はるすきてなつきにけらししろたへの',
                              shimo: 'ころもほすてふあまのかくやま')
    end

    it 'should remove element without changing size' do
      @slot << @liner1
      @slot << @liner2
      @slot.steal(@liner1)
      @slot[0].should.be.nil
      @slot[1].should == @liner2
      @slot.size.should == 2
    end

    it 'should return nil when paramater object not found' do
      @slot << @liner1
      @slot << @liner2
      @slot.steal(1).should.be.nil
    end
  end

  describe 'transfer' do
    before do
      @slot1 = ButtonSlot.new(2)
      @slot2 = ButtonSlot.new(2)
      @liner1 = Liner_2_parts.new({kami: 'あきのたのかりほのいほのとまをあらみ',
                                   shimo: 'わかころもてはつゆにぬれつつ'})
      @liner2 = Liner_2_parts.new(kami: 'はるすきてなつきにけらししろたへの',
                                  shimo: 'ころもほすてふあまのかくやま')
      @slot1 << @liner1
      @slot1 << @liner2
      @slot1.transfer(@liner1, to: @slot2)
    end

    it '移籍元のいた場所は空になる' do
      @slot1[0].should.be.nil
      @slot1.size.should == 2
    end

    it 'オブジェクトが移籍先に追加される' do
      @slot2.last.should == @liner1
    end

    it 'もう存在しないオブジェクトを移籍させようとしたら、nilが返る' do
      @slot1.transfer(@liner1, to: @slot2).should.be.nil
    end

    # 2013/08/03時点では、raise関連のテストがうまく動作しないので、コメントアウトしておく。
=begin
    it '満杯になっている移籍先にオブジェクトを移そうとすると、OverLimitErrorが返る' do
      @slot2 << 1
      should.raise(OverLimitError){@slot1.transfer(@liner2, to: @slot2)}
    end
=end
  end

  describe 'is_full?' do
    before do
      @slot1 = ButtonSlot.new(2)
      @slot1 << 1
    end

    it 'should not be full yet' do
      @slot1.is_full?.should.be.false
    end

    it 'should be full by next item' do
      @slot1 << 2
      @slot1.is_full?.should.be.true
    end
  end
end
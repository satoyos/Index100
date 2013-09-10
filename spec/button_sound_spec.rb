describe 'ButtonSound' do
  describe '初期化' do
    INIT_HASH = {id: :on_jin_b01,
                 path: 'audio/button/On-jin/botan_b01',
                 type: 'mp3',
                 label: 'ボタン1'}
    before do
      @bs = ButtonSound.new(INIT_HASH)
    end

    it 'should not be nil' do
      @bs.should.not.be.nil
    end

    it '正常に初期化されている' do
      @bs.id.should == INIT_HASH[:id]
      @bs.path.should == INIT_HASH[:path]
    end
  end

  describe 'クラスメソッドによるデータ準備' do
    before do
      @sounds = ButtonSound.create_sounds
    end

    it 'should not be nil' do
      @sounds.should.not.be.nil
    end

    it 'should be an Array of ButtonSound' do
      @sounds.size.should > 0
      @sounds.first.is_a?(ButtonSound).should.be.true
    end

  end
end
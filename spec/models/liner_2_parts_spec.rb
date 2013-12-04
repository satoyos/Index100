INIT_HASH_L2 = {kami: '花さそふ嵐の庭の雪ならで',
                shimo: 'ふりゆくものはわが身なりけり'}

describe Liner_2_parts do
  describe 'initialize' do
    before do
      @l2p = Liner_2_parts.new(INIT_HASH_L2)
    end
    it 'should not be nil' do
      @l2p.should.not.be.nil
    end

    it 'should have 上の句 as 「花さそふ嵐の庭の雪ならで」' do
      @l2p.kami.should.be.equal '花さそふ嵐の庭の雪ならで'
    end

    it 'should have 下の句 as 「ふりゆくものはわが身なりけり」' do
      @l2p.shimo.should.be.equal 'ふりゆくものはわが身なりけり'
    end
  end
end
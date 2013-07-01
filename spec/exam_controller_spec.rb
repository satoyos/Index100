describe 'ExamController' do
  describe '初期化' do
    tests ExamController

    it 'should not be nil' do
      controller.should.not.be.nil
    end

    it '畳ビューを一枚もつ' do
      controller.tatami_view.should.not.be.nil
      controller.tatami_view.is_a?(UIView).should.be.true
    end

    it '札ビューを一枚もつ' do
      controller.fuda_view.should.not.be.nil
      controller.fuda_view.is_a?(FudaView).should.be.true
    end

    it '畳ビューと札ビューのcenterは一致！' do
      controller.fuda_view.center.is_a?(CGPoint).should.be.true
      controller.fuda_view.center.eql?(controller.tatami_view.center).should.be.true
    end
  end


end
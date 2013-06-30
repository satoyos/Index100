describe 'ExamController' do
  describe '初期化' do
    tests ExamController

    it 'should not be nil' do
      controller.should.not.be.nil
    end

    it 'インスタンス変数で札ビューを一枚管理している' do
      controller.instance_eval do
        @fuda_view.should.not.be.nil
        #@fuda_view.is_a?(FudaView).should.be.true
        #%Todo: ↑このテストを通すところから！
      end
    end
  end


end
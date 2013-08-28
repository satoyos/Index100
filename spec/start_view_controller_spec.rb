describe 'StartViewController' do
  describe '初期化' do
    tests StartViewController

    it 'should not be nil' do
      controller.should.not.be.nil
    end

    it 'ツールバーがある' do
      controller.toolbarItems.should.not.be.nil
    end
    it 'ツールバーには、唯一ボタンがある' do
      controller.toolbarItems.size.should == 1
      controller.toolbarItems.first.is_a?(UIBarButtonItem).should.be.true
    end
  end
end
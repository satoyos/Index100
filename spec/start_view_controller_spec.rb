describe 'StartViewController' do
  describe '初期化' do
    tests StartViewController

    it 'should not be nil' do
      controller.should.not.be.nil
    end

    it 'ツールバーがある' do
      controller.toolbarItems.should.not.be.nil
    end
    it 'ツールバーには三つの要素がある' do
      controller.toolbarItems.size.should == 3
    end
    it '二つ目の要素がボタン' do
      controller.toolbarItems[1].tap do |second_item|
        second_item.is_a?(UIBarButtonItem).should.be.true
        second_item.title.should == StartViewController::GAME_START_BUTTON_TITLE
      end

    end
  end
end
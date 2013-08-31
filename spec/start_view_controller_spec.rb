describe 'StartViewController' do
  describe '初期化' do
    tests StartViewController

    it 'should not be nil' do
      controller.should.not.be.nil
    end

    it 'スタイルが UITableViewStyleGrouped に設定されている' do
      controller.view.style.should == UITableViewStyleGrouped
    end
  end

  describe 'tableView:numberOfRowsInSection' do
    tests StartViewController

    it 'section=0のときは、定められた設定項目数を返す' do
      controller.tableView(nil, numberOfRowsInSection: 0).should ==
          StartViewController::SETTING_ITEMS.size
    end
  end

end
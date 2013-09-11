describe 'PoemPicker' do
  describe '初期化' do
    tests PoemPicker

    it 'should not be nil' do
      controller.should.not.be.nil
    end

    it 'has 100 poems' do
      controller.poems.should.not.be.nil
      controller.poems.size.should == 100
      controller.poems.first.is_a?(Poem).should.be.true
    end

    it 'has 100 selected_status' do
      controller.selected.should.not.be.nil
      controller.selected.size.should == 100
#      controller.selected.first.is_a?(FalseClass).should.be.true
    end

    it 'has a tableView' do
      controller.tableView.should.not.be.nil
      controller.tableView.is_a?(UITableView).should.be.true
    end
  end

  describe 'テーブル表示' do
    tests PoemPicker

    it 'テーブルの要素数を返す' do
      controller.tableView(controller.tableView,
                           numberOfRowsInSection: 0).should == 100
    end
  end
end
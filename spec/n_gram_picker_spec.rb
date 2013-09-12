describe 'NGramPicker' do
  describe '初期化' do
    tests NGramPicker

    it 'should not be nil' do
      controller.should.not.be.nil
    end
    it 'has a title' do
      controller.title.should.not.be.nil
    end
  end

  describe 'セクション付きのテーブルを表示する' do
    tests NGramPicker

    it 'support numberOfSectionsInTableView' do
      controller.numberOfSectionsInTableView(nil).should ==
          NGramPicker::N_GRAM_SECTIONS.size
    end

    it 'supports tableView:numberOfRowsInSection:' do
      controller.tableView(nil, numberOfRowsInSection: 1).should == 5
    end

  end
end
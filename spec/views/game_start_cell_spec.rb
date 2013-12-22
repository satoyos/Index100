describe 'GameStartCell' do
  before do
    TEST_TEXT = 'ボタンの表示テキスト'
    TEST_ACC_LABEL = 'test_acc_label'
    TEST_REUSE_ID = 'test_reuse_id'
    @game_start_cell =
        GameStartCell.alloc.initWithText(TEST_TEXT,
                                         acc_label: TEST_ACC_LABEL,
                                         reuseIdentifier: TEST_REUSE_ID)
  end

  it 'should not be nil' do
    @game_start_cell.should.not.be.nil
  end

  it 'accessabilityLabelが正しく設定されている' do
    @game_start_cell.accessibilityLabel.should == TEST_ACC_LABEL
  end
end
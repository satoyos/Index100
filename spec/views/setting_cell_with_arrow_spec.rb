describe 'SettingCellWithArrow' do
  TEST_MAIN_TEXT = 'セルのメインテキスト'
  TEST_DETAIL_TEXT = 'セルの詳細テキスト'
  TEST_ACC_LABEL = 'test_acc_label'
  TEST_REUSE_ID = 'test_reuse_id'

  before do
    @cell =
        SettingCellWithArrow.alloc.initWithText(TEST_MAIN_TEXT,
                                                detail: TEST_DETAIL_TEXT,
                                                acc_label: TEST_ACC_LABEL,
                                                reuseIdentifier: TEST_REUSE_ID)
  end

  it 'should not be nil' do
    @cell.should.not.be.nil
  end

  it 'accessabilityLabelが正しく設定されている' do
    @cell.accessibilityLabel.should == TEST_ACC_LABEL
  end

end
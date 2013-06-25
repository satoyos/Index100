describe 'Settings' do
  describe 'instance' do
    before do
      @settings = Settings.instance
    end

    it 'should not be nil' do
      @settings.should.not.be.nil
    end

    it 'should be a instance of Settings' do
      @settings.is_a?(Settings).should.be.true
    end

    it 'should be a Singleton' do
      Settings.instance.should.be.equal @settings
    end
  end

  describe 'クラス内定数で定められたデータを保持する' do
    before do
      @settings = Settings.instance
      @settings.volume = 0.5
    end

    it 'should respond valid property call' do
      @settings.volume.should == 0.5
    end

    it 'should raise NoMethodError by invalid property call' do
      should.raise(NoMethodError){@settings.xxxxx}
    end

  end

end
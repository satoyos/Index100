describe 'FontFactory' do
  describe 'create_font_with_type' do
    shared 'a UIFont' do
      it 'should not be nil' do
        @font.should.not.be.nil
      end

      it 'should be a UIFont' do
        @font.is_a?(UIFont).should.be.true
      end
    end

    describe 'when type is :japanese' do
      before do
        @font = FontFactory.create_font_with_type(:japanese, size: 10)
      end

      describe 'a new Font' do
        behaves_like 'a UIFont'
      end
    end

    describe 'when unknown type is given' do
      before do
        @font = FontFactory.create_font_with_type(:xxxx, size: 10)
      end

      describe 'a new Font' do
        behaves_like 'a UIFont'
      end

    end

  end
end
describe 'JSONParser' do
  TEST_JSON =<<'EOF'
{
    "number": 2,
    "poet": "持統天皇",
    "liner": [
    "春過ぎて",
    "夏来にけらし",
    "白妙の",
    "衣干すてふ",
    "天の香具山"
]}
EOF

  shared 'a declared JSON' do
    it 'should not be nil' do
      @json.should.not.be.nil
    end
    it 'should have valid value related to declared key' do
      @json['number'].should == 2
      @json['poet'].should == '持統天皇'
      @json['liner'].size.should == 5
    end
  end

  describe 'parse' do
    before do
      @json = JSONParser.parse(TEST_JSON)
    end

    behaves_like 'a declared JSON'
  end

  describe 'parse_from_file' do
    before do
      @json = JSONParser.parse_from_file('test.json')
    end

    behaves_like 'a declared JSON'
  end

end
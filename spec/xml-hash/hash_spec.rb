require_relative "../../lib/xml-hash/hash"

describe Hash do
  describe 'self.snakecase' do
    it 'changes all letters to downcase' do
      word = "ThisIsAWord"
      converted_word = Hash.snakecase(word)
      converted_word.should_not match(/[A-Z]/)
    end

    it 'properly separates words on capitals' do
      word = "ThisIsAWord"
      Hash.snakecase(word).should == "this_is_a_word"
    end

    it 'has no spaces' do
      word = "ThisIsAWord"
      converted_word = Hash.snakecase(word)
      converted_word.should_not match(/\s/)
    end
  end

  describe 'self.symbolize' do
    it 'changes all keys in a hash to a symbol' do
      new_hash = {"one" => 1, :two => "2", "three" => "3"}
      hash_with_sym = Hash.symbolize(new_hash)
      hash_with_sym.keys.map{ |k| k.class.should == Symbol }
    end

    it 'does not change the values in a hash' do
      new_hash = {"one" => 1, :two => "2", "three" => "3"}
      hash_with_sym = Hash.symbolize(new_hash)
      hash_with_sym.values[0].should == 1
      hash_with_sym.values[1].should == "2"
      hash_with_sym.values[2].should == "3"
    end
  end

  describe "lib_fromxml" do
    describe "parsing a file" do
      let(:file_text) do
        File.read("spec/fixtures/inventory.xml")
      end

      it "can parse a top level node" do
        hash = Hash.from_libxml(file_text)
        hash[:inventory].should_not be_nil
      end

      it "can parse a top level attribute" do
        hash = Hash.from_libxml(file_text)
        hash[:inventory][:type].should == "vehicle"
      end

      it "can parse a second level node" do
        hash = Hash.from_libxml(file_text)
        hash[:inventory][:bikes].should_not be_nil
      end

      it "can parse a second level attribute" do
        hash = Hash.from_libxml(file_text)
        hash[:inventory][:bikes][:gender].should == "boy"
      end
    end
  end
end
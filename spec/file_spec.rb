describe DwcAgent do
  before(:all) do
    set_parser(DwcAgent::Parser.instance)
    set_cleaner(DwcAgent::Cleaner.instance)
  end

  it "generates standardized json" do
      read_test_file do |y|
        expect(JSON.load(json(y[:input]))).to eq JSON.load(y[:expected]) unless y[:comment]
      end
    end
end
module DwcAgent
  describe 'Similarity' do
    let(:similarity) { Similarity }

    describe "Test the similarity of given names" do

      it "should give J. and John a score of 1" do
        given1 = "J."
        given2 = "John"
        expect(similarity.similarity_score(given1,given2)).to eq 1
      end

      it "should give John R. and John a score of 1.1" do
        given1 = "John R."
        given2 = "John"
        expect(similarity.similarity_score(given1,given2)).to eq 1.1
      end

      it "should give J.D. and J. a score of 1.1" do
        given1 = "J.D."
        given2 = "J."
        expect(similarity.similarity_score(given1,given2)).to eq 1.1
      end

      it "should give John R. and J.R. a score of 2" do
        given1 = "John R."
        given2 = "J.R."
        expect(similarity.similarity_score(given1,given2)).to eq 2
      end

      it "should give John Robert and John a score of 1.1" do
        given1 = "John Robert"
        given2 = "John"
        expect(similarity.similarity_score(given1,given2)).to eq 1.1
      end

      it "should give John Robert and John R. a score of 2" do
        given1 = "John Robert"
        given2 = "John R."
        expect(similarity.similarity_score(given1,given2)).to eq 2
      end
  
      it "should give John R. and J.R.W. a score of 2" do
        given1 = "John R."
        given2 = "J.R.W."
        expect(similarity.similarity_score(given1,given2)).to eq 2
      end

      it "should give Jim B. and Jay a score of 0" do
        given1 = "Jim B."
        given2 = "Jay"
        expect(similarity.similarity_score(given1,given2)).to eq 0
      end

      it "should give John R. and John F. a score of 0" do
        given1 = "John R."
        given2 = "John F."
        expect(similarity.similarity_score(given1,given2)).to eq 0
      end

      it "should give J.R. and J.F. a score of 0" do
        given1 = "J.R."
        given2 = "J.F."
        expect(similarity.similarity_score(given1,given2)).to eq 0
      end

      it "should give J.F.W. and J.F.R. a score of 0" do
        given1 = "J.F.W."
        given2 = "J.F.R."
        expect(similarity.similarity_score(given1,given2)).to eq 0
      end

      it "should give Jack and John a score of 0" do
        given1 = "Jack"
        given2 = "John"
        expect(similarity.similarity_score(given1,given2)).to eq 0
      end

      it "should give Jack and Peter a score of 0" do
        given1 = "Jack"
        given2 = "Peter"
        expect(similarity.similarity_score(given1,given2)).to eq 0
      end

      it "should give Jack P. and Jack Peter a score of 2" do
        given1 = "Jack P."
        given2 = "Jack Peter"
        expect(similarity.similarity_score(given1,given2)).to eq 2
      end

      it "should give Jack Robert and Jack Richard a score of 0" do
        given1 = "Jack Robert"
        given2 = "Jack Richard"
        expect(similarity.similarity_score(given1,given2)).to eq 0
      end

      it "should give J. Robert and Jack Robert a score of 2" do
        given1 = "J. Robert"
        given2 = "Jack Robert"
        expect(similarity.similarity_score(given1,given2)).to eq 2
      end

      it "should give J. Richard and Jack Robert a score of 0" do
        given1 = "J. Richard"
        given2 = "Jack Robert"
        expect(similarity.similarity_score(given1,given2)).to eq 0
      end

      it "should give J.Wagner J. and John J. a score of 0" do
        given1 = "J.Wagner J."
        given2 = "John J."
        expect(similarity.similarity_score(given1,given2)).to eq 0
      end

      it "should give J.BollinG and J.V. a score of 0" do
        given1 = "J.BollinG"
        given2 = "J.V."
        expect(similarity.similarity_score(given1,given2)).to eq 0
      end

    end

  end
end
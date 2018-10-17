module DwcAgent
  describe 'Cleaner' do
    let(:parser) { Parser }
    let(:cleaner) { Cleaner }

    describe "Clean results from the Parser" do

      it "should reject a name that has 'Canadian Museum of Nature'" do
        input = "Jeff Saarela; Canadian Museum of Nature"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[1]).to_h).to eq({given: nil, family:nil})
      end

      it "should clean a name with two given names" do
        input = "William Leo Smith"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: "William Leo", family: "Smith"})
      end

      it "should reject a name that has 'Department' in it" do
        input = "Oregon Department of Agriculture"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: nil, family:nil})
      end

      it "should capitalize mistaken lowercase first initials" do
        input = "r.C. Smith"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given:"R.C.", family:"Smith"})
      end

      it "should clean family names with extraneous period" do
        input = "C. Tanner."
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given:'C.', family: 'Tanner'})
      end

      it "should remove extraneous capitalized letters within brackets" do
        input = "!B. P. J. Molloy (CHR)"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given:'B.P.J.', family: 'Molloy'})
      end

      it "should recognize a single name as a family name" do
        input = "Tanner"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given:nil, family: 'Tanner'})
      end

      it "should normalize a name all in caps" do
        input = "WILLIAM BEEBE"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: 'William', family:'Beebe'})
      end

      it "should remove brackets from name" do
        input = "W.P. Coreneuk(?)"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: 'W.P.', family:'Coreneuk'})
      end

      it "should not explode by E" do
        input = "Jack E Smith"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ family: "Smith", given: "Jack E."})
      end

      it "should parse name with many given initials" do
        input = "FAH Sperling"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ family: "Sperling", given: "F.A.H."})
      end

      it "should preserve caps in family names" do
        input = "Chris MacQuarrie"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ family: "MacQuarrie", given: "Chris"})
      end

      it "should recognize a religious suffix like Marie-Victorin, frère" do
        input = "Marie-Victorin, frère"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ family: "Marie-Victorin", given: nil})
      end

      it "should strip out 'synonymie'" do
        input = "Université Laval - synonymie"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ family: nil, given: nil})
      end

      it "should explode names with spaces missing surrounding ampersand" do
        input = "Henrik Andersen&jon Feilberg"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[1]).to_h).to eq({ family: "Feilberg", given: "Jon"})
      end

      it "should explode a messy list" do
        input = "Winterbottom, R.;Katz, L.;& CI team"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[2]).to_h).to eq({ family: nil, given: nil})
      end

      it "should ignore 'non précisé'" do
        input = "non précisé"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ family: nil, given: nil})
      end
  
      it "should parse name with given initials without period(s)" do
        input = "JH Picard"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ family: "Picard", given: "J.H."})
      end

      it "should parse name when given is initalized and order is reversed without separator" do
        input = "Picard J.H."
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ family: "Picard", given: "J.H."})
      end

      it "should capitalize surnames like 'Jack smith'" do
        input = "Jack smith"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ family: "Smith", given: "Jack"})
      end

      it "should capitalize names like 'C. YOUNG'" do
        input = "C. YOUNG"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ family: "Young", given: "C."})
      end

      it "should capitalize names like 'Chris R.T. YOUNG'" do
        input = "Chris R.T. YOUNG"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ family: "Young", given: "Chris R.T."})
      end

      it "should capitalize names like 'CHRIS R.T. YOUNG'" do
        input = "CHRIS R.T. YOUNG"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ family: "Young", given: "Chris R.T."})
      end

      it "should properly handle and capitalize utf-8 characters" do
        input = "Sicard, Léas"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ family: "Sicard", given: "Léas"})
      end

      it "should ignore poorly parsed names with long given names and many periods" do
        input = "J. Green; R. Driskill; J. W. Markham L. D. Druehl"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[2]).to_h).to eq({ family: nil, given: nil })
      end

      it "should ignore names with 'the'" do
        input = "The old bird was dead"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ family: nil, given: nil })
      end

      it "should ignore names with 'unidentified'" do
        input = "Unidentified Beetle"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ family: nil, given: nil })
      end

      it "should remove asterisks from a name" do
        input = "White*"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ family: "White", given: nil })
      end

      it "should split with 'communicated to' in text" do
        input = "Huber Moore; communicatd to Terry M. Taylor"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[1]).to_h).to eq({given: "Terry M.", family: "Taylor"})
      end

      it "should ignore a three letter family name without vowels" do
        input = "Jack Wft"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: nil, family: nil})
      end

      it "should accept a three letter family name with a vowel" do
        input = "Jack Wit"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: "Jack", family: "Wit"})
      end

      it "should not split a string of names with A." do
        input = "R.K. A. Godfrey"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: "R.K.A.", family: "Godfrey"})
      end

      it "should not ignore the name Paula Maybee" do
        input = "Paula Maybee"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: "Paula", family: "Maybee"})
      end

      it "it should not ignore the word maybe" do
        input = "Paula Maybee maybe"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: "Paula", family: "Maybee"})
      end

      it "should ignore a family name with CAPs at end" do
        input = "Jack SmitH"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: nil, family: nil})
      end

      it "should ignore ignore a family name with two CAPs at the beginning" do
        input = "RGBennett"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: nil, family: nil})
      end

      it "should normalize a name all in caps, written in reverse order" do
        input = "SOSIAK, MACLENNAN"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: 'MacLennan', family:'Sosiak'})
      end

    end

  end
end
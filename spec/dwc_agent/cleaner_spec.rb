module DwcAgent
  describe 'Cleaner' do
    let(:parser) { Parser.instance }
    let(:cleaner) { Cleaner.instance }

    describe "Clean results from the Parser" do

      it "should reject a name that has 'Canadian Museum of Nature'" do
        input = "Jeff Saarela; Canadian Museum of Nature"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[1]).to_h).to eq({given: nil, family: nil, particle: nil})
      end

      it "should clean a name with two given names" do
        input = "William Leo Smith"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: "William Leo", family: "Smith", particle: nil})
      end

      it "should reject a name that has 'Department' in it" do
        input = "Oregon Department of Agriculture"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: nil, family: nil, particle: nil})
      end

      it "should capitalize mistaken lowercase first initials" do
        input = "r.C. Smith"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given:"R.C.", family:"Smith", particle: nil})
      end

      it "should clean family names with extraneous period" do
        input = "C. Tanner."
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given:'C.', family: 'Tanner', particle: nil})
      end

      it "should remove extraneous capitalized letters within brackets" do
        input = "!B. P. J. Molloy (CHR)"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given:'B.P.J.', family: 'Molloy', particle: nil})
      end

      it "should recognize a single name as a family name" do
        input = "Tanner"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given:nil, family: 'Tanner', particle: nil})
      end

      it "should normalize a name all in caps" do
        input = "WILLIAM BEEBE"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: 'William', family:'Beebe', particle: nil})
      end

      it "should remove brackets from name" do
        input = "W.P. Coreneuk(?)"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: 'W.P.', family:'Coreneuk', particle: nil})
      end

      it "should not explode by E" do
        input = "Jack E Smith"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ family: "Smith", given: "Jack E.", particle: nil})
      end

      it "should parse name with many given initials" do
        input = "FAH Sperling"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ family: "Sperling", given: "F.A.H.", particle: nil})
      end

      it "should preserve caps in family names" do
        input = "Chris MacQuarrie"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ family: "MacQuarrie", given: "Chris", particle: nil})
      end

      it "should recognize a religious suffix like Marie-Victorin, frère" do
        input = "Marie-Victorin, frère"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ family: "Marie-Victorin", given: nil, particle: nil})
      end

      it "should strip out 'synonymie'" do
        input = "Université Laval - synonymie"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: nil, family: nil, particle: nil})
      end

      it "should explode names with spaces missing surrounding ampersand" do
        input = "Henrik Andersen&jon Feilberg"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[1]).to_h).to eq({ family: "Feilberg", given: "Jon", particle: nil})
      end

      it "should explode a messy list" do
        input = "Winterbottom, R.;Katz, L.;& CI team"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[2]).to_h).to eq({given: nil, family: nil, particle: nil})
      end

      it "should ignore 'non précisé'" do
        input = "non précisé"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: nil, family: nil, particle: nil})
      end

      it "should ignore '[Not Stated]'" do
        input = "[Not Stated]"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: nil, family: nil, particle: nil})
      end

      it "should parse name with given initials without period(s)" do
        input = "JH Picard"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ family: "Picard", given: "J.H.", particle: nil})
      end

      it "should reverse the order when family name is parsed as uppercase initials" do
        input = "Lepschi BJ; Albrecht DE"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ family: "Lepschi", given: "B.J.", particle: nil })
        expect(cleaner.clean(parsed[1]).to_h).to eq({ family: "Albrecht", given: "D.E.", particle: nil })
      end

      it "should parse name when given is initalized and order is reversed without separator" do
        input = "Picard J.H."
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ family: "Picard", given: "J.H.", particle: nil})
      end

      it "should capitalize surnames like 'Jack smith'" do
        input = "Jack smith"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ family: "Smith", given: "Jack", particle: nil})
      end

      it "should capitalize names like 'C. YOUNG'" do
        input = "C. YOUNG"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ family: "Young", given: "C.", particle: nil})
      end

      it "should flip a name like 'Groom Q.'" do
        input = "Groom Q."
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ family: "Groom", given: "Q.", particle: nil })
      end

      it "should capitalize names like 'Chris R.T. YOUNG'" do
        input = "Chris R.T. YOUNG"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ family: "Young", given: "Chris R.T.", particle: nil})
      end

      it "should capitalize names like 'CHRIS R.T. YOUNG'" do
        input = "CHRIS R.T. YOUNG"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ family: "Young", given: "Chris R.T.", particle: nil})
      end

      it "should properly handle and capitalize utf-8 characters" do
        input = "Sicard, Léas"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ family: "Sicard", given: "Léas", particle: nil})
      end

      it "should ignore poorly parsed names with long given names and many periods" do
        input = "J. Green; R. Driskill; J. W. Markham L. D. Druehl"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[2]).to_h).to eq({given: nil, family: nil, particle: nil})
      end

      it "should ignore names with 'the'" do
        input = "The old bird was dead"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: nil, family: nil, particle: nil})
      end

      it "should ignore names with 'unidentified'" do
        input = "Unidentified Beetle"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: nil, family: nil, particle: nil})
      end

      it "should ignore instances of word 'exchange'" do
        input = "Butcher, N.; Dominion exchange"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ family: "Butcher", given: "N.", particle: nil })
        expect(cleaner.clean(parsed[1]).to_h).to eq({given: nil, family: nil, particle: nil})
      end

      it "should remove asterisks from a name" do
        input = "White*"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ family: "White", given: nil, particle: nil })
      end

      it "should split with 'communicated to' in text" do
        input = "Huber Moore; communicatd to Terry M. Taylor"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[1]).to_h).to eq({given: "Terry M.", family: "Taylor", particle: nil})
      end

      it "should ignore a three letter family name without vowels" do
        input = "Jack Wft"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: "Jack", family: "Wft", particle: nil})
      end

      it "should accept a three letter family name with a vowel" do
        input = "Jack Wit"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: "Jack", family: "Wit", particle: nil})
      end

      it "should not split a string of names with A." do
        input = "R.K. A. Godfrey"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: "R.K.A.", family: "Godfrey", particle: nil})
      end

      it "should not ignore the name Paula Maybee" do
        input = "Paula Maybee"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: "Paula", family: "Maybee", particle: nil})
      end

      it "it should not ignore the word maybe" do
        input = "Paula Maybee maybe"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: "Paula", family: "Maybee", particle: nil})
      end

      it "should ignore a family name with CAPs at end" do
        input = "Jack SmitH"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: nil, family: nil, particle: nil})
      end

      it "should ignore a family name with two CAPs at the beginning" do
        input = "RGBennett"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: nil, family: nil, particle: nil})
      end

      it "should normalize a name all in caps, written in reverse order" do
        input = "SOSIAK, MACLENNAN"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: 'MacLennan', family:'Sosiak', particle: nil})
      end

      it "should clean a name whose given initials lack punctuation" do
        input = "A A Court"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: 'A.A.', family:'Court', particle: nil})
      end

      it "should clean a name whose given initials lack punctuation" do
        input = "Abreu, M.C"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: 'M.C.', family:'Abreu', particle: nil})
      end

      it "should remove anything between brackets" do
        input = "Michael (Mike) Smith"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: 'Michael', family: 'Smith', particle: nil})
      end

      it "should remove Ded:" do
        input = "Ded: A.E. Nordenskiöld (V"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: 'A.E.', family: 'Nordenskiöld', particle: nil})
      end

      it "should remove another variant of ded" do
        input = "Lagerström, H (Ded.)"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: 'H.', family: 'Lagerström', particle: nil})
      end

      it "should remove yet another variant of ded and parse the remains" do
        input = "Richt, L & S Jansson (ded"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[1]).to_h).to eq({given: 'S.', family: 'Jansson', particle: nil})
      end

      it "should remove extraneous information with brackets at end of string" do
        input = "J. Lindahl (Ingegerd & Gl"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: 'J.', family: 'Lindahl', particle: nil})
      end

      it "should remove Coll in brackets" do
        input = "D.Podlech (Coll. M, MSB)"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: 'D.', family: 'Podlech', particle: nil})
      end

      it "should remove nickname in brackets at end of string" do
        input = "Michael Smith (Mike)"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: 'Michael', family: 'Smith', particle: nil})
      end

      it "should remove extra content in brackets" do
        input = "Triplehorn, W. E. (Wanda Elaine) & Triplehorn, C."
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: 'W.E.', family: 'Triplehorn', particle: nil})
        expect(cleaner.clean(parsed[1]).to_h).to eq({given: 'C.', family: 'Triplehorn', particle: nil})
      end

      it "should remove content within square brackets" do
        input = "A. ORTEGA [INTERCAMBIO MA-VIT]"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: 'A.', family: 'Ortega', particle: nil})
      end

      it "should remove stray dashes and dots at the beginning of a string" do
        input = "-. Alfonso"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: nil, family: 'Alfonso', particle: nil})
      end

      it "should remove stray asterisks at the beginnning of a string" do
        input = "* SCHUCH"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: nil, family: 'Schuch', particle: nil})
      end

      it "should remove content prefixed by curly brackets" do
        input = "{Illegible]"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(0)
      end

      it "should remove any period after a number" do
        input = "B. Maguire 2375.4"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: "B.", family: 'Maguire', particle: nil})
      end

      it "should remove any period after a number and then remove trailing semicolon" do
        input = "B. Maguire; 2375.4"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: "B.", family: 'Maguire', particle: nil})
      end

      it "should remove via at end of string" do
        input = "B. Maguire via"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: "B.", family: 'Maguire', particle: nil})
      end

      it "should remove semicolon at start and messes elsewhere" do
        input = "; annot. J. Walter (W) 2017-04"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: "J.", family: 'Walter', particle: nil})
      end

      it "should ignore dashes in weird places" do
        input = "-. Borja; -- Rivet & Galiano"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(3)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: nil, family: "Borja", particle: nil})
      end

      it "should not mess with initials when there are three" do
        input = "A.J.E.Smith"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: "A.J.E.", family: "Smith", particle: nil})
      end

      it "should not mess with very small family names" do
        input = "Wen-Bin Yu"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: "Wen-Bin", family: "Yu", particle: nil})
      end

      it "should accept given name that is less than or equal to 25 characters" do
        input = "Jean-Baptiste Leschenault de La Tour"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: "Jean-Baptiste Leschenault", family: "La Tour", particle: "de"})
      end

      it "should reject given name that is greater than 25 characters" do
        input = "Jean-Baptiste Leschenaults de La Tour"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: nil, family: nil, particle: nil})
      end

      it "should strip out the terminal paricle" do
        input = "Andrade JC de"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: "J.C.", family: "Andrade", particle: nil})
      end

      it "should ignore a single paricle purported to be a name" do
        input = "Robillard|de"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: nil, family: "Robillard", particle: nil})
        expect(cleaner.clean(parsed[1]).to_h).to eq({given: nil, family: nil, particle: nil})
      end

      it "should recognize Lord as a middle name" do
        input = "Nathaniel Lord Britton"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: "Nathaniel Lord", family: "Britton", particle: nil})
      end

      it "should recognize Professor as a title" do
        input = "Professor Nathaniel Britton"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: "Nathaniel", family: "Britton", particle: nil})
      end

      it "should recognize Sir as a title" do
        input = "Sir Nathaniel Britton"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: "Nathaniel", family: "Britton", particle: nil})
      end

      it "should return a blank name when family name is 'der'" do
        input = "Baan M van der"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: nil, family: nil, particle: nil})
      end

      it "should return a blank name when family name is 'der'" do
        input = "Baan M van der"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: nil, family: nil, particle: nil})
      end

      it "should return a blank name when family name is 'von'" do
        input = "Baer K.E. von"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: nil, family: nil, particle: nil})
      end

      it " should return a blank name when family is 'Catalog'" do
        input = 'Catalog\1996'
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: nil, family: nil, particle: nil})
      end

      it "should ignore [no data]" do
        input = "[no data]"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: nil, family: nil, particle: nil})
      end

      it "should ignore [no disponible]" do
        input = "[no disponible]"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: nil, family: nil, particle: nil})
      end

      it "should ignore [no data available]" do
        input = "[no data available]"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: nil, family: nil, particle: nil})
      end

      it "should ignore [no agent data]" do
        input = "[no agent data]"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: nil, family: nil, particle: nil})
      end

      it "should ignore DATA NOT CAPTURED" do
        input = "DATA NOT CAPTURED"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: nil, family: nil, particle: nil})
      end

      it "should ignore 'Curators of USNM'" do
        input = "Curators of USNM"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: nil, family: nil, particle: nil})
      end

      it "should ignore 'C. N. C. Curators'" do
        input = "C. N. C. Curators"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: nil, family: nil, particle: nil})
      end

      it "should ignore 'Administrador'" do
        input = "Administrador"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: nil, family: nil, particle: nil})
      end

      it "should ignore 'nomenclatural adjustment'" do
        input = "nomenclatural adjustment"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({given: nil, family: nil, particle: nil})
      end

    end

  end
end
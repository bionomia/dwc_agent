module DwcAgent
  describe 'Cleaner' do
    let(:parser) { Parser.instance }
    let(:cleaner) { Cleaner.instance }

    describe "Clean results from the Parser" do

      it "should reject a name that has 'Canadian Museum of Nature'" do
        input = "Jeff Saarela; Canadian Museum of Nature"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[1]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil })
      end

      it "should clean a name with two given names" do
        input = "William Leo Smith"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "William Leo", particle: nil, family: "Smith", suffix: nil })
      end

      it "should reject a name that has 'Department' in it" do
        input = "Oregon Department of Agriculture"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil })
      end

      it "should capitalize mistaken lowercase first initials" do
        input = "r.C. Smith"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given:"R.C.", particle: nil, family:"Smith", suffix: nil })
      end

      it "should clean family names with extraneous period" do
        input = "C. Tanner."
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given:'C.', particle: nil, family: 'Tanner', suffix: nil })
      end

      it "should remove extraneous capitalized letters within brackets" do
        input = "!B. P. J. Molloy (CHR)"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given:'B.P.J.',  particle: nil, family: 'Molloy', suffix: nil })
      end

      it "should remove 1st" do
        input = "Beatty, G.H., 1st"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given:'G.H.',  particle: nil, family: 'Beatty', suffix: nil })
      end

      it "should remove 4th" do
        input = "G.H. Beatty 4th"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given:'G.H.',  particle: nil, family: 'Beatty', suffix: nil })
      end

      it "should remove 3rd" do
        input = "G.H. Beatty 3rd"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given:'G.H.',  particle: nil, family: 'Beatty', suffix: nil })
      end

      it "should recognize a single name as a family name" do
        input = "Tanner"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: 'Tanner', suffix: nil })
      end

      it "should normalize a name all in caps" do
        input = "WILLIAM BEEBE"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: 'William', particle: nil, family:'Beebe', suffix: nil })
      end

      it "should remove brackets from name" do
        input = "W.P. Coreneuk(?)"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: 'W.P.', particle: nil, family:'Coreneuk', suffix: nil })
      end

      it "should not explode by E" do
        input = "Jack E Smith"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Jack E.", particle: nil, family: "Smith", suffix: nil })
      end

      it "should parse name with many given initials" do
        input = "FAH Sperling"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "F.A.H.", particle: nil, family: "Sperling", suffix: nil })
      end

      it "should preserve caps in family names" do
        input = "Chris MacQuarrie"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Chris", particle: nil, family: "MacQuarrie", suffix: nil })
      end

      it "should recognize a religious suffix like Marie-Victorin, frère and treat it as a given name" do
        input = "Marie-Victorin, frère"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Frère", particle: nil, family: "Marie-Victorin", suffix: nil })
      end

      it "should strip out 'synonymie'" do
        input = "Université Laval - synonymie"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil })
      end

      it "should explode names with spaces missing surrounding ampersand" do
        input = "Henrik Andersen&jon Feilberg"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[1]).to_h).to eq({ title: nil, appellation: nil, given: "Jon", particle: nil, family: "Feilberg", suffix: nil })
      end

      it "should explode a messy list" do
        input = "Winterbottom, R.;Katz, L.;& CI team"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[2]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil })
      end

      it "should ignore 'non précisé'" do
        input = "non précisé"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil })
      end

      it "should ignore '[Not Stated]'" do
        input = "[Not Stated]"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil })
      end

      it "should parse name with given initials without period(s)" do
        input = "JH Picard"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "J.H.", particle: nil, family: "Picard", suffix: nil })
      end

      it "should reverse the order when family name is parsed as uppercase initials" do
        input = "Lepschi BJ; Albrecht DE"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "B.J.", particle: nil, family: "Lepschi", suffix: nil })
        expect(cleaner.clean(parsed[1]).to_h).to eq({ title: nil, appellation: nil, given: "D.E.", particle: nil, family: "Albrecht", suffix: nil })
      end

      it "should parse name when given is initalized and order is reversed without separator" do
        input = "Picard J.H."
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "J.H.", particle: nil, family: "Picard", suffix: nil })
      end

      it "should capitalize surnames like 'Jack smith'" do
        input = "Jack smith"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Jack", particle: nil, family: "Smith", suffix: nil })
      end

      it "should capitalize names like 'C. YOUNG'" do
        input = "C. YOUNG"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "C.", particle: nil, family: "Young", suffix: nil })
      end

      it "should flip a name like 'Groom Q.'" do
        input = "Groom Q."
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Q.", particle: nil, family: "Groom", suffix: nil })
      end

      it "should flip a name like 'Raes N'" do
        input = "Raes N"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "N.", particle: nil, family: "Raes", suffix: nil })
      end

      it "should flip a name like 'Slik JWF'" do
        input = "Slik JWF"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "J.W.F.", particle: nil, family: "Slik", suffix: nil })
      end

      it "should capitalize names like 'Chris R.T. YOUNG'" do
        input = "Chris R.T. YOUNG"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Chris R.T.", particle: nil, family: "Young", suffix: nil })
      end

      it "should capitalize names like 'CHRIS R.T. YOUNG'" do
        input = "CHRIS R.T. YOUNG"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Chris R.T.", particle: nil, family: "Young", suffix: nil })
      end

      it "should properly handle and capitalize utf-8 characters" do
        input = "Sicard, Léas"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Léas", particle: nil, family: "Sicard", suffix: nil })
      end

      it "should ignore poorly parsed names with long given names and many periods" do
        input = "J. Green; R. Driskill; J. W. Markham L. D. Druehl"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[2]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil })
      end

      it "should ignore names with 'the'" do
        input = "The old bird was dead"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil })
      end

      it "should ignore names with 'unidentified'" do
        input = "Unidentified Beetle"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil })
      end

      it "should ignore names with American State University" do
        input = "R. G. Helgesen : North Dakota State University"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "R.G.", particle: nil, family: "Helgesen", suffix: nil })
      end

      it "should clean Jr suffix" do
        input = "Abner Kingman, Jr.; Gary D. Alpert"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Abner", particle: nil, family: "Kingman", suffix: "Jr." })
        expect(cleaner.clean(parsed[1]).to_h).to eq({ title: nil, appellation: nil, given: "Gary D.", particle: nil, family: "Alpert", suffix: nil })
      end

      it "should ignore 'popa observers'" do
        input = "popa observers"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil })
      end

      it "should ignore instances of word 'exchange'" do
        input = "Butcher, N.; Dominion exchange"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "N.", particle: nil, family: "Butcher", suffix: nil })
        expect(cleaner.clean(parsed[1]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil })
      end

      it "should remove asterisks from a name" do
        input = "White*"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: "White", suffix: nil })
      end

      it "should remove 'purchased'" do
        input = "Purchased by A. E. Jamrach."
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "A.E.", particle: nil, family: "Jamrach", suffix: nil })
      end

      it "should split with 'communicated to' in text" do
        input = "Huber Moore; communicatd to Terry M. Taylor"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(cleaner.clean(parsed[1]).to_h).to eq({ title: nil, appellation: nil, given: "Terry M.", particle: nil, family: "Taylor", suffix: nil })
      end

      it "should ignore a three letter family name without vowels" do
        input = "Jack Wft"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Jack", particle: nil, family: "Wft", suffix: nil })
      end

      it "should accept a three letter family name with a vowel" do
        input = "Jack Wit"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Jack", particle: nil, family: "Wit", suffix: nil })
      end

      it "should not split a string of names with A." do
        input = "R.K. A. Godfrey"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "R.K.A.", particle: nil, family: "Godfrey", suffix: nil })
      end

      it "should not ignore the name Paula Maybee" do
        input = "Paula Maybee"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Paula", particle: nil, family: "Maybee", suffix: nil })
      end

      it "it should not ignore the word maybe" do
        input = "Paula Maybee maybe"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Paula", particle: nil, family: "Maybee", suffix: nil })
      end

      it "should ignore a family name with CAPs at end" do
        input = "Jack SmitH"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil })
      end

      it "should ignore a family name with two CAPs at the beginning" do
        input = "RGBennett"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil })
      end

      it "should normalize a name all in caps, written in reverse order" do
        input = "SOSIAK, MACLENNAN"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: 'MacLennan', particle: nil, family:'Sosiak', suffix: nil })
      end

      it "should normalize a name all in lowercase" do
        input = "beulah garner"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: 'Beulah', particle: nil, family:'Garner', suffix: nil })
      end

      it "should clean a name whose given initials lack punctuation" do
        input = "A A Court"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: 'A.A.', particle: nil, family:'Court', suffix: nil })
      end

      it "should clean a name whose given initials lack punctuation" do
        input = "Abreu, M.C"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: 'M.C.', particle: nil, family:'Abreu', suffix: nil })
      end

      it "should remove anything between brackets" do
        input = "Michael (Mike) Smith"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: 'Michael', particle: nil, family: 'Smith', suffix: nil })
      end

      it "should remove Ded:" do
        input = "Ded: A.E. Nordenskiöld (V"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: 'A.E.', particle: nil, family: 'Nordenskiöld', suffix: nil })
      end

      it "should remove another variant of ded" do
        input = "Lagerström, H (Ded.)"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: 'H.', particle: nil, family: 'Lagerström', suffix: nil })
      end

      it "should remove yet another variant of ded and parse the remains" do
        input = "Richt, L & S Jansson (ded"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[1]).to_h).to eq({ title: nil, appellation: nil, given: 'S.', particle: nil, family: 'Jansson', suffix: nil })
      end

      it "should remove extraneous information with brackets at end of string" do
        input = "J. Lindahl (Ingegerd & Gl"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: 'J.', particle: nil, family: 'Lindahl', suffix: nil })
      end

      it "should remove Coll in brackets" do
        input = "D.Podlech (Coll. M, MSB)"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: 'D.', particle: nil, family: 'Podlech', suffix: nil })
      end

      it "should remove nickname in brackets at end of string" do
        input = "Michael Smith (Mike)"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: 'Michael', particle: nil, family: 'Smith', suffix: nil })
      end

      it "should remove extra content in brackets" do
        input = "Triplehorn, W. E. (Wanda Elaine) & Triplehorn, C."
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: 'W.E.', particle: nil, family: 'Triplehorn', suffix: nil })
        expect(cleaner.clean(parsed[1]).to_h).to eq({ title: nil, appellation: nil, given: 'C.', particle: nil, family: 'Triplehorn', suffix: nil })
      end

      it "should remove content within square brackets" do
        input = "A. ORTEGA [INTERCAMBIO MA-VIT]"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: 'A.', particle: nil, family: 'Ortega', suffix: nil })
      end

      it "should remove stray dashes and dots at the beginning of a string" do
        input = "-. Alfonso"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: 'Alfonso', suffix: nil })
      end

      it "should remove stray asterisks at the beginnning of a string" do
        input = "* SCHUCH"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: 'Schuch', suffix: nil })
      end

      it "should remove content prefixed by curly brackets" do
        input = "{Illegible]"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(0)
      end

      it "should remove any period after a number" do
        input = "B. Maguire 2375.4"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "B.", particle: nil, family: 'Maguire', suffix: nil })
      end

      it "should remove any period after a number and then remove trailing semicolon" do
        input = "B. Maguire; 2375.4"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "B.", particle: nil, family: 'Maguire', suffix: nil })
      end

      it "should remove via at end of string" do
        input = "B. Maguire via"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "B.", particle: nil, family: 'Maguire', suffix: nil })
      end

      it "should remove semicolon at start and messes elsewhere" do
        input = "; annot. J. Walter (W) 2017-04"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "J.", particle: nil, family: 'Walter', suffix: nil })
      end

      it "should ignore dashes in weird places" do
        input = "-. Borja; -- Rivet & Galiano"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(3)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: "Borja", suffix: nil })
      end

      it "should not mess with initials when there are three" do
        input = "A.J.E.Smith"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "A.J.E.", particle: nil, family: "Smith", suffix: nil })
      end

      it "should not mess with very small family names" do
        input = "Wen-Bin Yu"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Wen-Bin", particle: nil, family: "Yu", suffix: nil })
      end

      it "should not ignore names that have russia in them" do
        input = "Choumovitch, W.; Settler, Russias"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "W.", particle: nil, family: "Choumovitch", suffix: nil })
        expect(cleaner.clean(parsed[1]).to_h).to eq({ title: nil, appellation: nil, given: "Russias", particle: nil, family: "Settler", suffix: nil })
      end

      it "should ignore affiliations with UNITED STATES" do
        input = "Upchurch, Garland R., Jr. - Texas State University (UNITED STATES)"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Garland R.", particle: nil, family: "Upchurch", suffix: "Jr." })
      end

      it "should strip out country names like Poland" do
        input = "Piotr Zuchlinski, Poland"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Piotr", particle: nil, family: "Zuchlinski", suffix: nil })
      end

      it "should strip out other country names entirely like Belgium" do
        input = "Belgium"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(0)
      end

      it "should accept given name that is less than or equal to 25 characters" do
        input = "Jean-Baptiste Leschenault de La Tour"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Jean-Baptiste Leschenault", particle: "de", family: "La Tour", suffix: nil })
      end

      it "should reject given name that is greater than 35 characters" do
        input = "Jean-Baptiste Leschenaults François Hulle de La Tour"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil })
      end

      it "should strip out the terminal particle" do
        input = "Andrade JC de"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "J.C.", particle: nil, family: "Andrade", suffix: nil })
      end

      it "should ignore a single paricle purported to be a name" do
        input = "Robillard|de"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: "Robillard", suffix: nil })
        expect(cleaner.clean(parsed[1]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil })
      end

      it "should recognize Lord as a middle name" do
        input = "Nathaniel Lord Britton"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Nathaniel Lord", particle: nil, family: "Britton", suffix: nil })
      end

      it "should recognize Professor as a title" do
        input = "Professor Nathaniel Britton"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: "Professor", appellation: nil, given: "Nathaniel", particle: nil, family: "Britton", suffix: nil })
      end

      it "should recognize Prof. as a title" do
        input = "Prof. Nathaniel Britton"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: "Prof.", appellation: nil, given: "Nathaniel", particle: nil, family: "Britton", suffix: nil })
      end

      it "should recognize Sir as a title" do
        input = "Sir Nathaniel Britton"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: "Sir", appellation: nil, given: "Nathaniel", particle: nil, family: "Britton", suffix: nil })
      end

      it "should return a blank name when family name is 'der'" do
        input = "Baan M van der"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil })
      end

      it "should return a blank name when family name is 'der'" do
        input = "Baan M van der"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil })
      end

      it "should return a blank name when family name is 'von'" do
        input = "Baer K.E. von"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil })
      end

      it " should return a blank name when family is 'Catalog'" do
        input = 'Catalog\1996'
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil })
      end

      it "should ignore [no data]" do
        input = "[no data]"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil })
      end

      it "should ignore [no disponible]" do
        input = "[no disponible]"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil })
      end

      it "should ignore [no data available]" do
        input = "[no data available]"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil })
      end

      it "should ignore [no agent data]" do
        input = "[no agent data]"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil })
      end

      it "should ignore DATA NOT CAPTURED" do
        input = "DATA NOT CAPTURED"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil })
      end

      it "should ignore 'Curators of USNM'" do
        input = "Curators of USNM"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil })
      end

      it "should ignore 'C. N. C. Curators'" do
        input = "C. N. C. Curators"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil })
      end

      it "should ignore 'Administrador'" do
        input = "Administrador"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil })
      end

      it "should ignore 'nomenclatural adjustment'" do
        input = "nomenclatural adjustment"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil })
      end

      it "should ignore 'not available'" do
        input = "not available"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil })
      end

      it "should ignore '[sequence data]'" do
        input = "[sequence data]"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil })
      end

      it "should recognize two family names without provided given names" do
        input = "Jackson and Peterson"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: "Jackson", suffix: nil })
        expect(cleaner.clean(parsed[1]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: "Peterson", suffix: nil })
      end

      it "should ignore 'Texas Instruments'" do
        input = "Texas Instruments For BLM"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil })
      end

      it "should reject '[Collector has not been verified and entered]'" do
        input = "[Collector has not been verified and entered]"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil })
        expect(cleaner.clean(parsed[1]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil })
      end

      it "should ignore échangé" do
        input = "échangé : B. Lanza"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil })
        expect(cleaner.clean(parsed[1]).to_h).to eq({ title: nil, appellation: nil, given: "B.", particle: nil, family: "Lanza", suffix: nil })
      end

      it "should ignore élève" do
        input = "Luc Rousseau, élève"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Luc", particle: nil, family: "Rousseau", suffix: nil })
        expect(cleaner.clean(parsed[1]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil })
      end

      it "should ignore éleveur" do
        input = "Francis GIRARD, éleveur"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Francis", particle: nil, family: "Girard", suffix: nil })
        expect(cleaner.clean(parsed[1]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil })
      end

      it "should ignore no coll." do
        input = "no coll."
        parsed = parser.parse(input)
        expect(parsed.size).to eq(0)
      end

      it "should ignore no collector" do
        input = "no collector"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(0)
      end

      it "should strip out square brackets and question mark" do
        input = "[A. Pront]?"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "A.", particle: nil, family: "Pront", suffix: nil })
      end

      it "should strip out square brackets around parts of a name" do
        input = "[Macoun], J."
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "J.", particle: nil, family: "Macoun", suffix: nil })
      end

      it "should strip out a whole bunch of junk" do
        input = "David##{} P. @%%Shorthouse"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "David P.", particle: nil, family: "Shorthouse", suffix: nil })
      end

      it "should strip out illisible" do
        input = "[illisible]"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(0)
      end

      it "should ignore 'No consta'" do
        input = "No consta"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil })
      end

      it "should reject a name like BgWd0062" do
        input = "BgWd0062"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil })
      end

      it "should retain appellation after cleaning" do
        input = "Mrs. James de Mornay"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: "Mrs.", given: "James", particle: "de", family: "Mornay", suffix: nil })
      end

      it "should retain title and suffix after cleaning" do
        input = "Dr. James Mornay Jr."
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: "Dr.", appellation: nil, given: "James", particle: nil, family: "Mornay", suffix: "Jr." })
      end

      it "should reject 'Illegible determiner name'" do
        input = "Illegible determiner name"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil })
      end

      it "should reject 'Illegible annotator name'" do
        input = "Illegible annotator name"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil })
      end

      it "should reject 'Collector Name Erased'" do
        input = "Collector Name Erased"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil })
      end

      it "should reject 'details lost'" do
        input = "details lost"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil })
      end

      it "should not reject 'E.V.C. Lost'" do
        input = "E.V.C. Lost"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "E.V.C.", particle: nil, family: "Lost", suffix: nil })
      end

      it "should not reject 'Name, T.F.'" do
        input = "Name, T.F."
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "T.F.", particle: nil, family: "Name", suffix: nil })
      end

      it "should not reject 'ALQthanin'" do
        input = "Rahmah Nasser ALQthanin"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Rahmah Nasser", particle: nil, family: "ALQthanin", suffix: nil })
      end

      it "should strip out extra dots at the end of a name" do
        input = "J. Jerratyka.."
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "J.", particle: nil, family: "Jerratyka", suffix: nil })        
      end

    end

  end
end

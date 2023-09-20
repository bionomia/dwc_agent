module DwcAgent
  describe 'Cleaner' do
    let(:parser) { Parser.instance }
    let(:cleaner) { Cleaner.instance }

    before(:all) do
      @blank_name = { title: nil, appellation: nil, given: nil, particle: nil, family: nil, suffix: nil, dropping_particle: nil, nick: nil }
    end

    describe "Clean results from the Parser" do

      it "should clean a name with two given names" do
        input = "William Leo Smith"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "William Leo", particle: nil, family: "Smith", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should reject a name that has 'Department' in it" do
        input = "Oregon Department of Agriculture"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq(@blank_name)
      end

      it "should capitalize mistaken lowercase first initials" do
        input = "r.C. Smith"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given:"R.C.", particle: nil, family:"Smith", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should clean family names with extraneous period" do
        input = "C. Tanner."
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given:'C.', particle: nil, family: 'Tanner', suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should remove extraneous capitalized letters within brackets" do
        input = "!B. P. J. Molloy (CHR)"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given:'B.P.J.',  particle: nil, family: 'Molloy', suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should remove 1st" do
        input = "Beatty, G.H., 1st"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given:'G.H.',  particle: nil, family: 'Beatty', suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should remove 4th" do
        input = "G.H. Beatty 4th"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given:'G.H.',  particle: nil, family: 'Beatty', suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should remove 3rd" do
        input = "G.H. Beatty 3rd"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given:'G.H.',  particle: nil, family: 'Beatty', suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should recognize a single name as a family name" do
        input = "Tanner"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: 'Tanner', suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should normalize a name all in caps" do
        input = "WILLIAM BEEBE"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: 'William', particle: nil, family:'Beebe', suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should remove aboard" do
        input = "D. Nabeshima, aboard longline vessel \"Mokihana\""
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given:'D.',  particle: nil, family: 'Nabeshima', suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should remove brackets from name" do
        input = "W.P. Coreneuk(?)"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: 'W.P.', particle: nil, family:'Coreneuk', suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should not explode by E" do
        input = "Jack E Smith"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Jack E.", particle: nil, family: "Smith", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should parse name with many given initials" do
        input = "FAH Sperling"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "F.A.H.", particle: nil, family: "Sperling", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should preserve caps in family names" do
        input = "Chris MacQuarrie"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Chris", particle: nil, family: "MacQuarrie", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should recognize a religious suffix like Marie-Victorin, frère and treat it as a given name" do
        input = "Marie-Victorin, frère"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Frère", particle: nil, family: "Marie-Victorin", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should strip out 'synonymie'" do
        input = "Université Laval - synonymie"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq(@blank_name)
      end

      it "should explode names with spaces missing surrounding ampersand" do
        input = "Henrik Andersen&jon Feilberg"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[1]).to_h).to eq({ title: nil, appellation: nil, given: "Jon", particle: nil, family: "Feilberg", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should explode a messy list" do
        input = "Winterbottom, R.;Katz, L.;& CI team"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[2]).to_h).to eq(@blank_name)
      end

      it "should ignore 'non précisé'" do
        input = "non précisé"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq(@blank_name)
      end

      it "should ignore '[Not Stated]'" do
        input = "[Not Stated]"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq(@blank_name)
      end

      it "should parse name with given initials without period(s)" do
        input = "JH Picard"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "J.H.", particle: nil, family: "Picard", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should reverse the order when family name is parsed as uppercase initials" do
        input = "Lepschi BJ; Albrecht DE"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "B.J.", particle: nil, family: "Lepschi", suffix: nil, dropping_particle: nil, nick: nil })
        expect(cleaner.clean(parsed[1]).to_h).to eq({ title: nil, appellation: nil, given: "D.E.", particle: nil, family: "Albrecht", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should parse name when given is initalized and order is reversed without separator" do
        input = "Picard J.H."
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "J.H.", particle: nil, family: "Picard", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should capitalize surnames like 'Jack smith'" do
        input = "Jack smith"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Jack", particle: nil, family: "Smith", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should capitalize names like 'C. YOUNG'" do
        input = "C. YOUNG"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "C.", particle: nil, family: "Young", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should flip a name like 'Groom Q.'" do
        input = "Groom Q."
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Q.", particle: nil, family: "Groom", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should flip a name like 'Raes N'" do
        input = "Raes N"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "N.", particle: nil, family: "Raes", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should flip a name like 'Slik JWF'" do
        input = "Slik JWF"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "J.W.F.", particle: nil, family: "Slik", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should capitalize names like 'Chris R.T. YOUNG'" do
        input = "Chris R.T. YOUNG"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Chris R.T.", particle: nil, family: "Young", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should capitalize names like 'CHRIS R.T. YOUNG'" do
        input = "CHRIS R.T. YOUNG"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Chris R.T.", particle: nil, family: "Young", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should properly handle and capitalize utf-8 characters" do
        input = "Sicard, Léas"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Léas", particle: nil, family: "Sicard", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should ignore poorly parsed names with long given names and many periods" do
        input = "J. Green; R. Driskill; J. W. Markham L. D. Druehl"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[2]).to_h).to eq(@blank_name)
      end

      it "should ignore names with 'the'" do
        input = "The old bird was dead"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq(@blank_name)
      end

      it "should ignore names with 'unidentified'" do
        input = "Unidentified Beetle"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq(@blank_name)
      end

      it "should ignore names with American State University" do
        input = "R. G. Helgesen : North Dakota State University"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "R.G.", particle: nil, family: "Helgesen", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should clean Jr suffix" do
        input = "Abner Kingman, Jr.; Gary D. Alpert"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Abner", particle: nil, family: "Kingman", suffix: "Jr.", dropping_particle: nil, nick: nil })
        expect(cleaner.clean(parsed[1]).to_h).to eq({ title: nil, appellation: nil, given: "Gary D.", particle: nil, family: "Alpert", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should ignore 'popa observers'" do
        input = "popa observers"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq(@blank_name)
      end

      it "should ignore instances of word 'exchange'" do
        input = "Butcher, N.; Dominion exchange"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "N.", particle: nil, family: "Butcher", suffix: nil, dropping_particle: nil, nick: nil })
        expect(cleaner.clean(parsed[1]).to_h).to eq(@blank_name)
      end

      it "should remove asterisks from a name" do
        input = "White*"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: "White", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should remove 'purchased'" do
        input = "Purchased by A. E. Jamrach."
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "A.E.", particle: nil, family: "Jamrach", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should split with 'communicated to' in text" do
        input = "Huber Moore; communicatd to Terry M. Taylor"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(cleaner.clean(parsed[1]).to_h).to eq({ title: nil, appellation: nil, given: "Terry M.", particle: nil, family: "Taylor", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should ignore a three letter family name without vowels" do
        input = "Jack Wft"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Jack", particle: nil, family: "Wft", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should accept a three letter family name with a vowel" do
        input = "Jack Wit"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Jack", particle: nil, family: "Wit", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should not split a string of names with A." do
        input = "R.K. A. Godfrey"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "R.K.A.", particle: nil, family: "Godfrey", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should not ignore the name Paula Maybee" do
        input = "Paula Maybee"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Paula", particle: nil, family: "Maybee", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "it should not ignore the word maybe" do
        input = "Paula Maybee maybe"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Paula", particle: nil, family: "Maybee", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should fix a family name with CAPs at end" do
        input = "Jack SmitH"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Jack", particle: nil, family: "Smith", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should ignore a family name with two CAPs at the beginning" do
        input = "RGBennett"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq(@blank_name)
      end

      it "should normalize a name all in caps, written in reverse order" do
        input = "SOSIAK, MACLENNAN"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: 'MacLennan', particle: nil, family:'Sosiak', suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should normalize a name all in lowercase" do
        input = "beulah garner"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: 'Beulah', particle: nil, family:'Garner', suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should clean a name whose given initials lack punctuation" do
        input = "A A Court"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: 'A.A.', particle: nil, family:'Court', suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should clean a name whose given initials lack punctuation" do
        input = "Abreu, M.C"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: 'M.C.', particle: nil, family:'Abreu', suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should remove anything between brackets" do
        input = "Michael (Mike) Smith"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: 'Michael', particle: nil, family: 'Smith', suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should remove Ded:" do
        input = "Ded: A.E. Nordenskiöld (V"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: 'A.E.', particle: nil, family: 'Nordenskiöld', suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should remove another variant of ded" do
        input = "Lagerström, H (Ded.)"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: 'H.', particle: nil, family: 'Lagerström', suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should remove yet another variant of ded and parse the remains" do
        input = "Richt, L & S Jansson (ded"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[1]).to_h).to eq({ title: nil, appellation: nil, given: 'S.', particle: nil, family: 'Jansson', suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should remove extraneous information with brackets at end of string" do
        input = "J. Lindahl (Ingegerd & Gl"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: 'J.', particle: nil, family: 'Lindahl', suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should remove Coll in brackets" do
        input = "D.Podlech (Coll. M, MSB)"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: 'D.', particle: nil, family: 'Podlech', suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should remove nickname in brackets at end of string" do
        input = "Michael Smith (Mike)"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: 'Michael', particle: nil, family: 'Smith', suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should remove extra content in brackets" do
        input = "Triplehorn, W. E. (Wanda Elaine) & Triplehorn, C."
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: 'W.E.', particle: nil, family: 'Triplehorn', suffix: nil, dropping_particle: nil, nick: nil })
        expect(cleaner.clean(parsed[1]).to_h).to eq({ title: nil, appellation: nil, given: 'C.', particle: nil, family: 'Triplehorn', suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should remove content within square brackets" do
        input = "A. ORTEGA [INTERCAMBIO MA-VIT]"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: 'A.', particle: nil, family: 'Ortega', suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should remove stray dashes and dots at the beginning of a string" do
        input = "-. Alfonso"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: 'Alfonso', suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should remove stray asterisks at the beginnning of a string" do
        input = "* SCHUCH"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: 'Schuch', suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should remove content prefixed by curly brackets" do
        input = "{Illegible]"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(0)
      end

      it "should remove any period after a number" do
        input = "B. Maguire 2375.4"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "B.", particle: nil, family: 'Maguire', suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should remove any period after a number and then remove trailing semicolon" do
        input = "B. Maguire; 2375.4"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "B.", particle: nil, family: 'Maguire', suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should remove via at end of string" do
        input = "B. Maguire via"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "B.", particle: nil, family: 'Maguire', suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should remove semicolon at start and messes elsewhere" do
        input = "; annot. J. Walter (W) 2017-04"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "J.", particle: nil, family: 'Walter', suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should ignore dashes in weird places" do
        input = "-. Borja; -- Rivet & Galiano"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(3)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: "Borja", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should not mess with initials when there are three" do
        input = "A.J.E.Smith"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "A.J.E.", particle: nil, family: "Smith", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should not mess with very small family names" do
        input = "Wen-Bin Yu"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Wen-Bin", particle: nil, family: "Yu", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should not ignore names that have russia in them" do
        input = "Choumovitch, W.; Settler, Russias"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "W.", particle: nil, family: "Choumovitch", suffix: nil, dropping_particle: nil, nick: nil })
        expect(cleaner.clean(parsed[1]).to_h).to eq({ title: nil, appellation: nil, given: "Russias", particle: nil, family: "Settler", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should ignore affiliations with UNITED STATES" do
        input = "Upchurch, Garland R., Jr. - Texas State University (UNITED STATES)"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Garland R.", particle: nil, family: "Upchurch", suffix: "Jr.", dropping_particle: nil, nick: nil })
      end

      it "should strip out country names like Poland" do
        input = "Piotr Zuchlinski, Poland"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Piotr", particle: nil, family: "Zuchlinski", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should strip out other country names entirely like Germany" do
        input = "Germany"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(0)
      end

      it "should accept given name that is less than or equal to 25 characters" do
        input = "Jean-Baptiste Leschenault de La Tour"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Jean-Baptiste Leschenault", particle: "de La", family: "Tour", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should reject given name that is greater than 35 characters" do
        input = "Jean-Baptiste Leschenaults François Hulle de La Tour"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq(@blank_name)
      end

      it "should strip out the terminal particle" do
        input = "Andrade JC de"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "J.C.", particle: nil, family: "Andrade", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should ignore a single particle purported to be a name" do
        input = "Robillard|de"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: "Robillard", suffix: nil, dropping_particle: nil, nick: nil })
        expect(cleaner.clean(parsed[1]).to_h).to eq(@blank_name)
      end

      it "should recognize Lord as a middle name" do
        input = "Nathaniel Lord Britton"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Nathaniel Lord", particle: nil, family: "Britton", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should recognize Professor as a title" do
        input = "Professor Nathaniel Britton"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: "Professor", appellation: nil, given: "Nathaniel", particle: nil, family: "Britton", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should recognize Prof. as a title" do
        input = "Prof. Nathaniel Britton"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: "Prof.", appellation: nil, given: "Nathaniel", particle: nil, family: "Britton", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should recognize Sir as a title" do
        input = "Sir Nathaniel Britton"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: "Sir", appellation: nil, given: "Nathaniel", particle: nil, family: "Britton", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should return a blank name when family name is 'der'" do
        input = "Baan M van der"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "M.", particle: "van der", family: "Baan", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it " should return a blank name when family is 'Catalog'" do
        input = 'Catalog\1996'
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq(@blank_name)
      end

      it "should ignore [no data]" do
        input = "[no data]"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq(@blank_name)
      end

      it "should ignore [no disponible]" do
        input = "[no disponible]"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq(@blank_name)
      end

      it "should ignore [no data available]" do
        input = "[no data available]"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq(@blank_name)
      end

      it "should ignore [no agent data]" do
        input = "[no agent data]"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq(@blank_name)
      end

      it "should ignore DATA NOT CAPTURED" do
        input = "DATA NOT CAPTURED"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq(@blank_name)
      end

      it "should ignore 'Curators of USNM'" do
        input = "Curators of USNM"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq(@blank_name)
      end

      it "should ignore 'C. N. C. Curators'" do
        input = "C. N. C. Curators"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq(@blank_name)
      end

      it "should ignore 'Administrador'" do
        input = "Administrador"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq(@blank_name)
      end

      it "should ignore 'nomenclatural adjustment'" do
        input = "nomenclatural adjustment"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq(@blank_name)
      end

      it "should ignore 'not available'" do
        input = "not available"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq(@blank_name)
      end

      it "should ignore '[sequence data]'" do
        input = "[sequence data]"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq(@blank_name)
      end

      it "should remove 'collector field number:' to end of string" do
        input = "R.M. Bailey | collector field number: C-5"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
      end

      it "should recognize two family names without provided given names" do
        input = "Jackson and Peterson"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: "Jackson", suffix: nil, dropping_particle: nil, nick: nil })
        expect(cleaner.clean(parsed[1]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: "Peterson", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should ignore 'Texas Instruments'" do
        input = "Texas Instruments For BLM"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq(@blank_name)
      end

      it "should reject '[Collector has not been verified and entered]'" do
        input = "[Collector has not been verified and entered]"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(cleaner.clean(parsed[0]).to_h).to eq(@blank_name)
        expect(cleaner.clean(parsed[1]).to_h).to eq(@blank_name)
      end

      it "should ignore échangé" do
        input = "échangé : B. Lanza"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(cleaner.clean(parsed[0]).to_h).to eq(@blank_name)
        expect(cleaner.clean(parsed[1]).to_h).to eq({ title: nil, appellation: nil, given: "B.", particle: nil, family: "Lanza", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should ignore élève" do
        input = "Luc Rousseau, élève"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Luc", particle: nil, family: "Rousseau", suffix: nil, dropping_particle: nil, nick: nil })
        expect(cleaner.clean(parsed[1]).to_h).to eq(@blank_name)
      end

      it "should ignore éleveur" do
        input = "Francis GIRARD, éleveur"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Francis", particle: nil, family: "Girard", suffix: nil, dropping_particle: nil, nick: nil })
        expect(cleaner.clean(parsed[1]).to_h).to eq(@blank_name)
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
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "A.", particle: nil, family: "Pront", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should strip out square brackets around parts of a name" do
        input = "[Macoun], J."
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "J.", particle: nil, family: "Macoun", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should strip out a whole bunch of junk" do
        input = "David##{} P. @%%Shorthouse"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "David P.", particle: nil, family: "Shorthouse", suffix: nil, dropping_particle: nil, nick: nil })
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
        expect(cleaner.clean(parsed[0]).to_h).to eq(@blank_name)
      end

      it "should reject a name like BgWd0062" do
        input = "BgWd0062"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq(@blank_name)
      end

      it "should retain appellation after cleaning" do
        input = "Mrs. James de Mornay"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: "Mrs.", given: "James", particle: "de", family: "Mornay", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should retain title and suffix after cleaning" do
        input = "Dr. James Mornay Jr."
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: "Dr.", appellation: nil, given: "James", particle: nil, family: "Mornay", suffix: "Jr.", dropping_particle: nil, nick: nil })
      end

      it "should add a space after Dr." do
        input = "Dr.G.A. Williams"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: "Dr.", appellation: nil, given: "G.A.", particle: nil, family: "Williams", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should still parse Dr. even if two spaces are created as a result of cleaning" do
        input = "Dr. G.A. Williams"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: "Dr.", appellation: nil, given: "G.A.", particle: nil, family: "Williams", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should reject 'Illegible determiner name'" do
        input = "Illegible determiner name"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq(@blank_name)
      end

      it "should reject 'Illegible annotator name'" do
        input = "Illegible annotator name"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq(@blank_name)
      end

      it "should reject 'Collector Name Erased'" do
        input = "Collector Name Erased"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq(@blank_name)
      end

      it "should reject 'details lost'" do
        input = "details lost"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq(@blank_name)
      end

      it "should not reject 'E.V.C. Lost'" do
        input = "E.V.C. Lost"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "E.V.C.", particle: nil, family: "Lost", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should not reject 'Name, T.F.'" do
        input = "Name, T.F."
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "T.F.", particle: nil, family: "Name", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should not reject 'ALQthanin'" do
        input = "Rahmah Nasser ALQthanin"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Rahmah Nasser", particle: nil, family: "ALQthanin", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should strip out extra dots at the end of a name" do
        input = "J. Jerratyka.."
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "J.", particle: nil, family: "Jerratyka", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should strip out 'C. Pau 1aaa-05'" do
        input = "C. Pau 1aaa-05"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "C.", particle: nil, family: "Pau", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should strip out 'AA4'" do
        input = "Aysan Y. AA4"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Y.", particle: nil, family: "Aysan", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should strip out '2015bb'" do
        input = "B.L. Isaac 2015bb"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "B.L.", particle: nil, family: "Isaac", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should strip out 'CC111'" do
        input = "Glaux C. CC111"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "C.", particle: nil, family: "Glaux", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should recognize 'Aa' as a family" do
        input = "Van Der Aa"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: "Van Der", family: "Aa", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should strip out 'malacology'" do
        input = "Ms. Alison Clair Miller - Australian Museum - Malacology"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(3)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: "Ms.", given: "Alison Clair", particle: nil, family: "Miller", suffix: nil, dropping_particle: nil, nick: nil })
        expect(cleaner.clean(parsed[1]).to_h).to eq(@blank_name)
        expect(cleaner.clean(parsed[2]).to_h).to eq(@blank_name)
      end

      it "should strip out :EXCH" do
        input = "THOMAS BOWN: EXCH"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq( { title: nil, appellation: nil, given: "Thomas", particle: nil, family: "Bown", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should strip out ex herb." do
        input = "ex herb. A. Braun"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq( { title: nil, appellation: nil, given: "A.", particle: nil, family: "Braun", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should strip out 'in Hb. Buschardt'" do
        input = "J. Poelt & A. Buschardt in Hb. Buschardt"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(cleaner.clean(parsed[0]).to_h).to eq( { title: nil, appellation: nil, given: "J.", particle: nil, family: "Poelt", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should treat a lowercase v. as a particle" do
        input = "G. v. Reenen"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq( { title: nil, appellation: nil, given: "G.", particle: "v.", family: "Reenen", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should not treat a lowercase v. as a particle when other lowercase initials are present" do
        input = "g. v. reenen"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq( { title: nil, appellation: nil, given: "G. v.", particle: nil, family: "Reenen", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should strip out fisherman" do
        input = "Sudanese fisherman, via J.E. Randall"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(cleaner.clean(parsed[0]).to_h).to eq(@blank_name)
      end

      it "should consider the name O'Keefe a family name" do
        input = "O'Keefe"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: nil, particle: nil, family: "O'Keefe", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should handle a name in reverse order with a comma and a particle" do
        input = "da Torre, A.R."
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "A.R.", particle: "da", family: "Torre", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should handle a name in reverse order without a comma and a particle" do
        input = "da Torre A.R."
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "A.R.", particle: "da", family: "Torre", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should handle two sets of names in reverse order, one of which with a particle" do
        input = "da Torre A.R. & Correia M.P."
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "A.R.", particle: "da", family: "Torre", suffix: nil, dropping_particle: nil, nick: nil })
        expect(cleaner.clean(parsed[1]).to_h).to eq({ title: nil, appellation: nil, given: "M.P.", particle: nil, family: "Correia", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should parse the name 'Berthe Hoola van Nooten'" do
        input = "Berthe Hoola van Nooten"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Berthe Hoola", particle: "van", family: "Nooten", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should parse the name 'Angela Iran Esquivel'" do
        input = "Angela Iran Esquivel"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Angela Iran", particle: nil, family: "Esquivel", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should pass through a nickname" do
        input = "David 'Dave' Jackson"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "David", particle: nil, family: "Jackson", suffix: nil, dropping_particle: nil, nick: "Dave" })
      end

      it "should parse a compound name in reverse order" do
        input = "A. Cano, E."
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "E.", particle: nil, family: "A. Cano", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should recognize a lowercase prof. as a title" do
        input = "prof.D.Lochman"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: "Prof.", appellation: nil, given: "D.", particle: nil, family: "Lochman", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should recognize an Mrs. as an appellation when in reverse order" do
        input = "Whitney, Mrs. W. W."
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: "Mrs.", given: "W.W.", particle: nil, family: "Whitney", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should recognize a MR. as an appellation when in reverse order and in caps" do
        input = "WIBLE, MRS. P."
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: "MRS.", given: "P.", particle: nil, family: "Wible", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should not strip out a name that contains 'anon'" do
        input = "R. Salanon"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "R.", particle: nil, family: "Salanon", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should recognize 'anon' as a blacklisted name" do
        input = "anon"
        parsed = parser.parse(input)
        expect(cleaner.clean(parsed[0]).to_h).to eq(@blank_name)
      end

      it "should not ignore a name like 'L.E. Bureau'" do
        input = "L.E. Bureau"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "L.E.", particle: nil, family: "Bureau", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should not ignore a name like 'Guaglianone,E.R.'" do
        input = "Guaglianone,E.R."
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "E.R.", particle: nil, family: "Guaglianone", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should not ignore a name like 'P. Classe'" do
        input = "P. Classe"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "P.", particle: nil, family: "Classe", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should not ignore a name like 'J.B.L. Companyo'" do
        input = "J.B.L. Companyo"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "J.B.L.", particle: nil, family: "Companyo", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should not ignore a name like 'Theodor Schube'" do
        input = "Theodor Schube"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Theodor", particle: nil, family: "Schube", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should ignore 'staff' as a name" do
        input = "Jacob Wheeler and staff"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "Jacob", particle: nil, family: "Wheeler", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should ignore 'Graduate Students' as a name" do
        input = "Graduate Students, Joanna Smith and R. Jackson"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(3)
        expect(cleaner.clean(parsed[0]).to_h).to eq(@blank_name)
        expect(cleaner.clean(parsed[1]).to_h).to eq({ title: nil, appellation: nil, given: "Joanna", particle: nil, family: "Smith", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should not ignore a name that contains the text 'staff'" do
        input = "M.L. Blickenstaff"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "M.L.", particle: nil, family: "Blickenstaff", suffix: nil, dropping_particle: nil, nick: nil })        
      end

      it "should not ignore 'Poindexter, D.B.'" do
        input = 'Poindexter, D.B.'
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "D.B.", particle: nil, family: "Poindexter", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should not ignore 'Bieberstein,F.A. Marschall v.'" do
        input = 'Bieberstein,F.A. Marschall v.'
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "F. A. Marschall", particle: "v.", family: "Bieberstein", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should not ignore 'Galán,P. & Montenegro,S.M.'" do
        input = 'Galán,P. & Montenegro,S.M.'
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "P.", particle: nil, family: "Galán", suffix: nil, dropping_particle: nil, nick: nil })
        expect(cleaner.clean(parsed[1]).to_h).to eq({ title: nil, appellation: nil, given: "S.M.", particle: nil, family: "Montenegro", suffix: nil, dropping_particle: nil, nick: nil })
      end

      it "should not ignore 'N.H. Le'" do
        input = 'N.H. Le'
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(cleaner.clean(parsed[0]).to_h).to eq({ title: nil, appellation: nil, given: "N.H.", particle: nil, family: "Le", suffix: nil, dropping_particle: nil, nick: nil })
      end

    end

  end
end

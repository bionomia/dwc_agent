module DwcAgent
  describe 'Parser' do
    let(:parser) { Parser.instance }

    describe "Parse people names from DwC terms" do

      it "should return an empty array if nil is passed" do
        input = nil
        parsed = parser.parse(input)
        expect(parsed).to eq([])
      end

      it "should return an empty array if an empty string is passed" do
        input = ""
        parsed = parser.parse(input)
        expect(parsed).to eq([])
      end

      it "should reject a name that has 'Canadian Museum of Nature'" do
        input = "Jeff Saarela; Canadian Museum of Nature"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(["Jeff", "Saarela"])
      end

      it "should remove 'first name unknown'" do
        input = "First Name Unknown|Robert Martin"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
      end

      it "should reject 'no name given'" do
        input = "no name given"
        parsed = parser.parse(input)
        expect(parsed).to eq([])
      end

      it "should reject 'not given'" do
        input = "not given"
        parsed = parser.parse(input)
        expect(parsed).to eq([])
      end

      it "should remove 'ohne angaben' (= without disclosure)" do
        input = "ohne angaben"
        parsed = parser.parse(input)
        expect(parsed).to eq([])
      end

      it "should remove 'keine angaben' (= not specified)" do
        input = "keine angaben"
        parsed = parser.parse(input)
        expect(parsed).to eq([])
      end

      it "should remove 'Field Number'" do
        input = "Field Number"
        parsed = parser.parse(input)
        expect(parsed).to eq([])
      end

      it "should remove 'pitfall trap'" do
        input = "pitfall trap"
        parsed = parser.parse(input)
        expect(parsed).to eq([])
      end

      it "should remove extraneous capitalized letters within brackets" do
        input = "!B. P. J. Molloy (CHR)"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['B. P. J.', 'Molloy'])
      end

      it "should recognize a single name in reverse order with a comma" do
        input = "Tanner, C.A."
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['C.A.', 'Tanner'])
      end

      it "should remove 'etal'" do
        input = "HUNT, G L, ETAL"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['G L', 'HUNT'])
      end

      it "should remove another form of 'etal'" do
        input = "L.Rossi;etal."
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['L.', 'Rossi'])
      end

      it "should remove numerical values and lowercase letter" do
        input = "23440a Ian D. MacDonald"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(["Ian D.", "MacDonald"])
      end

      it "should remove 'male' or 'female' text from name" do
        input = "13267 (male) W.J. Cody; 13268 (female) W.E. Kemp"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(["W.J.", "Cody"])
        expect(parsed[1].values_at(:given, :family)).to eq(["W.E.", "Kemp"])
      end

      it "should remove numerical values and capital letter" do
        input = "23440G Ian D. MacDonald"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(["Ian D.", "MacDonald"])
      end

      it "should remove [presumed]" do
        input = "[presumed] A C Ziegler"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(["A C", "Ziegler"])
      end

      it "should remove numerical values and lowercase letter in brackets" do
        input = "23440(a) Ian D. MacDonald"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(["Ian D.", "MacDonald"])
      end

      it "should remove 'interim'" do
        input = "interim"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(0)
      end

      #TODO Latin American names not parsed properly when Namae.options[:prefer_comma_as_separator] = true
    #  it "should deal with composite family names" do
    #    input = "Rázuri Gonzales, Ernesto"
    #    parsed = parser.parse(input)
    #    expect(parsed.size).to eq(1)
    #    expect(parsed[0].values_at(:given, :family)).to eq(["Ernesto", "Rázuri Gonzales"])
    #    expect(parser.clean(parsed[0]).to_h).to eq({given: 'Ernesto', family:'Rázuri Gonzales'})
    #  end

      it "should remove 'bis'" do
        input = "H.W. Lewis bis"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['H.W.', 'Lewis'])
      end

      it "should remove 'ter'" do
        input = "H.W. Lewis ter"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['H.W.', 'Lewis'])
      end

      it "should not remove surname (or other) terminating by 'bis'" do
        input = "Jack Anubis "
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'Anubis'])
      end

      it "should remove 'et al'" do
        input = "Jack Smith et al"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'Smith'])
      end

      it "should remove '; et al'" do
        input = "Jack Smith; et al"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'Smith'])
      end

      it "should remove 'et al.'" do
        input = "Jack Smith et al."
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'Smith'])
      end

      it "should remove 'et. al.'" do
        input = "Jack Smith et. al."
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'Smith'])
      end

      it "should remove Collector(s):" do
        input = "Collector(s): Richard D. Worthington"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['Richard D.', 'Worthington'])
      end

      it "should remove 'and others'" do
        input = "Jack Smith and others"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'Smith'])
      end

      it "should remove '& others'" do
        input = "Jack Smith & others"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'Smith'])
      end

      it "should remove '& party'" do
        input = "J Paxton & party"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['J', 'Paxton'])
      end

      it "should separate a concatenated name" do
        input = "J.R.Smith"
        parsed = parser.parse(input)
        expect(parsed[0].values_at(:given, :family)).to eq(['J.R.', 'Smith'])
      end

      it "should separate multiple concatenated names" do
        input = "J.R.Smith and P.Sutherland"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['J.R.', 'Smith'])
        expect(parsed[1].values_at(:given, :family)).to eq(['P.', 'Sutherland'])
      end

      it "should properly deal with Rev." do
        input = "Rev. Jack Smith"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'Smith'])
      end

      it "should properly deal with Fr." do
        input = "Fr. Jack Smith"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'Smith'])
      end

      it "should properly deal with Miss Penelope Cruz" do
        input = "Miss Penelope Cruz"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['Penelope', 'Cruz'])
      end

      it "should properly deal with Mrs. Penelope Cruz" do
        input = "Mrs. Penelope Cruz"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['Penelope', 'Cruz'])
      end

      it "should properly deal with Ms Penelope Cruz" do
        input = "Ms Penelope Cruz"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['Penelope', 'Cruz'])
      end

      it "should remove 'etc'" do
        input = "Jack Smith etc"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'Smith'])
      end

      it "should remove 'etc.'" do
        input = "Jack Smith etc."
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'Smith'])
      end

      it "should remove ', YYYY' " do
        input = "Jack Smith, 2009"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'Smith'])
      end

      it "should remove brackets from name" do
        input = "W.P. Coreneuk(?)"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['W.P.', 'Coreneuk'])
      end

      it "should remove 'Game Dept.'" do
        input = "Game Dept.  prep. C.J. Guiguet"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['C.J.', 'Guiguet'])
      end

      it "should remove 'prob.'" do
        input = "prob. A C Ziegler"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['A C', 'Ziegler'])
      end

      it "should explode by 'prep. by' at the start of the string" do
        input = "prep. C.J. Guiguet"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['C.J.', 'Guiguet'])
      end

      it "should explode by 'prep. by' at the start of the string" do
        input = "prep. by C.J. Guiguet"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['C.J.', 'Guiguet'])
      end

      it "should strip out 'prep.' at the end of the string" do
        input = "B. Pfeiffer prep."
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['B.', 'Pfeiffer'])
      end

      it "should explode by 'prep'" do
        input = "R.H. Mackay  prep. I. McTaggart-Cowan"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['R.H.', 'Mackay'])
      end

      it "should explode by 'via" do
        input = "via Serena Lowartz"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['Serena', 'Lowartz'])
      end

      it "should explode by +" do
        input = "D.B. Jepsen + T. L. McGuire"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['D.B.', 'Jepsen'])
      end

      it "should explode by + without spacing" do
        input = "Dalzell+Hutchison"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
      end

      it "should explode by 'stet!'" do
        input = "Jack Smith stet!"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'Smith'])
      end

      it "should explode by 'stet'" do
        input = "Jack Smith stet 1989"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'Smith'])
      end

      it "should explode by 'stet,'" do
        input = "Jack Smith stet, 1989"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'Smith'])
      end

      it "should explode by 'e'" do
        input = "Jack Smith e Carlos Santos"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'Smith'])
        expect(parsed[1].values_at(:given, :family)).to eq(['Carlos', 'Santos'])
      end

      it "should explode by & with a comma" do
        input = "W. C. Gagne, G. Young, & G. Nishida"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(3)
        expect(parsed[0].values_at(:given, :family)).to eq(['W. C.', 'Gagne'])
        expect(parsed[1].values_at(:given, :family)).to eq(['G.', 'Young'])
        expect(parsed[2].values_at(:given, :family)).to eq(['G.', 'Nishida'])
      end

      it "should not explode by E" do
        input = "Jack E Smith"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack E', 'Smith'])
      end

      it "should remove 'UNKNOWN'" do
        input = "UNKNOWN"
        parsed = parser.parse(input)
        expect(parsed).to eq([])
      end

      it "should remove 'importer'" do
        input = "Lucanus, O. (importer)"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['O.', 'Lucanus'])
      end

      it "should remove 'coll'" do
        input = "coll A Gyzen"
        parsed = parser.parse(input)
        expect(parsed[0].values_at(:given, :family)).to eq(['A', 'Gyzen'])
      end

      it "should remove 'Coll.'" do
        input = "A.B. Joly Coll."
        parsed = parser.parse(input)
        expect(parsed[0].values_at(:given, :family)).to eq(['A.B.', 'Joly'])
      end

      it "should remove 'Colln.'" do
        input = "Streng Colln."
        parsed = parser.parse(input)
        expect(parsed[0].values_at(:given, :family)).to eq(['Streng', nil]) #OK for now, would be later swapped with clean method
      end

      it "should remove 'COLLN'" do
        input = "J G MILLIAS COLLN"
        parsed = parser.parse(input)
        expect(parsed[0].values_at(:given, :family)).to eq(['J G', "MILLIAS"])
      end

      it "should remove 'Colls.'" do
        input = "O. Conle & F. Hennemann Colls."
        parsed = parser.parse(input)
        expect(parsed[1].values_at(:given, :family)).to eq(['F.', 'Hennemann'])
      end

      it "should not strip out Colls" do
        input = "D.G. Colls"
        parsed = parser.parse(input)
        expect(parsed[0].values_at(:given, :family)).to eq(['D.G.', 'Colls'])
      end

      it "should remove 'local collector'" do
        input = "A Engilis, Jr., local collector"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['A', 'Engilis'])
      end

      it "should not parse what does not resemble a name" do
        input = "EB"
        parsed = parser.parse(input)
        expect(parsed).to eq([])
      end

      it "should remove extraneous material" do
        input = "Unknown [J. S. Erskine?]"
        parsed = parser.parse(input)
        expect(parsed).to eq([])
      end

      it "should parse name with many given initials" do
        input = "FAH Sperling"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['FAH', 'Sperling'])
      end

      it "should preserve caps in family names" do
        input = "Chris MacQuarrie"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['Chris', 'MacQuarrie'])
      end

      it "should remove more exteneous material" do
        input = "Jack [John] Smith12345"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack John', 'Smith'])
      end

      it "should explode names with '/'" do
        input = "O.Bennedict/G.J. Spencer"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['O.', 'Bennedict'])
        expect(parsed[1].values_at(:given, :family)).to eq(['G.J.', 'Spencer'])
      end

      it "should explode names with ' i '" do
        input = "A. Pedrola i A. Aguilella"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['A.', 'Pedrola'])
        expect(parsed[1].values_at(:given, :family)).to eq(['A.', 'Aguilella'])
      end

      it "should explode names with ' - '" do
        input = "Jack Smith - Yves St-Archambault"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'Smith'])
        expect(parsed[1].values_at(:given, :family)).to eq(['Yves', 'St-Archambault'])
      end

      it "should explode names with ' – '" do
        input = "Jack Smith   –   Yves St-Archambault"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'Smith'])
        expect(parsed[1].values_at(:given, :family)).to eq(['Yves', 'St-Archambault'])
      end

      it "should explode names with 'and'" do
        input = "Jack Smith and Yves Archambault"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'Smith'])
        expect(parsed[1].values_at(:given, :family)).to eq(['Yves', 'Archambault'])
      end

      it "should explode names with 'or'" do
        input = "Jack Smithor or Orlando Archambault"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'Smithor'])
        expect(parsed[1].values_at(:given, :family)).to eq(['Orlando', 'Archambault'])
      end

      it "should explode names with 'AND'" do
        input = "Jack Smith AND Yves Archambault"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'Smith'])
        expect(parsed[1].values_at(:given, :family)).to eq(['Yves', 'Archambault'])
      end

      it "should explode multiple names with 'and'" do
        input = "Jack Smith and Yves Archambault and Don Johnson"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(3)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'Smith'])
        expect(parsed[1].values_at(:given, :family)).to eq(['Yves', 'Archambault'])
        expect(parsed[2].values_at(:given, :family)).to eq(['Don', 'Johnson'])
      end

      it "should explode names with ';'" do
        input = "Jack Smith; Yves Archambault"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'Smith'])
        expect(parsed[1].values_at(:given, :family)).to eq(['Yves', 'Archambault'])
      end

      it "should explode names with spaces" do
        input = "Puttock, C.F. James, S.A."
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['C.F.', 'Puttock'])
        expect(parsed[1].values_at(:given, :family)).to eq(['S.A.', 'James'])
      end

      it "should explode names with ' | '" do
        input = "Jack Smith | Yves Archambault"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'Smith'])
        expect(parsed[1].values_at(:given, :family)).to eq(['Yves', 'Archambault'])
      end

      it "should explode names with spaces and given initials with full stops" do
        input = "Groom Q., Desmet P."
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        #Order here is expected until we clean it
        expect(parsed[0].values_at(:given, :family)).to eq(['Groom', 'Q.'])
        expect(parsed[1].values_at(:given, :family)).to eq(['Desmet', 'P.'])
      end

      it "should explode names with '|'" do
        input = "Jack Smith|Yves Archambault"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'Smith'])
        expect(parsed[1].values_at(:given, :family)).to eq(['Yves', 'Archambault'])
      end

      it "should explode names with '&'" do
        input = "Jack Smith & Yves Archambault"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'Smith'])
        expect(parsed[1].values_at(:given, :family)).to eq(['Yves', 'Archambault'])
      end

      it "should explode lists of names that contain ',' and '&'" do
        input = "V. Crecco, J. Savage & T.A. Wheeler"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(3)
        expect(parsed[0].values_at(:given, :family)).to eq(['V.', 'Crecco'])
        expect(parsed[1].values_at(:given, :family)).to eq(['J.', 'Savage'])
        expect(parsed[2].values_at(:given, :family)).to eq(['T.A.', 'Wheeler'])
      end

      it "should explode lists of names with initials (reversed), commas, and '&'" do
        input = "Harkness, W.J.K., Dickinson, J.C., & Marshall, N."
        parsed = parser.parse(input)
        expect(parsed.size).to eq(3)
        expect(parsed[0].values_at(:given, :family)).to eq(['W.J.K.', 'Harkness'])
        expect(parsed[1].values_at(:given, :family)).to eq(['J.C.', 'Dickinson'])
        expect(parsed[2].values_at(:given, :family)).to eq(['N.', 'Marshall'])
      end

      it "should explode lists of names with semicolons and commas in reverse order" do
        input = "Gad., L.; Dawson, J.; Wyatt, N.; Gerring, J."
        parsed = parser.parse(input)
        expect(parsed.size).to eq(4)
        expect(parsed[0].values_at(:given, :family)).to eq(['L.', 'Gad.'])
        expect(parsed[1].values_at(:given, :family)).to eq(['J.', 'Dawson'])
        expect(parsed[2].values_at(:given, :family)).to eq(['N.', 'Wyatt'])
        expect(parsed[3].values_at(:given, :family)).to eq(['J.', 'Gerring'])
      end

      it "should explode lists of names with initials (forward), commas and '&'" do
        input = "N. Lujan, D. Werneke, D. Taphorn, D. German & D. Osorio"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(5)
        expect(parsed[0].values_at(:given, :family)).to eq(['N.', 'Lujan'])
        expect(parsed[1].values_at(:given, :family)).to eq(['D.', 'Werneke'])
        expect(parsed[2].values_at(:given, :family)).to eq(['D.', 'Taphorn'])
        expect(parsed[3].values_at(:given, :family)).to eq(['D.', 'German'])
        expect(parsed[4].values_at(:given, :family)).to eq(['D.', 'Osorio'])
      end

      it "should explode names with '/'" do
        input = "Jack Smith / Yves Archambault"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'Smith'])
        expect(parsed[1].values_at(:given, :family)).to eq(['Yves', 'Archambault'])
      end

      it "should explode names with 'et'" do
        input = "Jack Smith et Yves Archambault"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'Smith'])
        expect(parsed[1].values_at(:given, :family)).to eq(['Yves', 'Archambault'])
      end

      it "should explode names with 'with'" do
        input = "Jack Smith with Yves Archambault"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'Smith'])
        expect(parsed[1].values_at(:given, :family)).to eq(['Yves', 'Archambault'])
      end

      it "should explode names with 'with' and 'and'" do
        input = "Jack Smith with Yves Archambault and Don Johnson"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(3)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'Smith'])
        expect(parsed[1].values_at(:given, :family)).to eq(['Yves', 'Archambault'])
        expect(parsed[2].values_at(:given, :family)).to eq(['Don', 'Johnson'])
      end

      it "should explode names with 'by'" do
        input = "by P. Zika"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['P.', 'Zika'])
      end

      it "should explode names with 'annotated'" do
        input = "annotated Yves Archambault"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['Yves', 'Archambault'])
      end

      it "should explode names with 'annotated by'" do
        input = "annotated by Yves Archambault"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['Yves', 'Archambault'])
      end

      it "should explode names with 'conf'" do
        input = "Jack Johnson conf Yves Archambault"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'Johnson'])
        expect(parsed[1].values_at(:given, :family)).to eq(['Yves', 'Archambault'])
      end

      it "should explode names with 'conf'" do
        input = "Jack Johnson conf Yves Archambault"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'Johnson'])
        expect(parsed[1].values_at(:given, :family)).to eq(['Yves', 'Archambault'])
      end

      it "should explode names with 'conf.'" do
        input = "Jack Johnson conf. Yves Archambault"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'Johnson'])
        expect(parsed[1].values_at(:given, :family)).to eq(['Yves', 'Archambault'])
      end

      it "should explode names with 'conf by'" do
        input = "Jack Johnson conf by Yves Archambault"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'Johnson'])
        expect(parsed[1].values_at(:given, :family)).to eq(['Yves', 'Archambault'])
      end

      it "should explode names with 'conf. by'" do
        input = "Jack Johnson conf. by Yves Archambault"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'Johnson'])
        expect(parsed[1].values_at(:given, :family)).to eq(['Yves', 'Archambault'])
      end

      it "should explode names with 'confirmed by'" do
        input = "Jack Johnson confirmed by Yves Archambault"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'Johnson'])
        expect(parsed[1].values_at(:given, :family)).to eq(['Yves', 'Archambault'])
      end

      it "should explode names with 'confirmada por'" do
        input = "Fernandes,MG.C confirmada por Rapini,A."
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['MG.C', 'Fernandes'])
        expect(parsed[1].values_at(:given, :family)).to eq(['A.', 'Rapini'])
      end

      it "should explode names with 'checked:'" do
        input = "C.E. Garton 1980 checked:W.G. Argus 1980"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['C.E.', 'Garton'])
        expect(parsed[1].values_at(:given, :family)).to eq(['W.G.', 'Argus'])
      end

      it "should explode names with 'checked by'" do
        input = "Jack Johnson checked by Yves Archambault"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'Johnson'])
        expect(parsed[1].values_at(:given, :family)).to eq(['Yves', 'Archambault'])
      end

      it "should explode names with 'Checked By'" do
        input = "Checked By Yves Archambault"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['Yves', 'Archambault'])
      end

      it "should explode names with 'dupl'" do
        input = "Jack Johnson dupl Yves Archambault"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'Johnson'])
        expect(parsed[1].values_at(:given, :family)).to eq(['Yves', 'Archambault'])
      end

      it "should explode names with 'dupl.'" do
        input = "Jack Johnson dupl. Yves Archambault"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'Johnson'])
        expect(parsed[1].values_at(:given, :family)).to eq(['Yves', 'Archambault'])
      end

      it "should explode names with 'dup by'" do
        input = "Jack Johnson dup by Yves Archambault"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'Johnson'])
        expect(parsed[1].values_at(:given, :family)).to eq(['Yves', 'Archambault'])
      end

      it "should explode names with 'dup. by'" do
        input = "Jack Johnson dup. by Yves Archambault"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'Johnson'])
        expect(parsed[1].values_at(:given, :family)).to eq(['Yves', 'Archambault'])
      end

      it "should explode names with 'ex. by'" do
        input = "Rex Johnson ex. by Yves Archambault"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['Rex', 'Johnson'])
        expect(parsed[1].values_at(:given, :family)).to eq(['Yves', 'Archambault'])
      end

      it "should explode names with 'ex by'" do
        input = "Rex Byron ex by Yves Archambault"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['Rex', 'Byron'])
        expect(parsed[1].values_at(:given, :family)).to eq(['Yves', 'Archambault'])
      end

      it "should explode names with 'examined by'" do
        input = "Rex Byron examined by Yves Archambault"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['Rex', 'Byron'])
        expect(parsed[1].values_at(:given, :family)).to eq(['Yves', 'Archambault'])
      end

      it "should explode names with 'in part'" do
        input = "Rex Byron in part Yves Archambault"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['Rex', 'Byron'])
        expect(parsed[1].values_at(:given, :family)).to eq(['Yves', 'Archambault'])
      end

      it "should explode names with 'in part by'" do
        input = "Rex Byron in part by Yves Archambault"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['Rex', 'Byron'])
        expect(parsed[1].values_at(:given, :family)).to eq(['Yves', 'Archambault'])
      end

      it "should explode name with 'och'" do
        input = "M. Källersjö och A. Anderberg 272"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['M.', 'Källersjö'])
        expect(parsed[1].values_at(:given, :family)).to eq(['A.', 'Anderberg'])
      end

      it "should explode names with 'con'" do
        input = "Alfonso Octavio con A. Bonet y Rafael Torres"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(3)
        expect(parsed[0].values_at(:given, :family)).to eq(['Alfonso', 'Octavio'])
        expect(parsed[1].values_at(:given, :family)).to eq(['A.', 'Bonet'])
        expect(parsed[2].values_at(:given, :family)).to eq(['Rafael', 'Torres'])
      end

      it "should explode names with 'redet by'" do
        input = "Jack Smith redet. by Michael Jackson"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'Smith'])
        expect(parsed[1].values_at(:given, :family)).to eq(['Michael', 'Jackson'])
      end

      it "should explode names with 'stet'" do
        input = "Anna Roberts stet R. Scagel 1981"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['Anna', 'Roberts'])
        expect(parsed[1].values_at(:given, :family)).to eq(['R.', 'Scagel'])
      end

      it "should explode names with 'ver by'" do
        input = "Rex Byron ver by Yves Archambault"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['Rex', 'Byron'])
        expect(parsed[1].values_at(:given, :family)).to eq(['Yves', 'Archambault'])
      end

      it "should explode names with 'ver. by'" do
        input = "Rex Byron ver. by Yves Archambault"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['Rex', 'Byron'])
        expect(parsed[1].values_at(:given, :family)).to eq(['Yves', 'Archambault'])
      end

      it "should explode names with 'verified by'" do
        input = "Rex Byron verified by Yves Archambault"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['Rex', 'Byron'])
        expect(parsed[1].values_at(:given, :family)).to eq(['Yves', 'Archambault'])
      end

      it "should explode names with abbreviation for verified by" do
        input = "W.W. Diehl; Verif.: C.L. Shear"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['W.W.', 'Diehl'])
        expect(parsed[1].values_at(:given, :family)).to eq(['C.L.', 'Shear'])
      end

      it "should explode names with verified indicator in French" do
        input = "Vérifié Michelle Garneau"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['Michelle', 'Garneau'])
      end

      it "should explode names with complex verif. statements with year" do
        input = "Gji; Verif. S. Churchill; 1980"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['Gji', nil])
        expect(parsed[1].values_at(:given, :family)).to eq(['S.', 'Churchill'])
      end

      it "should remove FNA" do
        input = "Adam F. Szczawinski ; J.K. Morton (FNA) 1993"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['Adam F.', 'Szczawinski'])
        expect(parsed[1].values_at(:given, :family)).to eq(['J.K.', 'Morton'])
      end

      it "should remove Roman numerals from dates" do
        input = "S. Ross 12/i/1999"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['S.', 'Ross'])
      end

      it "should remove Roman numerals from determinations" do
        input = "S. Ross III.1990"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['S.', 'Ross'])
      end

      it "should not remove Roman numeral-like text from names" do
        input = "Xinxiao Wang"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['Xinxiao', 'Wang'])
      end

      it "should deal with 'Ver By'" do
        input = "S. Ross Ver By P. Perrin"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['S.', 'Ross'])
        expect(parsed[1].values_at(:given, :family)).to eq(['P.', 'Perrin'])
      end

      it "should treat a religious name like Marie-Victorin, frère as a given name" do
        input = "Marie-Victorin, frère"
        parsed = parser.parse(input)
        expect(parsed[0].values_at(:given, :family)).to eq(['frère', 'Marie-Victorin'])
      end

      it "should treat a religious name like Frère León as a given name" do
        input = "Frère León"
        parsed = parser.parse(input)
        expect(parsed[0].values_at(:given, :family)).to eq(['Frère', 'León'])
      end

      it "should remove (See Note Inside)" do
        input = "J. Macoun (See Note Inside)"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['J.', 'Macoun'])
      end

      it "should remove nom. rev." do
        input = "Bird,C.J. 9/Mar/1981: nom. rev."
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['C.J.', 'Bird'])
      end

      it "should remove stet ! at the end of the name" do
        input = "Roy, Claude   Stet !"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['Claude', 'Roy'])
      end

      it "should remove (MT) from a name" do
        input = "A.E. Porsild; stet! Luc Brouillet (MT) 2003"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['A.E.', 'Porsild'])
        expect(parsed[1].values_at(:given, :family)).to eq(['Luc', 'Brouillet'])
      end

      it "should remove '(See Note Inside)'" do
        input = "Roy, Claude (See Note Inside)"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['Claude', 'Roy'])
      end

      it "should remove '(see note)'" do
        input = "Roy, Claude (see note)"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['Claude', 'Roy'])
      end

      it "should remove Bro." do
        input = "Bro. Gustav G. Arsène Brouard"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family, :title)).to eq(["Gustav G. Arsène", "Brouard", "Bro."])
      end

      it "should strip out stet from the end of a name" do
        input = "Christian Kronenstet !"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(["Christian", "Kronenstet"])
      end

      it "should explode a complicated example" do
        input = "Vernon C. Brink; Thomas C. Brayshaw stet! 1979"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['Vernon C.', 'Brink'])
        expect(parsed[1].values_at(:given, :family)).to eq(['Thomas C.', 'Brayshaw'])
      end

      it "should explode names with extraneous commas" do
        input = "4073 A.A. Beetle, with D.E. Beetle and Alva Hansen"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(3)
        expect(parsed[0].values_at(:given, :family)).to eq(['A.A.', 'Beetle'])
        expect(parsed[1].values_at(:given, :family)).to eq(['D.E.', 'Beetle'])
        expect(parsed[2].values_at(:given, :family)).to eq(['Alva', 'Hansen'])
      end

      it "should explode names with extraneous period" do
        input = "C. Tanner.; M.W. Hawkes"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['C.', 'Tanner.'])
        expect(parsed[1].values_at(:given, :family)).to eq(['M.W.', 'Hawkes'])
      end

      it "should strip out dates like 21-12-1999 in the string" do
        input = "CJ Bird,21-12-1971"
        parsed = parser.parse(input)
        expect(parsed[0].values_at(:given, :family)).to eq(['CJ', 'Bird'])
      end

      it "should strip out dates like 21 Dec. 1999 in the string" do
        input = "CJ Bird,21 Dec. 1999"
        parsed = parser.parse(input)
        expect(parsed[0].values_at(:given, :family)).to eq(['CJ', 'Bird'])
      end

      it "should strip out year in string" do
        input = "Mortensen,Agnes Mols,2010"
        parsed = parser.parse(input)
        expect(parsed[0].values_at(:given, :family)).to eq(['Agnes Mols', 'Mortensen'])
      end

      it "should strip out '(Photograph)" do
        input = "Robert J. Bandoni (Photograph)"
        parsed = parser.parse(input)
        expect(parsed[0].values_at(:given, :family)).to eq(['Robert J.', 'Bandoni'])
      end

      it "should strip out 'Sight Identification" do
        input = "S.A. Redhead- Sight Identification"
        parsed = parser.parse(input)
        expect(parsed[0].values_at(:given, :family)).to eq(['S.A.', 'Redhead'])
      end

      it "should strip out '(to subsp.)" do
        input = "Jeffery M. Saarela 2005 (to subsp.) "
        parsed = parser.parse(input)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jeffery M.', 'Saarela'])
      end

      it "should strip out 'Fide:'" do
        input = "Bird, Carolyn J.; Fide: Lindsay, J.G."
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['Carolyn J.', 'Bird'])
        expect(parsed[1].values_at(:given, :family)).to eq(['J.G.', 'Lindsay'])
      end

      it "should explode names with Jan. 14, 2013 included in string" do
        input = "Jan Jones Jan. 14, 2013"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jan', 'Jones'])
      end

      it "should explode names with 'per'" do
        input = "G.J. Spencer per Sheila Lyons"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
      end

      it "should explode names with freeform dates in the string" do
        input = "Richard Robohm on 15 January 2013"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['Richard', 'Robohm'])
      end

      it "should explode names with structured dates in the string" do
        input = "C.J. Bird 20/Aug./1980"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['C.J.', 'Bird'])
      end

      it "should explode names with dates separated by commas in the string" do
        input = "K. January; January, 1979"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['K.', 'January'])
      end

      it "should explode names with possibly conflicting months in the string" do
        input = "Michael May May 2013"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['Michael', 'May'])
      end

      it "should explode names with months (in French) in the string" do
        input = "Jacques, Avril décembre 2013"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['Avril', 'Jacques'])
      end

      it "should explode names with possibly conflicting months (in French) in the string" do
        input = "Jacques, Avril avril 2013"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['Avril', 'Jacques'])
      end

      it "should explode names with a year and month (normal case) at the end of a string" do
        input = "Paul Kroeger 2006 May"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['Paul', 'Kroeger'])
      end

      it "should explode names with a year and month (lower case) at the end of a string" do
        input = "Paul Kroeger 2006 may"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['Paul', 'Kroeger'])
      end

      it "should explode names with spaces missing surrounding ampersand" do
        input = "Henrik Andersen&jon Feilberg"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(['Henrik', 'Andersen'])
        expect(parsed[1].values_at(:given, :family)).to eq([nil, 'Feilberg'])
      end

      it "should explode a messy list" do
        input = "Winterbottom, R.;Katz, L.;& CI team"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(3)
        expect(parsed[0].values_at(:given, :family)).to eq(['R.', 'Winterbottom'])
        expect(parsed[1].values_at(:given, :family)).to eq(['L.', 'Katz'])
        expect(parsed[2].values_at(:given, :family)).to eq(['CI', 'team'])
      end

      it "should parse name with given initials without period(s)" do
        input = "JH Picard"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['JH', 'Picard'])
      end

      it "should parse name when given is initalized and order is reversed without separator" do
        input = "Picard J.H."
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['J.H.', 'Picard'])
      end

      it "should parse a name with a small family name" do
        input = "J.Z. Cao"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['J.Z.', 'Cao'])
      end

      it "should retain lowercase surnames like 'Jack smith'" do
        input = "Jack smith"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['Jack', 'smith'])
      end

      it "should retain capitalized names like 'C. YOUNG'" do
        input = "C. YOUNG"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['C.', 'YOUNG'])
      end

      it "should retain capitalized names like 'Chris R.T. YOUNG'" do
        input = "Chris R.T. YOUNG"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['Chris R.T.', 'YOUNG'])
      end

      it "should retain capitalized names like 'CHRIS R.T. YOUNG'" do
        input = "CHRIS R.T. YOUNG"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['CHRIS R.T.', 'YOUNG'])
      end

      it "should properly handle and capitalize utf-8 characters" do
        input = "Sicard, Léas"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(['Léas', 'Sicard'])
      end

      it "should ignore poorly parsed names with long given names and many periods" do
        input = "J. Green; R. Driskill; J. W. Markham L. D. Druehl"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(3)
        expect(parsed[0].values_at(:given, :family)).to eq(['J.', 'Green'])
      end

      it "should parse a whole bunch of names" do
        input = "Smith, William Leo; Bentley, Andrew C; Girard, Matthew G; Davis, Matthew P; Ho, Hsuan-Ching"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(5)
        expect(parsed[4].values_at(:given, :family)).to eq(['Hsuan-Ching', 'Ho'])
      end

      it "should remove '(source)'" do
        input = "Tuck, Leslie M.; Vladykov, Vadim D. (source)"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(["Leslie M.", "Tuck"])
        expect(parsed[1].values_at(:given, :family)).to eq(["Vadim D.", "Vladykov"])
      end

      it "should remove asterisks from a name" do
        input = "White*"
        parsed = parser.parse(input)
        expect(parsed[0].values_at(:given, :family)).to eq(["White", nil])
      end

      it "should split with 'communicated to' in text" do
        input = "Huber Moore; communicatd to Terry M. Taylor"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(["Huber", "Moore"])
      end

      it "should ignore a three letter family name without vowels" do
        input = "Jack Wft"
        parsed = parser.parse(input)
        expect(parsed[0].values_at(:given, :family)).to eq(["Jack", "Wft"])
      end

      it "should accept a three letter family name with a vowel" do
        input = "Jack Wit"
        parsed = parser.parse(input)
        expect(parsed[0].values_at(:given, :family)).to eq(["Jack", "Wit"])
      end

      it "should ignore a family name with CAPs at end" do
        input = "Jack SmitH"
        parsed = parser.parse(input)
        expect(parsed[0].values_at(:given, :family)).to eq(["Jack", "SmitH"])
      end

      it "should ignore ignore a family name with two CAPs at the beginning" do
        input = "RGBennett"
        parsed = parser.parse(input)
        expect(parsed[0].values_at(:given, :family)).to eq(["RGBennett", nil])
      end

      it "should split a string of names with a." do
        input = "R.K. Godfrey a. R.D. Houk"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(["R.K.", "Godfrey"])
        expect(parsed[1].values_at(:given, :family)).to eq(["R.D.", "Houk"])
      end

      it "should not split a string of names with A." do
        input = "R.K. A. Godfrey"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(["R.K. A.", "Godfrey"])
      end

      it "should not ignore the name Paula Maybee" do
        input = "Paula Maybee"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(["Paula", "Maybee"])
      end

      it "it should not ignore the word maybe" do
        input = "Paula Maybee maybe"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(["Paula", "Maybee"])
      end

      it "should strip out 'by correspondance" do
        input = "Stephen Darbyshire 2005 (by correspondance)"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(["Stephen", "Darbyshire"])
      end

      it "should strip out 'operator', 'netter, and 'data recorder'" do
        input = "Holm, E (operator).; Ng, J.(netter); Litwiller, S. (netter); Lee, C. (data recorder)"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(4)
        expect(parsed[0].values_at(:given, :family)).to eq(["E", "Holm"])
        expect(parsed[1].values_at(:given, :family)).to eq(["J.", "Ng"])
        expect(parsed[2].values_at(:given, :family)).to eq(["S.", "Litwiller"])
        expect(parsed[3].values_at(:given, :family)).to eq(["C.", "Lee"])
      end

      it "should separate a short list of names separated by commas" do
        input = "A A Court, D J Court"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(["A A", "Court"])
        expect(parsed[1].values_at(:given, :family)).to eq(["D J", "Court"])
      end

      it "should parse another short list of names separated by commas" do
        input = "A B  Rose, J W  Trudgeon"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(["A B", "Rose"])
        expect(parsed[1].values_at(:given, :family)).to eq(["J W", "Trudgeon"])
      end

      it "should separate a long list of names separated by commas" do
        input = "J.W. Armbruster, C Armbruster, A Armbruster, B Armbruster, L Armbruster, R Armbruster, J Thomas, E Thomas"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(8)
        expect(parsed[0].values_at(:given, :family)).to eq(["J.W.", "Armbruster"])
        expect(parsed[1].values_at(:given, :family)).to eq(["C", "Armbruster"])
        expect(parsed[2].values_at(:given, :family)).to eq(["A", "Armbruster"])
        expect(parsed[3].values_at(:given, :family)).to eq(["B", "Armbruster"])
        expect(parsed[4].values_at(:given, :family)).to eq(["L", "Armbruster"])
        expect(parsed[5].values_at(:given, :family)).to eq(["R", "Armbruster"])
        expect(parsed[6].values_at(:given, :family)).to eq(["J", "Thomas"])
        expect(parsed[7].values_at(:given, :family)).to eq(["E", "Thomas"])
      end

      it "should separate some names with commas as separators and misc punctuation on initials" do
        input = "A C. Sanders, G. Helmkamp"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(["A C.", "Sanders"])
        expect(parsed[1].values_at(:given, :family)).to eq(["G.", "Helmkamp"])
      end

      it "should separate names with 'y'" do
        input = "N. Navarro, G. Gómez y A Ferreira"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(3)
        expect(parsed[0].values_at(:given, :family)).to eq(["N.", "Navarro"])
        expect(parsed[1].values_at(:given, :family)).to eq(["G.", "Gómez"])
        expect(parsed[2].values_at(:given, :family)).to eq(["A", "Ferreira"])
      end

      it "should not treat a single Y as a separator" do
        input = "A Y Jackson"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(["A Y", "Jackson"])
      end

      it "should not treat a single Y as a separator" do
        input = "A Y Jackson"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(["A Y", "Jackson"])
      end

      it "should treat 'und' as a separator" do
        input = "G. Fischer und K. E. Harz"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(["G.", "Fischer"])
      end

      it "should ignore 'leg.'" do
        input = "leg. A. Chuvilin"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(["A.", "Chuvilin"])
      end

      it "should ignore 'Leg:'" do
        input = "Leg: A. Chuvilin"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(["A.", "Chuvilin"])
      end

      it "should ignore 'LEG'" do
        input = "LEG Chuvilin"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(["Chuvilin",nil])
      end

      it "should ignore 'gift:'" do
        input = "gift: A. Chuvilin"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(["A.", "Chuvilin"])
      end

      it "should reject a portion of a name that has 'Person String'" do
        input = "Jeff Saarela; Person String"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
      end

      it "should reject a name that has 'Person String'" do
        input = "Person String"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(0)
      end

      it "should recognize a title Dr." do
        input = "Dr. R.K. Johnson,1972"
        parsed = parser.parse(input)
        expect(parsed[0].values_at(:given, :family, :title)).to eq(["R.K.", "Johnson", "Dr."])
      end

      it "should recognize a title Dr." do
        input = "Doctor R.K. Johnson,1972"
        parsed = parser.parse(input)
        expect(parsed[0].values_at(:given, :family, :title)).to eq(["R.K.", "Johnson", "Doctor"])
      end

      it "should recognize an appellation Mrs." do
        input = "Mrs. R.K. Johnson,1972"
        parsed = parser.parse(input)
        expect(parsed[0].values_at(:given, :family, :appellation)).to eq(["R.K.", "Johnson", "Mrs."])
      end

      it "should recognize an appellation Ms." do
        input = "Ms. R.K. Johnson,1972"
        parsed = parser.parse(input)
        expect(parsed[0].values_at(:given, :family, :appellation)).to eq(["R.K.", "Johnson", "Ms."])
      end

      it "should recognize an appellation Miss" do
        input = "Miss R.K. Johnson,1972"
        parsed = parser.parse(input)
        expect(parsed[0].values_at(:given, :family, :appellation)).to eq(["R.K.", "Johnson", "Miss"])
      end

      it "should recognize a title 'Maj'" do
        input = "Maj Richard W. G. Hingston"
        parsed = parser.parse(input)
        expect(parsed[0].values_at(:given, :family, :title)).to eq(["Richard W. G.", "Hingston", "Maj"])
      end

      it "should strip out LANUV0071" do
        input = "LANUV0071"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(0)
      end

      it "should strip out ORCID" do
        input = "J.Oscoz  (ORCID: 0000-0002-8464-9442)"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(["J.", "Oscoz"])
      end

      it "should strip out 'pers.comm.'" do
        input = "pers.comm. R. Hearn"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(["R.", "Hearn"])
      end

      it "should strip out MRI PAS" do
        input = "MRI PAS"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(0)
      end

      it "should recognize Esq. as a title" do
        input = "Charles R. Darwin Esq."
        parsed = parser.parse(input)
        expect(parsed[0].values_at(:given, :family, :title)).to eq(["Charles R.", "Darwin", "Esq."])
      end

      it "should recognize family names with only 2 characters" do
        input = "Wen-Bin Yu"
        parsed = parser.parse(input)
        expect(parsed[0].values_at(:given, :family)).to eq(["Wen-Bin", "Yu"])
      end

      it "should split names by a colon" do
        input = "R. Bieler : Field Museum of Natural History"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(["R.", "Bieler"])
      end

      it "should split a name with a character that looks like a pipe v1" do
        input = "H. Whetzel∣H. Jackson"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[1].values_at(:given, :family)).to eq(["H.", "Jackson"])
      end

      it "should split a name with a character that looks like a pipe v1" do
        input = "H. WhetzelǀH. Jackson"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[1].values_at(:given, :family)).to eq(["H.", "Jackson"])
      end

      it "should ignore particles" do
        input = "Leo Anton Karl de Ball"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family, :particle)).to eq(["Leo Anton Karl", "Ball", "de"])
      end

      it "should parse a complex name" do
        input = "Jean-Baptiste Leschenault de La Tour"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family, :particle)).to eq(["Jean-Baptiste Leschenault", "Tour", "de La"])
      end

      it "should parse a list each element within containing a role" do
        input = "Collector(s): Walter Cowary; Preparator(s): Donna C. Schmitt"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(["Walter", "Cowary"])
        expect(parsed[1].values_at(:given, :family)).to eq(["Donna C.", "Schmitt"])
      end

      it "should ignore brackets when wrapped around the entire string" do
        input = "[A. Gray (scripsit); W. T. Kittredge (2014)]"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(["A.", "Gray"])
        expect(parsed[1].values_at(:given, :family)).to eq(["W. T.", "Kittredge"])
      end

      it "should ignore 'sem coletor; sem data'" do
        input = "sem coletor; sem data"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(0)
      end

      # Although these are parsed as given names, the cleaner will do its job
      it "should not recombine contracted names" do
        input = "Jackson and Peterson"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family)).to eq(["Jackson", nil])
        expect(parsed[1].values_at(:given, :family)).to eq(["Peterson", nil])
      end

      it "should recognize Sir as a title" do
        input = "Sir Kenneth Brannaugh"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family, :title)).to eq(["Kenneth", "Brannaugh", "Sir"])
      end

      it "should recognize Father as a title" do
        input = "Father Kenneth Brannaugh"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family, :title)).to eq(["Kenneth", "Brannaugh", "Father"])
      end

      it "should recognize Ph.D. as a title" do
        input = "Kenneth Brannaugh Ph.D."
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family, :title)).to eq(["Kenneth", "Brannaugh", "Ph.D."])
      end

      it "should replace -Jr with ' Jr.'" do
        input = "P. Meira-Jr"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(["P.", "Meira"])
      end

      it "should replace an odd single quote" do
        input = "L. O´Brian"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(["L.", "O'Brian"])
      end

      it "should recognize Ph.D. preceeded by comma as a title" do
        input = "Kenneth Brannaugh, Ph.D."
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family, :title)).to eq(["Kenneth", "Brannaugh", "Ph.D."])
      end

      it "should strip out PROFº" do
        input = "PROFº Claudio Vale"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(["Claudio", "Vale"])
      end

      it "should recognize JR. as a suffix" do
        input = "Kenneth Brannaugh JR."
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family, :suffix)).to eq(["Kenneth", "Brannaugh", "JR."])
      end

      it "should recognize JR. as a suffix when preceeded by a comma" do
        input = "Kenneth Brannaugh, JR."
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family, :suffix)).to eq(["Kenneth", "Brannaugh", "JR."])
      end

      it "should recognize a comma after 'Jr.' as start of a new name" do
        input = "Joseph T. Marshall Jr., B. Sagal"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(2)
        expect(parsed[0].values_at(:given, :family, :suffix)).to eq(["Joseph T.", "Marshall", "Jr."])
        expect(parsed[1].values_at(:given, :family, :suffix)).to eq(["B.", "Sagal", nil])
      end

      it "should not treat any part of 'ACAD acc# 96317' as a name" do
        input = "ACAD acc# 96317"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(0)
      end

      it "should strip out Museums Victoria" do
        input = "Dr Martin F. Gomon - Museums Victoria"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(["Martin F.", "Gomon"])
      end

      it "should strip out TYPE" do
        input = "Dillon (F), TYPE"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq([nil,"Dillon"])
      end

      it "should strip out '& al.'" do
        input = "Strid & al."
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family)).to eq(["Strid", nil])
      end

      it "should recognize appellation, Mr." do
        input = "Mr. John Smith"
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family, :appellation)).to eq(["John", "Smith", "Mr."])
      end

      it "should retain title and suffix after cleaning" do
        input = "Dr. James Mornay Jr."
        parsed = parser.parse(input)
        expect(parsed.size).to eq(1)
        expect(parsed[0].values_at(:given, :family, :title, :suffix)).to eq(["James", "Mornay", "Dr.", "Jr."])
      end
    end

    it "should recognize ', Jr.' as a suffix and 'Mr.' as an appellation" do
      input = "Mr. Jerry E. Nichols Jr."
      parsed = parser.parse(input)
      expect(parsed.size).to eq(1)
      expect(parsed[0].values_at(:given, :family, :suffix, :appellation)).to eq(["Jerry E.", "Nichols", "Jr.", "Mr."])
    end

    it "should not remove 'France' from 'Frances'" do
      input = "Frances Smith"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(1)
      expect(parsed[0].values_at(:given, :family, :title, :suffix)).to eq(["Frances", "Smith", nil, nil])
    end

    it "should remove 'Paralectotypes'" do
      input = "Paralectotypes"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(0)
    end

    it "should remove isotype" do
      input = "Isotype (MO) P.J.M. Maas"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(1)
      expect(parsed[0].values_at(:given, :family, :title, :suffix)).to eq(["P.J.M.", "Maas", nil, nil])
    end

    it "should remove Exp." do
      input = "A.C. Twomey Exp."
      parsed = parser.parse(input)
      expect(parsed.size).to eq(1)
      expect(parsed[0].values_at(:given, :family, :title, :suffix)).to eq(["A.C.", "Twomey", nil, nil])
    end

    it "should remove Exp and digits" do
      input = "Kimberley Exp 2772"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(1)
      expect(parsed[0].values_at(:given, :family, :title, :suffix)).to eq(["Kimberley", nil, nil, nil])
    end

    it "should move 'van' to the beginning of the name" do
      input = "Heurn W.C. van"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(1)
      expect(parsed[0].values_at(:given, :family, :particle)).to eq(["W.C.", "Heurn", "van"])
    end

    it "should move 'von' to the beginning of the name" do
      input = "Humboldt A. von"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(1)
      expect(parsed[0].values_at(:given, :family, :particle)).to eq(["A.", "Humboldt", "von"])
    end

    it "should move 'von' to the beginning of the name and not add an additional comma" do
      input = "Humboldt, A. von"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(1)
      expect(parsed[0].values_at(:given, :family, :particle)).to eq(["A.", "Humboldt", "von"])
    end

    it "should construct two names from shared Family name, separated by 'and'" do
      input = "M.R. and J.D. Shorthouse"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(2)
      expect(parsed[0].values_at(:given, :family)).to eq(["M.R.", "Shorthouse"])
      expect(parsed[1].values_at(:given, :family)).to eq(["J.D.", "Shorthouse"])
    end

    it "should construct two names from shared Family name, separated by 'and' with spaces between initials" do
      input = "M. R. and J. D. Shorthouse"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(2)
      expect(parsed[0].values_at(:given, :family)).to eq(["M. R.", "Shorthouse"])
      expect(parsed[1].values_at(:given, :family)).to eq(["J. D.", "Shorthouse"])
    end

    it "should construct two names from shared Family name, separated by '&'" do
      input = "M. & J. Shorthouse"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(2)
      expect(parsed[0].values_at(:given, :family)).to eq(["M.", "Shorthouse"])
      expect(parsed[1].values_at(:given, :family)).to eq(["J.", "Shorthouse"])
    end

    it "should construct two names from shared Family name, separated by '&' without duplicating other names" do
      input = "M. & J. Shorthouse & A.Y. Jackson"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(3)
      expect(parsed[0].values_at(:given, :family)).to eq(["M.", "Shorthouse"])
      expect(parsed[1].values_at(:given, :family)).to eq(["J.", "Shorthouse"])
      expect(parsed[2].values_at(:given, :family)).to eq(["A.Y.", "Jackson"])
    end

    it "should construct two names from a shared family name where the latter has letters with diacritical marks" do
      input = "J. & A. Bornmüller"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(2)
      expect(parsed[0].values_at(:given, :family)).to eq(["J.", "Bornmüller"])
      expect(parsed[1].values_at(:given, :family)).to eq(["A.", "Bornmüller"])
    end

    it "should construct two names from shared Family name, separated by '&' no punctuation" do
      input = "DD & RS Shorthouse"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(2)
      expect(parsed[0].values_at(:given, :family)).to eq(["DD", "Shorthouse"])
      expect(parsed[1].values_at(:given, :family)).to eq(["RS", "Shorthouse"])
    end

    it "should strip out 'ded.'" do
      input = "Augener ded. 7.VI.1928"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(1)
      expect(parsed[0].values_at(:given, :family)).to eq(["Augener", nil])
    end

    it "should strip out 'don.' at the beginning" do
      input = "don. A. Hüllmann"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(1)
      expect(parsed[0].values_at(:given, :family)).to eq(["A.", "Hüllmann"])
    end

    it "should strip out 'don.' within text" do
      input = "Leg. et don. B.W. Hoeksema"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(1)
      expect(parsed[0].values_at(:given, :family)).to eq(["B.W.", "Hoeksema"])
    end

    it "should strip out everything at and after 'in herb.'" do
      input = "G. Lettau in herb. V. J. Grummann"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(1)
      expect(parsed[0].values_at(:given, :family)).to eq(["G.", "Lettau"])
    end

    it "should strip out everything at and after 'in Hb.'" do
      input = "J. Poelt & A. Buschardt in Hb. Buschardt"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(2)
      expect(parsed[0].values_at(:given, :family)).to eq(["J.", "Poelt"])
      expect(parsed[1].values_at(:given, :family)).to eq(["A.", "Buschardt"])
    end

    it "should split what looks like three comma-separated family names" do
      input = "Chaboo, Bennett, Shin"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(3)
      expect(parsed[0].values_at(:given, :family)).to eq(["Chaboo", nil])
      expect(parsed[1].values_at(:given, :family)).to eq(["Bennett", nil])
      expect(parsed[2].values_at(:given, :family)).to eq(["Shin", nil])
    end

    it "should split what looks like four comma-separated family names" do
      input = "Chaboo, Bennett, Shin, Smith"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(4)
      expect(parsed[0].values_at(:given, :family)).to eq(["Chaboo", nil])
      expect(parsed[1].values_at(:given, :family)).to eq(["Bennett", nil])
      expect(parsed[2].values_at(:given, :family)).to eq(["Shin", nil])
      expect(parsed[3].values_at(:given, :family)).to eq(["Smith", nil])
    end

    it "should split what looks like four comma-separated family names with and as last separator" do
      input = "Chaboo, Bennett, Shin and Smith"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(4)
      expect(parsed[0].values_at(:given, :family)).to eq(["Chaboo", nil])
      expect(parsed[1].values_at(:given, :family)).to eq(["Bennett", nil])
      expect(parsed[2].values_at(:given, :family)).to eq(["Shin", nil])
      expect(parsed[3].values_at(:given, :family)).to eq(["Smith", nil])
    end

    it "should split what looks like four comma-separated family names" do
      input = "Chaboo, Bennett, Shin, Smith & Jackson"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(5)
      expect(parsed[0].values_at(:given, :family)).to eq(["Chaboo", nil])
      expect(parsed[1].values_at(:given, :family)).to eq(["Bennett", nil])
      expect(parsed[2].values_at(:given, :family)).to eq(["Shin", nil])
      expect(parsed[3].values_at(:given, :family)).to eq(["Smith", nil])
      expect(parsed[4].values_at(:given, :family)).to eq(["Jackson", nil])
    end

    it "should not split what does not look like comma-separated family names" do
      input = "Chaboo, bennett, Shin"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(2)
      expect(parsed[0].values_at(:given, :family)).to eq(["bennett", "Chaboo"])
      expect(parsed[1].values_at(:given, :family)).to eq(["Shin", nil])
    end

    it "should split three family names with last one separated with ampersand" do
      input = "Wasum,Scur & Kegler"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(3)
      expect(parsed[0].values_at(:given, :family)).to eq(["Wasum", nil])
      expect(parsed[1].values_at(:given, :family)).to eq(["Scur", nil])
      expect(parsed[2].values_at(:given, :family)).to eq(["Kegler", nil])
    end

    it "should split two names that might have looked like three" do
      input = "Wasum,Scur & Kegler,R"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(2)
      expect(parsed[0].values_at(:given, :family)).to eq(["Scur", "Wasum"])
      expect(parsed[1].values_at(:given, :family)).to eq(["R", "Kegler"])
    end

    it "should parse Archduke Rainer Joseph of Austria" do
      input = "Archduke Rainer Joseph of Austria"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(1)
      expect(parsed[0].values_at(:given, :family, :particle)).to eq(["Archduke Rainer Joseph", "Austria", "of"])
    end

    it "should parse 'A.A. and A. Elizabeth Knowles'" do
      input = "A.A. and A. Elizabeth Knowles"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(2)
      expect(parsed[0].values_at(:given, :family)).to eq(["A.A.", "Knowles"])
      expect(parsed[1].values_at(:given, :family)).to eq(["A. Elizabeth", "Knowles"])
    end

    it "should recognize 'comm.' as a splitter" do
      input = "Yoder comm. R. Lowen"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(2)
      expect(parsed[0].values_at(:given, :family)).to eq(["Yoder", nil])
      expect(parsed[1].values_at(:given, :family)).to eq(["R.", "Lowen"])
    end

    it "should recognize 'Bill' as a nickname" do
      input = "William \"Bill\" Smith"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(1)
      expect(parsed[0].values_at(:given, :family, :nick)).to eq(["William", "Smith", "Bill"])
    end

    it "should convert a double quote in a family name" do
      input = "Michael O\"Malley"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(1)
      expect(parsed[0].values_at(:given, :family, :nick)).to eq(["Michael", "O'Malley", nil])
    end

    it "should split two names with '& Al'" do
      input = "CJR & Alan Smith"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(2)
      expect(parsed[1].values_at(:given, :family)).to eq(["Alan", "Smith"])
    end

    it "should strip out an emoji" do
      input = "Useita avantouimareita😄"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(1)
      expect(parsed[0].values_at(:given, :family)).to eq(["Useita", "avantouimareita"])
    end

    it "should parse a name in reverse order with no punctuation and one abbreviated given name" do
      input = "Groom Q."
      parsed = parser.parse(input)
      expect(parsed.size).to eq(1)
      expect(parsed[0].values_at(:given, :family)).to eq(["Q.", "Groom"])
    end

    it "should parse a name in reverse order with no punctuation and more than one abbreviated given name separated by spaces" do
      input = "Aznavour G. V."
      parsed = parser.parse(input)
      expect(parsed.size).to eq(1)
      expect(parsed[0].values_at(:given, :family)).to eq(["G. V.", "Aznavour"])
    end

    it "should recognize Dra. as a title" do
      input = "Dra. Poll"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(1)
      expect(parsed[0].values_at(:given, :family, :title)).to eq([nil, "Poll", "Dra."])
    end

    it "should recognize Profa as a title" do
      input = "Profa. Marcia Coura"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(1)
      expect(parsed[0].values_at(:given, :family, :title)).to eq(["Marcia", "Coura", "Profa."])
    end

    it "should not mistake Profa as a title when part of a name" do
      input = "Bob Profant"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(1)
      expect(parsed[0].values_at(:given, :family, :title)).to eq(["Bob", "Profant", nil])
    end

    it "should recognize Profª as a title" do
      input = "Profª Rita Maria de Carvalho"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(1)
      expect(parsed[0].values_at(:given, :family, :title, :particle)).to eq(["Rita Maria", "Carvalho", "Profª", "de"])
    end

    it "should recognize a name that contains 'anon'" do
      input = "A. Charpin, P. Hainard & R. Salanon"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(3)
      expect(parsed[2].values_at(:given, :family)).to eq(["R.", "Salanon"])
    end

    it "should strip out anonymous collector" do
      input = "anonymous collector & Humboldt,F.W.H.A. von"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(1)
      expect(parsed[0].values_at(:given, :family, :particle)).to eq(["F.W.H.A.", "Humboldt", "von"])
    end

    it "should split 'Mr. & Mrs. R.E. Moreau'" do
      input = "Mr. & Mrs. R.E. Moreau"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(2)
      expect(parsed[0].values_at(:appellation, :given, :family)).to eq(["Mr.", "R.E.", "Moreau"])
      expect(parsed[1].values_at(:appellation, :given, :family)).to eq(["Mrs.", "R.E.", "Moreau"])
    end

    it "should split 'L. B. and C. W. O\'Brien'" do
      input = "L. B. and C. W. O'Brien"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(2)
      expect(parsed[0].values_at(:given, :family)).to eq(["L. B.", "O'Brien"])
      expect(parsed[1].values_at(:given, :family)).to eq(["C. W.", "O'Brien"])
    end

    it "should split three family members like 'J. H., A. M. and A. W. Skevington'" do
      input = "J. H., A. M. and A. W. Skevington"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(3)
      expect(parsed[0].values_at(:given, :family)).to eq(["J. H.", "Skevington"])
      expect(parsed[1].values_at(:given, :family)).to eq(["A. M.", "Skevington"])
      expect(parsed[2].values_at(:given, :family)).to eq(["A. W.", "Skevington"])
    end

    it "should parse 'Marck,J.W.C.T., von der'" do
      input = "Marck,J.W.C.T. von der"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(1)
      expect(parsed[0].values_at(:given, :particle, :family)).to eq(["J.W.C.T.", "von der", "Marck"])
    end

    it "should remove square brackets within parts of names" do
      input = "A. Br[eu]ckner"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(1)
      expect(parsed[0].values_at(:given, :family)).to eq(["A.", "Breuckner"])
    end

    it "should remove multiple square braclets within parts of name" do
      input = "Attila Meste[r]há[zy]"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(1)
      expect(parsed[0].values_at(:given, :family)).to eq(["Attila", "Mesterházy"])
    end

    it "should recognize 'Lucile Capt'" do
      input = "Lucile Capt"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(1)
      expect(parsed[0].values_at(:given, :family)).to eq(["Lucile", "Capt"])
    end

    it "should strip out 'UNKNOWN OR ANONYMOUS'" do
      input = "UNKNOWN OR ANONYMOUS"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(0)
    end

    it "should strip out 'ContactID'" do
      input = "ContactID: 4703"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(0)
    end

    it "should parse names all in caps without conflict with the complex separators" do
      input = "R. SMITH & G. SMITH"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(2)
      expect(parsed[0].values_at(:given, :family)).to eq(["R.", "SMITH"])
      expect(parsed[1].values_at(:given, :family)).to eq(["G.", "SMITH"])
    end

    it "should parse names when a ampersand is preceded by a comma" do
      input = "Weiss, Schenck, & West"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(3)
      expect(parsed[0].values_at(:given, :family)).to eq(["Weiss", nil])
      expect(parsed[1].values_at(:given, :family)).to eq(["Schenck", nil])
      expect(parsed[2].values_at(:given, :family)).to eq(["West", nil])
    end

    it "should strip out quotes at the start of a name" do
      input = "'Weiss, Schenck, & West"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(3)
      expect(parsed[0].values_at(:given, :family)).to eq(["Weiss", nil])
      expect(parsed[1].values_at(:given, :family)).to eq(["Schenck", nil])
      expect(parsed[2].values_at(:given, :family)).to eq(["West", nil])
    end

    it "should strip out quotes at the end of a name" do
      input = "Weiss, Schenck, & West'"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(3)
      expect(parsed[0].values_at(:given, :family)).to eq(["Weiss", nil])
      expect(parsed[1].values_at(:given, :family)).to eq(["Schenck", nil])
      expect(parsed[2].values_at(:given, :family)).to eq(["West", nil])
    end

    it "should strip out quotes wrapped around a name" do
      input = "'Weiss, Schenck, & West'"
      parsed = parser.parse(input)
      expect(parsed.size).to eq(3)
      expect(parsed[0].values_at(:given, :family)).to eq(["Weiss", nil])
      expect(parsed[1].values_at(:given, :family)).to eq(["Schenck", nil])
      expect(parsed[2].values_at(:given, :family)).to eq(["West", nil])
    end

    it "should ignore exclamation marks and period at end" do
      input = '! L.P. Kvist, 1996.'
      parsed = parser.parse(input)
      expect(parsed.size).to eq(1)
      expect(parsed[0].values_at(:given, :family)).to eq(["L.P.", "Kvist"])
    end

    it "should strip out multiple quotes" do
      input = '"""Antonio Bausa"""'
      parsed = parser.parse(input)
      expect(parsed.size).to eq(1)
      expect(parsed[0].values_at(:given, :family)).to eq(["Antonio", "Bausa"])
    end

    it "should strip out double dashes and extra punctuation" do
      input = "-- Luke & -. Robertson"
      parsed = parser.parse(input)
      expect(parsed[0].values_at(:given, :family)).to eq(["Luke", nil])
    end

    it "should strip out preceding and trailing quotes or commas" do
      input = "\"H.Pittier,\""
      parsed = parser.parse(input)
      expect(parsed[0].values_at(:given, :family)).to eq(["H.", "Pittier"])
    end

    it "should strip out malformed et al" do
      input = "A. Ward; J. Dyer et.al"
      parsed = parser.parse(input)
      expect(parsed[0].values_at(:given, :family)).to eq(["A.", "Ward"])
      expect(parsed[1].values_at(:given, :family)).to eq(["J.", "Dyer"])
    end

    it "should not split by dupl in Duplessi" do
      input = "H. Duplessi"
      parsed = parser.parse(input)
      expect(parsed[0].values_at(:given, :family)).to eq(["H.", "Duplessi"])
    end

    it "should strip out Dupl.," do
      input = "Dupl., H. Inoue"
      parsed = parser.parse(input)
      expect(parsed[0].values_at(:given, :family)).to eq(["H.", "Inoue"])
    end

    it "should split by ;," do
      input = "E. Hassele;,Hassele"
      parsed = parser.parse(input)
      expect(parsed[0].values_at(:given, :family)).to eq(["E.", "Hassele"])
      expect(parsed[1].values_at(:given, :family)).to eq(["Hassele", nil])
    end

    it "should remove leg with a date" do
      input = "Stuhlmann leg. 2.VII.1889"
      parsed = parser.parse(input)
      expect(parsed[0].values_at(:given, :family)).to eq(["Stuhlmann", nil])
    end

    it "should recognize a family name that ends in leg" do
      input = "J.W. Gottleg"
      parsed = parser.parse(input)
      expect(parsed[0].values_at(:given, :family)).to eq(["J.W.", "Gottleg"])
    end

    it "should remove collection code-like content with one dash" do
      input = "A. Payette 46-72a"
      parsed = parser.parse(input)
      expect(parsed[0].values_at(:given, :family)).to eq(["A.", "Payette"])
    end

    it "should remove collection code-like content with two dashes" do
      input = "J.W. Groves # 47-I-62A"
      parsed = parser.parse(input)
      expect(parsed[0].values_at(:given, :family)).to eq(["J.W.", "Groves"])
    end

    it "should remove collection code-like content with a number sign" do
      input = "K. Wilson, #106"
      parsed = parser.parse(input)
      expect(parsed[0].values_at(:given, :family)).to eq(["K.", "Wilson"])
    end

    it "should remove collection code-like content with brackets" do
      input = "S.A. Redhead, (#4517)"
      parsed = parser.parse(input)
      expect(parsed[0].values_at(:given, :family)).to eq(["S.A.", "Redhead"])
    end

    it "should remove collection code-like content with a period" do
      input = "R.L. Black, 761.4"
      parsed = parser.parse(input)
      expect(parsed[0].values_at(:given, :family)).to eq(["R.L.", "Black"])
    end

    it "should remove 'literatur'" do
      input = "Literatur- und Herbardaten zum Bayernatlas"
      parsed = parser.parse(input)
      expect(parsed).to eq([])
    end

    it "should remove 'et al.' at the end of a string" do
      input = "Andrade, JC;Andrade, J.C.,et al."
      parsed = parser.parse(input)
      expect(parsed[0].values_at(:given, :family)).to eq(["JC", "Andrade"])
    end

    it "should strip digits from the beginning of a string" do
      input = "1, J. R. Mendelson"
      parsed = parser.parse(input)
      expect(parsed[0].values_at(:given, :family)).to eq(["J. R.", "Mendelson"])
    end

  end
end
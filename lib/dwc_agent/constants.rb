module DwcAgent
  STRIP_OUT = %r{
    (?i:acc\s?\#)|
    ["'-]{2,}|
    \-\.\s|
    [,;]?\s*(?i:1st|2nd|3rd|[4-9]th)|
    [,]?\s*?\d+\.\d+|
    [,]?\s*\([#NnOo\.\s0-9\-]*[0-9a-z]+\)\s*\z|
    [,]?\s+\#[0-9a-z]+\z|
    [,]?\s*\#*\s+\d+\-(?i:[A-Z]|\d)+\-?\d*[A-Za-z]*\z|
    \d*[A-Za-z]*\d*-\d*\z|
    \b\d+\(?(?i:[[:alpha:]])\)?\b|
    [,;\s]+(?:et\.?\s+al|&\s+al)l?\.?|
    \b[,;]?\s*(?i:etal)\.?|
    \b[,;]?\s*(?i:et.al)\.?|
    \b\s+(bis|ter)(\b|\z)|
    \bu\.\s*a\.|
    \b[,;]?\s*(?i:and|&)?\s*(?i:others|party)\s*\b|
    \b[,;]?\s*(?i:etc)\.?|
    \b[,;]?\s*(?i:exp)\.?\s*(\b|\z)|
    \b[,;]?\s*(?i:aboard)[^$]+|
    \b[,;]?\s+(?i:on)\b|
    \b(?i:unknown\s+or\s+anonymous)|
    \b[,;]?\s*(?i:unkn?own)\b|
    \b[,;]?\s*(?i:n/a)\b|
    \b[,;]?\s*(?i:ann?onymous)\b|
    \b[,;]?\s*\(?(?i:undetermined|indeterminable|dummy|interim|accession|ill(eg|is)ible|scripsit|presumed?|presumably)\)?\b|
    \b[,;]?\s*(?i:importer|gift)\:?\b|
    \b[,;]?\s*(?i:string)\b|
    \b[,;]?\s*(?i:person\s*string)\b|
    ^(?i:colln?)\.?\s+|\s*(?i:colln?)\.?\s*$|
    ^(?i:collection)\:?\s+|\s*(?i:collection)\s*$|
    \b[,;]?\s*(?i:colls)\.(\b|\z)|
    (?i:contactid)|
    ^(?i:dupl)[.,]+|
    \b[,;]?\s*(?i:stet)[,!]?\s*\d*\z|
    [,;]?\s*\d+[-/\s+](?i:\d+|Jan|Feb|Mar|Apr|
      May|Jun|Jul|Aug|Sept?|
      Oct|Nov|Dec)\.?\s*[-/\s+]?\d+|
    \b[,;]?\s*(?i:Jan|Jan(uary|vier))[.,;]?\s*\d+|
    \b[,;]?\s*(?i:Feb|February|f(é|e)vrier)[.,;]?\s*\d+|
    \b[,;]?\s*(?i:Mar|Mar(ch|s))[.,;]?\s*\d+|
    \b[,;]?\s*(?i:Apr|Apri|April|avril)[.,;]?\s*\d+|
    \b[,;]?\s*(?i:Ma(y|i))[.,;]?\s*\d+|
    \b[,;]?\s*(?i:Jun|June|juin)[.,;]?\s*\d+|
    \b[,;]?\s*(?i:Jul|July|juillet)[.,;]?\s*\d+|
    \b[,;]?\s*(?i:Aug|August|ao(û|u)t)[.,;]?\s*\d+|
    \b[,;]?\s*(?i:Sep|Sept|Septemb(er|re))[.,;]?\s*\d+|
    \b[,;]?\s*(?i:Oct|Octob(er|re))[.,;]?\s*\d+|
    \b[,;]?\s*(?i:Nov|Novemb(er|re))[.,;]?\s*\d+|
    \b[,;]?\s*(?i:Dec|D(é|e)cemb(er|re))[.,;]?\s*\d+|
    \d+\s+(?i:Jan|Jan(uary|vier))\.?\b|
    \d+\s+(?i:Feb|February|f(é|e)vrier)\.?\b|
    \d+\s+(?i:Mar|March|mars)\.?\b|
    \d+\s+(?i:Apr|Apri|April|avril)\.?\b|
    \d+\s+(?i:Ma(y|i))\b|
    \d+\s+(?i:Jun|June|juin)\.?\b|
    \d+\s+(?i:Jul|July|juillet)\.?\b|
    \d+\s+(?i:Aug|August|ao(û|u)t)\.?\b|
    \d+\s+(?i:Sep|Septemb(er|re))t?\.?\b|
    \d+\s+(?i:Oct|Octob(er|re))\.?\b|
    \d+\s+(?i:Nov|Novemb(er|re))\.?\b|
    \d+\s+(?i:Dec|D(e|é)cemb(er|re))\.?\b|
    \b[.-–,;:/]?\s*(?i:Alabama|Alaska|Arizona|Arkansas|California|Colorado|Connecticut|Delaware|Evergreen|Florida|Hawaii|Idaho|Illinois|Indiana|Iowa|Kansas|Kentucky|Louisiana|Maine|Maryland|Massachusetts|Michigan|Minnesota|Mississippi|Missouri|Montana|Nebraska|Nevada|New\s+Hampshire|New\s+Jersey|New\s+Mexico|New\s+York|North\s+Carolina|North\s+Dakota|Ohio|Oklahoma|Oregon|Pennsylvania|Portland|Rhode\s+Island|South\s+Carolina|South\s+Dakota|St\s+Petersburg|Tennessee|Texas|Utah|Vermont|Washington|West\s+Virginia|Wisconsin|Wyoming)\s+(?i:State)\s*\b|
    \b[.,;:/]?\s*?(?i:Afghanistan|Åland Islands|Albania|Algeria|American Samoa|Andorra|Angola|Anguilla|Antarctica|Antigua and Barbuda|Argentina|Armenia|Aruba|Australia|Azerbaijan|Bahamas|Bahrain|Bangladesh|Barbados|Belarus|Belize|Benin|Bermuda|Bhutan|Bolivia \(Plurinational State of\)|Bonaire, Sint Eustatius and Saba|Bosnia and Herzegovina|Botswana|Bouvet Island|Brazil|British Indian Ocean Territory|Brunei Darussalam|Bulgaria|Burkina Faso|Burundi|Cabo Verde|Cambodia|Cameroon|Canada|Cayman Islands|Central African Republic|Chad|Chile|Christmas Island|Cocos \(Keeling\) Islands|Colombia|Comoros|Congo|Congo \(Democratic Republic of the\)|Cook Islands|Costa Rica|Côte d'Ivoire|Croatia|Cuba|Curaçao|Cyprus|Czechia|Djibouti|Dominica|Dominican Republic|Ecuador|Egypt|El Salvador|Equatorial Guinea|Eritrea|Estonia|Ethiopia|Falkland Islands \(Malvinas\)|Faroe Islands|Fiji|Finland|French Guiana|French Polynesia|French Southern Territories|Gabon|Gambia|Germany|Ghana|Gibraltar|Greece|Greenland|Grenada|Guadeloupe|Guam|Guatemala|Guernsey|Guinea-Bissau|Guyana|Haiti|Heard Island and McDonald Islands|Holy See|Honduras|Hong Kong|Hungary|Iceland|India|Indonesia|Iran \(Islamic Republic of\)|Iraq|Isle of Man|Italy|Jamaica|Japan|Jersey|Kazakhstan|Kenya|Kiribati|Korea \(Democratic People\'s Republic of\)|Korea \(Republic of\)|Kuwait|Kyrgyzstan|Lao People\'s Democratic Republic|Latvia|Lebanon|Lesotho|Liberia|Libya|Liechtenstein|Lithuania|Luxembourg|Macao|Macedonia (the former Yugoslav Republic of)|Madagascar|Malawi|Malaysia|Maldives|Malta|Marshall Islands|Martinique|Mauritania|Mauritius|Mayotte|Mexico|Micronesia \(Federated States of\)|Moldova \(Republic of\)|Monaco|Mongolia|Morocco|Mozambique|Myanmar|Namibia|Nauru|Nepal|Netherlands|New Caledonia|New Zealand|Nicaragua|Niger|Nigeria|Niue|Norfolk Island|Northern Mariana Islands|Norway|Oman|Pakistan|Palau|Palestine, State of|Panama|Papua New Guinea|Paraguay|Peru|Philippines|Pitcairn|Poland|Puerto Rico|Qatar|Réunion|Romania|Russian Federation|Russia|Rwanda|Saint Barthélemy|Saint Helena, Ascension and Tristan da Cunha|Saint Kitts and Nevis|Saint Lucia|Saint Martin \(French part\)|Saint Pierre and Miquelon|Saint Vincent and the Grenadines|Samoa|San Marino|Sao Tome and Principe|Saudi Arabia|Senegal|Serbia|Seychelles|Sierra Leone|Singapore|Sint Maarten \(Dutch part\)|Slovakia|Slovenia|Solomon Islands|Somalia|South Africa|South Georgia and the South Sandwich Islands|South Sudan|Sri Lanka|Sudan|Suriname|Svalbard and Jan Mayen|Swaziland|Sweden|Switzerland|Syrian Arab Republic|Taiwan|Tajikistan|Tanzania, United Republic of|Thailand|Timor-Leste|Togo|Tokelau|Tonga|Trinidad and Tobago|Tunisia|Turkey|Turkmenistan|Turks and Caicos Islands|Tuvalu|Uganda|Ukraine|United Arab Emirates|United Kingdom of Great Britain and Northern Ireland|United States of America|United States Minor Outlying Islands|Uruguay|Uzbekistan|Vanuatu|Venezuela \(Bolivarian Republic of\)|Viet Nam|Virgin Islands \(British\)|Virgin Islands \(U\.S\.\)|Wallis and Futuna|Western Sahara|Yemen|Zambia|Zimbabwe)\b|
    (?i:autres?\s+de|probab|likely|possibl(e|y)|doubtful)|
    \b\s*(?i:maybe)\s*\b|
    \b\s*(?i:prob)\.\s*\b|
    \b\s*(?i:field\s*number)|
    \b\s*?(?i:malaise|light|pitfall|pan|suction|lobster|actinic light|cdc|fisherm(a|e)n)\s*(?i:trap)\s*\b|
    \|\s*(?i:collector\s*(field\s*)?number).*$|
    \(?[,]?\s*?(?i:(local)?\s?collectors?|data\s*recorder|netter|(oper|prepar)ator)\(?s?\)?\.?\:?|
    \b[.-–,;:]?\s*(?i:department|faculty)\s*?(?i:of)?\s*?(?i:entomology|biology|zoology)|
    (?i:Engº|Agrº|Fcº|Drº|Mº|Profº|Dº|Fº)|
    (?i:fide)\:?\s*\b|
    (?i:first\s+name\s+unknown)|
    (?i:game\s+dept)\.?\s*\b|
    (?i:see\s+notes?\s*(inside)?)|
    (?i:see\s+letter\s+enclosed)|
    (?i:(by)?\s+correspondance)|
    (?i:pers\.?\s*comm\.?)|
    (?i:crossed\s+out)|
    (?i:(ohne|keine)\s+angaben)|
    \(?(?i:source)\(?|
    (?i:according\s+to)|
    (?i:lanuv)\d+|
    \b\s*name\b|
    \b\s*lost\b|
    (?i:nswobs)|
    ORCID|
    MRI(\s|-)PAS|
    urn\:qm\.qld\.gov\.au\:collector|
    (?i:University\s+of\s+(Southern\s+)?California(,\s+Berkeley)?)|
    (?i:field\s+museum\s+of\s+natural\s+history)|
    (?i:american\s+museum\s+of\s+natural\s+history)|
    (?i:The\s+Paleontological\s+Research\s+Institution)|
    (?i:literature?)|
    (?i:museums?\s+victoria)|
    \b\s*(?i:united\s+states|russia)\s*\b|
    (?i:revised|photograph|fruits\s+only)|
    -?\s*(?i:sight\s+(id|identifi?cation))\.?\s*\b|
    -?\s*(?i:synonym(y|ie))|
    \b\s*\(?(?i:(fe)?male)\)?\s*\b|
    \b(?i:to\s+(sub)?spp?)\.?|
    (?i:nom\.?\s+rev\.?)|
    FNA|DAO|HUH|FDNMB|MNHN|PNI|USNM|ZMUC|CSIRO|ACAD|USGS|NAWQA|
    (?i:para|topo|syn|holo|allo|choro|eco|iso|isoepi|isopara|karyo|morpho|neo|mero|pala|paralecto|paraneo|photo|schizo)?(?i:types?\:?)|
    AFSC\/POLISH\s+SORTING\s+CTR\.?|
    (?i:university|mus(e|é)um|exhibits?)|
    (?i:uqam)|
    (?i:sem\s+(colec?tor|data))|
    (?i:no\s+coll\.?(ector)?)|
    (?i:not?)\s+(?i:name|date|details?|specific)?\s*?(?i:given|name|date|noted)|
    (?i:non?)\s+(?i:specificato)|
    \b[,;]\s+\d+\.?\z|
    [!@?]\s*\-?\s*|
    \d{1,4}[\/.]?(?i:i|ii|iii|iv|v|vi|vii|viii|ix|x|xi|xii)[\/.]\d{1,4}|
    [,]?\d+|
    [,;]\z|
    ^\w{0,2}\z|
    ^[A-Z]{2,}\z|
    (?i:annot)\.?\s*?\b|
    \s+(?i:stet)\s*!?\s*\z|
    \s+(?i:prep)\.?\s*\z|
    ([({].*?[)}])|
    \s+\[([[:word:]]|[[:space:]]|[-\?\.]){10,}\]|
    [\(\{][A-Za-z]{1,3}$|
    \b(?i:leg)[.:]?(\s|\z)|
    (?:[Dd](ed|on))[\.:]|
    \s+[A-Z]*\d+\z|
    \s+\d+[A-Za-z]+\z|
    ^[-,.\s;*\d]+\s?|
    \s*?-{2,}\s*?|
    ^(?i:exc?p?)[:.]\s*|
    ^(?:ex\.?|in)\s+(?:he?r?b)\.?\s+|
    (?!^)(?:ex\.?|in)\s+(?i:he?r?b)\.?\s+.*$|
    \:?\s*(?i:exch)(\b|\z)|
    \s+de\s*$|
    \.{2,}$|
    [^[:alnum:][:blank:][:punct:][∣´|ǀ∣｜│`~$^+|<>]]      # Removes emojis from string
  }x.freeze

  SPLIT_BY = %r{
    [;,]{2,} |                                            # Multiple semicolons or commas
    [–|ǀ∣｜│&+\/;:] |                                     # Various separators
    \s+-\s+ |                                             # Dash surrounded by spaces
    \s+a\.\s+ |                                           # "a." surrounded by spaces
    \b(con|e|y|i|en|et|or|per|for|und)\s*\b |             # Short conjunctions or prepositions
    \b(?i:and|with)\s*\b |                                # Case-insensitive "and", "with"
    \b(?i:annotated(\s+by)?)\s*\b |                       # "annotated (by)"
    \b(?i:coll\.)\s*\b |                                  # "coll."
    \b(?i:comm\.?)\s*\b |                                 # "comm."
    \b(?i:communicate?d(\s+to)?)\s*\b |                   # "communicated (to)"
    \b(?i:conf\.?(\s+by)?|confirmed(\s+by)?)\s*\b |       # "conf.", "confirmed (by)"
    \b(?i:confirmada)(\s+por)?\s*\b |                     # "confirmada (por)"
    \b(?i:checked?(\s+by)?)\s*\b |                        # "checked (by)"
    \b(?i:det\.?(\s+by)?)\s*\b |                          # "det."
    \b(?i:(donated)?\s*by)\s+ |                           # "donated by"
    \b(?i:dupl?[.,]?(\s+by)?|duplicate(\s+by)?)\s*\b |    # "dupl.", "duplicate"
    \b(?i:ex\.?(\s+by)?|examined(\s+by)?)\s*\b |          # "ex.", "examined (by)"
    \b(?i:in?dentified(\s+by)?)\s*\b |                    # "identified (by)"
    \b(?i:in\s+coll\.?\s*\b) |                            # "in coll."
    \b(?i:in\s+part(\s+by)?)\s*\b |                       # "in part (by)"
    \b(?i:och)\s*\b |                                     # "och"
    \b(?i:prep\.?\s+(?i:by)?)\s*\b |                      # "prep. by"
    \b(?i:purchased?)(\s+by)?\s*\b |                      # "purchased (by)"
    \b(?i:redet\.?(\s+by?)?)\s*\b |                       # "redet."
    \b(?i:reidentified(\s+by)?)\s*\b |                    # "reidentified"
    \b(?i:stet)\s*\b |                                    # "stet"
    \b(?i:then(\s+by)?)\s+ |                              # "then (by)"
    \b(?i:veri?f?\.?\:?(\s+by)?|v(e|é)rifi(e|é)d?(\s+by)?)\s*\b | # "verif."
    \b(?i:via|from)\s*\b                                  # "via", "from"
  }x.freeze

  POST_STRIP_TIDY = %r{
    ^\s*[&,;.]\s* |                                       # Leading whitespace followed by any combination of &, ;, or .
    [\[\]] |                                              # Any standalone square brackets
    ^[`'".,!?]+ |                                         # Leading repeated punctuation (` ' " . , ! ?)
    [`'",]+$                                              # Trailing repeated punctuation (` ' ")
  }x.freeze

  CHAR_SUBS = {
    '"' => '\'',
    '|' => ' | ',
    'ǀ' => ' | ',
    '∣' => ' | ',
    '│' => ' | ',
    '(' => ' ',
    ')' => ' ',
    '?' => '',
    '!' => '',
    '=' => '',
    '#' => '',
    '/' => ' / ',
    '&' => ' & ',
    '*' => '',
    '>' => '',
    '<' => '',
    '{' => '',
    '}' => '',
    '@' => '',
    '%' => '',
    '\\' => '',
    '´' => '\'',
    '+' => ' | ',
    ', ph.d.' => ' Ph.D.',
    ', Ph.D.' => ' Ph.D.',
    ', bro.' => ' Bro.',
    ', Jr.,' => ' Jr.;',
    ', Jr.' => ' Jr.',
    ',Jr.' => ' Jr.',
    ', Sr.' => ' Sr.',
    ',Sr.' => ' Sr.',
    ' jr.,' => ' Jr.;',
    ' jr,' => ' Jr.;',
    '-jr' => ' Jr.',
    '-Jr' => ' Jr.',
    'Dr.' => 'Dr. ',
    'prof.' => 'Prof. ',
    ' .;' => '. ;',
    ', &' => ' &'
  }.freeze

  COMPLEX_SEPARATORS = {
    "^(\\S{4,}),\\s+(Mrs?\\.|MRS?\\.)\\s+([A-Za-z\\.\\s]+)$" => "\\2 \\3 \\1",
    "^(Mrs?\\.?)\\s+&\\s+(Mrs?\\.?)\\s+(.*)$" => "\\1 \\3 | \\2 \\3",
    "^([A-Z]{1}\\.\\s*[[:alpha:]]+),\\s*?([A-Z.]+)$" => "\\1 \\2",
    "^(\\S{4,},\\s+(?:\\S\\.\\s*)+)\\s+(\\S{4,},\\s+(?:\\S\.\\s*)+)$" => "\\1 | \\2",
    "(\\S{1}\\.)([[:alpha:]]{2,})" => "\\1 \\2",
    "^([[:alpha:]]{2,})(?:\\s+)((?:\\S{1}\\.\\s?)+)$" => "\\1, \\2",
    "([[:alpha:]]*),?\\s*(.*)\\s+(van|von|v\\.|v(a|o)n\\s+der?)$" => "\\3 \\1, \\2",
    "^((?i:[A-Z]\\.\\s?)+)\\s?(?:and|&|et|e)\\s+((?i:[A-Z]\\.\\s?)+)\\s+([[:alpha:]’`'-]{2,})\\s+([[:alpha:]’`'-]{2,})$" => "\\1 \\4 | \\2 \\3 \\4",
    "^((?i:[A-Z]\\.\\s?)+)\\s?(?:and|&|et|e)\\s+((?i:[A-Z]\\.\\s?)+)\\s+([[:alpha:]’`'-]{2,})(.*)$" => "\\1 \\3 | \\2 \\3 | \\4",
    "^([A-Z]{1,3})\\s+(?:and|&|et|e)\\s+([A-Z]{1,3})\\s+([[:alpha:]’`'-]{2,})(.*)$" => "\\1 \\3 | \\2 \\3 | \\4",
    "^((?i:[A-Z]\\.\\s?)+),\\s+([A-Z.\\s]+)\\s+(?:and|&|et|e)\\s+((?i:[A-Z]\\.\\s?)+)\\s+([[:alpha:]’`'-]{2,})(.*)$" => "\\1 \\4 | \\2 \\4 | \\3 \\4 | \\5",
    "^([A-Z][[:alpha:]]{2,}),\\s*?([A-Z][[:alpha:]]{2,})\\s*?(?i:and|&|et|e|,)\\s+([A-Z][[:alpha:]]{2,})$" => "\\1 | \\2 | \\3",
    "^([A-Z][[:alpha:]]{2,}),\\s*?([A-Z][[:alpha:]]{2,}),\\s*?([A-Z][[:alpha:]]{2,})\\s*?(?i:and|&|et|e|,)\\s+([A-Z][[:alpha:]]{3,})$" => "\\1 | \\2 | \\3 | \\4",
    "^([A-Z][[:alpha:]]{2,}),\\s*?([A-Z][[:alpha:]]{2,}),\\s*?([A-Z][[:alpha:]]{2,}),\\s*?([A-Z][[:alpha:]]{2,})\\s*?(?i:and|&|et|e|,)\\s+([A-Z][[:alpha:]]{3,})$" => "\\1 | \\2 | \\3 | \\4 | \\5"
  }.freeze

  BLACKLIST = %r{
    (?i:
      abundant |
      adult | juvenile |
      administra(?:d|t)or |
      ^anon$ |
      australian? |
      average |
      believe | unclear | ill?egible | suggested | (dis)?agrees? | approach |
      \bnone\b |
      barcod |
      bgwd |
      (biolog|botan|zoo|ecolog|mycol|(?:in)?vertebrate|fisheries|genetic|animal|mushroom|wildlife|plumage|flower|agriculture) |
      (bris?tish|canadi?an?|chinese|arctic|japan|russian|north\s+america) |
      carex | salix |
      catalog(?:ue)? |
      conservator |
      (herbarium|herbier|collection|collected|publication|specimen|species|describe|an(?:a|o)morph|isolated|recorded|inspection|define|status|lighthouse) |
      \bhelp\b |
      data\s+not\s+captured |
      (description|drawing|identification|remark|original|illustration|checklist|intermedia|measurement|indisting|series|imperfect) |
      desconocido |
      exc(?:s?icc?at(?:a|i)) |
      evidence |
      exporter |
      foundation |
      ichthyology |
      inconn?u |
      (internation|gou?vern|ministry|extension|unit|district|provincial|na(?:c|t)ional|military|region|environ|natur(?:e|al)|naturelles|division|program|direction) |
      label |
      o\.?m\.?n\.?r\.? |
      measurement |
      ent(?:o|y)mology |
      malacology |
      geographic |
      (mus(?:eum|ée)|universit(?:y|é|e|at)|college|institute?|acad(?:e|é)m|school|écol(?:e|iers?)|laboratoi?r|project|polytech|dep(?:t|artment)|research|clinic|hospital|cientifica|sanctuary|safari) |
      univ\. |
      \b(graduate|student|élèves?|éleveur|étudiants|estudi?antes?|labo\.|storekeep|supervisor|superint|rcmp|coordinator|minority|fisherm(?:a|e)n|police|taxonomist|consultant|participant(?:es)?|team|(?:é|e)quipe|memb(?:er|re)|crew|group|personnel|staff|family|captain|friends|assistant|worker|gamekeeper)\b |
      non\s+pr(?:é|e)cis(?:é|e) |
      no\s+consta |
      no\s+(agent\s+)?(?:data|disponible)(?:\s+available)? |
      not?\s+(entered|stated) |
      nomenclatur(?:e|al)\s+adjustment |
      not\s+available |
      (ontario|qu(?:e|é)bec|saskatchewan|new brunswick|sault|newfoundland|assurance|vancouver|u\.?s\.?s\.?r\.?) |
      popa\s+observers? |
      recreation | culture |
      renseigné |
      (shaped|dark|pale|areas|phase|spotting|interior|between|closer) |
      soci(?:e|é)t(?:y|é) | cent(?:er|re) | community | history | conservation | conference | assoc | commission | consortium | council | club | exposit | alliance | protective | circle |
      ^class\b |
      commercial | control | product |
      ^company\b |
      sequence\s+data |
      size | large | colou?r |
      skeleton |
      survey | assessment | station | monitor | stn\. | project | engine | (e|é)x?chang(?:e|é)s? | ex(?:c|k)urs(?:e|o|ó)n? | exped\.? | exp(?:e|i)di(?:c|t)i(?:e|o|ó)n? | experiment | explora(?:d|t) | festival | generation | inventory | marine | service |
      ^index\b |
      submersible |
      synonymy? |
      systematic | perspective |
      ^(?:off|too|the)\b |
      taxiderm(?:ies|y) |
      though |
      texas\s+instruments?(?:\s+for)? |
      tropical |
      toward | seen\s+at |
      unidentified | unspecified | unk?nown? | unnamed | unread | unmistak | no agent |
      urn: |
      usda | ucla |
      workshop | garden | farm | jardin | public |
      ^de$
    )
  }x.freeze

  FAMILY_GREENLIST = ::Set.new([
    "Ng",
    "Srb",
    "Srp",
    "Vlk",
    "Smrz",
    "Smrž",
    "Smrt",
    "Krc",
    "Krč"
  ]).freeze

  FAMILY_BLACKLIST = ::Set.new([
    "a b",
    "a e",
    "a g",
    "a j",
    "a k",
    "ap",
    "da",
    "de",
    "de'",
    "del",
    "der",
    "di",
    "do",
    "dos",
    "du",
    "el",
    "la",
    "nebc",
    "van",
    "von",
    "the",
    "of",
    "new",
    "no",
    "pp",
    "adjustment",
    "agent",
    "annotator",
    "available",
    "arachnology",
    "catalogue",
    "comments",
    "curators",
    "data",
    "details",
    "determiner",
    "determination",
    "dissected",
    "dissection",
    "entered",
    "erased",
    "expd",
    "expdn",
    "hist",
    "historical",
    "historie",
    "indecipherable",
    "inst",
    "meteorological",
    "nomenclatural",
    "orig",
    "prof",
    "professional",
    "qld",
    "registration",
    "science",
    "study",
    "umeå",
    "wg",
    "wm",
    "wn",
    "zw",
    "zz",
    "z-"
  ]).freeze

  GIVEN_BLACKLIST = ::Set.new([
    "not any",
    "has not"
  ]).freeze

  TITLE = /\s*\b(sir|count(ess)?|colonel|(gen|adm|col|maj|cmdr|lt|sgt|cpl|pvt|proff?|dr|dra\.|drª|md|ph\.?d|rev|mme|abbé|ptre|bro|esq)\.?|doct(eu|o)r|father|cantor|vicar|père|pastor|profa\.?|profª|rabbi|reverend|pere|soeur|sister|professor)(\s+|$)/i.freeze

  APPELLATION = /\s*\b((mrs?|ms|fr|hr)\.?|miss|herr|frau)(\s+|$)/i.freeze

  SUFFIX = /\s*\b(JR|Jr|jr|SR|Sr|sr|ESQ|esq|[IVX]{2,})(\.|\b)/.freeze

  PARTICLES = ::Set.new([
    "ap",
    "da",
    "de",
    "de'",
    "del",
    "der",
    "des",
    "di",
    "do",
    "dos",
    "du",
    "el",
    "le",
    "la",
    "van",
    "von",
    "the",
    "of",
    "van de",
    "van der",
    "von der"
  ]).freeze

  VOWELS = "aeiouàáâäǎæãåāèéêëěẽēėęìíîïǐĩīıįòóôöǒœøõōùúûüǔũūűů"

end

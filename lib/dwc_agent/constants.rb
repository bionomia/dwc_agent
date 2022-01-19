module DwcAgent
  STRIP_OUT = %r{
    ^[\[{(]|
    [\]})]\??$|
    (?i:acc\s?\#)|
    [,;]?\s*(?i:1st|2nd|3rd|[4-9]th)|
    \s*?\d+\.\d+|
    \b\d+\(?(?i:[[:alpha:]])\)?\b|
    \b[,;]?\s*(?i:et\.?\s+al|&\s+al)\.?|
    \b[,;]?\s*(?i:etal)\.?|
    \b\s+(bis|ter)(\b|\z)|
    \bu\.\s*a\.|
    \b[,;]?\s*(?i:and|&)?\s*(?i:others|party)\s*\b|
    \b[,;]?\s*(?i:etc)\.?|
    \b[,;]?\s*(?i:exp)\.?\s*(\b|\z)|
    \b[,;]?\s*(?i:on)\b|
    \b[,;]?\s*(?i:unkn?own)\b|
    \b[,;]?\s*(?i:n/a)\b|
    \b[,;]?\s*(?i:ann?onymous)\b|
    \b[,;]?\s*\(?(?i:undetermined|indeterminable|dummy|interim|accession|ill(eg|is)ible|scripsit|presumed?|presumably)\)?\b|
    \b[,;]?\s*(?i:importer|gift)\:?\b|
    \b[,;]?\s*(?i:string)\b|
    \b[,;]?\s*(?i:person\s*string)\b|
    \b[,;]?\s*(?i:colls)\.(\b|\z)|
    \b[,;]?\s*(?i:colln?)[:.]?(\b|\z)|
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
    \b[.,;:/]?\s*?(?i:Afghanistan|Åland Islands|Albania|Algeria|American Samoa|Andorra|Angola|Anguilla|Antarctica|Antigua and Barbuda|Argentina|Armenia|Aruba|Australia|Azerbaijan|Bahamas|Bahrain|Bangladesh|Barbados|Belarus|Belize|Benin|Bermuda|Bhutan|Bolivia \(Plurinational State of\)|Bonaire, Sint Eustatius and Saba|Bosnia and Herzegovina|Botswana|Bouvet Island|Brazil|British Indian Ocean Territory|Brunei Darussalam|Bulgaria|Burkina Faso|Burundi|Cabo Verde|Cambodia|Cameroon|Canada|Cayman Islands|Central African Republic|Chad|Chile|Christmas Island|Cocos \(Keeling\) Islands|Colombia|Comoros|Congo|Congo \(Democratic Republic of the\)|Cook Islands|Costa Rica|Côte d'Ivoire|Croatia|Cuba|Curaçao|Cyprus|Czechia|Djibouti|Dominica|Dominican Republic|Ecuador|Egypt|El Salvador|Equatorial Guinea|Eritrea|Estonia|Ethiopia|Falkland Islands \(Malvinas\)|Faroe Islands|Fiji|Finland|French Guiana|French Polynesia|French Southern Territories|Gabon|Gambia|Germany|Ghana|Gibraltar|Greece|Greenland|Grenada|Guadeloupe|Guam|Guatemala|Guernsey|Guinea-Bissau|Guyana|Haiti|Heard Island and McDonald Islands|Holy See|Honduras|Hong Kong|Hungary|Iceland|India|Indonesia|Iran \(Islamic Republic of\)|Iraq|Ireland|Isle of Man|Italy|Jamaica|Japan|Jersey|Kazakhstan|Kenya|Kiribati|Korea \(Democratic People\'s Republic of\)|Korea \(Republic of\)|Kuwait|Kyrgyzstan|Lao People\'s Democratic Republic|Latvia|Lebanon|Lesotho|Liberia|Libya|Liechtenstein|Lithuania|Luxembourg|Macao|Macedonia (the former Yugoslav Republic of)|Madagascar|Malawi|Malaysia|Maldives|Malta|Marshall Islands|Martinique|Mauritania|Mauritius|Mayotte|Mexico|Micronesia \(Federated States of\)|Moldova \(Republic of\)|Monaco|Mongolia|Montenegro|Morocco|Mozambique|Myanmar|Namibia|Nauru|Nepal|Netherlands|New Caledonia|New Zealand|Nicaragua|Niger|Nigeria|Niue|Norfolk Island|Northern Mariana Islands|Norway|Oman|Pakistan|Palau|Palestine, State of|Panama|Papua New Guinea|Paraguay|Peru|Philippines|Pitcairn|Poland|Puerto Rico|Qatar|Réunion|Romania|Russian Federation|Rwanda|Saint Barthélemy|Saint Helena, Ascension and Tristan da Cunha|Saint Kitts and Nevis|Saint Lucia|Saint Martin \(French part\)|Saint Pierre and Miquelon|Saint Vincent and the Grenadines|Samoa|San Marino|Sao Tome and Principe|Saudi Arabia|Senegal|Serbia|Seychelles|Sierra Leone|Singapore|Sint Maarten \(Dutch part\)|Slovakia|Slovenia|Solomon Islands|Somalia|South Africa|South Georgia and the South Sandwich Islands|South Sudan|Sri Lanka|Sudan|Suriname|Svalbard and Jan Mayen|Swaziland|Sweden|Switzerland|Syrian Arab Republic|Taiwan|Tajikistan|Tanzania, United Republic of|Thailand|Timor-Leste|Togo|Tokelau|Tonga|Trinidad and Tobago|Tunisia|Turkey|Turkmenistan|Turks and Caicos Islands|Tuvalu|Uganda|Ukraine|United Arab Emirates|United Kingdom of Great Britain and Northern Ireland|United States of America|United States Minor Outlying Islands|Uruguay|Uzbekistan|Vanuatu|Venezuela \(Bolivarian Republic of\)|Viet Nam|Virgin Islands \(British\)|Virgin Islands \(U\.S\.\)|Wallis and Futuna|Western Sahara|Yemen|Zambia|Zimbabwe)\b|
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
    \b[,;]\s+\d+\z|
    ["!@?]|
    [,]?\d+|
    \s+\d+?(\/|\.)?(?i:i|ii|iii|iv|v|vi|vii|viii|ix|x)(\/|\.)\d+|
    [,;]\z|
    ^\w{0,2}\z|
    ^[A-Z]{2,}\z|
    (?i:annot)\.?\s*?\b|
    \s+(?i:stet)\s*!?\s*\z|
    \s+(?i:prep)\.?\s*\z|
    (\(|\{|\[).{1,}(\)|\]|\})|
    (\(|\[|\{).{1,}\z|
    \b(?i:leg)[\.:]?\s*\b|
    (?:[Dd](ed|on))[\.:]|
    \d*[A-Za-z]*\d*-\d*\z|
    \s+[A-Z]*\d+\z|
    \s+\d+[A-Za-z]+\z|
    ^[-,.\s;*\d]+\s?|
    \s*?-{2,}\s*?|
    ^(?i:exc?p?)[:.]\s*|
    (?i:ex\.?\s+herb\.?\s*)|
    \:?\s*(?i:exch)(\b|\z)|
    \s+de\s*$|
    \.{2,}$
  }x

  SPLIT_BY = %r{
    [–|ǀ∣｜│&+\/;:]|
    \s+-\s+|
    \s+a\.\s+|
    \b(con|e|y|i|en|et|or|per|for)\s*\b|
    \b(?i:and|with)\s*\b|
    \b(?i:annotated(\s+by)?)\s*\b|
    \b(?i:coll\.)\s*\b|
    \b(?i:communicate?d(\s+to)?)\s*\b|
    \b(?i:conf\.?(\s+by)?|confirmed(\s+by)?)\s*\b|
    \b(?i:confirmada)(\s+por)?\s*\b|
    \b(?i:checked?(\s+by)?)\s*\b|
    \b(?i:det\.?(\s+by)?)\s*\b|
    \b(?i:dupl?\.?(\s+by)?|duplicate(\s+by)?)\s*\b|
    \b(?i:ex\.?(\s+by)?|examined(\s+by)?)\s*\b|
    \b(?i:in?dentified(\s+by)?)\s*\b|
    \b(?i:in\s+part(\s+by)?)\s*\b|
    \b(?i:och)\s*\b|
    \b(?i:prep\.?\s+(?i:by)?)\s*\b|
    \b(?i:purchased?)(\s+by)?\s*\b|
    \b(?i:redet\.?(\s+by?)?)\s*\b|
    \b(?i:reidentified(\s+by)?)\s*\b|
    \b(?i:stet)\s*\b|
    \b(?i:then(\s+by)?)\s+|
    \b(?i:veri?f?\.?\:?(\s+by)?|v(e|é)rifi(e|é)d?(\s+by)?)\s*\b|
    \b(?i:via|from)\s*\b|
    \b(?i:(donated)?\s*by)\s+
  }x

  CHAR_SUBS = {
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
    '+' => ' | '
  }

  PHRASE_SUBS = {
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
    '-Jr' => ' Jr.'
  }

  SEPARATORS = {
    "^(\\S{4,},\\s+(?:\\S\\.\\s*){1,})\\s+(\\S{4,},\\s+(?:\\S\.\\s*){1,})$" => "\\1 | \\2",
    "(\\S{1}\\.)([[:alpha:]]{2,})" => "\\1 \\2",
    "([[:alpha:]]*),?\\s+(.*)\\s+(van|von)$" => "\\3 \\1, \\2",
    "^([A-Z.\\s]+)\\s+(?:and|&|et|e)\\s+([A-Z.\\s]+)\\s+([[:alpha:]]{2,})(.*)" => "\\1 \\3 | \\2 \\3 | \\4",
    "^([A-Z][[:alpha:]]{2,}),\\s*?([A-Z][[:alpha:]]{2,})\\s*?[,&]\\s*?([A-Z][[:alpha:]]{2,})$" => "\\1 | \\2 | \\3",
    "^([A-Z][[:alpha:]]{2,}),\\s*?([A-Z][[:alpha:]]{2,}),\\s*?([A-Z][[:alpha:]]{2,})\\s*?[,&]\\s*?([A-Z][[:alpha:]]{3,})$" => "\\1 | \\2 | \\3 | \\4",
    "^([A-Z][[:alpha:]]{2,}),\\s*?([A-Z][[:alpha:]]{2,}),\\s*?([A-Z][[:alpha:]]{2,}),\\s*?([A-Z][[:alpha:]]{2,})\\s*?[,&]\\s*?([A-Z][[:alpha:]]{3,})$" => "\\1 | \\2 | \\3 | \\4 | \\5"
  }

  BLACKLIST = %r{
    (?i:abundant)|
    (?i:adult|juvenile)|
    (?i:administra(d|t)or)|
    (?i:anon)|
    (?i:australian?)|
    (?i:average)|
    (?i:believe|unclear|ill?egible|none|suggested|(dis)?agrees?)|approach|
    (?i:barcod)|
    (?i:BgWd)|
    (?i:biolog|botan|zoo|ecolog|mycol|(in)?vertebrate|fisheries|genetic|animal|mushroom|wildlife|plumage|flower|agriculture)|
    (?i:bris?tish|canadi?an?|chinese|arctic|japan|russian|north\s+america)|
    (?i:carex|salix)|
    (?i:catalog(ue)?)|
    (?i:herbarium|herbier|collection|collected|publication|specimen|species|describe|an(a|o)morph|isolated|recorded|inspection|define|status|lighthouse)|
    \b\s*(?i:help)\s*\b|
    (?i:data\s+not\s+captured)|
    (?i:description|drawing|identification|remark|original|illustration|checklist|intermedia|measurement|indisting|series|imperfect)|
    (?i:desconocido)|
    (?i:exc?s?icc?at(a|i))|
    (?i:evidence)|
    (?i:exporter)|
    (?i:foundation)|
    (?i:ichthyology)|
    (?i:inconn?u)|
    (?i:internation|gou?vern|ministry|extension|unit|district|provincial|na(c|t)ional|military|region|environ|natur(e|al)|naturelles|division|program|direction|national)|
    (?i:label)|
    (?i:o?\.?m\.?n\.?r\.?)|
    (?i:measurement)|
    (?i:ent(o|y)mology)|
    (?i:malacology)|
    (?i:geographic)|
    (?i:mus(eum|ée)|universit(y|é|e|at)|college|institute?|acad(e|é)m|school|écol(e|iers?)|laboratoi?r|projec?t|polytech|dep(t|art?ment)|research|clinic|hospital|cientifica|sanctuary|safari)|
    (?i:univ\.)|
    (?i:graduate|student|élèves?|éleveur|étudiants|estudi?antes?|labo\.|storekeep|supervisor|superint|rcmp|coordinator|minority|fisherm(a|e)n|police|taxonomist|consultant|participante?s?|team|(é|e)quipe|memb(er|re)|crew|group|staff|personnel|family|captain|friends|assistant|worker|gamekeeper)|
    (?i:non\s+pr(é|e)cis(é|e))|
    (?i:no\s+consta)|
    (?i:no\s+(agent)?\s?(data|disponible)(\s+available)?)|
    (?i:not?\s+(entered|stated))|
    (?i:nomenclatur(e|al)\s+adjustment)|
    (?i:not\s+available)|
    (?i:ontario|qu(e|é)bec|saskatchewan|new brunswick|sault|newfoundland|assurance|vancouver|u\.?s\.?s\.?r\.?)|
    (?i:popa\s+observers?)|
    (?i:recreation|culture)|
    (?i:renseigné)|
    (?i:shaped|dark|pale|areas|phase|spotting|interior|between|closer)|
    (?i:soci(e|é)t(y|é)|cent(er|re)|community|history|conservation|conference|assoc|class|commission|consortium|council|club|exposit|alliance|protective|circle)|
    (?i:commercial|company|control|product)|
    (?i:sequence\s+data)|
    (?i:size|large|colou?r)\s+|
    (?i:skeleton)|
    (?i:survey|assessment|station|monitor|stn\.|index|project|bureau|engine|(e|é)x?chang(e|é)s?|ex(c|k)ursi(e|o|ó)n?|exped\.?|exp(e|i)di(c|t)i(e|o|ó)n?|experiment|explora(d|t)|festival|generation|inventory|marine|service)|
    (?i:submersible)|
    (?i:synonymy?)|
    (?i:systematic|perspective)|
    \s+(?i:off)\s+|
    \s*(?i:too)\s+|\s*(?i:the)\s+|
    (?i:taxiderm(ies|y))|
    (?i:though)|
    (?i:texas\s+instruments?)\s*?(for)?|
    (?:tropical)|
    (?i:toward|seen\s+at)|
    (?i:unidentified|unspecified|unk?nown?|unnamed|unread|unmistak|no agent)|
    (?i:urn\:)|
    (?i:usda|ucla)|
    (?i:workshop|garden|farm|jardin|public)|
    ^\s*?de\s*?$
  }x

  FAMILY_BLACKLIST = [
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
    "le",
    "la",
    "van",
    "von",
    "the",
    "of",
    "new",
    "no",
    "adjustment",
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
    "nomenclatural",
    "orig",
    "qld",
    "registration",
    "science",
    "study",
    "wg",
    "wm",
    "wn",
    "zw",
    "zz",
    "z-"
  ]

  GIVEN_BLACKLIST = [
    "not any",
    "has not"
  ]

  TITLE = /\s*\b(sir|count(ess)?|colonel|(gen|adm|col|maj|capt|cmdr|lt|sgt|cpl|pvt|proff?|dr|md|ph\.?d|rev|mme|abbé|ptre|bro|esq)\.?|doct(eu|o)r|father|cantor|vicar|père|pastor|rabbi|reverend|pere|soeur|sister|professor)(\s+|$)/i

  APPELLATION = /\s*\b((mrs?|ms|fr|hr)\.?|miss|herr|frau)(\s+|$)/i

  SUFFIX = /\s*\b(JR|Jr|jr|SR|Sr|sr|[IVX]{2,})(\.|\b)/

end

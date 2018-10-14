require "dwc_agent/version"
require "capitalize_names"
require "namae"

class DwcAgent

  STRIP_OUT = %r{
    \b\d+\(?(?i:[[:alpha:]])\)?\b|
    \b[,;]?\s*(?i:et\s+al)\.?|
    \bu\.\s*a\.|
    \b[,;]?\s*(?i:and|&)?\s*(?i:others)\s*\b|
    \b[,;]?\s*(?i:etc)\.?|
    \b[,;]?\s*(?i:on)\b|
    \b[,;]?\s*(?i:unkn?own)\b|
    \b[,;]?\s*(?i:n/a)\b|
    \b[,;]?\s*(?i:ann?onymous)\b|
    \b[,;]?\s*(?i:undetermined|indeterminable|dummy|interim)\b|
    \b[,;]?\s*(?i:importer)\b|
    \b[,;]?\s*(?i:frère|frere|père|pere|soeur|sister|bro)\.?(\b|\z)|
    (?i:no\s+(data|disponible))|
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
    (?i:autres?\s+de|probab|likely|possibl(e|y)|doubtful)|
    \b\s*maybe\s*\b|
    \(?(?i:collector|data\s*recorder|netter|(oper|prepar)ator)\(?s?\)?\.?\:?|
    (?i:fide)\:?\s*\b|
    (?i:game\s+dept)\.?\s*\b|
    (?i:see\s+notes?\s*(inside)?)|
    (?i:see\s+letter\s+enclosed)|
    (?i:(by)?\s+correspondance)|
    (?i:pers\.?\s+comm\.?)|
    (?i:crossed\s+out)|
    \(?(?i:source)\(?|
    (?i:according\s+to)|
    (?i:revised|photograph|fruits\s+only)|
    -?\s*(?i:sight\s+(id|identifi?cation))\.?\s*\b|
    -?\s*(?i:synonym(y|ie))|
    \b\s*\(?(?i:(fe)?male)\)?\s*\b|
    \b(?i:to\s+(sub)?spp?)\.?|
    (?i:nom\.?\s+rev\.?)|
    FNA|DAO|HUH|\(MT\)|(?i:\(KEW\))|
    (?i:uqam)|
    \b[,;]\s+\d+\z|
    [":!]|
    [,]?\d+|
    \s+\d+?(\/|\.)?(?i:i|ii|iii|iv|v|vi|vii|viii|ix|x)(\/|\.)\d+|
    [,;]\z|
    ^\w{0,2}\z|
    ^[A-Z]{2,}\z|
    \s+(?i:stet)\s*!?\s*\z|
    \s+(?i:prep)\.?\s*\z|
    \b\s*\([A-Z]{2,}\)
  }x

  SPLIT_BY = %r{
    [–|&+/;]|
    \s+-\s+|
    \s+a\.\s+|
    \b(?i:and|et|with|per)\s+|
    \be\s*\b|
    \b(?i:annotated(\s+by)?)\s*\b|
    \b(?i:coll\.)\s*\b|
    \b(?i:communicate?d(\s+to)?)\s*\b|
    \b(?i:conf\.?(\s+by)?|confirmed(\s+by)?)\s*\b|
    \b(?i:checked?(\s+by)?)\s*\b|
    \b(?i:det\.?(\s+by)?)\s*\b|
    \b(?i:dupl?\.?(\s+by)?|duplicate(\s+by)?)\s*\b|
    \b(?i:ex\.?(\s+by)?|examined(\s+by)?)\s*\b|
    \b(?i:in?dentified(\s+by)?)\s*\b|
    \b(?i:in\s+part(\s+by)?)\s*\b|
    \b(?i:or)\s+|
    \b(?i:prep\.?\s+(?i:by)?)\s*\b|
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
    '(' => ' ',
    ')' => ' ',
    '[' => ' ',
    ']' => ' ',
    '?' => '',
    '!' => '',
    '=' => '',
    '#' => '',
    '/' => ' / ',
    '&' => ' & ',
    '*' => ''
  }

  COMPLEX_SEPARATORS = %r{
    ^([A-Za-z]{4,},\s+(?:[A-Z]\.\s*){1,})\s+([A-Za-z]{4,},\s+(?:[A-Z]\.\s*){1,})$
  }x

  BLACKLIST = %r{
    (?i:abundant)|
    (?i:adult|juvenile)|
    (?i:anon)|
    (?i:average)|
    (?i:believe|unclear|illegible|none|suggested|(dis)?agrees?)|approach|
    (?i:barcod)|
    (?i:biolog|botan|zoo|ecolog|mycol|(in)?vertebrate|fisheries|genetic|animal|mushroom|wildlife|plumage|flower|agriculture)|
    (?i:bris?tish|canadi?an?|chinese|arctic|japan|russian|north\s+america)|
    (?i:carex|salix)|
    (?i:herbarium|herbier|collection|collected|publication|specimen|species|describe|an(a|o)morph|isolated|recorded|inspection|define|status|lighthouse)|
    \b\s*(?i:help)\s*\b|
    (?i:description|drawing|identification|remark|original|illustration|checklist|intermedia|measurement|indisting|series|imperfect)|
    (?i:desconocido)|
    (?i:evidence)|
    (?i:inconn?u)|
    (?i:internation|gou?vern|ministry|unit|district|provincial|na(c|t)ional|military|region|environ|natur(e|al)|naturelles|division|program|direction|national)|
    (?i:label)|
    (?i:o?\.?m\.?n\.?r\.?)|
    (?i:measurement)|
    (?i:ent(o|y)mology)|
    (?i:mus(eum|ée)|universit(y|é|e|at)|college|institute?|acad(e|é)m|school|écol(e|iers?)|laboratoi?r|projec?t|polytech|dep(t|art?ment)|research|clinic|hospital|cientifica|sanctuary|safari)|
    (?i:univ\.)|
    (?i:graduate|student|estudantes|storekeep|supervisor|superint|rcmp|coordinator|minority|fishermen|police|taxonomist|consultant|participante?s?|team|(é|e)quipe|memb(er|re)|crew|group|staff|personnel|family|captain|friends|assistant|worker)|
    (?i:non\s+pr(é|e)cis(é|e))|
    (?i:ontario|qu(e|é)bec|saskatchewan|new brunswick|sault|newfoundland|assurance|vancouver|u\.?s\.?s\.?r\.?)|
    (?i:recreation|culture)|
    (?i:shaped|dark|pale|areas|phase|spotting|interior|between|closer)|
    (?i:soci(e|é)t(y|é)|cent(er|re)|community|history|conservation|conference|assoc|class|commission|consortium|council|club|alliance|protective|circle)|
    (?i:commercial|company|control|product)|
    (?i:size|large|colou?r)\s+|
    (?i:skeleton)|
    (?i:survey|assessment|station|monitor|stn\.|index|project|bureau|engine|expedi(c|t)ion|festival|generation|inventory|marine|service)|
    (?i:submersible)|
    (?i:synonymy?)|(topo|syn|holo)type|
    (?i:systematic|perspective)|
    \s+(?i:off)\s+|
    \s*(?i:too)\s+|\s*(?i:the)\s+|
    (?i:taxiderm(ies|y))|
    (?i:though)|
    (?i:toward|seen at)|
    (?i:unidentified|unspecified|unk?nown|unnamed|unread|unmistak|no agent)|
    (?i:urn\:)|
    (?i:usda|ucla)|
    (?i:workshop|garden|farm|jardin|public)
  }x

  TITLE = /\s*\b(sir|lord|count(ess)?|(gen|adm|col|maj|capt|cmdr|lt|sgt|cpl|pvt|prof|dr|md|ph\.?d|rev|docteur|mme|abbé|ptre)\.?|frère|frere|père|pere|professor)(\s+|$)/i

  Namae.options[:prefer_comma_as_separator] = true
  Namae.options[:separator] = SPLIT_BY
  Namae.options[:title] = TITLE

  # Parses the passed-in string and returns a list of names.
  #
  # @param names [String] the name or names to be parsed
  # @return [Array] the list of parsed names
  def self.parse(name)
    return [] if name.nil? || name == ""
    cleaned = name.gsub(STRIP_OUT, ' ')
                  .gsub(/[#{CHAR_SUBS.keys.join('\\')}]/, CHAR_SUBS)
                  .gsub(/([A-Z]{1}\.)([[:alpha:]]{2,})/, '\1 \2')
                  .gsub(COMPLEX_SEPARATORS, '\1 | \2')
                  .gsub(/,\z/, '')
                  .squeeze(' ').strip
    Namae.parse(cleaned)
  end

  # Cleans the passed-in namae object from the parse method and
  # re-organizes it to better match expected Darwin Core output.
  #
  # @param parsed_namae [Object] the namae object
  # @return [Hash] the given, family hash
  def self.clean(parsed_namae)
    blank_name = { given: nil, family: nil }

    if parsed_namae.family && parsed_namae.family.length < 3
      return blank_name
    end
    if parsed_namae.family && parsed_namae.family.length == 3 && parsed_namae.family.count('.') == 1
      return blank_name
    end
    if parsed_namae.given && parsed_namae.given.length > 15
      return blank_name
    end
    if parsed_namae.given && parsed_namae.given.count('.') >= 3 && /\.\s*[a-zA-Z]{4,}\s+[a-zA-Z]{1,}\./.match(parsed_namae.given)
      return blank_name
    end
    if parsed_namae.family && /[a-zA-Z]{2,}\.?\s+[a-zA-Z]{2,}/.match(parsed_namae.family)
      return blank_name
    end
    if parsed_namae.given && /[a-zA-Z]{2,}\.?\s+[a-zA-Z]{2,}/.match(parsed_namae.given)
      return blank_name
    end
    if parsed_namae.display_order =~ BLACKLIST
      return blank_name
    end

    if parsed_namae.given && 
       parsed_namae.family && 
       parsed_namae.family.count(".") > 0 && 
       parsed_namae.family.length - parsed_namae.family.count(".") <= 3
        given = parsed_namae.given
        family = parsed_namae.family
        parsed_namae.family = given
        parsed_namae.given = family
    end

    if parsed_namae.given && 
      (parsed_namae.given == parsed_namae.given.upcase || 
      parsed_namae.given == parsed_namae.given.downcase) && 
      !parsed_namae.given.include?(".") &&
      parsed_namae.given.length >= 4
        parsed_namae.given = CapitalizeNames.capitalize(parsed_namae.given)
    end

    if parsed_namae.given && /[A-Za-z]\./.match(parsed_namae.given)
      parsed_namae.given = CapitalizeNames.capitalize(parsed_namae.given).sub(/[a-z]\./, &:upcase)
    end

    parsed_namae.normalize_initials

    family = parsed_namae.family.gsub(/\.\z/, '').strip rescue nil
    given = parsed_namae.given.strip rescue nil
    particle = parsed_namae.particle.strip rescue nil

    if family.nil? && !given.nil? && !given.include?(".")
      family = given
      given = nil
    end

    if !family.nil? && given.nil? && !particle.nil?
      given = particle.sub(/[a-z]\./, &:upcase).sub(/^(.)/) { $1.capitalize }
      particle = nil
    end

    if !family.nil? && (family == family.upcase || family == family.downcase)
      family = family.mb_chars.capitalize.to_s rescue nil
    end

    if !family.nil? && family.length <= 4 && family !~ /[aeiouy]/
      return blank_name
    end

    if !family.nil? && family.match(/[A-Z]$/)
      return blank_name
    end

    if !family.nil? && family.match(/^[A-Z]{2}/)
      return blank_name
    end

    { given: given, family: family }
  end

  # Produces a similarity score of two given names
  #
  # @param given1 [String] one given name
  # @param given2 [String] a second given name
  # @return [Float] the similarity score
  def self.similarity_score(given1, given2)
    given1_parts = given1.gsub(/\.\s+/,".").split(/[\.\s]/)
    given2_parts = given2.gsub(/\.\s+/,".").split(/[\.\s]/)
    largest = [given1_parts,given2_parts].max
    smallest = [given1_parts,given2_parts].min

    score = 0
    largest.each_with_index do |val,index|
      if smallest[index]
        if val[0] == smallest[index][0]
          score += 1
        else
          return 0
        end
        if val.length > 1 && smallest[index].length > 1 && val != smallest[index]
          return 0
        end
      else
        score += 0.1
      end
    end
    
    score
  end

end

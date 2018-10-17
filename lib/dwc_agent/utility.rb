module DwcAgent

  module_function

  def parse(names)
    Parser.instance.parse(names)
  end

  def clean(parsed_name)
    Cleaner.instance.clean(parsed_name)
  end

  def similarity_score(given1, given2)
    Similarity.instance.similarity_score(given1, given2)
  end

end
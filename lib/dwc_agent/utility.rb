module DwcAgent

  module_function

  def parse(names)
    Parser.parse(names)
  end

  def clean(parsed_namae)
    Cleaner.clean(parsed_namae)
  end

  def similarity_score(given1, given2)
    Similarity.similarity_score(given1, given2)
  end

end
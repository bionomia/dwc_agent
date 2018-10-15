module DwcAgent

  module_function

  def parse(names)
    Parser.parse(names)
  end

  def clean(parsed_namae)
    Cleaner.clean(parsed_namae)
  end

  def similarity(given1, given2)
    Similarity.similarity(given1, given2)
  end

end
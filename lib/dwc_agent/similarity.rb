module DwcAgent
  class Similarity

    class << self
      def instance
        Thread.current[:dwc_agent_similarity] ||= new
      end
    end

    # Produces a similarity score of two given names
    # Logic inspired by R.D.M. Page, https://orcid.org/0000-0002-7101-9767
    # At https://linen-baseball.glitch.me/
    #
    # @param given1 [String] one given name
    # @param given2 [String] a second given name
    # @return [Float] the similarity score
    def similarity_score(given1, given2)
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
end
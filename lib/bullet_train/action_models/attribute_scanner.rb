require "matrix"

module BulletTrain
  module ActionModels 
    module AttributeScanner
      def closest_attribute_matches(target_model, comparison_strings)
        attributes = target_model.attribute_names.excluding("id", "team_id", "created_at", "updated_at")
        request_data = attributes + comparison_strings 
        response = request_to_openai(request_data)
        calculate_similarity_scores(response, attributes, comparison_strings)
      end

      # https://platform.openai.com/docs/guides/embeddings/what-are-embeddings
      def request_to_openai(input)
        openai_model = "text-similarity-babbage-001"
        client = OpenAI::Client.new(access_token: ENV["OPENAI_ACCESS_TOKEN"])

        client.embeddings(
          parameters: {
              model: openai_model,
              input: input
          }
        )
      end

      private

      # Returns the model's attributes with its closest matching strings.
      def calculate_similarity_scores(response, attributes, comparison_strings)
        attribute_scores = response["data"].shift(attributes.size)
        comparison_string_scores = response["data"]

        attributes.flat_map.with_index do |attr, attr_idx|
          # Dot products range from -1 to 1, so we start at the lowest possible value.
          highest_similarity_score = -1
          closest_match = nil

          comparison_strings.each_with_index do |str, str_idx|
            # Calculate the dot product.
            attribute_vector = Vector.elements(attribute_scores[attr_idx]["embedding"])
            comparison_vector = Vector.elements(comparison_string_scores[str_idx]["embedding"])
            dot_product = attribute_vector.dot(comparison_vector)

            if dot_product > highest_similarity_score
              highest_similarity_score = dot_product
              closest_match = str
            end
          end
        
          {attribute: attr, closest_match: closest_match, score: highest_similarity_score}
        end
      end
    end
  end
end

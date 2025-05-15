class CreateEmbeddingsJob < ApplicationJob
  queue_as :default

  def perform(chunks:)
    embeddings = CreateEmbeddings.call(text: chunks.map(&:body))

    embeddings.each_with_index do |embedding, index|
      model = chunks[index]
      Rails.logger.info "#{self.class}: model[#{model.body.truncate(30)}] embedding[#{embedding.to_s.truncate(20)}...]"
      model.update!(embedding:)
    end
  end
end

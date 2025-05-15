# == Schema Information
#
# Table name: chunks
#
#  id          :integer          not null, primary key
#  resource_id :integer          not null
#  body        :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  embedding   :vector(1536)
#
# Indexes
#
#  index_chunks_on_embedding    (embedding)
#  index_chunks_on_resource_id  (resource_id)
#

class Chunk < ApplicationRecord
  belongs_to :resource
  has_neighbors :embedding

  after_commit :create_embedding, on: :create

  private

    def create_embedding
      CreateEmbeddingsJob.perform_later(chunks: [ self ])
    end
end

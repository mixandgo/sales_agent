class AddEmbeddingToChunks < ActiveRecord::Migration[8.0]
  def change
    # OpenAI text-embedding-3-small (1536)
    add_column :chunks, :embedding, :vector, limit: 1536
    add_index :chunks, :embedding, using: :hnsw, opclass: :vector_ip_ops
  end
end

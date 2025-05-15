class CreateEmbeddings < Base
  # @param text [String] or [Array<String>] the text to embed
  def initialize(text:)
    @text = text
    @llm = Langchain::LLM::OpenAI.new(api_key: ENV["OPENAI_API_KEY"], default_options: { model: "gpt-41-nano" })
  end

  def perform
    Retryable.retryable(tries: 5, sleep: ->(n) { 4**n }, on: RETRYABLE_API_ERRORS) do
      response = @llm.embed(
        model: "text-embedding-3-small",
        text: Array(@text)
      )

      if response.embeddings.empty?
        raise "Embedding failed: #{response.error}"
      end

      response.embeddings
    end
  end
end

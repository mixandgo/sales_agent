class FetchContextTool
  extend Langchain::ToolDefinition

  @tool_name = "fetch_context_tool"

  define_function :fetch_context, description: "Fetch context when you don't have enough information on the topic." do
    property :topic, type: "string", description: "The topic you are looking for", required: true
  end

  def fetch_context(topic:)
    Rails.logger.info("#{self.class}: Fetching context for '#{topic}'")

    @topic_embedding = CreateEmbeddings.call(text: topic).first

    chunks = Chunk
      .nearest_neighbors(:embedding, @topic_embedding, distance: "inner_product")
      .limit(10)

    if chunks.empty?
      Rails.logger.info("#{self.class}: No context found for '#{topic}'")
      nil
    else
      context = chunks.map(&:body).join(" ")
      Rails.logger.info("#{self.class}: Found context for '#{topic}' \n\n-----#{context.truncate(100)}-----\n\n")

      context
    end
  end
end

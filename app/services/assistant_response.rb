class AssistantResponse
  def initialize(agent:, messages: [], &response_handler)
    @agent = agent

    # https://github.com/patterns-ai-core/langchainrb?tab=readme-ov-file#assistants
    @assistant = Langchain::Assistant.new(
      llm: Langchain::LLM::OpenAI.new(api_key: ENV["OPENAI_API_KEY"]),
      instructions: @agent.system_prompt,
      messages: messages,
      tools: []
    ) { response_handler }
  end

  def self.call(...)
    new(...).call
  end

  def call
    @assistant.add_message_and_run!(content: "What's the latest news about AI?")
    @assistant.run # auto_tool_execution: true
  end
end

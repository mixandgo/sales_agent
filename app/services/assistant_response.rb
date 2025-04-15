class AssistantResponse
  def initialize(chat:, submission:)
    @chat = chat
    @submission = submission
    @agent = @chat.agent
    @messages = @chat.messages_for_llm

    # https://github.com/patterns-ai-core/langchainrb?tab=readme-ov-file#assistants
    @assistant = Langchain::Assistant.new(
      llm: Langchain::LLM::OpenAI.new(api_key: ENV["OPENAI_API_KEY"]),
      instructions: @agent.system_prompt,
      messages: @messages,
      tools: [],
      &response_handler
    )
  end

  def self.call(...)
    new(...).call
  end

  def call
    @assistant.add_message_and_run!(content: "What's the latest news about AI?")
    @assistant.run # auto_tool_execution: true
  end


  private

    def response_handler
      Rails.logger.info "------------------------: ResponseHandler START"
      @last_response = ""

      proc do |chunk, _bytesize|
        Rails.logger.info "------------------------: chunk[#{chunk}]"
        if (error = chunk.dig("error").presence)
          Rails.logger.error "------------------------: error[#{error}]"
          raise error
        elsif (finish_reason = chunk.dig("finish_reason").presence)
          Rails.logger.info "------------------------: finish_reason: #{finish_reason}"

          # Saving the assistant response into a message
          @submission.assistant_message.update(body: @last_response)

          # Updating the chat UI
          render_message_content(content: @last_response)
        elsif (content = chunk.dig("delta", "content"))
          # Collecting streamed response
          @last_response += content

          # Updating the chat UI
          render_message_content(content: @last_response)
        else
          Rails.logger.info "------------------------: event: UNKNOWN STATE"
        end
      end
    end

    def render_message_content(content:)
      Turbo::StreamsChannel.broadcast_update_to(
        @chat.stream_id,
        target: @chat.messages_id,
        html: markdown(content)
      )
    end

    def markdown(text)
      renderer = Redcarpet::Render::HTML.new
      markdown = Redcarpet::Markdown.new(renderer, extensions = {})

      markdown.render(text).html_safe
    end
end

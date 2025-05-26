class AssistantResponse < Base
  include ActionView::RecordIdentifier
  include ApplicationHelper

  def initialize(chat:, submission:)
    @chat = chat
    @submission = submission
    @agent = @chat.agent
    @messages = @chat.messages_for_llm

    # https://github.com/patterns-ai-core/langchainrb?tab=readme-ov-file#assistants
    @assistant = Langchain::Assistant.new(
      llm: Langchain::LLM::OpenAI.new(api_key: ENV["OPENAI_API_KEY"], default_options: { model: "gpt-41-nano" }),
      instructions:,
      messages: @messages,
      tools: [
        ScheduleAppointmentTool.new,
        FetchContextTool.new
      ],
      &response_handler
    )
  end

  def perform
    @assistant.add_message_and_run!(content: @submission.input)
    @assistant.run(auto_tool_execution: true)
  end

  private

    def instructions
      prompt = Langchain::Prompt::PromptTemplate.new(template: @agent.system_prompt, input_variables: [ "now", "timezone" ])
      prompt.format(now: Time.current, timezone: Time.zone.name)
    end

    def response_handler
      Rails.logger.info "------------------------: ResponseHandler START"
      @last_response = ""

      proc do |chunk, _bytesize|
        Rails.logger.info "[CHUNK] ------------------------: chunk[#{chunk}]"
        if (error = chunk.dig("error").presence)
          Rails.logger.error "[CHUNK] ------------------------: error[#{error}]"
          raise error
        elsif (finish_reason = chunk.dig("finish_reason").presence)
          Rails.logger.info "[CHUNK] ------------------------: finish_reason: #{finish_reason}"

          # Saving the assistant response into a message
          @submission.assistant_message.update(body: @last_response)
        elsif (content = chunk.dig("delta", "content"))
          # Collecting streamed response
          @last_response += content

          # Updating the chat UI
          render_message_content(content: @last_response)
        else
          Rails.logger.info "[CHUNK] ------------------------: event: UNKNOWN STATE"
        end
      end
    end

    def render_message_content(content:)
      Turbo::StreamsChannel.broadcast_update_to(
        @chat.stream_id,
        target: dom_id(@submission.assistant_message, :stream),
        html: markdown(content)
      )
    end
end

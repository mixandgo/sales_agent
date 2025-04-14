class SubmissionsController < ApplicationController
  def create
    @chat = Chat.find(params[:chat_id])
    @submission = @chat.submissions.create(submission_params)
    AssistantResponse.call(agent: @chat.agent, messages: @chat.messages_for_llm, &response_handler)
  end

  private

    def submission_params
      params.require(:submission).permit(:input)
    end

    def response_handler
      Rails.logger.info "------------------------: ResponseHandler START"

      proc do |chunk, _bytesize|
        Rails.logger.info "------------------------: chunk[#{chunk}]"
        if (error = chunk.dig("error").presence)
          Rails.logger.error "------------------------: error[#{error}]"
          raise error
        elsif (finish_reason = chunk.dig("finish_reason").presence)
          Rails.logger.info "------------------------: finish_reason: #{finish_reason}"

          # Saving the assistant response into a message
          @submission.assistant_message.update(content: @last_response)

          # Updating the chat UI
          render_message_content(@last_response, assistant_message)
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
        html: content
      )
    end
end

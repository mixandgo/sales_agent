class AssistantResponseJob < ApplicationJob
  queue_as :default

  def perform(chat:, submission:)
    AssistantResponse.call(chat: chat, submission: submission)
  end
end

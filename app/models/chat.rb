class Chat < ApplicationRecord
  belongs_to :agent
  has_many :submissions, dependent: :destroy
  has_many :messages, through: :submissions

  def stream_id
    "chat_#{id}"
  end

  def messages_id
    "chat_messages_#{id}"
  end

  def messages_for_llm
    messages.map do |message|
      Langchain::Assistant::Messages::OpenAIMessage.new(
        role: message.role,
        content: message.body
      )
    end
  end
end

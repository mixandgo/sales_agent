class Submission < ApplicationRecord
  belongs_to :chat
  has_many :messages, dependent: :destroy

  after_create :create_user_message

  def user_message
    messages.find_by(role: "user")
  end

  def assistant_message
    messages.find_by(role: "assistant")
  end

  private

    def create_user_message
      messages.create(role: "user", body: input)
    end
end

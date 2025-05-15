# == Schema Information
#
# Table name: submissions
#
#  id         :integer          not null, primary key
#  input      :text
#  context    :text
#  chat_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_submissions_on_chat_id  (chat_id)
#

class Submission < ApplicationRecord
  belongs_to :chat
  has_many :messages, dependent: :destroy

  after_create :create_user_message
  after_create :create_assistant_message

  validates :input, presence: true
  validates :input, length: { maximum: 4096 }
  validates :input, format: { with: /\A[[:print:]]+\z/, message: "only allows printable characters" }
  validates :input, format: { without: /\A\s*\n+\z/, message: "cannot be blank" }

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

    def create_assistant_message
      messages.create(role: "assistant", body: "")
    end
end
